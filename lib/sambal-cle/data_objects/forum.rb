# Note that this class is for icon-sakai-forums. NOT jforums.
class ForumObject

  include Foundry
  include DataFactory
  include StringFactory
  include Navigation
  
  attr_accessor :site, :title, :short_description, :description, :direct_link,
                :description_html
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :title=>random_alphanums
    }
    set_options(defaults.merge(opts))
    requires :site
  end

  alias :name :title

  def create
    open_my_site_by_name @site
    forums
    on(Forums).new_forum
    on EditForum do |edit|
      fill_out edit, :title, :short_description
      edit.source
      edit.source_field.fit @description
      edit.save
    end
  end
    
  def edit opts={}
    open_my_site_by_name @site
    forums
    reset
    on(Forums).forum_settings @title
    on EditForum do |edit|
      edit.title.fit opts[:title]
      edit.short_description.fit opts[:short_description]
      unless opts[:description] == nil
        edit.source
        edit.source_field.fit opts[:description]
      end
      edit.save
    end
    set_options(opts)
  end
    
  def view
    open_my_site_by_name @site
    forums
    on(Forums).open_forum @title
    on ForumView do |view|
      @short_description = view.short_description
      view.view_full_description
      @description_html = view.description_html
    end
  end
    
  def delete
    
  end

  def get_direct_link
    open_my_site_by_name @site
    forums
    reset
    on(Forums).forum_settings @title
    on(EditForum).open_link_tool
    @direct_link = on(LinkTool).get_forum_link @title
  end

end

class TopicObject

  include Foundry
  include DataFactory
  include StringFactory
  include Navigation
  
  attr_accessor :title, :short_description, :description, :site, :forum,
                :author, :moderated, :modified_by, :date_modified,
                :date_created, :direct_link, :description_html
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :title=>random_alphanums,
      :short_description=>random_alphanums,
      :description=>random_alphanums,

    }
    set_options(defaults.merge(opts))
    requires :site, :forum
  end

  alias :name :title

  def create
    open_my_site_by_name @site
    forums
    reset
    on(Forums).new_topic_for_forum @forum
    on AddEditTopic do |add|
      fill_out add, :title, :short_description
      add.source
      add.source_field.fit @description
      add.save
    end
  end

  def edit opts={}
    open_my_site_by_name @site
    forums
    reset
    on(Forums).topic_settings @title
    on AddEditTopic do |edit|
      edit.title.fit opts[:title]
      edit.short_description.fit opts[:short_description]
      unless opts[:description] == nil
        edit.source
        edit.source_field.fit opts[:description]
      end
      edit.save
    end
    set_options(opts)
  end
    
  def view
    open_my_site_by_name @site
    forums
    reset
    on(Forums).open_topic @title
    on ForumView do |view|
      @short_description = view.short_description
      view.view_full_description
      @description_html = view.description_html
    end
  end
    
  def delete
    
  end

  def get_direct_link
    open_my_site_by_name @site
    forums
    on(Forums).topic_settings @title
    on(AddEditTopic).open_link_tool
    @direct_link = on(LinkTool).get_topic_link @title
  end
  
end
    
      