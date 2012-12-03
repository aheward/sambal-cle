class PortfolioSiteObject

  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows
  
  attr_accessor :title, :description, :short_description, :contact_email, :site_email,
                :site_contact_name, :access, :default_role, :creator, :status,
                :creation_date, :id, :participants
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :title=>random_alphanums,
      :site_email=>random_nicelink(32),
      :participants=>{}
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
    # TODO: Add definition of @participants variable here
    # Create a string that will match the new Site's "creation date" string
    @creation_date = right_now[:sakai]

    on SiteSetup do |site_setup|
      site_setup.search(Regexp.escape(@title))

      # Get the site id for storage
      @browser.frame(:class=>"portletMainIframe").link(:href=>/xsl-portal.site/, :index=>0).href =~ /(?<=\/site\/).+/
      @id = $~.to_s
    end
  end
    
  def edit opts={}
    
    set_options(opts)
  end
    
  def view
    
  end
    
  def delete
    
  end

  def add_official_participants(role, *participants)
    list_of_ids=participants.join("\n")
    open_my_site_by_name @title
    site_editor
    on SiteEditor do |site|
      site.add_participants
    end
    on SiteSetupAddParticipants do |add|
      add.official_participants.set list_of_ids
      add.continue
    end
    on SiteSetupChooseRole do |choose|
      choose.radio_button(role).set
      choose.continue
    end
    on SiteSetupParticipantEmail do |send|
      send.continue
    end
    on SiteSetupParticipantConfirm do |confirm|
      confirm.finish
    end
    if @participants.has_key?(role)
      @participants[role].insert(-1, participants).flatten!
    else
      @participants.store(role, participants)
    end
  end

end