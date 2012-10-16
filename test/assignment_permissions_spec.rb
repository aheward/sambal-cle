require 'rspec'
require 'sambal-cle'
require 'yaml'

# TODO: Add more tests of various permissions settings.

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

    log_in(@instructor1, @ipassword)

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
    log_in(@instructor2, @password1)
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