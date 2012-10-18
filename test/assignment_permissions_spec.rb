require 'rspec'
require 'sambal-cle'
require 'yaml'

describe "Assignment Permissions" do

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

    @sakai.page.login(@instructor1, @ipassword)

    @site = make SiteObject
    @site.create

    @site.add_official_participants :role=>"Student", :participants=>[@student]
    @site.add_official_participants :role=>"Instructor", :participants=>[@instructor2]

    @assignment = make AssignmentObject, :status=>"Draft", :site=>@site.name, :title=>random_string(25), :open=>next_monday
    @assignment2 = make AssignmentObject, :site=>@site.name
    @assignment.create
    @assignment2.create

    @permissions = make AssignmentPermissionsObject, :site=>@site.name

    log_out

  end

  after :all do
    # Close the browser window
    @sakai.browser.close
  end

  it "Default permissions allow instructors to share drafts" do
    @sakai.page.login(@instructor2, @password1)
    open_my_site_by_name @assignment.site
    assignments
    on AssignmentsList do |list|
      list.assignments_list.should include "Draft - #{@assignment.title}"
      list.assignments_list.should include @assignment2.title
    end
  end

  it "Removing 'share draft' permissions for instructors works as expected" do
    @permissions.set :instructor=>{:share_drafts=>:clear}
    on AssignmentsList do |list|
      list.assignments_list.should_not include "Draft - #{@assignment.title}"
      list.assignments_list.should include @assignment2.title
    end
  end
=begin
    # Go to Assignments Permissions page
    assignments.permissions

    permissions = AssignmentsPermissions.new(@browser)




    # Uncheck "Instructors share drafts"
    permissions.uncheck_instructors_share_drafts

    # An "obsolete element error" bug requires accessing the
    # Save button element explicitly, here, instead of using the
    # AssignmentPermissions class definition. Hopefully this will
    # be fixed in the future.
    @browser.frame(:index=>1).button(:name, "eventSubmit_doSave").click

    assignments = AssignmentsList.new(@browser)

    # TEST CASE: instructor2 can no longer see the Draft assignment
    assert_equal false, assignments.assignments_list.include?("Draft - #{@assignments[2][:title]}")

    # Go to Assignments Permissions page
    permissions = assignments.permissions

    # Re-check "Instructors share drafts"
    permissions.check_instructors_share_drafts
    @browser.frame(:index=>1).button(:name, "eventSubmit_doSave").click

    assignments = AssignmentsList.new(@browser)

    # Edit Assignment 3 and save it so it's no longer in Draft mode
    assignment3 = assignments.edit_assignment "Draft - #{@assignments[2][:title]}"

    assignments = assignment3.post

    # Go to Home page of Site
    home = assignments.home

    # TEST CASE: Verify assignment 3 appears in announcements
    assert home.announcements_list.include? "Assignment: Open Date for '#{@assignments[2][:title]}'"

    # Go to the assignments page and make Assignment 5
    assignments = home.assignments

    assignment5 = assignments.add

    assignment5.title=@assignments[4][:title]
    assignment5.open_day=@assignments[4][:open_day]

    # Set the open month to last month if today is the first
    if (Time.now - (3600*24)).strftime("%d").to_i > (Time.now).strftime("%d").to_i
      assignment5.open_month=last_month
    end

    assignment5.grade_scale=@assignments[4][:grade_scale]

    # Enter assignment instructions into the rich text editor
    assignment5.instructions=@assignments[4][:instructions]

    #==========
    # Add attachment code should go here later
    #==========

    # Save assignment 5 as draft
    assignments = assignment5.save_draft

    # TEST CASE: Assignment link shows "draft" mode
    assert assignments.assignment_list.include? "Draft - #{@assignments[4][:title]}"

    # Log out and log back in as instructor1
    assignments.logout
    workspace = @sakai.page.login(@user_name, @password)

    # Go to test site
    home = workspace.open_my_site_by_id(@site_id)

    # Go to assignments page
    assignments = home.assignments

    # TEST CASE: Make sure there's a link to the Assignment 5 draft.
    assert assignments.assignment_list.include? "Draft - #{@assignments[4][:title]}"

    # Post assignment 5
    assignment_5 = assignments.edit_assignment("Draft - #{@assignments[4][:title]}")

    assignments = assignment_5.post

    # Edit assignment 1
    assignment_1 = assignments.edit_assignment(@assignments[0][:title])

    # TEST CASE: Verify the alert about revising assignments after the Open Date.
    assert_equal(@revising_alert, assignment_1.alert_text)

    # Change letter grade
    assignment_1.grade_scale=@assignments[0][:grade_scale]

    # Save
    assignment_1.post

    assignment_1 = AssignmentAdd.new(@browser)

    # Verify the instructions error message again
    assert_equal @missing_instructions, assignment_1.alert_text

    # Add instructions
    assignment_1.instructions=@assignments[0][:instructions]

    # Click on Student View
    assignment_1.student_view

    # Save assignment
    assignments = assignment_1.post

    # Delete Assignment 1
    assignments = assignments.delete_assignment @assignments[0][:title]

    # Verify delete
    assert_equal false, assignments.assignment_titles.include?(@assignments[0][:title])

    # Duplicate assignment 2 to assignment 1
    assignments = assignments.duplicate_assignment(@assignments[1][:title])

    # TEST CASE: Verify duplication
    assert assignments.assignment_list.include? "Draft - #{@assignments[1][:title]} - Copy"

    # Go to Reorder page
    assignments = AssignmentsList.new(@browser)
    assignments.reorder

    # Sort assignments by title
    reorder = AssignmentsReorder.new(@browser)
    reorder.sort_by_title
    reorder.save

    #=============
    # Add verification of sorts tests later - though this should probably get its own test case
    #=============
=end

end