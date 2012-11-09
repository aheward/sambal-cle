class MessageObject

  include Foundry
  include DataFactory
  include StringFactory
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
    requires @site
  end

  def create
    open_my_site_by_name @site
    messages
  end

  alias compose create



end

class MessageFolderObject

  include Foundry
  include DataFactory
  include Workflows

  attr_accessor :site

  def initialize(browser, opts={})
    @browser = browser

    defaults = {}

  end

  def create


  end

end