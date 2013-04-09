class AssignmentSubmissionObject

  include Foundry
  include DataFactory
  include StringFactory
  include DateFactory
  include Navigation

  attr_accessor :site, :title, :text, :status, :submission_date,
      :student, :allow_resubmission, :resubmission, :num_resubmissions,
      :release_to_student, :grade, :summary_comment, :inline_comment,
      :grade_status, :accept_until, :returned

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
      :text=>random_alphanums,
      :status=>'Not Started'
    }
    options = defaults.merge(opts)

    set_options(options)
    requires :site, :title, :student
  end

  def submit
    open
    on AssignmentStudentView do |assignment|
      assignment.assignment_text=@text
      # TODO: Add stuff for adding file(s) to the assignment
      assignment.submit
      @submission_date=right_now[:sakai]
      @status='Submitted'
    end
  end

  def save_draft
    open
    on AssignmentStudentView do |assignment|
      assignment.assignment_text=@text
      # TODO: Add stuff for adding file(s) to the assignment
      assignment.save_draft
      @submission_date=right_now[:sakai]
      @status='Draft - In progress'
    end
  end

  def resubmit opts={}
    open
    on AssignmentStudentView do |assignment|
      assignment.assignment_text=opts[:text] unless opts[:text]==nil
      # TODO: Add stuff for adding/updating/removing file(s) for the assignment
      assignment.resubmit
      @submission_date=right_now[:sakai] # Is this right?
      @status='Submitted'
    end
    @text=opts[:text]
  end

  def grade_submission opts={}
    open_my_site_by_name @site
    assignments
    reset
    on(AssignmentsList).grade @title
    on(AssignmentSubmissionList).grade @student.ln_fn_id
    on AssignmentSubmission do |submission|
      submission.prepend(submission.assignment_submission, "{{#{opts[@inline_comment]}}}") unless opts[:inline_comment]==nil
      submission.instructor_comments=opts[:summary_comment] unless opts[:summary_comment]==nil
      submission.grade.select opts[:grade] unless opts[:grade]==nil
      submission.allow_resubmission.send(opts[:allow_resubmission]) unless opts[:allow_resubmission]==nil
      if opts[:allow_resubmission]==:set || submission.allow_resubmission.set?
        submission.num_resubmissions.wait_until_present
        if opts[:accept_until]==nil
          @num_resubmissions=submission.num_resubmissions.selected_options[0].text
          @accept_until={} # Okay to wipe this (in case it's there) because we're getting
                           # the values from UI--but most likely this var is nil anyway,
                           # in which case we need to turn it into a hash.
          @accept_until[:MON]=submission.accept_until_month.selected_options[0].text
          @accept_until[:day_of_month]=submission.accept_until_day.selected_options[0].text
          @accept_until[:year]=submission.accept_until_year.selected_options[0].text
          @accept_until[:hour]=submission.accept_until_hour.selected_options[0].text
          @accept_until[:minute_rounded]=submission.accept_until_min.selected_options[0].text
          @accept_until[:MERIDIAN]=submission.accept_until_meridian.selected_options[0].text
          @accept_until[:sakai_rounded]=@accept_until[:MON].capitalize+" "+@accept_until[:day_of_month]+", "+@accept_until[:year]+" "+@accept_until[:hour]+":"+@accept_until[:minute_rounded]+" "+@accept_until[:MERIDIAN].downcase
        else
          submission.num_resubmissions.select opts[:num_resubmissions]
          submission.accept_until_month.select opts[:accept_until][:MON]
          submission.accept_until_day.select opts[:accept_until][:day_of_month]
          submission.accept_until_year.select opts[:accept_until][:year]
          submission.accept_until_hour.select opts[:accept_until][:hour]
          submission.accept_until_min.select opts[:accept_until][:minute_rounded]
          submission.accept_until_meridian.select opts[:accept_until][:MERIDIAN]
        end
      end
      if opts[:release_to_student]=~/yes/i
        submission.save_and_release
        @status="Returned"
        @returned=right_now
      else
        submission.save_and_dont_release
      end
      submission.return_to_list
    end
    on AssignmentSubmissionList do |list|
      @grade_status=list.submission_status_of @student.ln_fn_id
    end
    set_options(opts)
  end

  def open
    open_my_site_by_name @site
    assignments
    reset
    on(AssignmentsList).open_assignment @title
  end
  alias view open


end