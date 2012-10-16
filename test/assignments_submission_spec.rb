require 'rspec'
require 'sambal-cle'
require 'yaml'

describe "Assignments" do

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

    @assignment = make AssignmentObject, :site=>@site.name, :title=>random_string(25),
                       :open=>an_hour_ago, :grade_scale=>"Pass",
                       :instructions=>random_multiline(100, 15, :string)
    @assignment2 = make AssignmentObject, :site=>@site.name, :title=>random_string(25),
                        :open=>an_hour_ago, :grade_scale=>"Points", :max_points=>"111",
                        :allow_resubmission=>:set
    @assignment.create
    @assignment2.create
    log_out

  end

  after :all do
    # Close the browser window
    @sakai.browser.close
  end

  it "Student can save an assignment as 'In progress'" do
    log_in(@student, @spassword)

    @assignment.submit :text=>random_alphanums, :student_status=>"Draft"
    on SubmissionConfirmation do |confirm|
      confirm.submission_text.should==@assignment.text
      confirm.confirmation_text.should=="You have successfully saved your work but NOT submitted yet. To complete submission, you must select the Submit button."
      confirm.back_to_list
    end
    on AssignmentsList do |list|
      list.status_of(@assignment.title).should==@assignment.student_status
    end
  end

  it "Blank submissions throw a warning and aren't submitted" do
    @assignment.submit :text=>"", :student_status=>"Submitted"
    on AssignmentStudent do |assignment|
      assignment.alert_text.should=="Alert: You must either type in your answer in the text input or attach at least one document before submission."
    end
  end

  it "Student can submit an assignment" do
    @assignment.submit :text=>random_alphanums(100), :student_status=>"Submitted"
    on SubmissionConfirmation do |confirm|
      confirm.summary_info["Class site:"].should==@assignment.site
      #confirm.summary_info["User:"].should== TODO: Add this line when we're making UserObjects.
      confirm.summary_info["Assignment:"].should==@assignment.title
      confirm.submission_text.should==@assignment.text
      confirm.confirmation_text.should=="You have successfully submitted your work. You will receive an email confirmation containing this information."
      # TODO Need to add validation of attachments
      confirm.back_to_list
    end
    on AssignmentsList do |list|
      list.status_of(@assignment.title).should=="#{@assignment.student_status} #{@assignment.submission_date}"
    end
  end

  it "Assignments by default do not allow resubmission" do
    @assignment.view_submission
    on AssignmentStudentPreview do |view|
      view.summary_info["Submitted Date"].should==@assignment.submission_date
      view.summary_info["Title"].should==@assignment.title
      view.submit_button.should_not be_present
      view.save_draft_button.should_not be_present
      view.back_to_list
    end
  end

  it "Assignments that allow resubmission can be" do
    @assignment2.submit :text=>random_alphanums
    on SubmissionConfirmation do |confirm|
      confirm.back_to_list
    end
    on AssignmentsList do |list|
      list.status_of(@assignment2.title).should=="#{@assignment2.student_status} #{@assignment2.submission_date}"
      list.open_assignment @assignment2.title
    end
    on AssignmentStudent do |assignment|
      assignment.resubmit_button.should be_present
      assignment.resubmit
    end
    on SubmissionConfirmation do |confirm|
      confirm.summary_info["Class site:"].should==@assignment2.site
      #confirm.summary_info["User:"].should== TODO: Add this line when we're making UserObjects.
      confirm.summary_info["Assignment:"].should==@assignment2.title
      confirm.summary_info["Submitted on:"].should==@assignment2.submission_date # TODO: "resubmission" date? This needs testing.
      confirm.submission_text.should==@assignment2.text
      confirm.confirmation_text.should=="You have successfully submitted your work. You will receive an email confirmation containing this information."
      confirm.back_to_list
    end
  end

  it "Assignments only allow one resubmission by default" do
    @assignment2.num_resubmissions.should=="1"
    on AssignmentsList do |list|
      list.open_assignment @assignment2.title
    end
    on AssignmentStudentPreview do |assignment|
      assignment.resubmit_button.should_not be_present
    end

  end
  
end