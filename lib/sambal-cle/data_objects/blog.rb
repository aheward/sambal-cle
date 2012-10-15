class BlogEntryObject

  include PageHelper
  include Utilities
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
<<<<<<< HEAD
<<<<<<< HEAD
    requirements @site
=======
    raise "You need to specify a site for your blog entry" if @site==nil
>>>>>>> 8c662f2... Added the set_options method to the PageHelper module. Updated the data object classes to use this method.
=======
    requirements @site
>>>>>>> 38e0fb3... Added requires method to pagehelper, updated data object classes to use this method.
  end
    
  def create
    open_my_site_by_name @site unless @browser.title=~/#{@site}/
    blogs unless @browser.title=~/Blogs$/
    # TODO: More needed here
  end
    
  def edit opts={}
    
  end
    
  def view
    
  end
    
  def delete
    
  end
  
end
    
      