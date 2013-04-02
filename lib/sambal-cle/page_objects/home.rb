# Topmost page for a Site in Sakai
class Home < BasePage

  action(:site_info_display_options) { |b| b.frame(:index=>0).link(:text=>'Options').click }

  # Recent Announcements Options button
  action(:recent_announcements_options) { |b| b.frame(:index=>1).link(:text=>'Options').click }

  # Link for New In Forums
  action(:new_in_forums) { |b| b.frame(:index=>2).link(:text=>'New Messages').click }

  element(:number_of_announcements) { |b| b.frame(:index=>1).text_field(:id=>'itemsEntryField') }
  action(:update_announcements) { |b| b.frame(:index=>1).button(:name=>'eventSubmit_doUpdate').click }

  # Gets the text of the displayed announcements, for
  # test case verification
  def announcements_list
    list = []
    links = @browser.frame(:index=>2).links
    links.each { |link| list << link.text }
    list.delete_if { |item| item=='Options' } # Deletes the Options link if it's there.
    return list
  end

end