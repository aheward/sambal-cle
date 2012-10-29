class AssessmentObject

  include Foundry
  include DataFactory
  include StringFactory
  include DateFactory
  include Workflows

  attr_accessor :title, :site, :questions, :parts, :status, :type, :available_date,
                :due_date, :retract_date, :feedback_authoring, :feedback_delivery, :feedback_date,
                :release_to, :release, :release_options, :secondary_id, :secondary_password,
                :navigation, :question_layout, :numbering, :submissions, :num_submissions,
                :late_handling, :submission_message, :final_page_url, :student_ids,
                :gradebook_options, :recorded_score, :allowed_ips

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
      :title=>random_alphanums,
      :authors=>random_alphanums,
      :description=>random_alphanums,
      :parts=>[],
      :questions=>[],
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

    default_part = make PartObject, :title=>"Default", :assessment=>@title, :part_number=>1, :information=>""
    @parts << default_part
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
      settings.send(@released_to).set
      # High Security
      settings.allow_specified_ips.set @allowed_ips
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
      settings.send(@release).set
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
    my_workspace.open_my_site_by_name @site unless @browser.title=~/#{@site}/
    tests_and_quizzes unless @browser.title=~/Tests & Quizzes$/
    reset
    on AssessmentsList do |list|
      list.publish @title
    end
    on PublishAssessment do |assessment|
      assessment.publish
    end
  end

  def add_part opts={}
    position
    defaults = {
      :assessment=>@title,
      :part_number=>@parts.length+1
    }
    options = defaults.merge(opts)
    part = make PartObject, options
    part.create
    @parts << part
  end

  def add_question opts={}
    position
    defaults = {
        :assessment=>@title,
        :part=>@parts[rand(@parts.length)].title
    }
    options = defaults.merge(opts)
    question = make QuestionObject, options
    question.create
    @questions << question
  end

  private

  def position
    my_workspace.open_my_site_by_name @site unless @browser.title=~/#{@site}/
    tests_and_quizzes unless @browser.title=~/Tests & Quizzes$/
    unless @browser.frame(:class=>"portletMainIframe").h3.text=="Questions: #{@title}"
      reset
      on AssessmentsList do |list|
        list.edit @title
      end
    end
  end

end

class QuestionObject

  include Foundry
  include Utilities
  include Workflows
  include StringFactory

  attr_accessor :type, :assessment, :text, :point_value, :part,
                # Multiple Choice attributes...
                :correct_type, :answer_credit, :negative_point_value

  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        :type=>QUESTION_TYPES.keys[rand(QUESTION_TYPES.length)],
        :text=>random_alphanums,
        :point_value=>(rand(100)+1).to_s

    }
    options = defaults.merge(opts)
    set_options(options)
    requires @assessment
  end

  QUESTION_TYPES = {
      :"Multiple Choice"=>:add_multiple_choice,
      :Survey=>:add_survey#,
      #:"Short Answer/Essay"=>:add_short_answer,
      #:"Fill in the Blank"=>:add_fill_in_the_blank,
      #:"Numeric Response"=>:add_numeric,
      #:Matching=>:add_matching,
      #:"True False"=>:add_true_false,
      #:"Audio Recording"=>:add_audio,
      #:"File Upload"=>:add_file_upload,
      #:"Calculated Question"=>:add_calculated_question
  }

  def create
    on EditAssessment do |edit|
      edit.add_question_to_part(@part).select @type
    end
    self.send(QUESTION_TYPES[@type.to_sym])
  end

  private

  def add_multiple_choice
    on MultipleChoice do |add|
      add.answer_point_value.set @point_value
      add.question_text.set @text
      add.send(@correct_type).set
      add.send(@answer_credit).set unless @answer_credit==nil
      add.negative_point_value.set @negative_point_value unless @negative_point_value==nil

    end
  end

  def add_survey
    on Survey do |add|

    end
  end

end

class PartObject

  include Foundry
  include Utilities
  include Workflows
  include StringFactory

  attr_accessor :assessment, :title, :information, :type, :number_of_questions, :pool_name, :part_number, :question_ordering
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :title=>random_alphanums,
      :information=>random_alphanums,
      :type=>:one_by_one,
      :question_ordering=>:order_as_listed
    }
    options = defaults.merge(opts)
    
    set_options(options)
    requires @assessment
  end
    
  def create
    on EditAssessment do |edit|
      edit.add_part
    end
    on AddEditAssessmentPart do |part|
      part.title.set @title
      part.information.set @information
      part.send(@type).set
      part.send(@question_ordering).set
      # TODO: more to add here
      part.save
    end
  end
    
  def edit opts={}

    set_options(opts)
  end
    
  def view
    
  end
    
  def delete
    
  end
  
end
    
      