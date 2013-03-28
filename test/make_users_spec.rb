require 'rspec'
require 'sambal-cle'
require 'yaml'

describe "Make Users" do

  include StringFactory
  include Navigation
  include Foundry

  before :all do

    # Get the test configuration data
    @config = YAML.load_file('config.yml')
    @directory = YAML.load_file('directory.yml')
    @sakai = SambalCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    @user = make UserObject, id: @directory['admin']['username'],
                             password: @directory['admin']['password'],
                             first_name: 'Sakai',
                             last_name: 'Administrator'
    @user.log_in
  end

  after :all do
    # Close the browser window
    @browser.close
  end

  it "makes the users correctly" do

    administration_workspace

    # Go to Users page in Sakai
    users

    # Get a count of how many users will be added
    count = 1
    while @directory["person#{count}"] != nil do
      count+=1
    end
    count = count-1

    # Add each user to the workspace
    1.upto(count) do |x|

      # Create a new user
      on(Users).new_user
      on CreateNewUser do |create|
        create.user_id.set @directory["person#{x}"]['id']
        create.first_name.set @directory["person#{x}"]['firstname']
        create.last_name.set @directory["person#{x}"]['lastname']
        create.email.set @directory["person#{x}"]['email']
        create.create_new_password.set @directory["person#{x}"]['password']
        create.verify_new_password.set @directory["person#{x}"]['password']
        create.type.select @directory["person#{x}"]['type']
        create.save
      end
      on Users do |users_page|

        # TEST CASE: Verify that the user has been created
        users_page.search_field.set @directory["person#{x}"]['id']
        users_page.search_button
        @browser.frame(:index=>0).link(:text, @directory["person#{x}"]['id']).should exist
      end
    end
  end

end