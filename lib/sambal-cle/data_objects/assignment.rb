# This data object is strictly the assignment as created by an instructor
# for Student submissions of an assignment, use AssignmentSubmissionObject
class AssignmentObject

  include Foundry
  include DataFactory
  include StringFactory
  include DateFactory
  include Workflows

  attr_accessor :title, :site, :instructions, :id, :link, :status, :grade_scale,
                :max_points, :allow_resubmission, :num_resubmissions, :open,
                :due, :accept_until, :student_submissions, :resubmission,
                :add_due_date, :add_open_announcement, :add_to_gradebook,
                # Note the following variables are taken from the Entity picker's
                # Item Info list
                :retract_time, :time_due, :time_modified, :url, :portal_url,
                :description, :time_created, :direct_url

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :title=>random_alphanums,
        :instructions=>random_multiline(250, 10, :string),
        :resubmission=>{},
        :open=>{},
        :due=>{},
        :accept_until=>{}
    }
    options = defaults.merge(opts)

    set_options(options)
    requires @site
    raise "You must specify max points if your grade scale is 'points'" if @max_points==nil && @grade_scale=="Points"
  end

  alias :name :title

  def create
    open_my_site_by_name @site

    # Go to assignments page
    assignments

    on_page AssignmentsList do |list|
      list.add
    end
    on_page AssignmentAdd do |add|
      @allow_resubmission==nil ? @allow_resubmission=checkbox_setting(add.allow_resubmission) : add.allow_resubmission.send(@allow_resubmission)
      if @allow_resubmission==:set
        add.num_resubmissions.wait_until_present
        @num_resubmissions=get_or_select(@num_resubmissions, add.num_resubmissions)
        @resubmission[:MON]=get_or_select(@resubmission[:MON], add.resub_until_month)
        @resubmission[:day_of_month]=get_or_select(@resubmission[:day_of_month], add.resub_until_day)
        @resubmission[:year]=get_or_select(@resubmission[:year], add.resub_until_year)
        @resubmission[:hour]=get_or_select(@resubmission[:hour], add.resub_until_hour)
        @resubmission[:minute_rounded]=get_or_select(@resubmission[:minute_rounded], add.resub_until_minute)
        @resubmission[:MERIDIAN]=get_or_select(@resubmission[:MERIDIAN], add.resub_until_meridian)
      end
      add.title.set @title
      add.instructions=@instructions
      @student_submissions=get_or_select(@student_submissions, add.student_submissions)
      @grade_scale=get_or_select(@grade_scale, add.grade_scale)
      @open[:MON]=get_or_select(@open[:MON], add.open_month)
      add.max_points.set(@max_points) unless @max_points==nil
      @open[:year]=get_or_select(@open[:year], add.open_year)
      @open[:day_of_month]=get_or_select(@open[:day_of_month], add.open_day)
      @open[:hour]=get_or_select(@open[:hour], add.open_hour)
      @open[:minute_rounded]=get_or_select(@open[:minute_rounded], add.open_minute)
      @open[:MERIDIAN]=get_or_select(@open[:MERIDIAN], add.open_meridian)
      @add_due_date==nil ? @add_due_date=checkbox_setting(add.add_due_date) : add.add_due_date.send(@add_due_date)
      @add_open_announcement==nil ? @add_open_announcement=checkbox_setting(add.add_open_announcement) : add.add_open_announcement.send(@add_open_announcement)
      @add_to_gradebook==nil ? @add_to_gradebook=radio_setting(add.add_to_gradebook) : add.add_to_gradebook.send(@add_to_gradebook)
      @due[:MON]=get_or_select(@due[:MON], add.due_month)
      @due[:year]=get_or_select(@due[:year], add.due_year)
      @due[:day_of_month]=get_or_select(@due[:day_of_month], add.due_day)
      @due[:hour]=get_or_select(@due[:hour], add.due_hour)
      @due[:minute_rounded]=get_or_select(@due[:minute_rounded], add.due_minute)
      @due[:MERIDIAN]=get_or_select(@due[:MERIDIAN], add.due_meridian)
      @accept_until[:MON]=get_or_select(@accept_until[:MON], add.accept_month)
      @accept_until[:year]=get_or_select(@accept_until[:year], add.accept_year)
      @accept_until[:day_of_month]=get_or_select(@accept_until[:day_of_month], add.accept_day)
      @accept_until[:hour]=get_or_select(@accept_until[:hour], add.accept_hour)
      @accept_until[:minute_rounded]=get_or_select(@accept_until[:minute_rounded], add.accept_minute)
      @accept_until[:MERIDIAN]=get_or_select(@accept_until[:MERIDIAN], add.accept_meridian)
      #@do_not_add_to_gradebook==nil ? @do_not_add_to_gradebook=radio_setting(add.do_not_add_gradebook.set?) :
      if @status=="Draft"
        add.save_draft
      else
        add.post
      end
    end
    on_page AssignmentsList do |list|
      @id = list.get_assignment_id @title
      @link = list.assignment_href @title
      @status = list.status_of @title
    end
  end

  def edit opts={}
    open_my_site_by_name @site
    assignments
    on AssignmentsList do |list|
      if @status=="Draft"
        list.edit_assignment "Draft - #{@title}"
      else
        list.edit_assignment @title
      end
    end

    on AssignmentAdd do |edit|
      edit.title.fit opts[:title]
      unless opts[:instructions]==nil
        edit.enter_source_text edit.editor, opts[:instructions]
      end
      edit.grade_scale.fit opts[:grade_scale]
      edit.max_points.fit opts[:max_points]

      #TODO: All the rest goes here

      # This should be one of the last items edited...
      edit.add_to_gradebook.send(opts[:add_to_gradebook]) unless opts[:add_to_gradebook]==nil

      if (@status=="Draft" && opts[:status]==nil) || opts[:status]=="Draft"
        edit.save_draft
      elsif opts[:status]=="Editing"
        # Stay on the page
      else
        edit.post
      end
    end
    set_options(opts)

    unless opts[:status]=="Editing"
      on AssignmentsList do |list|
        @status=list.status_of @title
      end
    end
  end

  def get_info
    open_my_site_by_name @site
    assignments
    on AssignmentsList do |list|
      @id = list.get_assignment_id @title
      @status=list.status_of @title
      @link=list.assignment_href @title
      if @status=="Draft"
        list.open_assignment "Draft - #{@title}"
      else
        list.edit_assignment @title
      end
    end

    # TODO: Add more stuff here as needed...

    on AssignmentAdd do |edit|

      @instructions=edit.get_source_text edit.editor
      edit.source edit.editor
      edit.entity_picker(edit.editor)
    end
    on EntityPicker do |info|
      info.view_assignment_details @title
      @retract_time=info.retract_time
      @time_due=info.time_due
      @time_modified=info.time_modified
      @url=info.url
      @portal_url=info.portal_url
      @description=info.description
      @time_created=info.time_created
      @direct_url=info.direct_link
      info.close_picker
    end
    on AssignmentAdd do |edit|
      edit.cancel
    end
  end

  def duplicate
    open_my_site_by_name @site
    assignments
    reset
    on AssignmentsList do |list|
      list.duplicate @title
    end

    duplicate_assignment = self
    duplicate_assignment.title="Draft - #{self.title} - Copy"
    duplicate_assignment.status="Draft"
    duplicate_assignment
  end

  def view_submissions
    # TODO: Create this method
  end

  # Use this method to open a submitted assignment for viewing
  # the page.
  def view_submission
    open_my_site_by_name @site
    assignments
    reset
    on AssignmentsList do |list|
      list.open_assignment @title
    end
  end
  alias open view_submission

end