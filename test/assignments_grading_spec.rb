require 'rspec'
require 'sambal-cle'
require 'yaml'

describe "Assignments grading" do

  include Utilities
  include Workflows
  include PageHelper
  include Randomizers
  include DateMakers

  before :all do

    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8c662f2... Added the set_options method to the PageHelper module. Updated the data object classes to use this method.
    @student = make UserObject, :id=>@directory['person1']['id'], :password=>@directory['person1']['password'],
                    :first_name=>@directory['person1']['firstname'], :last_name=>@directory['person1']['lastname']
    @instructor1 = make UserObject, :id=>@directory['person3']['id'], :password=>@directory['person3']['password'],
                        :first_name=>@directory['person3']['firstname'], :last_name=>@directory['person3']['lastname'],
                        :type=>"Instructor"
    @instructor2 = make UserObject, :id=>@directory['person4']['id'], :password=>@directory['person4']['password'],
                        :first_name=>@directory['person4']['firstname'], :last_name=>@directory['person4']['lastname'],
                        :type=>"Instructor"
    @instructor1.log_in
<<<<<<< HEAD

    @site = make SiteObject
    @site.create
    @site.add_official_participants :role=>@student.type, :participants=>[@student.id]
    @site.add_official_participants :role=>@instructor2.type, :participants=>[@instructor2.id]
=======
    @student = @directory['person1']['id']
    @spassword = @directory['person1']['password']
    @instructor1 = @directory['person3']['id']
    @ipassword = @directory['person3']['password']

    @instructor2 = @directory['person4']['id']
    @password1 = @directory['person4']['password']

    log_in(@instructor1, @ipassword)

    @site = make SiteObject
    @site.create

    @site.add_official_participants :role=>"Student", :participants=>[@student]
    @site.add_official_participants :role=>"Instructor", :participants=>[@instructor2]
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.
=======

    @site = make SiteObject
    @site.create
    @site.add_official_participants :role=>@student.type, :participants=>[@student.id]
    @site.add_official_participants :role=>@instructor2.type, :participants=>[@instructor2.id]
>>>>>>> 8c662f2... Added the set_options method to the PageHelper module. Updated the data object classes to use this method.

    @assignment = make AssignmentObject, :site=>@site.name, :title=>random_string(25),
                       :open=>an_hour_ago, :grade_scale=>"Pass",
                       :instructions=>random_multiline(50, 15, :string)
<<<<<<< HEAD
<<<<<<< HEAD
    @submission = make AssignmentSubmissionObject, :site=>@site.name, :title=>@assignment.title,
                       :student=>@student
    @assignment2 = make AssignmentObject, :site=>@site.name, :title=>random_string(25),
                        :open=>an_hour_ago, :grade_scale=>"Letter grade"
<<<<<<< HEAD
    @submission2 = make AssignmentSubmissionObject, :site=>@site.name, :title=>@assignment2.title,
                        :student=>@student
    @assignment.create
    @assignment2.create

    @instructor1.log_out

    @student.log_in

    @submission.submit
    @submission2.submit

    @student.log_out
=======
=======
    @submission = make AssignmentSubmissionObject, :site=>@site.name, :title=>@assignment.title,
                       :student=>@student
>>>>>>> 8c662f2... Added the set_options method to the PageHelper module. Updated the data object classes to use this method.
    @assignment2 = make AssignmentObject, :site=>@site.name, :title=>random_string(25),
                        :open=>an_hour_ago, :grade_scale=>"Letter"
=======
>>>>>>> 38e0fb3... Added requires method to pagehelper, updated data object classes to use this method.
    @submission2 = make AssignmentSubmissionObject, :site=>@site.name, :title=>@assignment2.title,
                        :student=>@student
    @assignment.create
    @assignment2.create

    @instructor1.log_out

    @student.log_in

    @submission.submit
    @submission2.submit

    @student.log_out

<<<<<<< HEAD
    @instructor_comments = random_multiline(156, 9, :string)
    @comment_string = "{{Try again please.}}"

    @grade2 = "A-"
    @url = "www.rsmart.com"

<<<<<<< HEAD


>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.

=======
>>>>>>> 8c662f2... Added the set_options method to the PageHelper module. Updated the data object classes to use this method.
=======
>>>>>>> feb4534... Finished the Assignments Grading spec.
  end
=begin
  after :all do
    # Close the browser window
    @sakai.browser.close
  end
=end
<<<<<<< HEAD
<<<<<<< HEAD
  it "Assignment can be graded" do
    @instructor1.log_in
    @submission.grade_submission :summary_comment=>random_alphanums, :grade=>"Fail",
                      :inline_comment=>random_alphanums, :allow_resubmission=>:set,
                      :release_to_student=>"yes"
    @submission2.grade_submission :grade=>"C", :inline_comment=>random_alphanums,
                                  :summary_comment=>random_alphanums
    @instructor1.log_out
  end

  it "The graded assignment's status is based on whether it was released" do
    @student.log_in
    open_my_site_by_name @submission.site
    assignments
    on AssignmentsList do |list|
      list.status_of(@submission2).should=="#{@submission2.status} #{@submission2.submission_date}"
      list.status_of(@submission).should=="Returned"
    end
  end

  it "Assignment grade can be released to the student" do

    @submission.open
    on AssignmentStudentView do |view|
      view.summary_info["Grade"].should==@submission.grade
    end
  end

  it "Assignments can be resubmitted if instructor allows" do
    on AssignmentStudentView do |view|
      view.summary_info["Status"].should=="Return #{@submission.returned[:sakai]}"
      view.summary_info["Number of resubmissions allowed"].should==@submission.num_resubmissions
      view.summary_info["Accept Resubmission Until"].should==@submission.accept_until[:sakai_rounded]
      view.resubmit_button.should_be present
    end
  end

  it "Student can read instructor comments for returned assignments" do
    on AssignmentStudentView do |view|
      view.instructions.should==@assignment.instructions
      view.instructor_comments.should==@submission.summary_comment
      view.submission_text.should include @submission.inline_comment

    end
  end

  it "Students can't see grade or instructor comments until released" do
    @submission2.open
    on AssignmentStudentView do |view|
      view.summary_info["Grade"].should==nil
      view.instructor_comment_field.should_not be_present
      view.submission_text.should_not include @submission2.inline_comment
    end
  end

  # TODO: Other tests to add:
  # - Assignment resubmissions from the Grade page are per student, not global
  # - Tests of the second submission: Does it not allow any more?
=======
  it "Assignment grade can be released to the student" do
    log_in(@instructor1, @ipassword)
=======
  it "Assignment can be graded" do
    @instructor1.log_in
<<<<<<< HEAD
>>>>>>> 38e0fb3... Added requires method to pagehelper, updated data object classes to use this method.
    @submission.grade :grade=>"Fail", :summary_comment=>random_alphanums,
                      :inline_comment=>random_alphanums, :allow_resubmission==:set

=======
    @submission.grade_submission :summary_comment=>random_alphanums, :grade=>"Fail",
                      :inline_comment=>random_alphanums, :allow_resubmission=>:set,
                      :release_to_student=>"yes"
    @submission2.grade_submission :grade=>"C", :inline_comment=>random_alphanums,
                                  :summary_comment=>random_alphanums
    @instructor1.log_out
>>>>>>> 78bca1d... Adding more stuff for the assignment grading spec.  Renamed a page object class (AssignmentView) but didn't update all the specs, so this probably broke a bunch of stuff.
  end

  it "The graded assignment's status is based on whether it was released" do
    @student.log_in
    open_my_site_by_name @submission.site
    assignments
    on AssignmentsList do |list|
      list.status_of(@submission2).should=="#{@submission2.status} #{@submission2.submission_date}"
      list.status_of(@submission).should=="Returned"
    end
  end

  it "Assignment grade can be released to the student" do

    @submission.open
    on AssignmentStudentView do |view|
      view.summary_info["Grade"].should==@submission.grade
    end
  end

  it "Assignments can be resubmitted if instructor allows" do
    on AssignmentStudentView do |view|
      view.summary_info["Status"].should=="Return #{@submission.returned[:sakai]}"
      view.summary_info["Number of resubmissions allowed"].should==@submission.num_resubmissions
      view.summary_info["Accept Resubmission Until"].should==@submission.accept_until[:sakai_rounded]
      view.resubmit_button.should_be present
    end
  end

  it "Student can read instructor comments for returned assignments" do
    on AssignmentStudentView do |view|
      view.instructions.should==@assignment.instructions
      view.instructor_comments.should==@submission.summary_comment
      view.submission_text.should include @submission.inline_comment

    end
  end

  it "Students can't see grade or instructor comments until released" do
    @submission2.open
    on AssignmentStudentView do |view|
      view.summary_info["Grade"].should==nil
      view.instructor_comment_field.should_not be_present
      view.submission_text.should_not include @submission2.inline_comment
    end
  end
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.

  # TODO: Other tests to add:
  # - Assignment resubmissions from the Grade page are per student, not global
  # - Tests of the second submission: Does it not allow any more?

end