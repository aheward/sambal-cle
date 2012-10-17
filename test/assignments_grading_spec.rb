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

    @student = make UserObject, :id=>@directory['person1']['id'], :password=>@directory['person1']['password'],
                    :first_name=>@directory['person1']['firstname'], :last_name=>@directory['person1']['lastname']
    @instructor1 = make UserObject, :id=>@directory['person3']['id'], :password=>@directory['person3']['password'],
                        :first_name=>@directory['person3']['firstname'], :last_name=>@directory['person3']['lastname'],
                        :type=>"Instructor"
    @instructor2 = make UserObject, :id=>@directory['person4']['id'], :password=>@directory['person4']['password'],
                        :first_name=>@directory['person4']['firstname'], :last_name=>@directory['person4']['lastname'],
                        :type=>"Instructor"
    @instructor1.log_in

    @site = make SiteObject
    @site.create
    @site.add_official_participants :role=>@student.type, :participants=>[@student.id]
    @site.add_official_participants :role=>@instructor2.type, :participants=>[@instructor2.id]

    @assignment = make AssignmentObject, :site=>@site.name, :title=>random_string(25),
                       :open=>an_hour_ago, :grade_scale=>"Pass",
                       :instructions=>random_multiline(50, 15, :string)
    @submission = make AssignmentSubmissionObject, :site=>@site.name, :title=>@assignment.title,
                       :student=>@student
    @assignment2 = make AssignmentObject, :site=>@site.name, :title=>random_string(25),
                        :open=>an_hour_ago, :grade_scale=>"Letter"
    @submission2 = make AssignmentSubmissionObject, :site=>@site.name, :title=>@assignment2.title,
                        :student=>@student
    @assignment.create
    @assignment2.create

    @instructor1.log_out

    @student.log_in

    @submission.submit
    @submission2.submit

    @student.log_out

    @instructor_comments = random_multiline(156, 9, :string)
    @comment_string = "{{Try again please.}}"

    @grade2 = "A-"
    @url = "www.rsmart.com"

  end
=begin
  after :all do
    # Close the browser window
    @sakai.browser.close
  end
=end
  it "Assignment grade can be released to the student" do
    log_in(@instructor1, @ipassword)
    @submission.grade :grade=>"Fail", :summary_comment=>random_alphanums,

  end

  xit "bal" do
    # Click to Grade the first assignment
    submissions = assignments.grade(@assignment1)

    # Grade the student's assignment
    grade_assignment = submissions.grade @student

    # Add comments
    grade_assignment.assignment_text=@comment_string
    grade_assignment.instructor_comments=@instructor_comments

    # Set failing grade
    grade_assignment.select_default_grade=@grade1

    # Allow resubmission
    grade_assignment.check_allow_resubmission

    # Add attachment
    attach = grade_assignment.add_attachments

    attach.url=@url
    attach.add

    grade_assignment = attach.continue

    # Save and release to student
    grade_assignment.save_and_release

    submissions = grade_assignment.return_to_list

    # Go back to the assignments list
    assignments = submissions.assignment_list

    # Grade Assignment 2...
    submissions = assignments.grade(@assignment2)

    # Select the student
    grade_assignment = submissions.grade @student

    # Select a default grade
    grade_assignment.select_default_grade=@grade2

    # Save and don't release
    grade_assignment.save_and_dont_release

    # Log out and log back in as student user
    grade_assignment.logout
    workspace = @sakai.page.login(@student_id, @student_pw)

    # Go to the test site
    home = workspace.open_my_site_by_id @site_id

    # Go to assignments page
    assignments = home.assignments

    assignment1 = assignments.open_assignment @assignment1

    # TEST CASE: Verify that the assignment grade is "Fail"
    assert_equal("Fail", assignment1.item_summary["Grade"])

    # TEST CASE: Verify assignment 1 shows "returned"
    assert_equal( assignment1.header, "#{@assignment1} - Resubmit" )

    assignments = assignment1.cancel

    assignment2 = assignments.open_assignment @assignment2

    # TEST CASE: Verify assignment 2 still shows "submitted"
    assert_equal( assignment2.header, "#{@assignment2} - Submitted" )

    list = assignment2.back_to_list

    # TEST CASE: Verify assignment 2 shows as "submitted" in the assignments list.
    assert list.status_of(@assignment2).include?("Submitted")
  end

end