class PortfolioSiteObject

  include Foundry
  include DataFactory
  include StringFactory
  include Workflows
  
  attr_accessor :title, :description, :short_description, :contact_email, :site_email,
                :site_contact_name, :access, :default_role, :creator, :status,
                :creation_date, :id
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :title=>random_alphanums,
      :site_email=>random_nicelink(32),
    }
    options = defaults.merge(opts)
    
    set_options(options)
    requires @title
  end
    
  def create
    my_workspace
    site_setup
    on_page SiteSetup do |page|
      page.new
    end
    on SiteType do |page|
      # Select the Portfolio Site radio button
      page.portfolio_site.set
      page.continue
    end
    on PortfolioSiteInfo do |info|
      info.title.set @title
      info.description=@description unless @description==nil
      info.short_description.fit @short_description
      #TODO Add support for other fields here
      info.continue
    end
    on PortfolioSiteTools do |tools|
      # TODO Add support for individual tool selection and reuse of material from other sites
      tools.all_tools.set
      tools.continue
    end
    on PortfolioConfigureToolOptions do |options|
      options.email.set @site_email
      # TODO Add support for other fields here
      options.continue
    end
    on SiteAccess do |access|
      # TODO Support non-default selections here
      access.continue
    end
    on ConfirmSiteSetup do |confirm|
      if confirm.request_button.present?
        confirm.request_site
      else
        confirm.create_site
      end
    end
  end
    
  def edit opts={}
    
    set_options(opts)
  end
    
  def view
    
  end
    
  def delete
    
  end
  
end
    
      