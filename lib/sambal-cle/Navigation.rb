# Navigation is a module containing helper navigation methods
module Navigation

  # Opens 'My Sites' and then clicks on the matching
  # Site name--unless the specified site is what you're already in.
  def open_my_site_by_name(name)
    case
      when @browser.title=~/#{name}/
        # do nothing, you're already there
      when @browser.link(title: /#{name}/).present?
        @browser.link(title: /#{name}/).click
      when @browser.link(:text, 'More Sites').present?
        @browser.link(:text, 'More Sites').click
        if @browser.link(title: /#{name}/).present?
          @browser.link(title: /#{name}/).click
        else
          @browser.text_field(id: 'txtSearch').set name[0..5]
          @browser.link(title: /#{name}/).click
        end
    end
  end

  def self.menu_link link_text
    define_method(StringFactory.damballa(link_text)) { @browser.link(text: link_text).click unless @browser.title=~/#{link_text}/ }
  end

  menu_link 'Account'
  menu_link 'Aliases'
  menu_link 'Administration Workspace'
  menu_link 'Announcements'
  menu_link 'Assignments'
  menu_link 'Basic LTI'
  menu_link 'Blogs'
  menu_link 'Blogger'
  menu_link 'Calendar'
  menu_link 'Certification'
  menu_link 'Chat Room'
  menu_link 'Configuration Viewer'
  menu_link 'Customizer'
  menu_link 'Discussion Forums'
  menu_link 'Drop Box'
  menu_link 'Email'
  menu_link 'Email Archive'
  menu_link 'Email Template Administration'
  menu_link 'Evaluation System'
  menu_link 'Feedback'
  menu_link 'Forms'
  menu_link 'Forums'
  menu_link 'Glossary'
  menu_link 'Gradebook'
  menu_link 'Gradebook2'
  menu_link 'Help'
  menu_link 'Home'
  menu_link 'Job Scheduler'
  menu_link 'Lessons'
  menu_link 'Lesson Builder'
  menu_link 'Link Tool'
  menu_link 'Live Virtual Classroom'
  menu_link 'Matrices'
  menu_link 'Media Gallery'
  menu_link 'Membership'
  menu_link 'Memory'
  menu_link 'Messages'
  menu_link 'My Sites'
  menu_link 'My Workspace'
  menu_link 'News'
  menu_link 'On-Line'
  menu_link 'Oauth Providers'
  menu_link 'Oauth Tokens'
  menu_link 'OpenSyllabus'
  menu_link 'Podcasts'
  menu_link 'Polls'
  menu_link 'Portfolios'
  menu_link 'Portfolio Templates'
  menu_link 'Preferences'
  menu_link 'Profile'
  menu_link 'Profile2'
  menu_link 'Realms'
  menu_link 'Resources'
  menu_link 'Roster'
  menu_link 'rSmart Support'
  menu_link 'Search'
  menu_link 'Sections'
  menu_link 'Site Archive'
  menu_link 'Site Editor'
  menu_link 'Site Setup'
  menu_link 'Site Statistics'
  menu_link 'Sites'
  menu_link 'Skin Manager'
  menu_link 'Super User'
  menu_link 'Styles'
  menu_link 'Syllabus'
  menu_link 'Tests & Quizzes'
  alias_method :assessments, :tests__quizzes
  alias_method :tests_and_quizzes, :tests__quizzes
  menu_link 'User Membership'
  menu_link 'Users'
  menu_link 'Web Content'
  menu_link 'Wiki'

  # The Page Reset button, found on all Site pages
  def reset
    @browser.link(:href=>/tool-reset/).click
  end

  # Use in the #create method of your data objects for filling out
  # fields. This method eliminates the need to write repetitive
  # lines of code, with one line for every field needing to be
  # filled in.
  #
  # Requirement: The field method name and the class instance variable
  # must be the same!
  #
  # This method currently only supports text fields, selection lists,
  # and radio buttons.
  def fill_out(page, *fields)
    methods={
        'Watir::TextField' => lambda{|p, f| p.send(f).fit(ivg f)},
        'Watir::Select'    => lambda{|p, f| p.send(f).pick!(ivg f)},
        # Standard model for Sakai radio buttons is that the instance
        # variable contains a symbol matching the method for the radio
        # button you're going to set. Do not use #fill_out for radio
        # buttons that don't follow that pattern.
        'Watir::Radio'     => lambda{|p, f| p.send(ivg f).set}
    }
    fields.each do |field|
      methods[page.send(field).class.to_s].call(page, field)
    end
  end
  alias_method :fill_in, :fill_out

  # ==========
  private
  # ==========

  def ivg(symb)
    instance_variable_get('@'+symb.to_s)
  end

end
