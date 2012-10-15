class BloggerPostObject

  include PageHelper
  include Utilities
  include Workflows
  
  attr_accessor :title, :abstract, :site, :text, :read_only, :access, :allow_comments
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :title=>random_alphanums,
      :abstract=>random_alphanums,
      :text=>random_alphanums
    }
    options = defaults.merge(opts)
    
    set(options)
<<<<<<< HEAD
<<<<<<< HEAD
    requires @site
=======
    raise "You need to specify a site for your blogger post" if @site==nil
>>>>>>> 8c662f2... Added the set_options method to the PageHelper module. Updated the data object classes to use this method.
=======
    requires @site
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
    
      