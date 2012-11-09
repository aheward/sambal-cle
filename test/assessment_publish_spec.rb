require 'rspec'
require 'sambal-cle'
require 'yaml'

describe "Publishing Assessments" do

  include Workflows
  include Foundry
  include DateFactory

  before :all do
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser

    @student = make UserObject, :id=>@directory['person1']['id'], :password=>@directory['person1']['password'],
                    :first_name=>@directory['person1']['firstname'], :last_name=>@directory['person1']['lastname']
    @instructor1 = make UserObject, :id=>@directory['person3']['id'], :password=>@directory['person3']['password'],
                        :first_name=>@directory['person3']['firstname'], :last_name=>@directory['person3']['lastname'],
                        :type=>"Instructor"
    @instructor2 = make UserObject, :id=>@directory['person4']['id'], :password=>@directory['person4']['password'],
                        :first_name=>@directory['person4']['firstname'], :last_name=>@directory['person4']['lastname'],
                        :type=>"Instructor"
    @instructor1.log_in

    @site = make CourseSiteObject
    @site.create
    @site.add_official_participants :role=>@student.type, :participants=>[@student.id]
    @site.add_official_participants :role=>@instructor2.type, :participants=>[@instructor2.id]

    @assessment1 = make AssessmentObject, :site=>@site.name
    @assessment1.create

    1.times{ @assessment1.add_part }
    3.times{ @assessment1.add_question }

    @assessment2 = make AssessmentObject, :site=>@site.name
    @assessment2.create

    1.times{ @assessment2.add_part }
    3.times{ @assessment2.add_question }

    @assessment2.publish

    @assessment3 = make AssessmentObject, :site=>@site.name, :available_date=>in_an_hour
    @assessment3.create

    1.times{ @assessment3.add_part }
    3.times{ @assessment3.add_question }

    @assessment3.publish

    @instructor1.log_out

  end

  after :all do
    @browser.close
  end

  it "Instructors can see pending, published, and inactive assessments made by others" do
    @instructor2.log_in
    open_my_site_by_name @site.name
    tests_and_quizzes
    on AssessmentsList do |list|
      list.pending_assessment_titles.should include @assessment1.title
      list.published_assessment_titles.should include @assessment2.title
      list.inactive_assessment_titles.should include @assessment3.title
    end
    @instructor2.log_out
  end

  it "Students can see published assessments that are currently available" do
    @student.log_in
    open_my_site_by_name @site.name
    tests_and_quizzes
    on StudentAssessmentsList do |list|
      list.available_assessments.should include @assessment2.title
    end
  end

  it "Students cannot see published assessments prior to the available date" do
    @student.log_in
    open_my_site_by_name @site.name
    tests_and_quizzes
    on StudentAssessmentsList do |list|
      list.available_assessments.should_not include @assessment3.title
    end
  end

  it "Students cannot see unpublished assessments" do
    @student.log_in
    open_my_site_by_name @site.name
    tests_and_quizzes
    on StudentAssessmentsList do |list|
      list.available_assessments.should_not include @assessment1.title
    end
  end

end