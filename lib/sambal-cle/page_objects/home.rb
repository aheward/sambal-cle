# Topmost page for a Site in Sakai
class Home < BasePage

  action(:site_info_display_options) { |b| b.sid_frame.link(:text=>'Options').click }

  # Recent Announcements Options button
  action(:recent_announcements_options) { |b| b.ra_frame.link(:text=>'Options').click }

  # Link for New In Forums
  action(:new_in_forums) { |b| b.frame(:index=>2).link(:text=>'New Messages').click }

  action(:update_announcements) { |b| b.ra_frame.button(:name=>'eventSubmit_doUpdate').click }

  # Gets the text of the displayed announcements, for
  # test case verification
  def announcements_list
    list = []
    ra_frame.links.each { |link| list << link.text }
    list.delete_if { |item| item=='Options' } # Deletes the Options link if it's there.
    list
  end

  # ========
  private
  # ========

  element(:ra_frame) { |b| b.frame(title: 'Recent Announcements ') }
  element(:sid_frame) { |b| b.frame(title:'Site Information Display ') }
  element(:calendar_frame) { |b| b.frame(title: 'Calendar ') }
  element(:messages_frame) { |b| b.frame(title: 'Unread Messages and Forums ') }

end