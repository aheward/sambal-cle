require 'rspec'
require 'sambal-cle'
require 'yaml'

# TODO: Add more tests of various permissions settings.

describe "Assignment Permissions" do

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
    @site.add_official_participants :role=>@student.type, :participants=>[@student.id]
    @site.add_official_participants :role=>@instructor2.type, :participants=>[@instructor2.id]

    @site = make CourseSiteObject
    @site.create

    @site.add_official_participants :role=>"Student", :participants=>[@student]
    @site.add_official_participants :role=>"Instructor", :participants=>[@instructor2]

    @assignment = make AssignmentObject, :status=>"Draft", :site=>@site.name, :title=>random_string(25), :open=>next_monday
    @assignment2 = make AssignmentObject, :site=>@site.name
    @assignment.create
    @assignment2.create

    @permissions = make AssignmentPermissionsObject, :site=>@site.name

    @instructor1.log_out
    @instructor2.log_in
  end

  after :all do
    # Close the browser window
    @sakai.browser.close
  end

  it "Default permissions allow instructors to share drafts" do
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

end