# The Announcements list page for a Site.
class Announcements < BasePage

  frame_element

  # Clicks the add button, goes to the AddEditAnnouncements class.
  action(:add) { |b| b.frm.div(:class=>"portletBody").link(:title=>"Add").click }

  # Edits the specified announcement in the list.
  # @param subject [String] the text of the announcement listing link.
  action(:edit) { |subject, b| b.frm.table(:class=>"listHier").row(:text=>/#{Regexp.escape(subject)}/).link(:text=>"Edit").click }

  action(:view) { |title, b| b.frm.link(:text=>title).click }

  # Returns an array of the subject strings of the announcements
  # listed on the page.
  def subjects
    links = frm.table(:class=>"listHier").links.find_all { |link| link.title=~/View announcement/ }
    subjects = []
    links.each { |link| subjects << link.text }
    return subjects
  end

  action(:href) { |subject, b| b.frm.link(:text=>subject).href }

  # Returns true or false depending on whether the specified announcement has an attachment.
  # @param subject [String] the text of the announcement listing link.
  def has_attachment?(subject)
    if frm.table(:class=>"listHier").row(:text=>/#{Regexp.escape(subject)}/).exist?
      return frm.table(:class=>"listHier").row(:text=>/#{Regexp.escape(subject)}/).image(:alt=>"attachment").exist?
    else
      puts "Can't find your target row. Your test is faulty."
      return false
    end
  end

  # Returns the text of the "For" column for
  # the specified announcement.
  # @param subject [String] the text of the announcement listing link.
  action(:for_column) { |subject, b| b.frm.table(:class=>"listHier").row(:text=>/#{Regexp.escape(subject)}/)[4].text }

  # Clicks the specified announcement link and instantiates the PreviewAnnouncements class.
  # @param subject [String] the text of the announcement listing link.
  action(:preview_announcement) { |subject, b| b.frm.link(:text=>subject).click }

  # Selects the specified list item from the View selection list.
  # @param list_item [String] the text of the option in the selection list.
  def view=(list_item)
    frm.select(:id=>"view").set(list_item)
  end

  # Clicks the Merge link and goes to the AnnouncementsMerge class.
  link("Merge")

end

# Show Announcements from Another Site. On this page you select what announcements
# you want to merge into the current Site.
class AnnouncementsMerge < BasePage

  frame_element
  basic_page_elements

  # Checks the checkbox for the specified site name
  # @param site_name [String] the name of the relevant site displayed in the table
  action(:check) { |site_name, b| b.frm.table(:class=>'listHier lines nolines').row(:text=>/#{Regexp.escape(site_name)}/).checkbox(:id=>/site/).set }

end

# This Class does double-duty. It's for the Preview page when editing an
# Announcement, plus for when you just click an Announcement to view it.
class ViewAnnouncement < BasePage

  frame_element

  # Clicks the Return to list button and goes to the Announcements class.
  button('Return to List')

  # Clicks the Save changes button and goes to the Announcements class.
  button('Save Changes')

  # Clicks the Edit button and goes to the AddEditAnnouncements class.
  button('Edit')

  value(:subject) { |b| b.frm.table(class: 'itemSummary')[0][1].text }
  value(:saved_by) { |b| b.frm.table(class: 'itemSummary')[1][1].text }
  value(:date) { |b| b.frm.table(class: 'itemSummary')[2][1].text }
  value(:groups) { |b| b.frm.table(class: 'itemSummary')[3][1].text }
  value(:message) { |b| b.frm.div(class: 'portletBody').p.text }
  value(:message_html) { |b| b.frm.div(class: 'portletBody').p.html }

end

# The page where an announcement is created or edited.
class AddEditAnnouncements < BasePage

  frame_element
  cke_elements

  action(:body=) { |text, b| b.rich_text_field('body').send_keys text }

  expected_element :editor

  # Clicks the Add Announcement button. The next class is either
  # AddEditAnnouncements or Announcements.
  button 'Post Announcement'

  # Clicks the Save changes button. Next is the Announcements class.
  button 'Save Changes'

  # Clicks the Preview button. Next is the PreviewAnnouncements class.
  button 'Preview'

  # Clicks the Add attachments button. Next is the Announcements Attach class.
  button 'Add Attachments'

  # Clicks the checkbox for the specified group name
  # when you've set the announcement access to display
  # to groups.
  # @param group_name [String] the name of the group in the table that you intend to select.
  action(:check_group) { |group_name, b| b.frm.table(:id=>'groupTable').row(:text=>/#{Regexp.escape(group_name)}/).checkbox(:name=>'selectedGroups').set }

  element(:title) { |b| b.frm.text_field(:id=>'subject') }
  element(:site_members) { |b| b.frm.radio(:id=>'site') }
  element(:publicly_viewable) { |b| b.frm.radio(:id=>'pubview') }
  element(:groups) { |b| b.frm.radio(:id=>'groups') }
  element(:show) { |b| b.frm.radio(:id=>'hidden_false') }
  element(:hide) { |b| b.frm.radio(:id=>'hidden_true') }
  element(:specify_dates) { |b| b.frm.radio(:id=>'hidden_specify') }
  element(:beginning) { |b| b.frm.checkbox(:id=>'use_start_date') }
  element(:ending) { |b| b.frm.checkbox(:id=>'use_end_date') }
  element(:all) { |b| b.frm.checkbox(:id=>'selectall') }

  element(:beginning_month) { |b| b.frm.select(:id=>'release_month') }

  # Sets the Beginning Day selection to the
  # specified string.
  element(:beginning_day) { |b| b.frm.select(:id=>'release_day') }
  element(:beginning_year) { |b| b.frm.select(:id=>'release_year') }
  element(:beginning_hour) { |b| b.frm.select(:id=>'release_hour') }
  element(:beginning_minute) { |b| b.frm.select(:id=>'release_minute') }
  element(:beginning_meridian) { |b| b.frm.select(:id=>'release_ampm') }
  element(:ending_month) { |b| b.frm.select(:id=>'retract_month') }
  element(:ending_day) { |b| b.frm.select(:id=>'retract_day') }
  element(:ending_year) { |b| b.frm.select(:id=>'retract_year') }
  element(:ending_hour) { |b| b.frm.select(:id=>'retract_hour') }
  element(:ending_minute) { |b| b.frm.select(:id=>'retract_minute') }
  element(:ending_meridian) { |b| b.frm.select(:id=>'retract_ampm') }

  value(:alert_box) { |b| b.frm.div(:class=>'alertMessage').text }

end

# Page for setting up options for announcements
class AnnouncementsOptions < BasePage

  frame_element

end

# Page containing permissions options for announcements
class AnnouncementsPermissions < BasePage

  frame_element

end