class FileObject

  include Foundry
  include DataFactory
  include Navigation

  attr_accessor :name, :site, :source_path, :target_folder, :href

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
    }

    set_options(defaults.merge!(opts))
    @target_folder=@site if defaults[:target_folder]==nil
    requires :site
  end

  def create
    open_my_site_by_name @site
    resources
    on(Resources).upload_files_to_folder @target_folder
    on ResourcesUploadFiles do |upload|
      upload.file_to_upload @name, @source_path
      upload.upload_files_now
    end
    on Resources do |file|
      @href = file.href @name
    end
  end

end

class FolderObject
  include Foundry
  include DataFactory
  include Navigation
  include StringFactory

  attr_accessor :name, :parent_folder, :site

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :name=>random_alphanums
    }

    set_options(defaults.merge(opts))
    requires :site
  end

  def create
    open_my_site_by_name @site
    resources
    on(Resources).create_subfolders_in @parent_folder
    on_page CreateFolders do |page|
      page.folder_name.set @name
      page.create_folders_now
    end
  end

end

class WebLinkObject
  include Foundry
  include DataFactory
  include Navigation

  attr_accessor :site

  def initialize(browser, opts={})
    @browser = browser

    defaults = {}
    options = defaults.merge(opts)
    set_options(options)
    requires :site
  end

  def create

  end

end

class HTMLPageObject

  include Foundry
  include DataFactory
  include StringFactory
  include Navigation

  attr_accessor :name, :description, :site, :folder, :html, :url

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :name=>random_alphanums,
        :description=>random_multiline(100, 15, :alpha),
        :html=>'<body>Body</body>'
    }
    options = defaults.merge(opts)

    set_options(options)
    requires :site
  end

  alias :title :name
  alias :href :url
  alias :content :html

  def create
    open_my_site_by_name @site
    resources
    on(Resources).create_html_page_in @folder
    on_page EditHTMLPageContent do |page|
      page.source
      page.source_field.set @html
      page.continue
    end
    on_page EditHTMLPageProperties do |page|
      fill_out page, :name, :description # Put more here as needed later
      page.finish
    end
    on_page Resources do |page|
      @url = page.href(@name)
    end
  end

  def edit_content(html_source)
    open_my_site_by_name @site
    resources
    on Resources do |fileslist|
      fileslist.open_folder @folder unless fileslist.item(@name).present? || @folder==nil
      fileslist.edit_content @name
    end
    on EditHTMLPageContent do |edit|
      edit.source
      edit.source_field.set html_source
      edit.continue
    end
    @html=html_source
  end

end

class TextDocumentObject
  include Foundry
  include DataFactory
  include Navigation

  attr_accessor :site

  def initialize(browser, opts={})
    @browser = browser

    defaults = {}
    options = defaults.merge(opts)
    set_options(options)
    requires :site
  end

  def create
    open_my_site_by_name @site
    resources
  end

end

class CitationListObject
  include Foundry
  include DataFactory
  include Navigation

  attr_accessor :site

  def initialize(browser, opts={})
    @browser = browser

    defaults = {}
    options = defaults.merge(opts)
    set_options(options)
    requires :site
  end

  def create
    open_my_site_by_name @site
    resources
  end

end