class AssignmentSubmissionObject

  include PageHelper
  include Utilities
  include Randomizers
  include DateMakers
  include Workflows

  attr_accessor :site, :title, :text, :status, :submission_date,
      :student, :allow_resubmissions, :resubmission, :num_resubmissions,
      :release_to_student, :grade, :summary_comment, :inline_comment,
      :grade_status, :accept_until

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
      :text=>random_alphanums,
      :status=>"Not Started"
    }
    options = defaults.merge(opts)

    set_options(options)

    requires @site, @title, @student
  end

  def submit
    open
    on AssignmentStudent do |assignment|
      assignment.assignment_text=@text
      # TODO: Add stuff for adding file(s) to the assignment
      assignment.submit
      @submission_date=right_now[:sakai]
      @status="Submitted"
    end
  end

  def save_draft
    open
    on AssignmentStudent do |assignment|
      assignment.assignment_text=@text
      # TODO: Add stuff for adding file(s) to the assignment
      assignment.save_draft
      @submission_date=right_now[:sakai]
      @status="Draft - In progress"
    end
  end

  def resubmit opts={}
    open
    on AssignmentStudent do |assignment|
      assignment.assignment_text=opts[:text] unless opts[:text]==nil
      # TODO: Add stuff for adding/updating/removing file(s) for the assignment
      assignment.resubmit
      @submission_date=right_now[:sakai] # Is this right?
      @status="Submitted"
    end
    @text=opts[:text]
  end

  def grade opts={}
    open_my_site_by_name @site unless @browser.title=~/#{@site}/
    assignments unless @browser.title=~/Assignments$/
    reset
    on AssignmentsList do |list|
      list.grade @title
    end
    on AssignmentSubmissionList do |submissions|
      submissions.grade @student.ln_fn_id
    end
    on AssignmentSubmission do |submission|
      submission.prepend(submission.assignment_submission, "{{#{opts[:inline_comment]}}}") unless opts[:inline_comment]==nil
      submission.instructor_comments=opts[:summary_comment] unless opts[:summary_comment]==nil
      submission.grade.select opts[:grade] unless opts[:grade]==nil
      submission.accept_until @bla unless opts[:bla]==nil
    end





    # Get the @grade_status!

    set_options(opts)

  end

  def open
    open_my_site_by_name @site unless @browser.title=~/#{@site}/
    assignments unless @browser.title=~/Assignments$/
    reset
    on AssignmentsList do |list|
      list.open_assignment @title
    end
  end
  alias view open


end