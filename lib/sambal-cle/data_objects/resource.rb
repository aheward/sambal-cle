class FileObject

  include Foundry
  include DataFactory
  include Workflows

  attr_accessor :name, :site, :source_path, :target_folder, :href

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
    }
    options = defaults.merge(opts)

    set_options(options)
    @target_folder=@site if options[:target_folder]==nil
    requires @site
  end

  def create
    open_my_site_by_name @site
    resources
    on Resources do |file|
      file.upload_file_to_folder @target_folder
    end
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
  include Workflows

  attr_accessor :name, :parent_folder, :site

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :name=>random_alphanums
    }
    options = defaults.merge(opts)

    set_options(options)
    requires @site
  end

  def create
    open_my_site_by_name @site
    resources
    on_page Resources do |page|
      page.create_subfolders_in @parent_folder
    end
    on_page CreateFolders do |page|
      page.folder_name.set @name
      page.create_folders_now
    end
  end

end

class WebLinkObject
  include Foundry
  include DataFactory
  include Workflows

  attr_accessor :site

  def initialize(browser, opts={})
    @browser = browser

    defaults = {}
    options = defaults.merge(opts)
    set_options(options)
    requires @site
  end

  def create

  end

end

class HTMLPageObject

  include Foundry
  include DataFactory
  include Workflows

  attr_accessor :name, :description, :site, :folder, :html, :url

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :name=>random_alphanums,
        :description=>random_multiline(100, 15, :alpha),
        :html=>"<body>Body</body>"
    }
    options = defaults.merge(opts)

    set_options(options)
    requires @site
  end

  alias :title :name
  alias :href :url
  alias :content :html

  def create
    open_my_site_by_name @site
    resources
    on_page Resources do |page|
      page.create_html_page_in @folder
    end
    on_page EditHTMLPageContent do |page|
      page.enter_source_text page.editor, @html
      page.continue
    end
    on_page EditHTMLPageProperties do |page|
      page.name.set @name
      page.description.set @description
      # Put more here as needed later
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
      edit.enter_source_text edit.editor, html_source
      edit.continue
    end
    @html=html_source
  end

end

class TextDocumentObject
  include Foundry
  include DataFactory
  include Workflows

  attr_accessor :site

  def initialize(browser, opts={})
    @browser = browser

    defaults = {}
    options = defaults.merge(opts)
    set_options(options)
    requires @site
  end

  def create
    open_my_site_by_name @site
    resources
  end

end

class CitationListObject
  include Foundry
  include DataFactory
  include Workflows

  attr_accessor :site

  def initialize(browser, opts={})
    @browser = browser

    defaults = {}
    options = defaults.merge(opts)
    set_options(options)
    requires @site
  end

  def create
    open_my_site_by_name @site
    resources
  end

end