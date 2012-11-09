class GlossaryTermObject

  include Foundry
  include DataFactory
  include StringFactory
  include Workflows
  
  attr_accessor :term, :short_description, :long_description, :portfolio
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :term=>random_alphanums,
      :short_description=>random_alphanums,
      :long_description=>random_alphanums
    }
    options = defaults.merge(opts)
    
    set_options(options)
    requires @portfolio
  end
    
  def create
    open_my_site_by_name @portfolio
    glossary
    on Glossary do |list|
      list.add
    end
    on AddEditTerm do |term|
      term.term.set @term
      term.short_description.set @short_description
      term.long_description=@long_description
      term.add_term
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
    
      