class AssessmentObject

  include Foundry
  include DataFactory
  include StringFactory
  include DateFactory
  include Navigation

  def question_types
    {
      :'Multiple Choice'=>MultipleChoiceQuestion,
      :Survey=>SurveyQuestion,
      :'Short Answer/Essay'=>ShortAnswerQuestion,
      :'Fill in the Blank'=>FillInBlankQuestion,
      :'Numeric Response'=>NumericResponseQuestion,
      :Matching=>MatchingQuestion,
      :'True False'=>TrueFalseQuestion,
      :'Audio Recording'=>AudioRecordingQuestion,
      :'File Upload'=>FileUploadQuestion,
      :'Calculated Question'=>CalculatedQuestion
    }
  end

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
        :parts=>PartsCollection.new,
        :questions=>QuestionsCollection.new,
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
        :final_page_url=>'http://www.rsmart.com',
        :student_ids=>:student_ids_seen
        # TODO: More to add
    }
    set_options(defaults.merge(opts))
    requires :site
    default_part = make PartObject, :title=>'Default', :assessment=>@title, :part_number=>1, :information=>''
    @parts << default_part
  end

  def create
    open_my_site_by_name @site
    tests_and_quizzes
    reset
    on_page AssessmentsList do |page|
      page.title.set @title
      page.type.select @type unless @type==nil
      page.create
    end
    on(EditAssessment).settings
    on AssessmentSettings do |settings|
      settings.open
      # Introduction

      #settings.authors.set @authors
      #settings.description.set @description
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
      #settings.submission_message.set @submission_message
      #settings.final_page_url.set @final_page_url
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

      fill_out settings, :authors, :description, :submission_message, :final_page_url

      settings.save_settings
    end
  end

  def update_settings opts={}

    set_options(opts)
  end

  def publish
    open_my_site_by_name @site
    tests_and_quizzes
    reset
    on(AssessmentsList).publish @title
    on(PublishAssessment).publish
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
        :part=>@parts[rand(@parts.length)].title,
        :type=>question_types.keys.shuffle[0]
    }
    options = defaults.merge(opts)
    question = make question_types[options[:type].to_sym], options
    question.create
    @questions << question
  end

  private

  def position
    open_my_site_by_name @site
    tests_and_quizzes
    unless @browser.frame(:class=>'portletMainIframe').h3.text=="Questions: #{@title}"
      reset
      on(AssessmentsList).edit @title
    end
  end

end

class PartObject

  include Foundry
  include DataFactory
  include Navigation
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
    requires :assessment
  end
    
  def create
    # Assumes you're already on the right page.
    on(EditAssessment).add_part
    on AddEditAssessmentPart do |part|
      fill_out part, :title, :information, :type, :question_ordering
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

class PartsCollection < Array

  # TODO: Is this method actually needed?
  def get(title)
    self.find { |item| item.title==title }
  end

end

class QuestionsCollection < Array



end