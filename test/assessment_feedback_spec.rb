require 'rspec'
require 'sambal-cle'
require 'yaml'

describe "Assessment Feedback" do

  include Workflows
  include Foundry
  include StringFactory
  include DateFactory

  before :all do
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser

    @student = make UserObject, :id=>@directory['person1']['id'], :password=>@directory['person1']['password'],
                    :first_name=>@directory['person1']['firstname'], :last_name=>@directory['person1']['lastname']
    @instructor = make UserObject, :id=>@directory['person3']['id'], :password=>@directory['person3']['password'],
                        :first_name=>@directory['person3']['firstname'], :last_name=>@directory['person3']['lastname'],
                        :type=>"Instructor"
    @instructor.log_in

    @site = make CourseSiteObject
    @site.create
    @site.add_official_participants @student.type, @student.id

    @assessment = make AssessmentObject, :site=>@site.name,
                       :feedback_delivery=>:immediate_feedback,
                       :feedback_authoring=>:both_feedback_levels,
                       :release_options=>[:release_question_level_feedback, :release_selection_level_feedback]
    @assessment.create

    @assessment.add_question :type=>"Multiple Choice",
                             :answers_feedback=>[random_alphanums, random_alphanums, random_alphanums, random_alphanums],
                             :correct_answer_feedback=>random_alphanums,
                             :incorrect_answer_feedback=>random_alphanums
    @assessment.add_question :type=>"Survey",
                             :feedback=>random_alphanums
    @assessment.add_question :type=>"Short Answer/Essay",
                             :feedback=>random_alphanums
    @assessment.add_question :type=>"Fill in the Blank",
                             :correct_answer_feedback=>random_alphanums,
                             :incorrect_answer_feedback=>random_alphanums
    @assessment.add_question :type=>"Numeric Response",
                             :correct_answer_feedback=>random_alphanums,
                             :incorrect_answer_feedback=>random_alphanums
    @assessment.add_question :type=>"Matching",
                             :correct_answer_feedback=>random_alphanums,
                             :incorrect_answer_feedback=>random_alphanums
    @assessment.add_question :type=>"True False",
                             :correct_answer_feedback=>random_alphanums,
                             :incorrect_answer_feedback=>random_alphanums
    @assessment.add_question :type=>"Audio Recording",
                             :feedback=>random_alphanums
    @assessment.add_question :type=>"File Upload",
                             :feedback=>random_alphanums
    @assessment.add_question :type=>"Calculated Question",
                             :correct_answer_feedback=>random_alphanums,
                             :incorrect_answer_feedback=>random_alphanums

    @assessment.publish

    @instructor.log_out

  end

  after :all do
    @browser.close
  end

  xit "feedback" do
    # Test cases pending underlying submission code.
  end

end