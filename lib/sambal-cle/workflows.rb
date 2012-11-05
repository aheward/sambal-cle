# Workflows is a module containing helper navigation methods
module Workflows

  def self.menu_link name, title, opts={}
    define_method name.to_s do
      @browser.link(opts).click unless @browser.title=~/#{title}$/
    end
  end

  # Opens "My Sites" and then clicks on the matching
  # Site name--unless the specified site is what you're already in.
  # Shortens the name used for search so
  # that truncated names are not a problem.
  def open_my_site_by_name(name)
    unless @browser.title=~/#{name}/
      @browser.link(:text, "My Sites").click
      @browser.link(:text, /#{Regexp.escape(name[0..19])}/).click
    end
  end

  # Clicks the "Account" link in the Adminstration Workspace
  # Should be followed by the UserAccount class.
  #
  # Throws an error if the link is not present.
  menu_link :account, "Account", :text=>"Account"

  # Clicks the "Aliases" link in the Administration Workspace
  # menu, then should be followed by the Aliases class.
  menu_link :aliases, "Aliases", :text=>"Aliases"

  # Clicks the link for the Administration Workspace, then
  # should be followed by the MyWorkspace class.
  menu_link :administration_workspace, "Administration Workspace", :text=>"Administration Workspace"

  # Clicks the Announcements link goes to
  # the Announcements class.
  menu_link :announcements, "Announcements", :class=>'icon-sakai-announcements'

  # Clicks the Assignments link, goes to
  # the AssignmentsList class.
  menu_link :assignments, "Assignments", :class=>"icon-sakai-assignment-grades"

  # BasicLTI class
  menu_link :basic_lti, "Basic LTI", :class=>"icon-sakai-basiclti"

  # Blogs class
  menu_link :blogs, "Blogs", :class=>"icon-sakai-blogwow"

  # Clicks the Blogger link in the Site menu and
  # instantiates the Blogger Class.
  menu_link :blogger, "Blogger", :class=>"icon-blogger"

  # Clicks the Calendar link, then instantiates
  # the Calendar class.
  menu_link :calendar, "Calendar", :text=>"Calendar"

  menu_link :certification, "Certification", :text=>"Certification"

  # ChatRoom class
  menu_link :chat_room, "Chat Room", :class=>"icon-sakai-chat"

  menu_link :configuration_viewer, "Configuration Viewer", :text=>"Configuration Viewer"
  menu_link :customizer, "Customizer", :text=>"Customizer"

  # JForum page class.
  menu_link :discussion_forums, "Discussion Forums", :class=>"icon-sakai-jforum-tool"

  # DropBox class
  menu_link :drop_box, "Drop Box", :class=>"icon-sakai-dropbox"

  menu_link :email, "Email", :text=>"Email"

  # Email Archive class
  menu_link :email_archive, "Email Archive", :class=>"icon-sakai-mailbox"

  menu_link :email_template_administration, "Email Template Administration", :text=>"Email Template Administration"

  # EvaluationSystem class
  menu_link :evaluation_system, "Evaluation System", :class=>"icon-sakai-rsf-evaluation"

  # Feedback class
  menu_link :feedback, "Feedback", :class=>"icon-sakai-postem"

  # Forms class
  menu_link :forms, "Forms", :text=>"Forms", :class=>"icon-sakai-metaobj"

  # Forums class.
  menu_link :forums, "Forums", :text=>"Forums"

  # Glossary Class.
  menu_link :glossary, "Glossary", :text=>"Glossary"

  # Gradebook Class.
  menu_link :gradebook, "Gradebook", :text=>"Gradebook"

  # Gradebook2 class
  menu_link :gradebook2, "Gradebook2", :text=>"Gradebook2"

  menu_link :help, "Help", :text=>"Help"

  # Home class--unless the target page happens to be
  # My Workspace, in which case the MyWorkspace
  # page should be used.
  menu_link :home, "Home", :text=>"Home"

  # Job Scheduler class.
  menu_link :job_scheduler, "Job Scheduler", :text=>"Job Scheduler"

  # Lessons class
  menu_link :lessons, "Lessons", :text=>"Lessons"

  menu_link :lesson_builder, "Lesson Builder", :text=>"Lesson Builder"
  menu_link :link_tool, "Link Tool", :text=>"Link Tool"
  menu_link :live_virtual_classroom, "Live Virtual Classroom", :text=>"Live Virtual Classroom"

  # Matrices Class
  menu_link :matrices, "Matrices", :text=>"Matrices"

  # MediaGallery class
  menu_link :media_gallery, "Media Gallery", :class=>"icon-sakai-kaltura"

  menu_link :membership, :text=>"Membership"
  menu_link :memory, :text=>"Memory"

  # Messages class.
  menu_link :messages, :text=>"Messages"
  menu_link :my_sites, :text=>"My Sites"

  # MyWorkspace Class.
  menu_link :my_workspace, :text=>"My Workspace"

  # News
  menu_link :news, "News", :class=>"icon-sakai-news"

  menu_link :online, "On-Line", :text=>"On-Line"
  menu_link :oauth_providers, "Oauth Providers", :text=>"Oauth Providers"
  menu_link :oauth_tokens, "Oauth Tokens", :text=>"Oauth Tokens"
  menu_link :openSyllabus, :text=>"OpenSyllabus"

  # Podcasts
  menu_link :podcasts, "Podcasts", :class=>"icon-sakai-podcasts"

  # Polls class
  menu_link :polls, "Polls", :class=>"icon-sakai-poll"

  # Portfolios class
  menu_link :portfolios, "Portfolios", :class=>"icon-osp-presentation"

  # PortfolioTemplates
  menu_link :portfolio_templates, "Portfolio Templates", :text=>"Portfolio Templates"

  menu_link :preferences, "Preferences", :text=>"Preferences"

  menu_link :profile, "Profile", :text=>"Profile"

  # Profile2 class
  menu_link :profile2, "Profile2", :class=>"icon-sakai-profile2"

  menu_link :realms, "Realms", :text=>"Realms"

  # Resources class.
  menu_link :resources, "Resources", :text=>"Resources"

  # Roster
  menu_link :roster, "Roster", :class=>"icon-sakai-site-roster"

  menu_link :rsmart_support, "rSmart Support", :text=>"rSmart Support"

  # Because "Search" is used in many pages,
  # The Search button found in the Site Management
  # Menu must be given the more explicit name
  menu_link :site_management_search, "Search", :class=>"icon-sakai-search"

  # Sections
  menu_link :sections, "Sections", :class=>"icon-sakai-sections"

  menu_link :site_archive, "Site Archive", :text=>"Site Archive"

  # SiteEditor class.
  menu_link :site_editor, "Site Editor", :text=>"Site Editor"

  # SiteSetup class.
  menu_link :site_setup, "Site Setup", :text=>"Site Setup"

  menu_link :site_statistics, "Site Statistics", :text=>"Site Statistics"

  # Sites class.
  menu_link :sites, "Sites", :class=>"icon-sakai-sites"

  menu_link :skin_manager, "Skin Manager", :text=>"Skin Manager"
  menu_link :super_user, "Super User", :text=>"Super User"

  # Styles
  menu_link :styles, "Styles", :text=>"Styles"

  # Syllabus class.
  menu_link :syllabus, "Syllabus", :text=>"Syllabus"

  # AssessmentsList class OR the TakeAssessmentList for students
  menu_link :assessments, "Tests & Quizzes", :class=>"icon-sakai-samigo"
  alias :tests_and_quizzes :assessments

  # UserMembership
  menu_link :user_membership, "User Membership", :class=>"icon-sakai-usermembership"

  # Users
  menu_link :users, "Users", :class=>"icon-sakai-users"

  # WebContent
  menu_link :web_content, "Web Content", :class=>"icon-sakai-iframe"

  # Wikis
  menu_link :wiki, "Wiki", :class=>"icon-sakai-rwiki"

  # The Page Reset button, found on all Site pages
  def reset
    @browser.link(:href=>/tool-reset/).click
  end

end
