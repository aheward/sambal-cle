<<<<<<< HEAD
<<<<<<< HEAD
# coding: UTF-8
=======
>>>>>>> 20d9a61... Now working on the Assignments Submissions Spec.  Small tweaks to other scripts because of a change to the basic log_in method.
=======
# coding: UTF-8
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.
require 'rspec'
require 'sambal-cle'
require 'yaml'

<<<<<<< HEAD
<<<<<<< HEAD
describe "Assignments Submission" do
=======
describe "Assignments" do
>>>>>>> 20d9a61... Now working on the Assignments Submissions Spec.  Small tweaks to other scripts because of a change to the basic log_in method.
=======
describe "Assignments Submission" do
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.

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
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.
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
>>>>>>> 20d9a61... Now working on the Assignments Submissions Spec.  Small tweaks to other scripts because of a change to the basic log_in method.
=======

    @site = make SiteObject
    @site.create
    @site.add_official_participants :role=>@student.type, :participants=>[@student.id]
    @site.add_official_participants :role=>@instructor2.type, :participants=>[@instructor2.id]
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.

    @assignment = make AssignmentObject, :site=>@site.name, :title=>random_string(25),
                       :open=>an_hour_ago, :grade_scale=>"Pass",
                       :instructions=>random_multiline(100, 15, :string)
<<<<<<< HEAD
<<<<<<< HEAD
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

=======
=======
    @submission = make AssignmentSubmissionObject, :site=>@site.name, :title=>@assignment.title,
                       :student=>@student
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.
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
<<<<<<< HEAD
=begin
>>>>>>> 20d9a61... Now working on the Assignments Submissions Spec.  Small tweaks to other scripts because of a change to the basic log_in method.
=======

>>>>>>> 44be355... Assignment Submissions Spec completed.
  after :all do
    # Close the browser window
    @sakai.browser.close
  end
<<<<<<< HEAD
<<<<<<< HEAD

  it "Student can save an assignment as 'In progress'" do
    @submission.save_draft
<<<<<<< HEAD
    on SubmissionConfirmation do |confirm|
      confirm.submission_text.should==@submission.text
=======
=end
  xit "Student can save an assignment as 'In progress'" do
=======

  it "Student can save an assignment as 'In progress'" do
>>>>>>> 44be355... Assignment Submissions Spec completed.
    log_in(@student, @spassword)

    @assignment.submit :text=>random_alphanums, :student_status=>"Draft"
    on SubmissionConfirmation do |confirm|
      confirm.submission_text.should==@assignment.text
>>>>>>> 20d9a61... Now working on the Assignments Submissions Spec.  Small tweaks to other scripts because of a change to the basic log_in method.
=======
    on SubmissionConfirmation do |confirm|
      confirm.submission_text.should==@submission.text
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.
      confirm.confirmation_text.should=="You have successfully saved your work but NOT submitted yet. To complete submission, you must select the Submit button."
      confirm.back_to_list
    end
    on AssignmentsList do |list|
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
      list.status_of(@assignment.title).should==@assignment.student_status
=======
      list.status_of(@submission.title).should==@submission.status
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.
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
<<<<<<< HEAD
      confirm.summary_info["Class site:"].should==@assignment.site
      #confirm.summary_info["User:"].should== TODO: Add this line when we're making UserObjects.
      confirm.summary_info["Assignment:"].should==@assignment.title
      confirm.submission_text.should==@assignment.text
>>>>>>> 20d9a61... Now working on the Assignments Submissions Spec.  Small tweaks to other scripts because of a change to the basic log_in method.
=======
      confirm.summary_info["Class site:"].should==@submission.site
      confirm.summary_info["User:"].should==@student.long_name
      confirm.summary_info["Assignment:"].should==@submission.title
      confirm.submission_text.should==@submission.text
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.
      confirm.confirmation_text.should=="You have successfully submitted your work. You will receive an email confirmation containing this information."
      # TODO Need to add validation of attachments
      confirm.back_to_list
    end
    on AssignmentsList do |list|
<<<<<<< HEAD
<<<<<<< HEAD
      list.status_of(@submission.title).should=="#{@submission.status} #{@submission.submission_date}"
    end
  end

  it "Assignments by default do not allow resubmission" do
    @submission.view
    on AssignmentStudentView do |view|
<<<<<<< HEAD
      view.summary_info["Submitted Date"].should==@submission.submission_date
      view.summary_info["Title"].should==@submission.title
      view.submit_button.should_not be_present
      view.save_draft_button.should_not be_present
=======
      list.status_of(@assignment.title).should=="#{@assignment.student_status} #{@assignment.submission_date}"
=======
      list.status_of(@submission.title).should=="#{@submission.status} #{@submission.submission_date}"
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.
    end
  end

  it "Assignments by default do not allow resubmission" do
    @submission.view
    on AssignmentStudentPreview do |view|
<<<<<<< HEAD
      view.summary_info["Submitted Date"].should==@assignment.submission_date
      view.summary_info["Title"].should==@assignment.title
<<<<<<< HEAD
>>>>>>> 20d9a61... Now working on the Assignments Submissions Spec.  Small tweaks to other scripts because of a change to the basic log_in method.
=======
=======
=======
>>>>>>> feb4534... Finished the Assignments Grading spec.
      view.summary_info["Submitted Date"].should==@submission.submission_date
      view.summary_info["Title"].should==@submission.title
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.
      view.submit_button.should_not be_present
      view.save_draft_button.should_not be_present
>>>>>>> 44be355... Assignment Submissions Spec completed.
      view.back_to_list
    end
  end

  it "Assignments that allow resubmission can be" do
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    @submission2.submit
=======
    @assignment2.submit :text=>random_alphanums
>>>>>>> 44be355... Assignment Submissions Spec completed.
=======
    @submission2.submit
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.
    on SubmissionConfirmation do |confirm|
      confirm.back_to_list
    end
    on AssignmentsList do |list|
<<<<<<< HEAD
<<<<<<< HEAD
      list.status_of(@submission2.title).should=="#{@submission2.status} #{@submission2.submission_date}"
      list.open_assignment @submission2.title
    end
    on AssignmentStudentView do |assignment|
<<<<<<< HEAD
=======
      list.status_of(@assignment2.title).should=="#{@assignment2.student_status} #{@assignment2.submission_date}"
      list.open_assignment @assignment2.title
=======
      list.status_of(@submission2.title).should=="#{@submission2.status} #{@submission2.submission_date}"
      list.open_assignment @submission2.title
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.
    end
    on AssignmentStudent do |assignment|
>>>>>>> 44be355... Assignment Submissions Spec completed.
=======
>>>>>>> feb4534... Finished the Assignments Grading spec.
      assignment.resubmit_button.should be_present
      assignment.resubmit
    end
    on SubmissionConfirmation do |confirm|
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
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
>>>>>>> 20d9a61... Now working on the Assignments Submissions Spec.  Small tweaks to other scripts because of a change to the basic log_in method.
=======
      confirm.summary_info["Class site:"].should==@assignment2.site
=======
      confirm.summary_info["Class site:"].should==@submission2.site
<<<<<<< HEAD
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.
      #confirm.summary_info["User:"].should== TODO: Add this line when we're making UserObjects.
=======
      confirm.summary_info["User:"].should==@student.long_name
>>>>>>> feb4534... Finished the Assignments Grading spec.
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
>>>>>>> 44be355... Assignment Submissions Spec completed.

  end
  
end