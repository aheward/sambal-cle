class AssessmentObject

  include PageHelper
  include Utilities
  include Workflows

  attr_accessor :title, :site

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
      :title=>random_alphanums,
    }
    options = defaults.merge(opts)
    set_options(options)
<<<<<<< HEAD
<<<<<<< HEAD
    requires @site
=======
    raise "You must specify a Site for your Assessment" if @site==nil
>>>>>>> 8c662f2... Added the set_options method to the PageHelper module. Updated the data object classes to use this method.
=======
    requires @site
>>>>>>> 38e0fb3... Added requires method to pagehelper, updated data object classes to use this method.
  end

  def create
    my_workspace.open_my_site_by_name @site unless @browser.title=~/#{@site}/
    tests_and_quizzes unless @browser.title=~/Tests & Quizzes$/
    on_page AssessmentsList do |page|
      page.title.set @title
      page.create
    end
    # Do more here eventually...
  end

end