class MultipleChoiceQuestion

  include Foundry
  include DataFactory
  include Navigation
  include StringFactory

  attr_accessor :assessment, :text, :point_value, :part, :correct_type, :answer_credit,
                :negative_point_value, :pool,
                # TODO: There is no support yet for situations with multiple correct answers
                :correct_answer,
                # TODO: Can't have questions with more than 26 answers. That support must be added if necessary
                :answers,
                :answers_feedback,
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
    set_options(defaults.merge(opts))
    requires :assessment, :part
  end

  def create
    # Note that this method presumes that it's being called from
    # within methods in the AssessmentObject class, not directly
    # in a test script, so no positioning navigation is set up.
    on EditAssessment do |edit|
      edit.question_type 'Multiple Choice'
    end
    on MultipleChoice do |add|
      add.answer_point_value.set @point_value
      add.question_text.set @text
      add.send(@correct_type).set
      add.send(@answer_credit).set unless @answer_credit==nil
      add.negative_point_value.fit @negative_point_value
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
          raise 'There is no support for more than 26 choices right now'
      end
      @answers.each_with_index do |answer, x|
        add.answer_text((x+65).chr).set answer
      end
      @answers_feedback.each_with_index do |feedback, x|
        add.answer_feedback_text((x+65).chr).set feedback
      end
      add.correct_answer(@correct_answer).set
      add.randomize_answers_yes.set if @randomize_answers=="yes"
      add.require_rationale_yes.set if @require_rationale=="yes"
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.fit @pool
      add.correct_answer_feedback.fit @correct_answer_feedback
      add.incorrect_answer_feedback.fit @incorrect_answer_feedback
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
  include Navigation
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
      :one_to_ten
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
      edit.question_type 'Survey'
    end
    on Survey do |add|
      add.question_text.set @text
      add.send(@answer).set
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.fit @pool
      add.feedback.fit @feedback
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
  include Navigation
  include StringFactory

  attr_accessor :assessment, :part, :text, :point_value, :model_answer, :feedback,
                :pool, :rich_text

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :text=>random_alphanums,
        :point_value=>(rand(100)+1).to_s,
        :model_answer=>random_alphanums,
        :rich_text=>false
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
      edit.question_type 'Short Answer/Essay'
    end
    on ShortAnswer do |add|
      if @rich_text
        add.toggle_question_editor
        add.enter_source_text(add.question_editor, @text)
      else
        add.question_text.set @text
      end
      add.answer_point_value.set @point_value
      add.model_short_answer.set @model_answer
      add.feedback.fit @feedback
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.fit @pool
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
  include Navigation

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
      edit.question_type 'Fill in the Blank'
    end
    on FillInBlank do |add|
      add.question_text.set @text
      add.answer_point_value.set @point_value
      add.case_sensitive.send(@case_sensitive) unless @case_sensitive==nil
      add.mutually_exclusive.send(@mutually_exclusive) unless @mutually_exclusive==nil
      add.feedback.fit @feedback
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.fit @pool
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
  include Navigation

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
    on NumericResponse do |add|
      add.question_text.set @text
      add.answer_point_value.set @point_value
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.select @pool unless @pool==nil
      add.correct_answer_feedback.fit @correct_answer_feedback
      add.incorrect_answer_feedback.fit @incorrect_answer_feedback
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
  include Navigation

  attr_accessor :text, :point_value, :pairs, :correct_answer_feedback, :incorrect_answer_feedback

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :text=>random_alphanums,
        :point_value=>(rand(100)+1).to_s,
        :pairs=>[
            {:choice=>random_alphanums, :match=>random_alphanums, :correct_match_feedback=>random_alphanums, :incorrect_match_feedback=>random_alphanums},
            {:choice=>random_alphanums, :match=>random_alphanums, :correct_match_feedback=>random_alphanums, :incorrect_match_feedback=>random_alphanums},
            {:choice=>random_alphanums, :match=>:distractor, :correct_match_feedback=>random_alphanums, :incorrect_match_feedback=>random_alphanums},
            {:choice=>random_alphanums, :match=>random_alphanums, :correct_match_feedback=>random_alphanums, :incorrect_match_feedback=>random_alphanums},
            {:choice=>random_alphanums, :match=>random_alphanums, :correct_match_feedback=>random_alphanums, :incorrect_match_feedback=>random_alphanums},
            {:choice=>random_alphanums, :match=>:distractor, :correct_match_feedback=>random_alphanums, :incorrect_match_feedback=>random_alphanums}
        ]
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
      edit.question_type 'Matching'
    end
    on Matching do |add|
      add.question_text.set @text
      add.answer_point_value.set @point_value
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.fit @pool
      add.correct_answer_feedback.fit @correct_answer_feedback
      add.incorrect_answer_feedback.fit @incorrect_answer_feedback

      @pairs.each do |pair|
        add.choice.set pair[:choice]
        if pair[:match]==:distractor
          add.distractor
        else
          add.match.set pair[:match]
        end
        if add.correct_match_feedback.present?
          add.correct_match_feedback.fit pair[:correct_match_feedback]
          add.incorrect_match_feedback.fit pair[:incorrect_match_feedback]
        end
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
  include Navigation

  attr_accessor :point_value, :text, :negative_point_value, :answer, :assessment, :part, :pool,
                :correct_answer_feedback, :incorrect_answer_feedback, :required_rationale

  ANSWERS = %w{true false}

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :point_value=>(rand(100)+1).to_s,
        :text=>random_alphanums,
        :negative_point_value=>'0',
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
      edit.question_type 'True False'
    end
    on TrueFalse do |add|
      add.question_text.set @text
      add.answer_point_value.set @point_value
      add.answer(@answer).set
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.fit @pool
      add.correct_answer_feedback.fit @correct_answer_feedback
      add.incorrect_answer_feedback.fit @incorrect_answer_feedback
      add.require_rationale_yes.set if @require_rationale=='yes'
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
  include Navigation

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
      edit.question_type 'Audio Recording'
    end
    on AudioRecording do |add|
      add.question_text.set @text
      add.answer_point_value.set @point_value
      add.time_allowed.set @time_allowed
      add.number_of_attempts.select @number_of_attempts
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.fit @pool
      add.feedback.fit @feedback
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
  include Navigation

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
      edit.question_type 'File Upload'
    end
    on FileUpload do |add|
      add.question_text.set @text
      add.answer_point_value.set @point_value
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.fit @pool
      add.feedback.fit @feedback
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

class CalculatedQuestion

  include Foundry
  include DataFactory
  include StringFactory
  include Navigation

  attr_accessor :text, :point_value, :variables, :formulas, :part, :pool

  #TODO: Add randomization to this class!

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :text=>"Two cars left from the same point at the same time, one traveling East at {x} mph and the other traveling South at {y} mph. In how many minutes will they be {z} miles apart?\n\nRound to the nearest minute.\n\n{{abc}}",
        :variables=>{
            :x=>{:min=>rand(50)+1,:max=>rand(50)+51, :decimals=>rand(11)},
            :y=>{:min=>rand(50)+1,:max=>rand(50)+51, :decimals=>rand(11)},
            :z=>{:min=>rand(50)+1,:max=>rand(50)+51, :decimals=>rand(11)}
        },
        :formulas=>[{
                        :name=>'abc',
                        :text=>'SQRT({z}^2/({x}^2+{y}^2))*60',
                        :tolerance=>'0.01',
                        :decimals=>'0'
                    }],
        :point_value=>(rand(100)+1).to_s
    }

    options = defaults.merge(opts)

    set_options(options)
    requires @text
  end

  def calculation(x, y, z)
    (Math.sqrt((z**2)/((x**2)+(y**2))))*60
  end

  def create
    on EditAssessment do |edit|
      edit.question_type 'Calculated Question'
    end
    on CalculatedQuestions do |add|
      add.question_text.set @text
      add.answer_point_value.set @point_value
      add.assign_to_part.select /#{@part}/
      add.assign_to_pool.fit @pool
      add.question_text.set @text
      add.extract_vs_and_fs

      @variables.each do |name, attribs|
        var = name.to_s
        add.min_value(var).set attribs[:min]
        add.max_value(var).set attribs[:max]
        add.var_decimals(var).select attribs[:decimals]
      end
      @formulas.each do |formula|
        add.formula(formula[:name]).set formula[:text]
        add.tolerance(formula[:name]).set formula[:tolerance]
        add.form_decimals(formula[:name]).select formula[:decimals]
      end
      add.correct_answer_feedback.fit @correct_answer_feedback
      add.incorrect_answer_feedback.fit @incorrect_answer_feedback
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

# TODO: Finish defining this class
class PoolObject #TODO: Someday add support for sub pools

  include Foundry
  include DataFactory
  include StringFactory
  include Navigation

  attr_accessor :site, :name, :questions, :creator, :department, :description,
                :objectives, :keywords

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :name=>random_alphanums
    }
    options = defaults.merge(opts)

    set_options(options)
    requires @site
  end

  alias :group :department

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
