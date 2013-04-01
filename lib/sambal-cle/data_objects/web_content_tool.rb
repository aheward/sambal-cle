class WebContentObject

  include Foundry
  include DataFactory
  include StringFactory
  include Navigation

  attr_accessor :title, :source, :site

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
      :title=>random_alphanums,
      :source=>"www.rsmart.com"
    }
    set_options(defaults.merge(opts))
    requires :site
  end

  def create
    my_workspace
    site_setup
    on_page SiteSetupList do |page|
      page.edit @site
    end
    on_page SiteEditor do |page|
      page.edit_tools
    end
    on_page EditSiteTools do |page|
      page.web_content.set
      page.continue
    end
    on_page AddMultipleTools do |page|
      page.web_content_title.set @title
      page.web_content_source.set @source
      page.continue
    end
    on_page ConfirmSiteToolsEdits do |page|
      page.finish
    end
    on_page SiteEditor do |page|
      page.return_button.wait_until_present
      page.return_to_sites_list
    end
  end

end