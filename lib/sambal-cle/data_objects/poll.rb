class PollObject

  include Foundry
  include DataFactory
  include StringFactory
  include Navigation
  
  attr_accessor :question, :instructions, :options, :opening_date, :closing_date,
                :access, :visibility, :site
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :question=>random_alphanums,
      :options=>[random_alphanums, random_alphanums]
    }
    
    set_options(defaults.merge(opts))
    requires :site
  end
    
  def create
    open_my_site_by_name @site
    polls
    on(Polls).add
    on AddEditPoll do |add|
      add.question.set @question
      add.enter_source_text add.editor, @instructions
      # TODO: Need to add the filling out of more fields here
      add.save_and_add_options
    end
    on AddAnOption do |page|
      if @options.length > 1
        @options[0..-2].each do |option|
          page.enter_source_text page.editor, option
          page.save_and_add_options
        end
        page.enter_source_text(page.editor, @options[-1])
        page.save
      else
        page.enter_source_text(page.editor, @options[0])
        page.save
      end
    end
    on(AddEditPoll).save
  end
    
  def edit opts={}
    #TODO: Add stuff here
    set_options(opts)
  end
    
  def view
    #TODO: Add stuff here
  end
    
  def delete
    #TODO: Add stuff here
  end
  
end
    
      