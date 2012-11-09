# coding: UTF-8
require 'rspec'
require 'sambal-cle'
require 'yaml'

describe "Assignments Submission" do

  include Utilities
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
    @instructor1 = make UserObject, :id=>@directory['person3']['id'], :password=>@directory['person3']['password'],
                        :first_name=>@directory['person3']['firstname'], :last_name=>@directory['person3']['lastname'],
                        :type=>"Instructor"
    @instructor2 = make UserObject, :id=>@directory['person4']['id'], :password=>@directory['person4']['password'],
                        :first_name=>@directory['person4']['firstname'], :last_name=>@directory['person4']['lastname'],
                        :type=>"Instructor"
    @instructor1.log_in

    @site = make CourseSiteObject
    @site.create
    @site.add_official_participants @student.type, @student.id
    @site.add_official_participants @instructor2.type, @instructor2.id

    @assignment = make AssignmentObject, :site=>@site.name, :title=>random_string(25),
                       :open=>an_hour_ago, :grade_scale=>"Pass",
                       :instructions=>random_multiline(100, 15, :string)
    @submission = make AssignmentSubmissionObject, :site=>@site.name, :title=>@assignment.title,
                       :student=>@student
    @assignment2 = make AssignmentObject, :site=>@site.name, :title=>random_string(25),
                        :open=>an_hour_ago, :grade_scale=>"Points", :max_points=>"111",
                        :allow_resubmission=>:set
    @submission2 = make AssignmentSubmissionObject, :site=>@site.name, :title=>@assignment2.title,
                       :student=>@student
    @assignment.create
    @assignment2.create

    @instructor1.log_out
    @student.log_in
  end

  after :all do
    # Close the browser window
    @sakai.browser.close
  end

  it "Student can save an assignment as 'In progress'" do
    @submission.save_draft
    on SubmissionConfirmation do |confirm|
      confirm.submission_text.should==@submission.text
      confirm.confirmation_text.should=="You have successfully saved your work but NOT submitted yet. To complete submission, you must select the Submit button."
      confirm.back_to_list
    end
    on AssignmentsList do |list|
      list.status_of(@submission.title).should==@submission.status
    end
  end

  it "Blank submissions throw a warning and aren't submitted" do
    @submission.text="" # Typically we want to avoid doing this!
    @submission.submit
    on AssignmentStudentView do |assignment|
      assignment.instructions.should==@assignment.instructions
      assignment.alert_box.should=="Alert: You must either type in your answer in the text input or attach at least one document before submission."
    end
  end

  it "Student can submit an assignment" do
    @submission.text=random_alphanums
    @submission.submit
    on SubmissionConfirmation do |confirm|
      confirm.summary_info["Class site:"].should==@submission.site
      confirm.summary_info["User:"].should==@student.long_name
      confirm.summary_info["Assignment:"].should==@submission.title
      confirm.submission_text.should==@submission.text
      confirm.confirmation_text.should=="You have successfully submitted your work. You will receive an email confirmation containing this information."
      # TODO Need to add validation of attachments
      confirm.back_to_list
    end
    on AssignmentsList do |list|
      list.status_of(@submission.title).should=="#{@submission.status} #{@submission.submission_date}"
    end
  end

  it "Assignments by default do not allow resubmission" do
    @submission.view
    on AssignmentStudentView do |view|
      view.summary_info["Submitted Date"].should==@submission.submission_date
      view.summary_info["Title"].should==@submission.title
      view.submit_button.should_not be_present
      view.save_draft_button.should_not be_present
      view.back_to_list
    end
  end

  it "Assignments that allow resubmission can be" do
    @submission2.submit
    on SubmissionConfirmation do |confirm|
      confirm.back_to_list
    end
    on AssignmentsList do |list|
      list.status_of(@submission2.title).should=="#{@submission2.status} #{@submission2.submission_date}"
      list.open_assignment @submission2.title
    end
    on AssignmentStudentView do |assignment|
      assignment.resubmit_button.should be_present
      assignment.resubmit
    end
    on SubmissionConfirmation do |confirm|
      confirm.summary_info["Class site:"].should==@submission2.site
      confirm.summary_info["User:"].should==@student.long_name
      confirm.summary_info["Assignment:"].should==@submission2.title
      confirm.summary_info["Submitted on:"].should==@submission2.submission_date # TODO: "resubmission" date? This needs testing.
      confirm.submission_text.should==@submission2.text
      confirm.confirmation_text.should=="You have successfully submitted your work. You will receive an email confirmation containing this information."
      confirm.back_to_list
    end
  end

  it "Assignments only allow one resubmission by default" do
    @assignment2.num_resubmissions.should=="1"
    on AssignmentsList do |list|
      list.open_assignment @submission2.title
    end
    on AssignmentStudentView do |assignment|
      assignment.resubmit_button.should_not be_present
    end

  end
  
end