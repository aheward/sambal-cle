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
=begin
  after :all do
    # Close the browser window
    @sakai.browser.close
  end
=end
  xit "Student can save an assignment as 'In progress'" do
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

  xit "Blank submissions throw a warning and aren't submitted" do

  end

  xit "Student can submit an assignment" do
    @assignment.submit :text=>random_alphanums(100), :student_status=>"Submitted"
    on SubmissionConfirmation do |confirm|
      confirm.summary_info["Class site:"].should==@assignment.site
      #confirm.summary_info["User:"].should== TODO: Add this line when we're making UserObjects.
      confirm.summary_info["Assignment:"].should==@assignment.title
      confirm.summary_info["Saved Assignment ID:"].should==@assignment.id
      confirm.submission_text.should==@assignment.text
      confirm.confirmation_text.should=="You have successfully submitted your work. You will receive an email confirmation containing this information."
      # TODO Need to add validation of attachments
      confirm.back_to_list
    end
    on AssignmentsList do |list|
      list.status_of(@assignment.title).should=="#{@assignment.student_status} #{@assignment.submission_date}"
    end
  end

  xit "Assignments by default do not allow resubmission" do
    @assignment.view_submission
    on AssignmentStudentPreview do |view|
      view.submit_button.should_not be_present
      view.save_draft_button.should_not be_present
      view.summary_info["Submitted Date"].should==@assignment.submission_date
      view.summary_info["Title"].should==@assignment.title
      view.back_to_list
    end
  end

  it "Assignments that allow resubmission can be" do
    @assignment2.submit :text=>

  end



  xit "goo goo gah chew" do
    # Open an assignment that allows 1 resubmission
    assignment2 = assignments.open_assignment(@assignment_2_title)

    # Fill it out and submit
    assignment2.assignment_text=@assignment_2_text1

    confirm = assignment2.submit

    # Verify submission
    assert_equal( "You have successfully submitted your work. You will receive an email confirmation containing this information.", confirm.confirmation_text)

    assignments = confirm.back_to_list

    # Edit it and resubmit
    assignment2 = assignments.open_assignment(@assignment_2_title)

    # Clear out the field
    assignment2.remove_assignment_text

    # Enter the new text
    assignment2.assignment_text=@assignment_2_text2

    confirm = assignment2.resubmit

    # Verify submission
    assert_equal( "You have successfully submitted your work. You will receive an email confirmation containing this information.", confirm.confirmation_text )

    # Verify changed assignment text
    assert_equal(@assignment_2_text2, confirm.submission_text)

    # Back to list
    assignments = confirm.back_to_list

    # Edit assignment again
    assignment2 = assignments.open_assignment(@assignment_2_title)

    # Verify the user is not allowed to edit assignment
    assert @browser.frame(:index=>1).button(:name=>"eventSubmit_doCancel_view_grade").exist?
    assert_equal(false, @browser.frame(:index=>1).button(:name=>"post").exist?)
    
    #=============
    # Add verification of sorts tests later - though this should probably get its own test case
    #=============

  end
  
end