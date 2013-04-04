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
      fill_out_form edit, :title, :short_description
      edit.enter_source_text(edit.editor, @description) unless @description==nil
      edit.save
    end
  end
    
  def edit opts={}
    open_my_site_by_name @site
    forums unless @browser.title=~/Forums$/
    on(Forums).forum_settings @title
    on EditForum do |edit|
      edit.title.fit opts[:title]
      edit.short_description.fit opts[:short_description]
      unless opts[:description] == nil
        edit.enter_source_text edit.editor, opts[:description]
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

  def get_entity_info
    open_my_site_by_name @site
    forums
    # TODO: Something will probably be needed here, in case we're currently
    # on a Forum page already.
    on(Forums).forum_settings @title
    on(EditForum).entity_picker edit.editor
    on EntityPicker do |pick|
      pick.view_forum_details @title
      @direct_link = pick.direct_link
      pick.close_picker
    end
    on(EditForum).cancel
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
    requires @site, @forum
  end

  alias :name :title

  def create
    open_my_site_by_name @site
    forums
    on(Forums).new_topic_for_forum @forum
    on AddEditTopic do |add|
      fill_out_form add, :title, :short_description
      add.enter_source_text add.editor, @description
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
        edit.enter_source_text edit.editor, opts[:description]
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

  def get_entity_info
    open_my_site_by_name @site
    forums
    on(Forums).topic_settings @title
    on AddEditTopic do |topic|
      topic.entity_picker topic.editor
    end
    on EntityPicker do |picker|
      picker.view_topic_details @forum, @title
      @author = picker.author
      @moderated = picker.moderated
      @modified_by = picker.modified_by
      @date_modified = picker.date_modified
      @date_created = picker.date_created
      @direct_link = picker.direct_link
      picker.close_picker
    end
    on( AddEditTopic).cancel
  end
  
end
    
      