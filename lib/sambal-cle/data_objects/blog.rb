class BlogEntryObject

  include Foundry
  include StringFactory
  include Navigation
  
  attr_accessor :title, :content, :site, :permissions
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :title=>random_alphanums,
      :content=>random_alphanums,
      :permissions=>:publicly_viewable
    }
    set_options(defaults.merge(opts))
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
    
      