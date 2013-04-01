class GlossaryTermObject

  include Foundry
  include DataFactory
  include StringFactory
  include Navigation
  
  attr_accessor :term, :short_description, :long_description, :portfolio
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :term=>random_alphanums,
      :short_description=>random_alphanums,
      :long_description=>random_alphanums
    }
    set_options(defaults.merge(opts))
    requires :portfolio
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
    open_my_site_by_name @portfolio
    glossary
    on Glossary do |list|
      list.edit @term
    end
    on AddEditTerm do |term|
      term.term.fit opts[:term]
      term.short_description.fit opts[:short_description]
      term.long_description=opts[:long_description] unless opts[:long_description]==nil
      term.save_changes
    end
    set_options(opts)
  end
    
  def open
    open_my_site_by_name @portfolio
    glossary
    on Glossary do |list|
      list.open @term
    end
  end
    
  def delete
    open_my_site_by_name @portfolio
    glossary
    on Glossary do |list|
      list.delete @term
    end
  end
  
end
    
      