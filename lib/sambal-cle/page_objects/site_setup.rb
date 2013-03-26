#================
# Site Setup/Site Editor Pages
#================

# This superclass contains the methods referring to the menu items
# across the top of all the Site Editor pages.
class SiteSetupBase < BasePage

  frame_element
  basic_page_elements

  class << self

  end
end

# The Site Setup page - a.k.a., link class=>"icon-sakai-sitesetup"
class SiteSetupList < SiteSetupBase

  menu_elements

  expected_element :search_field

  element(:search_field) { |b| b.frm.text_field(:id, "search") }
  button 'Search'
  link 'Edit'
  link 'New'
  element(:view) { |b| b.frm.select(:id=>"view") }
  button 'Clear Search'

  # Returns an Array object containing strings of
  # all Site titles displayed on the web page.
  action(:site_titles) { |b| titles = []; 1.upto(b.sites_table.rows.size-1) { |x| titles << b.sites_table[x][1].text }; titles }

  action(:check_site) { |site_name, b| b.sites_table }

  element(:select_page_size) { |b| b.frm.select(:id=>"selectPageSize").click }
  action(:sort_by_title) { |b| b.frm.link(:text=>"Worksite Title").click }
  action(:sort_by_type) { |b| b.frm.link(:text=>"Type").click }
  action(:sort_by_creator) { |b| b.frm.link(:text=>"Creator").click }
  action(:sort_by_status) { |b| b.frm.link(:text=>"Status").click }
  action(:sort_by_creation_date) { |b| b.frm.link(:text=>"Creation Date").click }

  # =========
  private
  # =========

  element(:sites_table) { |b| b.frm.table(:id=>"siteList") }

end

# The topmost "Site Editor" page,
# found in SITE MANAGEMENT
# or else Site Setup after you have
# selected to Edit a particular site.
class SiteEditor < SiteSetupBase

  menu_elements
  
  # Sets the specified role for the specified participant.
  #
  # Because the participant is selected using a regular expression,
  # the "participant" string can be anything that will suffice as a
  # unique match--i.e., last name, first name, or user id, or any combination,
  # as long as it will match a part of the string that appears in the
  # desired row.
  def set_role(participant, role)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(participant)}/).select(:id=>/role/).select(role)
  end
  
  #action(:update_participants) { |b| b.frm.button(:value=>"Update Participants").click }
  button("Update Participants")

  element(:return_button) { |b| b.frm.button(:name=>"back") }

  action(:return_to_sites_list) { |p| p.return_button.click }

  action(:previous) { |b| b.frm.button(:name=>"previous").click }
  #action(:printable_version) { |b| b.frm.link(:text=>"Printable Version").click }
  link("Printable Version")

end


# Groups page inside the Site Editor
class Groups < SiteSetupBase

  menu_elements

  expected_element :create_new_group_link

  link("Create New Group")
  link("Auto Groups")

  action(:remove_checked) { |b| b.frm.button(:id=>"delete-groups").click }

  end

# The Create New Group page inside the Site Editor
class CreateNewGroup < SiteSetupBase

  menu_elements
  
  # Clicks the Add button and instantiates the Groups Class.
  action(:add) { |b| b.frm.button(:id=>"save").click }
  
  element(:title) { |b| b.frm.text_field(:id=>"group_title") }
  element(:description) { |b| b.frm.text_field(:id=>"group_description") }
  element(:site_member_list) { |b| b.frm.select(:name=>"siteMembers-selection").click }
  element(:group_member_list) { |b| b.frm.select(:name=>"groupMembers-selection").click }
  action(:right) { |b| b.frm.button(:name=>"right", :index=>0,).click }
  action(:left) { |b| b.frm.button(:name=>"left", :index=>0).click }
  action(:all_right) { |b| b.frm.button(:name=>"right", :index=>1).click }
  action(:all_left) { |b| b.frm.button(:name=>"left",:index=>1).click }

  end

# The first page of the Duplicate Site pages in the Site Editor.
class DuplicateSite < SiteSetupBase

  menu_elements
   
  def duplicate
    frm.button(:value=>"Duplicate").click
    frm.span(:class=>"submitnotif").wait_while_present(300)
  end

  # Returns the site name in the header, for verification.
  value(:site_name) { |b| b.frm.div(:class=>"portletBody").h3.span(:class=>"highlight").text }
  element(:site_title) { |b| b.frm.text_field(:id=>"title") }
  element(:academic_term) { |b| b.frm.select(:id=>"selectTerm") }

end

# Page for Adding Participants to a Site in Site Setup
class SiteSetupAddParticipants < SiteSetupBase

  menu_elements

  button("Continue")
  
  element(:official_participants) { |b| b.frm.text_field(:id=>"content::officialAccountParticipant") }
  element(:non_official_participants) { |b| b.frm.text_field(:id=>"content::nonOfficialAccountParticipant") }
  element(:assign_all_to_same_role) { |b| b.frm.radio(:id=>"content::role-row:0:role-select") }
  element(:assign_each_individually) { |b| b.frm.radio(:id=>"content::role-row:1:role-select") }
  element(:active_status) { |b| b.frm.radio(:id=>"content::status-row:0:status-select") }
  element(:inactive_status) { |b| b.frm.radio(:id=>"content::status-row:1:status-select") }
  #action(:cancel) { |b| b.frm.button(:id=>"content::cancel").click }
    
end

# Page for selecting Participant roles individually
class SiteSetupChooseRolesIndiv < SiteSetupBase

  menu_elements

  button("Continue")
  
  action(:back) { |b| b.frm.button(:name=>"command link parameters&Submitting%20control=content%3A%3Aback&Fast%20track%20action=siteAddParticipantHandler.processDifferentRoleBack").click }
  #action(:cancel) { |b| b.frm.button(:name=>"command link parameters&Submitting%20control=content%3A%3Acancel&Fast%20track%20action=siteAddParticipantHandler.processCancel").click }
  element(:user_role) { |b| b.frm.select(:id=>"content::user-row:0:role-select-selection") }

end

# Page for selecting the same role for All. This class is used for
# both Course and Portfolio sites.
class SiteSetupChooseRole < BasePage

  frame_element

  button("Continue")

  # Use this method for radio buttons that aren't
  # included in the default list below. Enter the
  # radio button's label in the UI.
  action(:radio_button) { |label, b| b.frm.radio(:value=>label) }

  action(:back) { |b| b.frm.button(:name=>"command link parameters&Submitting%20control=content%3A%3Aback&Fast%20track%20action=siteAddParticipantHandler.processSameRoleBack").click }
  action(:cancel) { |b| b.frm.button(:name=>"command link parameters&Submitting%20control=content%3A%3Acancel&Fast%20track%20action=siteAddParticipantHandler.processCancel").click }
  element(:guest) { |b| b.frm.radio(:value=>"Guest") }
  element(:instructor) { |b| b.frm.radio(:value=>"Instructor") }
  element(:student) { |b| b.frm.radio(:value=>"Student") }
  element(:evaluator) { |b| b.frm.radio(:value=>"Evaluator") }
  element(:organizer) { |b| b.frm.radio(:value=>"Organizer") }
  element(:participant) { |b| b.frm.radio(:value=>"Participant") }
  element(:reviewer) { |b| b.frm.radio(:value=>"Reviewer") }
  element(:teaching_assistant) { |b| b.frm.radio(:id=>"content::role-row:3:role-select") }

end


# Page for specifying whether to send an email
# notification to the newly added Site participants
class SiteSetupParticipantEmail < SiteSetupBase

  menu_elements

  button("Continue")
  action(:back) { |b| b.frm.button(:name=>"command link parameters&Submitting%20control=content%3A%3Acontinue&Fast%20track%20action=siteAddParticipantHandler.processEmailNotiBack").click }
  #action(:cancel) { |b| b.frm.button(:name=>"command link parameters&Submitting%20control=content%3A%3Acontinue&Fast%20track%20action=siteAddParticipantHandler.processEmailNotiCancel").click }
  element(:send_now) { |b| b.frm.radio(:id=>"content::noti-row:0:noti-select") }
  element(:dont_send) { |b| b.frm.radio(:id=>"content::noti-row:1:noti-select") }
    
end


# The confirmation page showing site participants and their set roles
class SiteSetupParticipantConfirm < SiteSetupBase

  menu_elements
  
  button("Finish")
  
  # Returns the value of the id field for the specified name.
  def id(name)
    frm.table(:class=>"listHier").row(:text=>/#{Regexp.escape(name)}/)[1].text
  end
  
  # Returns the value of the Role field for the specified name.
  def role(name)
    frm.table(:class=>"listHier").row(:text=>/#{Regexp.escape(name)}/)[2].text
  end
  
  action(:back) { |b| b.frm.button(:name=>"command link parameters&Submitting%20control=content%3A%3Aback&Fast%20track%20action=siteAddParticipantHandler.processConfirmBack").click }

end

# The Edit Tools page (click on "Edit Tools" when editing a site
# in Site Setup in the Admin Workspace)
class EditSiteTools < SiteSetupBase

  menu_elements

  expected_element :all_tools

  button("Continue")
  
  # This is a comprehensive list of all checkboxes and
  # radio buttons for this page,
  # though not all will appear at one time.
  # The list will depend on the type of site being
  # created/edited.
  element(:all_tools) { |b| b.frm.checkbox(:id=>"all") }
  element(:home) { |b| b.frm.checkbox(:id=>"home") }
  element(:announcements) { |b| b.frm.checkbox(:id=>"sakai.announcements") }
  element(:assignments,) { |b| b.frm.checkbox(:id=>"sakai.assignment.grades") }
  element(:basic_lti) { |b| b.frm.checkbox(:id=>"sakai.basiclti") }
  element(:calendar) { |b| b.frm.checkbox(:id=>"sakai.schedule") }
  element(:email_archive) { |b| b.frm.checkbox(:id=>"sakai.mailbox") }
  element(:evaluations) { |b| b.frm.checkbox(:id=>"osp.evaluation") }
  element(:forms) { |b| b.frm.checkbox(:id=>"sakai.metaobj") }
  element(:glossary) { |b| b.frm.checkbox(:id=>"osp.glossary") }
  element(:matrices) { |b| b.frm.checkbox(:id=>"osp.matrix") }
  element(:news) { |b| b.frm.checkbox(:id=>"sakai.news") }
  element(:portfolio_layouts) { |b| b.frm.checkbox(:id=>"osp.presLayout") }
  element(:portfolio_showcase) { |b| b.frm.checkbox(:id=>"sakai.rsn.osp.iframe") }
  element(:portfolio_templates) { |b| b.frm.checkbox(:id=>"osp.presTemplate") }
  element(:portfolios) { |b| b.frm.checkbox(:id=>"osp.presentation") }
  element(:resources) { |b| b.frm.checkbox(:id=>"sakai.resources") }
  element(:roster) { |b| b.frm.checkbox(:id=>"sakai.site.roster") }
  element(:search) { |b| b.frm.checkbox(:id=>"sakai.search") }
  element(:styles) { |b| b.frm.checkbox(:id=>"osp.style") }
  element(:web_content) { |b| b.frm.checkbox(:id=>"sakai.iframe") }
  element(:wizards) { |b| b.frm.checkbox(:id=>"osp.wizard") }
  element(:blogger) { |b| b.frm.checkbox(:id=>"blogger") }
  element(:blogs) { |b| b.frm.checkbox(:id=>"sakai.blogwow") }
  element(:chat_room) { |b| b.frm.checkbox(:id=>"sakai.chat") }
  element(:discussion_forums) { |b| b.frm.checkbox(:id=>"sakai.jforum.tool") }
  element(:drop_box) { |b| b.frm.checkbox(:id=>"sakai.dropbox") }
  element(:email) { |b| b.frm.checkbox(:id=>"sakai.mailtool") }
  element(:forums) { |b| b.frm.checkbox(:id=>"sakai.forums") }
  element(:certification) { |b| b.frm.checkbox(:id=>"com.rsmart.certification") }
  element(:feedback) { |b| b.frm.checkbox(:id=>"sakai.postem") }
  element(:gradebook) { |b| b.frm.checkbox(:id=>"sakai.gradebook.tool") }
  element(:gradebook2) { |b| b.frm.checkbox(:id=>"sakai.gradebook.gwt.rpc") }
  element(:lesson_builder) { |b| b.frm.checkbox(:id=>"sakai.lessonbuildertool") }
  element(:lessons) { |b| b.frm.checkbox(:id=>"sakai.melete") }
  element(:live_virtual_classroom) { |b| b.frm.checkbox(:id=>"rsmart.virtual_classroom.tool") }
  element(:media_gallery) { |b| b.frm.checkbox(:id=>"sakai.kaltura") }
  element(:messages) { |b| b.frm.checkbox(:id=>"sakai.messages") }
  element(:opensyllabus) { |b| b.frm.checkbox(:id=>"sakai.opensyllabus.tool") }
  element(:podcasts) { |b| b.frm.checkbox(:id=>"sakai.podcasts") }
  element(:polls) { |b| b.frm.checkbox(:id=>"sakai.poll") }
  element(:sections) { |b| b.frm.checkbox(:id=>"sakai.sections") }
  element(:site_editor) { |b| b.frm.checkbox(:id=>"sakai.siteinfo") }
  element(:site_statistics) { |b| b.frm.checkbox(:id=>"sakai.sitestats") }
  element(:syllabus) { |b| b.frm.checkbox(:id=>"sakai.syllabus") }
  element(:tests_and_quizzes_cb) { |b| b.frm.checkbox(:id=>"sakai.samigo") }
  element(:wiki) { |b| b.frm.checkbox(:id=>"sakai.rwiki") }
  element(:no_thanks) { |b| b.frm.radio(:id=>"import_no") }
  element(:yes) { |b| b.frm.radio(:id=>"import_yes") }
  element(:import_sites) { |b| b.frm.select(:id=>"importSites") }
  action(:back) { |b| b.frm.button(:name=>"Back").click }

end

class ReUseMaterial < SiteSetupBase

  menu_elements

  element(:announcements_checkbox) { |b| b.frm.checkbox(name: "sakai.announcements") }
  element(:calendar_checkbox) { |b| b.frm.checkbox(name: "sakai.schedule") }
  element(:discussion_forums_checkbox) { |b| b.frm.checkbox(name: "sakai.jforum.tool") }
  element(:forums_checkbox) { |b| b.frm.checkbox(name: "sakai.forums") }
  element(:chat_room_checkbox) { |b| b.frm.checkbox(name: "sakai.chat") }
  element(:polls_checkbox) { |b| b.frm.checkbox(name: "sakai.poll") }
  element(:syllabus_checkbox) { |b| b.frm.checkbox(name: "sakai.syllabus") }
  element(:lessons_checkbox) { |b| b.frm.checkbox(name: "sakai.melete") }
  element(:resources_checkbox) { |b| b.frm.checkbox(name: "sakai.resources") }
  element(:assignments_checkbox) { |b| b.frm.checkbox(name: "sakai.assignment.grades") }
  element(:tests_and_quizzes_checkbox) { |b| b.frm.checkbox(name: "sakai.samigo") }
  element(:gradebook_checkbox) { |b| b.frm.checkbox(name: "sakai.gradebook.tool") }
  element(:gradebook2_checkbox) { |b| b.frm.checkbox(name: "sakai.gradebook.gwt.rpc") }
  element(:wiki_checkbox) { |b| b.frm.checkbox(name: "sakai.rwiki") }
  element(:news_checkbox) { |b| b.frm.checkbox(name: "sakai.news") }
  element(:web_content_checkbox) { |b| b.frm.checkbox(name: "sakai.iframe") }
  element(:site_statistics_checkbox) { |b| b.frm.checkbox(name: "sakai.sitestats") }
  action(:continue) { |b| b.frm.button(name: "eventSubmit_doContinue").click }

end

# Confirmation page when editing site tools in Site Setup
class ConfirmSiteToolsEdits < SiteSetupBase

  menu_elements

  expected_element :finish_button

  button("Finish")
  
end


# The Delete Confirmation Page for deleting a Site
class DeleteSite < SiteSetupBase

  menu_elements

  button("Remove")

end

#The Site Type page that appears when creating a new site
class SiteType < SiteSetupBase

  menu_elements

  def continue #FIXME
    if frm.button(:id, "submitBuildOwn").enabled?
      frm.button(:id, "submitBuildOwn").click
    elsif frm.button(:id, "submitFromTemplateCourse").enabled?
      frm.button(:id, "submitFromTemplateCourse").click
    elsif frm.button(:id, "submitFromTemplate").enabled?
      frm.button(:id, "submitFromTemplate").click
    end

  end
  
  element(:course_site) { |b| b.frm.radio(:id=>"course") }
  element(:project_site) { |b| b.frm.radio(:id=>"project") }
  element(:portfolio_site) { |b| b.frm.radio(:id=>"portfolio") }
  element(:create_site_from_template) { |b| b.frm.radio(:id=>"copy") }
  element(:academic_term) { |b| b.frm.select(:id=>"selectTerm") }
  element(:select_template) { |b| b.frm.select(:id=>"templateSiteId") }
  element(:select_term) { |b| b.frm.select(:id=>"selectTermTemplate") }
  element(:copy_users) { |b| b.frm.checkbox(:id=>"copyUsers") }
  element(:copy_content) { |b| b.frm.checkbox(:id=>"copyContent") }

end
  

# The Add Multiple Tool Instances page that appears during Site creation
# after the Course Site Tools page
class AddMultipleTools < SiteSetupBase

  menu_elements

  button("Continue")

    # Note that the text field definitions included here
    # for the Tools definitions are ONLY for the first
    # instances of each. Since the UI allows for
    # an arbitrary number, if you are writing tests
    # that add more then you're going to have to explicitly
    # reference them or define them in the test case script
    # itself--for now, anyway.
  element(:site_email_address) { |b| b.frm.text_field(:id=>"emailId") }
  element(:basic_lti_title) { |b| b.frm.text_field(:id=>"title_sakai.basiclti") }
  element(:more_basic_lti_tools) { |b| b.frm.select(:id=>"num_sakai.basiclti") }
  element(:lesson_builder_title) { |b| b.frm.text_field(:id=>"title_sakai.lessonbuildertool") }
  element(:more_lesson_builder_tools) { |b| b.frm.select(:id=>"num_sakai.lessonbuildertool")  }
  element(:news_title) { |b| b.frm.text_field(:id=>"title_sakai.news") }
  element(:news_url_channel) { |b| b.frm.text_field(:name=>"channel-url_sakai.news") }
  element(:more_news_tools) { |b| b.frm.select(:id=>"num_sakai.news")  }
  element(:web_content_title) { |b| b.frm.text_field(:id=>"title_sakai.iframe") }
  element(:web_content_source) { |b| b.frm.text_field(:id=>"source_sakai.iframe") }
  element(:more_web_content_tools) { |b| b.frm.select(:id=>"num_sakai.iframe")  }

end
  

# The Course/Section Information page that appears when creating a new Site
class CourseSectionInfo < SiteSetupBase

  menu_elements
  expected_element :subject

  button("Continue")
  
  # Clicks the Done button (or the
  # "Done - go to Site" button if it
  # happens to be there), then instantiates
  # the SiteSetup Class.
  action(:done) { |b| b. frm.button(:value=>/Done/).click }
  
    # Note that ONLY THE FIRST instances of the
    # subject, course, and section fields
    # are included in the page elements definitions here,
    # because their identifiers are dependent on how
    # many instances exist on the page.
    # This means that if you need to access the second
    # or subsequent of these elements, you'll need to
    # explicitly identify/define them in the test case
    # itself.
  element(:subject) { |b| b.frm.text_field(:name=>/Subject:/) }
  element(:course) { |b| b.frm.text_field(:name=>/Course:/) }
  element(:section) { |b| b.frm.text_field(:name=>/Section:/) }
  element(:authorizers_username) { |b| b.frm.text_field(:id=>"uniqname") }
  element(:special_instructions) { |b| b.frm.text_field(:id=>"additional") }
  element(:add_more_rosters) { |b| b.frm.select(:id=>"number")  }
  action(:back) { |b| b.frm.button(:name=>"Back").click }

end
  

# The Site Access Page that appears during Site creation
# immediately following the Add Multiple Tools Options page.
class SiteAccess < SiteSetupBase

  menu_elements
  expected_element :allow
  
  # The page element that displays the joiner role
  # select list. Use this method to validate whether the
  # select list is visible or not.
  #
  # Example: page.joiner_role_div.visible?
  element(:joiner_role_div) { |b| b.frm.div(:id=>"joinerrole") }

  button("Continue")
  
  element(:publish_site) { |b| b.frm.radio(:id=>"publish") }
  element(:leave_as_draft) { |b| b.frm.radio(:id=>"unpublish") }
  element(:limited) { |b| b.frm.radio(:id=>"unjoinable") }
  element(:allow) { |b| b.frm.radio(:id=>"joinable") }
  action(:back) { |b| b.frm.button(:name=>"eventSubmit_doBack").click }
  element(:joiner_role) { |b| b.frm.select(:id=>"joinerRole") }

end


# The Confirmation page at the end of a Course Site Setup
class ConfirmSiteSetup < BasePage

  frame_element

  button("Request Site")
  button("Create Site")
  
end

# The Course Site Information page that appears when creating a new Site
# immediately after the Course/Section Information page
class CourseSiteInfo < BasePage

  frame_element
  basic_page_elements
  include FCKEditor

  expected_element :editor

  element(:editor) { |b| b.frm.frame(:id=>"description___Frame") }

  def description=(text)
    editor.td(:id, "xEditingArea").frame(:index=>0).send_keys text
  end

  button("Continue")

  element(:short_description) { |b| b.frm.text_field(:id=>"short_description") }
  element(:special_instructions) { |b| b.frm.text_field(:id=>"additional") }
  element(:site_contact_name) { |b| b.frm.text_field(:id=>"siteContactName") }
  element(:site_contact_email) { |b| b.frm.text_field(:id=>"siteContactEmail") }

end
  

# 
class PortfolioSiteInfo < BasePage

  include FCKEditor
  frame_element

  expected_element :editor

  element(:editor) { |b| b.frm.frame(:id, "description___Frame") }

  def description=(text)
    editor.td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  button("Continue")

  element(:title) { |b| b.frm.text_field(:id=>"title") }
  element(:url_alias) { |b| b.frm.text_field(:id=>"alias_0") }
  element(:short_description) { |b| b.frm.text_field(:id=>"short_description") }
  element(:icon_url) { |b| b.frm.text_field(:id=>"iconUrl") }
  element(:site_contact_name) { |b| b.frm.text_field(:id=>"siteContactName") }
  element(:site_contact_email) { |b| b.frm.text_field(:id=>"siteContactEmail") }

end

# 
class PortfolioSiteTools < BasePage

  frame_element

  button("Continue")

  element(:all_tools) { |b| b.frm.checkbox(:id=>"all") }
  #TODO Add support for individual tool selection

end

# 
class PortfolioConfigureToolOptions < BasePage

  frame_element

  button("Continue")

  element(:email) { |b| b.frm.text_field(:id=>"emailId") }

end


