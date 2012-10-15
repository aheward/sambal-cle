class AnnouncementObject

  include Utilities
  include PageHelper
  include Workflows

  attr_accessor :title, :body, :site, :link, :access, :availability,
                :subject, :saved_by, :date, :creation_date, :groups,
                :message, :message_html, :id

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :title=>random_alphanums,
        :body=>random_multiline(500, 10, :alpha)
    }
    options = defaults.merge(opts)
    set_options(options)
<<<<<<< HEAD
<<<<<<< HEAD
    requires @site
=======
    raise "You must specify a Site for the announcement" if @site==nil
>>>>>>> 8c662f2... Added the set_options method to the PageHelper module. Updated the data object classes to use this method.
=======
    requires @site
>>>>>>> 38e0fb3... Added requires method to pagehelper, updated data object classes to use this method.
  end

  alias :name :title

  def create
    open_my_site_by_name @site unless @browser.title=~/#{@site}/
    announcements unless @browser.title=~/Announcements$/
    on_page Announcements do |page|
      page.add
    end
    on_page AddEditAnnouncements do |page|
      page.title.set @title
      page.enter_source_text page.editor, @body
      page.add_announcement
      @creation_date=make_date Time.now
    end
    on_page Announcements do |page|
      @link = page.href(@title)
      @id = @link[/(?<=msg\/).+(?=\/main\/)/]
    end
  end

  def edit opts={}
    open_my_site_by_name @site unless @browser.title=~/#{@site}/
    announcements unless @browser.title=~/Announcements$/
    on_page Announcements do |list|
      list.edit @title
    end
    on AddEditAnnouncements do |edit|
      edit.title.set opts[:title] unless opts[:title]==nil
      edit.send(opts[:access]) unless opts[:access]==nil
      edit.send(opts[:availability]) unless opts[:availability]==nil
      unless opts[:body]==nil
        edit.enter_source_text edit.editor, opts[:body]
      end
      edit.save_changes
    end
    update_options(opts)
  end

  def view
    open_my_site_by_name @site unless @browser.title=~/#{@site}/
    announcements unless @browser.title=~/Announcements$/
    on Announcements do |list|
      list.view @title
    end
    on ViewAnnouncement do |view|
      @subject=view.subject
      @saved_by=view.saved_by
      @date=view.date
      @groups=view.groups
      @message=view.message
      @message_html=view.message_html
    end
  end

end