require 'rspec'
require 'sambal-cle'
require 'yaml'

describe "Assignments appearing in Announcements" do

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
>>>>>>> 8c662f2... Added the set_options method to the PageHelper module. Updated the data object classes to use this method.
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
=======
    @student = @directory['person1']['id']
    @spassword = @directory['person1']['password']
    @instructor1 = @directory['person3']['id']
    @ipassword = @directory['person3']['password']

    @instructor2 = @directory['person4']['id']
    @password1 = @directory['person4']['password']

    log_in(@instructor1, @ipassword)
>>>>>>> 20d9a61... Now working on the Assignments Submissions Spec.  Small tweaks to other scripts because of a change to the basic log_in method.
=======
>>>>>>> 8c662f2... Added the set_options method to the PageHelper module. Updated the data object classes to use this method.

    @site = make SiteObject
    @site.create
    @site.add_official_participants :role=>@student.type, :participants=>[@student.id]
    @site.add_official_participants :role=>@instructor2.type, :participants=>[@instructor2.id]

    @assignment1 = make AssignmentObject, :status=>"Draft", :add_open_announcement=>:set, :site=>@site.name, :title=>random_xss_string(30), :open=>in_an_hour, :student_submissions=>"Attachments only", :grade_scale=>"Points", :max_points=>"100", :instructions=>random_multiline(600, 12, :string)
    @assignment2 = make AssignmentObject, :site=>@site.name, :add_open_announcement=>:set, :open=>an_hour_ago
    @assignment1.create
    @assignment2.create

  end

  after :all do
    # Close the browser window
    @sakai.browser.close
  end

  it "Assignments in Draft status do not appear in Announcements" do
    home

    on Home do |home|
     home.announcements_list.should_not include("Assignment: Open Date for '#{@assignment1.title}'")
    end
  end

  it "Open assignments do appear in Announcements" do
    on Home do |home|
      home.announcements_list.should include("Assignment: Open Date for '#{@assignment2.title}'")
    end
  end

  it "Changing assignment from Draft to open will display assignment in Announcements" do
    @assignment1.edit :status=>"Open"
    home
    on Home do |home|
      home.announcements_list.should include("Assignment: Open Date for '#{@assignment1.title}'")
    end
  end

end