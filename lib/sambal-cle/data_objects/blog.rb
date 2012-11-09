class BlogEntryObject

  include Foundry
  include StringFactory
  include Workflows
  
  attr_accessor :title, :content, :site, :permissions
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :title=>random_alphanums,
      :content=>random_alphanums,
      :permissions=>:publicly_viewable
    }
    options = defaults.merge(opts)
    
    set_options(options)
    requirements @site
  end
    
  def create
    open_my_site_by_name @site
    blogs
    # TODO: More needed here
  end
    
  def edit opts={}
    
  end
    
  def view
    
  end
    
  def delete
    
  end
  
end
    
      