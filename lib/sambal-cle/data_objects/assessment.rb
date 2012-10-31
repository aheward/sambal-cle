class AssessmentObject

  include Foundry
  include DataFactory
  include StringFactory
  include DateFactory
  include Workflows

  def question_types
    {
      :"Multiple Choice"=>MultipleChoiceQuestion,
      :Survey=>SurveyQuestion,
      :"Short Answer/Essay"=>ShortAnswerQuestion,
      :"Fill in the Blank"=>FillInBlankQuestion,
      :"Numeric Response"=>NumericResponseQuestion,
      :Matching=>MatchingQuestion,
      :"True False"=>TrueFalseQuestion,
      :"Audio Recording"=>AudioRecordingQuestion,
      :"File Upload"=>FileUploadQuestion,
      :"Calculated Question"=>CalculatedQuestion
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

class MultipleChoiceQuestion

  include Foundry
  include DataFactory
  include Workflows
  include StringFactory

  attr_accessor :assessment, :text, :point_value, :part, :correct_type, :answer_credit,
                :negative_point_value, :pool,
                # TODO: There is no support yet for situations with multiple correct answers
                :correct_answer,
                # TODO: Can't have questions with more than 26 answers. That support must be added if necessary
                :answers,
                # TODO: Add support for individual answer feedback
                :randomize_answers, :require_rationale, :correct_answer_feedback,
                :incorrect_answer_feedback


  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        :text=>random_alphanums,
        :point_value=>(rand(100)+1).to_s,
        :correct_type=>:single_correct,
        :answers=>[random_alphanums, random_alphanums, random_alphanums, random_alphanums],
    }
    defaults[:correct_answer]=(rand(defaults[:answers].length)+65).chr.to_s
    options = defaults.merge(opts)
    set_options(options)
    requires @assessment, @part
  end

  def create
    # Note that this method presumes that it's being called from
    # within methods in the AssessmentObject class, not directly
    # in a test script, so no positioning navigation is set up.
    on EditAssessment do |edit|
      edit.question_type "Multiple Choice"
    end
    on MultipleChoice do |add|
      add.answer_point_value.set @point_value
      add.question_text.set @text
      add.send(@correct_type).set
      add.send(@answer_credit).set unless @answer_credit==nil
      add.negative_point_value.set @negative_point_value unless @negative_point_value==nil
      case(@answers.length)
        when 1..3
          (4-@answers.length).times { add.remove_last_answer }
        when 4
          # Do nothing yet
        when 5..10
          add.insert_additional_answers.select((@answers.length-4).to_s)
        when 11..16
          add.insert_additional_answers.select "6"
          add.insert_additional_answers.select((@answers.length-10).to_s)
        when 17..22
          2.times {add.insert_additional_answers.select "6"}
          add.insert_additional_answers.select((@answers.length-16).to_s)
        when 23..26
          3.times {add.insert_additional_answers.select "6"}
          add.insert_additional_answers.select((@answers.length-22).to_s)
        else
          raise "There is no support for more than 26 choices right now"
      end
      @answers.each_with_index do |answer, x|
        add.answer_text((x+65).chr).set answer
      end
      add.correct_answer(@correct_answer).set
      add.randomize_answers_yes.set if @randomize_answers=="yes"
      add.require_rationale_yes.set if @require_rationale=="yes"
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.select @pool unless @pool==nil
      add.correct_answer_feedback.set @correct_answer_feedback unless @correct_answer_feedback==nil
      add.incorrect_answer_feedback.set @incorrect_answer_feedback unless @incorrect_answer_feedback==nil
      add.save
    end
  end

  def edit opts={}
    # TODO
    set_options(opts)
  end

end

class SurveyQuestion

  include Foundry
  include DataFactory
  include Workflows
  include StringFactory
  
  attr_accessor :assessment, :text, :part, :answer, :feedback, :pool

  ANSWERS=[
      :yes_no,
      :disagree_agree,
      :disagree_undecided,
      :below_above,
      :strongly_agree,
      :unacceptable_excellent,
      :one_to_five,
      :one_to_ten,
      :feedback
  ]

  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :text=>random_alphanums,
      :answer=>ANSWERS[rand(ANSWERS.length)]
    }
    options = defaults.merge(opts)
    
    set_options(options)
    requires @assessment
  end
    
  def create
    # Note that this method presumes that it's being called from
    # within methods in the AssessmentObject class, not directly
    # in a test script, so no positioning navigation is set up.
    on EditAssessment do |edit|
      edit.question_type "Survey"
    end
    on Survey do |add|
      add.question_text.set @text
      add.send(@answer).set
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.select @pool unless @pool==nil
      add.feedback.set @feedback unless @feedback==nil
      add.save
    end
  end
    
  def edit opts={}
    #TODO
    set_options(opts)
  end

  
end
    
class ShortAnswerQuestion

  include Foundry
  include DataFactory
  include Workflows
  include StringFactory

  attr_accessor :assessment, :part, :text, :point_value, :model_answer, :feedback, :pool

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
      :text=>random_alphanums,
      :point_value=>(rand(100)+1).to_s,
      :model_answer=>random_alphanums,
    }
    options = defaults.merge(opts)

    set_options(options)
    requires @assessment, @part
  end

  def create
    # Note that this method presumes that it's being called from
    # within methods in the AssessmentObject class, not directly
    # in a test script, so no positioning navigation is set up.
    on EditAssessment do |edit|
      edit.question_type "Short Answer/Essay"
    end
    on ShortAnswer do |add|
      add.question_text.set @text
      add.answer_point_value.set @point_value
      add.model_short_answer.set @model_answer
      add.feedback.set @feedback unless @feedback==nil
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.select @pool unless @pool==nil
      add.save
    end
  end

  def edit opts={}
    #TODO
  end

end

class FillInBlankQuestion

  include Foundry
  include DataFactory
  include StringFactory
  include Workflows
  
  attr_accessor :assessment, :part, :text, :point_value, :case_sensitive, :mutually_exclusive, :pool,
                :correct_answer_feedback, :incorrect_answer_feedback,
                # TODO: Make the answer support more robust--for synonyms and stuff.
                :answers
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :answers=>[random_alphanums, random_alphanums],
      :point_value=>(rand(100)+1).to_s
    }
    question_string = random_alphanums
    defaults[:answers].each do |answer|
      question_string << " {#{answer}} #{random_alphanums}"
    end
    defaults[:text]=question_string
    options = defaults.merge(opts)
    
    set_options(options)
    requires @assessment
  end
    
  def create
    # Note that this method presumes that it's being called from
    # within methods in the AssessmentObject class, not directly
    # in a test script, so no positioning navigation is set up.
    on EditAssessment do |edit|
      edit.question_type "Fill in the Blank"
    end
    on FillInBlank do |add|
      add.question_text.set @text
      add.answer_point_value.set @point_value
      add.case_sensitive.send(@case_sensitive) unless @case_sensitive==nil
      add.mutually_exclusive.send(@mutually_exclusive) unless @mutually_exclusive==nil
      add.feedback.set @feedback unless @feedback==nil
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.select @pool unless @pool==nil
      add.save
    end
  end
    
  def edit opts={}
    
    set_options(opts)
  end
  
end
    
class NumericResponseQuestion

  include Foundry
  include DataFactory
  include StringFactory
  include Workflows
  
  attr_accessor :text, :point_value, :answers, :correct_answer_feedback, :part, :pool, :incorrect_answer_feedback
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
        :answers=>[rand(2000), rand(10000000)],
        :point_value=>(rand(100)+1).to_s
    }
    question_string = random_alphanums
    defaults[:answers].each do |answer|
      question_string << " {#{answer}} #{random_alphanums}"
    end
    defaults[:text]=question_string

    options = defaults.merge(opts)
    
    set_options(options)
    requires @text
  end
    
  def create
    # Note that this method presumes that it's being called from
    # within methods in the AssessmentObject class, not directly
    # in a test script, so no positioning navigation is set up.
    on EditAssessment do |edit|
      edit.question_type "Numeric Response"
    end
    on FillInBlank do |add|
      add.question_text.set @text
      add.answer_point_value.set @point_value
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.select @pool unless @pool==nil
      add.correct_answer_feedback.set @correct_answer_feedback unless @correct_answer_feedback==nil
      add.incorrect_answer_feedback.set @incorrect_answer_feedback unless @incorrect_answer_feedback==nil
      add.save
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

class MatchingQuestion

  include Foundry
  include DataFactory
  include StringFactory
  include Workflows
  
  attr_accessor :text, :point_value, :pairs, :distractors, :correct_answer_feedback, :incorrect_answer_feedback
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :text=>random_alphanums,
      :point_value=>(rand(100)+1).to_s,
      :pairs=>{random_alphanums=>random_alphanums, random_alphanums=>random_alphanums, random_alphanums=>random_alphanums, random_alphanums=>random_alphanums, random_alphanums=>random_alphanums, random_alphanums=>random_alphanums},
      :distractors=>[random_alphanums, random_alphanums, random_alphanums, random_alphanums, random_alphanums, random_alphanums]
    }
    options = defaults.merge(opts)
    
    set_options(options)
    requires @assessment
  end
    
  def create
    # Note that this method presumes that it's being called from
    # within methods in the AssessmentObject class, not directly
    # in a test script, so no positioning navigation is set up.
    on EditAssessment do |edit|
      edit.question_type "Matching"
    end
    on Matching do |add|
      add.question_text.set @text
      add.answer_point_value.set @point_value
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.select @pool unless @pool==nil
      add.correct_answer_feedback.set @correct_answer_feedback unless @correct_answer_feedback==nil
      add.incorrect_answer_feedback.set @incorrect_answer_feedback unless @incorrect_answer_feedback==nil

      #Match Pairs
      @pairs.each do |choice, match|
        add.choice.set choice
        add.match.set match
        add.save_pairing
        add.choice.wait_until_present
      end

      #Distractors
      @distractors.each do |distractor|
        add.choice.set distractor
        add.distractor
        add.save_pairing
        add.choice.wait_until_present
      end

      add.save
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
    
class TrueFalseQuestion

  include Foundry
  include DataFactory
  include StringFactory
  include Workflows
  
  attr_accessor :point_value, :text, :negative_point_value, :answer, :assessment, :part, :pool,
                :correct_answer_feedback, :incorrect_answer_feedback, :required_rationale

  ANSWERS = %w{true false}

  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :point_value=>(rand(100)+1).to_s,
      :text=>random_alphanums,
      :negative_point_value=>"0",
      :answer=>ANSWERS[rand(2)]
    }
    options = defaults.merge(opts)
    
    set_options(options)
    requires @point_value
  end
    
  def create
    # Note that this method presumes that it's being called from
    # within methods in the AssessmentObject class, not directly
    # in a test script, so no positioning navigation is set up.
    on EditAssessment do |edit|
      edit.question_type "True False"
    end
    on TrueFalse do |add|
      add.question_text.set @text
      add.answer_point_value.set @point_value
      add.answer(@answer).set
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.select @pool unless @pool==nil
      add.correct_answer_feedback.set @correct_answer_feedback unless @correct_answer_feedback==nil
      add.incorrect_answer_feedback.set @incorrect_answer_feedback unless @incorrect_answer_feedback==nil
      add.require_rationale_yes.set if @require_rationale=="yes"
      add.save
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
    
class AudioRecordingQuestion

  include Foundry
  include DataFactory
  include StringFactory
  include Workflows
  
  attr_accessor :text, :point_value, :time_allowed, :number_of_attempts, :part, :pool, :feedback
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :text=>random_alphanums,
      :point_value=>(rand(100)+1).to_s,
      :time_allowed=>(rand(600)+1).to_s,
      :number_of_attempts=>(rand(10)+1).to_s,
    }
    options = defaults.merge(opts)
    
    set_options(options)
    requires @text
  end
    
  def create
    # Note that this method presumes that it's being called from
    # within methods in the AssessmentObject class, not directly
    # in a test script, so no positioning navigation is set up.
    on EditAssessment do |edit|
      edit.question_type "Audio Recording"
    end
    on AudioRecording do |add|
      add.question_text.set @text
      add.answer_point_value.set @point_value
      add.time_allowed.set @time_allowed
      add.number_of_attempts.select @number_of_attempts
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.select @pool unless @pool==nil
      add.feedback.set @feedback unless @feedback==nil
      add.save
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
    
class FileUploadQuestion

  include Foundry
  include DataFactory
  include StringFactory
  include Workflows
  
  attr_accessor :text, :point_value, :part, :pool, :feedback
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :text=>random_alphanums,
      :point_value=>(rand(100)+1).to_s
    }
    options = defaults.merge(opts)
    
    set_options(options)
    requires @text
  end
    
  def create
    # Note that this method presumes that it's being called from
    # within methods in the AssessmentObject class, not directly
    # in a test script, so no positioning navigation is set up.
    on EditAssessment do |edit|
      edit.question_type "File Upload"
    end
    on FileUpload do |add|
      add.question_text.set @text
      add.answer_point_value.set @point_value
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.select @pool unless @pool==nil
      add.feedback.set @feedback unless @feedback==nil
      add.save
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
    
class CalculatedQuestionObject

  include Foundry
  include DataFactory
  include StringFactory
  include Workflows
  
  attr_accessor :text, :point_value, :variables, :formula,

  FORMULAS = [
      ""
  ]

  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :text=>"ugh",
      :point_value=>(rand(100)+1).to_s,
      :variables=>[],
      :formula=>,
    }
    options = defaults.merge(opts)
    
    set_options(options)
    requires @text
  end
    
  def create
    
  end
    
  def edit opts={}
    
    set_options(opts)
  end
    
  def view
    
  end
    
  def delete
    
  end
  
end

class PartObject

  include Foundry
  include DataFactory
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
    
      