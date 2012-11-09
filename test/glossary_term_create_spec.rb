require 'rspec'
require 'sambal-cle'
require 'yaml'

describe "Create Portfolio Glossary Term" do

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

    @instructor = make UserObject, :id=>@directory['person3']['id'], :password=>@directory['person3']['password'],
                       :first_name=>@directory['person3']['firstname'], :last_name=>@directory['person3']['lastname'],
                       :type=>"Instructor"
    @student = make UserObject, :id=>@directory['person1']['id'], :password=>@directory['person1']['password'],
                    :first_name=>@directory['person1']['firstname'], :last_name=>@directory['person1']['lastname']
    @student2 = make UserObject, :id=>@directory['person2']['id'], :password=>@directory['person2']['password'],
                     :first_name=>@directory['person2']['firstname'], :last_name=>@directory['person2']['lastname']
    @instructor.log_in
    @portfolio = make PortfolioSiteObject
    @portfolio.create
    @portfolio.add_official_participants "Participant", @student.id, @student2.id

  end

  after :all do
    @browser.close
  end

  it "A Glossary Term can be created" do
    @term = make GlossaryTermObject, :portfolio=>@portfolio.title
    @term.create
  end

end