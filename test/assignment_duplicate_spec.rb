require 'rspec'
require 'sambal-cle'
require 'yaml'

describe "Duplicating an Assignment" do

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

    @assignment = make AssignmentObject, :site=>@site.name, :title=>random_string(25), :open=>next_monday, :grade_scale=>"Pass", :instructions=>random_alphanums

    @assignment.create

  end

  after :all do
    # Close the browser window
    @sakai.browser.close
  end

  it "Duplicate command creates duplicate of the Assignment" do
    dupe = @assignment.duplicate
    on AssignmentsList do |list|
      list.assignments_titles.should include dupe.title
    end

    # TODO: Add more verification stuff here

  end
end
