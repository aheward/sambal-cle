class SyllabusObject

  include Foundry
  include DataFactory
  include StringFactory
  include Navigation

  attr_accessor :title, :content, :site

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :title=>random_alphanums,
        :content=>random_multiline(50, 5, :alpha)
    }
    set_options(defaults.merge(opts))
    requires :site
  end

  alias :name :title

  def create
    open_my_site_by_name @site
    syllabus
    on Syllabus do |add|
      add.create_edit
      add.add
    end
    on AddEditSyllabusItem do |create|
      create.title.set @title
      create.source
      create.source_field.set @content
      create.post
    end
  end

  def edit opts={}
    open_my_site_by_name @site
    syllabus
    reset
    on(Syllabus).create_edit
    on(SyllabusEdit).open_item @title
    on AddEditSyllabusItem do |item|
      item.title.fit opts[:title]
      item.enter_source_text(item.editor, opts[:content]) unless opts[:content]==nil
    end
    set_options(opts)
  end

  def get_properties
    open_my_site_by_name @site
    syllabus
    sleep 2 #FIXME
    reset
    on(Syllabus).create_edit
    on(SyllabusEdit).open_item @title
    on AddEditSyllabusItem do |item|
      @content = item.get_source_text(item.editor)
      # Add more here as necessary...
    end
  end

end