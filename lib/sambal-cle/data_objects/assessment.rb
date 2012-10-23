class AssessmentObject

  include PageHelper
  include Utilities
  include Randomizers
  include DateMakers
  include Workflows

  attr_accessor :title, :site, :questions, :parts, :status, :type, :available_date,
                :due_date, :retract_date, :feedback_authoring, :feedback_delivery, :feedback_date,
                :release_to, :release, :release_options, :secondary_id, :secondary_password,
                :navigation, :question_layout, :numbering, :submissions, :num_submissions,
                :late_handling, :submission_message, :final_page_url, :student_ids,
                :gradebook_options, :recorded_score

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
      :title=>random_alphanums,
      :authors=>random_alphanums,
      :description=>random_alphanums,
      :available_date=>right_now,
      :due_date=>tomorrow,
      :retract_date=>next_week,
      :feedback_authoring=>:question_level_feedback,
      :feedback_delivery=>:no_feedback,
      :release=>:release_questions_and,
      :release_options=>[],
      :released_to=>:released_to_site,
      :navigation=>:linear_access,
      :submissions=>:unlimited_submissions,
      :late_handling=>:late_submissions_not_accepted,
      :submission_message=>random_alphanums,
      :final_page_url=>"http://www.rsmart.com",
      :student_ids=>:student_ids_seen
      # TODO: More to add
    }
    options = defaults.merge(opts)
    set_options(options)
    requires @site
  end

  def create
    my_workspace.open_my_site_by_name @site unless @browser.title=~/#{@site}/
    tests_and_quizzes unless @browser.title=~/Tests & Quizzes$/
    reset
    on_page AssessmentsList do |page|
      page.title.set @title
      page.type.select @type unless @type==nil
      page.create
    end
    on EditAssessment do |assessment|
      assessment.settings
    end
    on AssessmentSettings do |settings|
      settings.open
      # Introduction
      settings.authors.set @authors
      settings.description.set @description
      # Delivery Dates
      settings.available_date.set @available_date[:samigo]
      settings.due_date.set @due_date[:samigo]
      settings.retract_date.set @retract_date[:samigo]
      # Assessment Released To
      settings.release_to.set @released_to
      # High Security
      settings.secondary_id.set @secondary_id
      settings.secondary_pw.set @secondary_password
      # Assessment Organization
      settings.send(@navigation).set
      if @navigation==:random_access
        settings.send(@question_layout).set
        settings.send(@numbering).set
      # Mark for Review
        settings.send(@mark_for_review)
      end
      # Submissions
      settings.send(@submissions).set
      if @submissions==:only_x_submissions
        settings.allowed_submissions.set @num_submissions
      end
      settings.send(@late_handling).set
      # Submission Message
      settings.submission_message.set @submission_message
      settings.final_page_url.set @final_page_url
      # Feedback
      settings.send(@feedback_authoring).set
      settings.send(@feedback_delivery).set
      settings.send(@release_options).set
      @release_options.each do |option|
        settings.send(option).set
      end
      if @feedback_delivery==:feedback_on_date
        settings.feedback_date.set @feedback_date
      end
      # Grading
      # TODO: More to add here
      # Graphics

      # Metadata


      settings.save
    end
  end

  def update_settings opts={}

    set_options(opts)
  end

  def publish


  end

end

class QuestionObject

  include PageHelper
  include Utilities
  include Workflows

  attr_accessor :site, :type, :assessment, :text, :point_value, :part

  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        :type=>"Short Answer/Essay",
        :text=>random_alphanums,
        :point_value=>"10"

    }
    options = defaults.merge(opts)
    set_options(options)
    requires @site
    requires @assessment
  end

  @q_types = {
      "Multiple Choice"=>:make_multiple_choice,
      "True False"=>:make_true_false,
      "Fill in the Blank"=>:make_fill_blank,
      "Survey"=>:make_survey
  }

  def create
    my_workspace.open_my_site_by_name @site unless @browser.title=~/#{@site}/
    tests_and_quizzes unless @browser.title=~/Tests & Quizzes$/

  end

  private

  def make_multiple_choice

  end

  def make_true_false

  end

end