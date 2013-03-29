require 'rspec'
require 'sambal-cle'
require 'yaml'

describe "Assignments" do

  include Utilities
  include Workflows
  include Foundry
  include StringFactory
  include DateFactory

  before :all do

    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SambalCLE.new(@config['browser'], @config['url'])
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

    #@site = create CourseSiteObject

    #@site.add_official_participants @student.type, @student.id
    #@site.add_official_participants @instructor2.type, @instructor2.id

    @assignment = create AssignmentObject, :site=>"TWhe0TXq Y3QgNJhR xGrVjH9J fall_2012",#@site.name,
                         :title=>random_string(25), :open=>next_monday, :grade_scale=>"Pass", :instructions=>random_multiline(300, 15, :string)

  end

  after :all do
    # Close the browser window
    @sakai.browser.close
  end

  it "Assignments with 'Pass' grade scale cannot be added to the Gradebook" do
    @assignment.edit :status=>"Editing", :add_to_gradebook=>:set
    on AssignmentAdd do |edit|
      sleep 0.1
      edit.add_to_gradebook.should_not be_set
      edit.gradebook_warning.should be_present
    end
  end

  it "Assignments with 'Ungraded' grade scale cannot be added to the Gradebook" do
    on AssignmentAdd do |edit|
      edit.grade_scale.select "Ungraded"
      edit.add_to_gradebook.set
      sleep 0.1
      edit.add_to_gradebook.should_not be_set
      edit.gradebook_warning.should be_present
      edit.gradebook_warning.wait_while_present
    end
  end

  it "Assignments with 'Letter grade' grade scale cannot be added to the Gradebook" do
    on AssignmentAdd do |edit|
      edit.grade_scale.select "Letter grade"
      edit.add_to_gradebook.set
      sleep 0.1
      edit.add_to_gradebook.should_not be_set
      edit.gradebook_warning.should be_present
      edit.gradebook_warning.wait_while_present
    end
  end

  it "Assignments with 'Checkmark' grade scale cannot be added to the Gradebook" do
    on AssignmentAdd do |edit|
      edit.grade_scale.select "Checkmark"
      edit.add_to_gradebook.set
      sleep 0.1
      edit.add_to_gradebook.should_not be_set
      edit.gradebook_warning.should be_present
    end
  end

  it "Assignments graded by points can be added to the gradebook" do
    reset
    @assignment.edit :grade_scale=>"Points", :max_points=>"111", :add_to_gradebook=>:set
    gradebook
    on Gradebook do |book|
      book.items_titles.should include @assignment.title
    end
  end

  # TODO: Add a GB2 test here.

end