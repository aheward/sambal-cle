class CourseSiteObject

  include Foundry
  include DataFactory
  include StringFactory
  include DateFactory
  include Navigation

  attr_accessor :name, :id, :subject, :course, :section, :term, :term_value, :authorizer,
    :web_content_source, :email, :joiner_role, :creation_date, :web_content_title,
    :description, :short_description, :site_contact_name, :site_contact_email, :participants

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
      :subject => random_alphanums(8),
      :course => random_alphanums(8),
      :section => random_alphanums(8),
      :authorizer => "admin",
      :web_content_title => random_alphanums(15),
      :web_content_source => "http://www.rsmart.com",
      :email=>random_nicelink(32),
      :joiner_role => "Student",
      :description => random_alphanums(30),
      :short_description => random_alphanums,
      :site_contact_name => random_alphanums(5)+" "+random_alphanums(8),
      :participants=>{}
    }
    set_options(defaults.merge(opts))
  end

  def create
    my_workspace
    site_setup
    on(SiteSetupList).new
    on SiteType do |page|
      # Select the Course Site radio button
      page.course_site.set
      # Store the selected term value for use later
      # TODO: Add logic here in case we want to actually SET the term value instead.
      @term_value = page.academic_term.value
      @term = page.academic_term.selected_options[0].text[/\w+.\w+/]
      page.continue
    end
    on CourseSectionInfo do |page|
      # Fill in those fields, storing the entered values for later verification steps
      page.subject.set @subject

      page.course.set @course

      page.section.set @section

      # Store site name for ease of coding and readability later
      @name = "#{@subject} #{@course} #{@section} #{@term_value}"

      # Click continue button
      page.continue
    end
    on CourseSiteInfo do |page|
      fill_out page, :short_description, :site_contact_name, :site_contact_email
      page.source
      page.source_field.set @description

      # Click Continue
      page.continue
    end
    on EditSiteTools do |page|
      #Check All Tools
      page.all_tools.set
      page.continue
    end
    on AddMultipleTools do |add_tools|
      add_tools.site_email_address.set @email
      fill_out add_tools, :web_content_title, :web_content_source

      add_tools.continue
    end
    on SiteAccess do |access|
      access.allow.set
      access.joiner_role.select @joiner_role
      access.continue
    end
    on ConfirmSiteSetup do |review|
      review.request_site
    end

    # Create a string that will match the new Site's "creation date" string
    @creation_date = right_now[:sakai]

    on SiteSetupList do |site_setup|
      site_setup.search_field.set(Regexp.escape(@subject))
      site_setup.search

      # Get the site id for storage
      site_setup.frm.link(:href=>/portal.site/, :index=>0).href =~ /(?<=\/site\/).+/
      @id = $~.to_s
    end
  end

  def create_and_reuse_site(site_name)
    my_workspace
    site_setup
    on(SiteSetupList).new
    on SiteType do |site_type|

      # Select the Course Site radio button

      site_type.course_site.set

      # Store the selected term value for use later
      @term = site_type.academic_term.value

      # Click continue
      site_type.continue
    end
    on CourseSectionInfo do |course_section|
      # Fill in those fields, storing the entered values for later verification steps
      fill_out course_section, :subject, :course, :section

      # Store site name for ease of coding and readability later
      @name = "#{@subject} #{@course} #{@section} #{@term_value}"

      # Add a valid instructor id
      course_section.authorizers_username.set @authorizer

      # Click continue button
      course_section.continue
    end
    on CourseSiteInfo do |course_site|
      course_site.enter_source_text course_site.editor, @description
      course_site.short_description.set @short_description
      # Click Continue
      course_site.continue
    end
    on EditSiteTools do |course_tools|
      #Check All Tools
      course_tools.all_tools.set
      course_tools.yes.set
      course_tools.import_sites.select site_name
      course_tools.continue
    end
    on_page ReUseMaterial do |page|
      page.announcements_checkbox.set
      page.calendar_checkbox.set
      page.discussion_forums_checkbox.set
      page.forums_checkbox.set
      page.chat_room_checkbox.set
      page.polls_checkbox.set
      page.syllabus_checkbox.set
      page.lessons_checkbox.set
      page.resources_checkbox.set
      page.assignments_checkbox.set
      page.tests_and_quizzes_checkbox.set
      page.gradebook_checkbox.set
      page.gradebook2_checkbox.set
      page.wiki_checkbox.set
      page.news_checkbox.set
      page.web_content_checkbox.set
      page.site_statistics_checkbox.set
      page.continue
    end
    on_page AddMultipleTools do |page|
      page.site_email_address.set @email
      fill_out page, :web_content_title, :web_content_source
      page.continue
    end
    on_page SiteAccess do |page|
      page.allow.set
      page.joiner_role.select @joiner_role
      page.continue
    end
    on(ConfirmSiteSetup).request_site
    # Create a string that will match the new Site's "creation date" string
    @creation_date = make_date(Time.now)
    on(SiteSetupList).search(Regexp.escape(@subject))
    # Get the site id for storage
    @browser.frame(:class=>'portletMainIframe').link(:href=>/xsl-portal.site/, :index=>0).href =~ /(?<=\/site\/).+/
    @id = $~.to_s

  end

  def duplicate opts={}

    defaults = {
        :name => random_alphanums,
        :term => @term,
        :subject => @subject,
        :course => @course,
        :section => @section,
        :authorizer => @authorizer,
        :web_content_title => @web_content_title,
        :web_content_source => @web_content_source,
        :email=>@email,
        :joiner_role => @joiner_role,
        :description => @description,
        :short_description => @short_description,
        :site_contact_name => @site_contact_name,
        :site_contact_email => @site_contact_email
    }
    options = defaults.merge(opts)

    new_site = make CourseSiteObject, options

    open_my_site_by_name @name
    site_editor
    on(SiteEditor).duplicate_site
    on DuplicateSite do |dupe|
      dupe.site_title.set new_site.name
      dupe.academic_term.select new_site.term
      dupe.duplicate
    end
    my_workspace
    site_setup
    on SiteSetupList do |list|
      list.clear_search
      list.search_field.set(Regexp.escape(new_site.name))
      list.search
    end

    # Get the site id for storage
    @browser.frame(:class=>'portletMainIframe').link(:href=>/portal.site/, :index=>0).href =~ /(?<=\/site\/).+/
    new_site.id = $~.to_s

    new_site

  end

  def add_official_participants(role, *participants)
    list_of_ids=participants.join("\n")
    open_my_site_by_name @name
    site_editor
    on(SiteEditor).add_participants
    on SiteSetupAddParticipants do |add|
      add.official_participants.set list_of_ids
      add.continue
    end
    on SiteSetupChooseRole do |choose|
      choose.radio_button(role).set
      choose.continue
    end
    on(SiteSetupParticipantEmail).continue
    on(SiteSetupParticipantConfirm).finish
    if @participants.has_key?(role)
      @participants[role].insert(-1, participants).flatten!
    else
      @participants.store(role, participants)
    end
  end

end