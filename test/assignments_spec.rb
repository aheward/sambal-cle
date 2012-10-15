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

    @sakai.page.login(@instructor1, @ipassword)

    @site = make SiteObject
    @site.create

    @site.add_official_participants :role=>"Student", :participants=>[@student]
    @site.add_official_participants :role=>"Instructor", :participants=>[@instructor2]

    @assignment = make AssignmentObject, :site=>@site.name, :title=>random_string(25), :open=>next_monday, :grade_scale=>"Pass", :instructions=>random_multiline(300, 15, :string)

    @assignment.create


  end
=begin
  after :all do
    # Close the browser window
    @sakai.browser.close
  end
=end
  it "does a whole bunch of shtuff" do

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
  
end