class MessageObject

  include PageHelper
  include Utilities
  include Workflows

  attr_accessor :site, :subject, :send_cc, :recipients, :message, :label

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
      :subject=>random_alphanums,
      :recipients=>["All Participants"]
    }
    options = defaults.merge(opts)

    set_options(options)
<<<<<<< HEAD
<<<<<<< HEAD
    requires @site
=======
    raise "You need to specify a site for your web content" if @site==nil
>>>>>>> 8c662f2... Added the set_options method to the PageHelper module. Updated the data object classes to use this method.
=======
    requires @site
>>>>>>> 38e0fb3... Added requires method to pagehelper, updated data object classes to use this method.
  end

  def create
    open_my_site_by_name @site unless @browser.title=~/#{@site}/
    messages unless @browser.title=~/Messages$/
  end

  alias compose create



end

class MessageFolderObject

  include PageHelper
  include Utilities
  include Workflows

  attr_accessor :site

  def initialize(browser, opts={})
    @browser = browser

    defaults = {}

  end

  def create


  end

end