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
    on Forums do |forums|
      forums.new_forum
    end
    on EditForum do |edit|
      edit.title.set @title
      edit.short_description.fit @short_description
      edit.enter_source_text(edit.editor, @description) unless @description==nil
      edit.save
    end
  end
    
  def edit opts={}
    open_my_site_by_name @site
    forums unless @browser.title=~/Forums$/
    on Forums do |forum|
      forum.forum_settings @title
    end
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
    on Forums do |forum|
      forum.open_forum @title
    end
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
    on Forums do |forum|
      forum.forum_settings @title
    end
    on EditForum do |edit|
      edit.entity_picker edit.editor
    end
    on EntityPicker do |pick|
      pick.view_forum_details @title
      @direct_link = pick.direct_link
      # TODO: put more entity info stuff here!!
      pick.close_picker
    end
    on EditForum do |edit|
      edit.cancel
    end
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
    on Forums do |forums|
      forums.new_topic_for_forum @forum
    end
    on AddEditTopic do |add|
      add.title.set @title
      add.short_description.set @short_description
      add.enter_source_text add.editor, @description
      add.save
    end
  end

  def edit opts={}
    open_my_site_by_name @site
    forums
    on Forums do |forum|
      reset
      forum.topic_settings @title
    end
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
    on Forums do |forum|
      reset
      forum.open_topic @title
    end
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
    on Forums do |forums|
      forums.topic_settings @title
    end
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
    on AddEditTopic do |topic|
      topic.cancel
    end
  end
  
end
    
      