require 'rspec'
require 'sambal-cle'
require 'yaml'

describe "Portfolio Glossary Term CRUD" do

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
    @term1 = make GlossaryTermObject, :portfolio=>@portfolio.title
    @term1.create
    @term2 = make GlossaryTermObject, :portfolio=>@portfolio.title
    @term2.create
    @term3 = make GlossaryTermObject, :portfolio=>@portfolio.title
    @term3.create
  end

  after :all do
    @browser.close
  end

  it "Terms can be created" do
    on Glossary do |list|
      list.terms.should include @term1.term
      list.terms.should include @term2.term
      list.terms.should include @term3.term
    end
  end

  it "Terms can be updated" do
    @term1.edit :term=>random_alphanums, :short_description=>random_alphanums, :long_description=>random_alphanums
    on Glossary do |list|
      list.terms.should include @term1.term
    end
  end

  it "Terms can be deleted" do
    @term2.delete
    on Glossary do |list|
      list.terms.should_not include @term2.term
    end
  end

  it "Terms can be read" do
    @instructor.log_out
    @student.log_in
    @term1.open
    @browser.text.should include @term1.long_description
  end

end