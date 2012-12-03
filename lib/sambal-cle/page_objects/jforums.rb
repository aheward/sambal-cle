#================
# Discussion Forums Pages
#================

class JForumsBase < BasePage

  frame_element

  class << self
    def forums_page_elements
      action(:discussion_home) { |b| b.frm.link(:id=>"backtosite").click }
      action(:search) { |b| b.frm.link(:id=>"search", :class=>"mainmenu").click }
      action(:my_bookmarks) { |b| b.frm.link(:class=>"mainmenu", :text=>"My Bookmarks").click }
      action(:my_profile) { |b| b.frm.link(:id=>"myprofile").click }
      action(:member_listing) { |b| b.frm.link(:text=>"Member Listing", :id=>"latest", :class=>"mainmenu").click }
      action(:private_messages) { |b| b.frm.link(:id=>"privatemessages", :class=>"mainmenu").click }
      action(:manage) { |b| b.frm.link(:id=>"adminpanel", :text=>"Manage").click }
      action(:submit) { |b| b.frm.button(:value=>"Submit").click }
    end
  end
end

# The topmost page in Discussion Forums
class JForums < JForumsBase

  forums_page_elements

  # Clicks on the supplied forum name
  action(:open_forum) { |forum_name,b| b.frm.link(:text=>forum_name).click }

  # Clicks the specified Topic and instantiates
  # the ViewTopic Class.
  action(:open_topic) { |topic_title,b| b.frm.link(:text=>topic_title).click }

  # Returns an array containing the names of the Forums listed on the page.
  def forum_list
    list = frm.table(:class=>"forumline").links.map do |link|
      if link.href =~ /forums\/show\//
        link.text
      end
    end
    list.compact!
    return list
  end

  # Returns the displayed count of topics for the specified
  # Forum.
  def topic_count(forum_name)
    frm.table(:class=>"forumline").row(:text=>/#{Regexp.escape(forum_name)}/)[2].text
  end

end

# The page of a particular Discussion Forum, show the list
# of Topics in the forum.
class DiscussionForum < JForumsBase

  forums_page_elements

  # Clicks the New Topic button,
  # then instantiates the NewTopic class
  def new_topic
    frm.image(:alt=>"New Topic").fire_event("onclick")
    frm.frame(:id, "message___Frame").td(:id, "xEditingArea").wait_until_present
  end
  # Clicks the specified Topic Title, then
  # instantiates the ViewTopic Class.
  def open_topic(topic_title)
    frm.link(:href=>/posts.list/, :text=>topic_title).click
  end

end

# The Discussion Forums Search page.
class DiscussionSearch < JForumsBase

  forums_page_elements

  # Clicks the Search button on the page,
  # then instantiates the JForums class.
  def click_search
    frm.button(:value=>"Search").click
  end

  element(:keywords) { |b| b.frm.text_field(:name=>"search_keywords") }

end

# The Manage Discussions page in Discussion Forums.
class ManageDiscussions < JForumsBase

  forums_page_elements

  # Clicks the Manage Forums link,
  # then instantiates the ManageForums Class.
  def manage_forums
    frm.link(:text=>"Manage Forums").click
  end

  # Creates and returns an array of forum titles
  # which can be used for verification
  def forum_titles
    forum_titles = []
    forum_links = frm.links.find_all { |link| link.id=="forumEdit"}
    forum_links.each { |link| forum_titles << link.text }
    return forum_titles
  end

end

# The page for Managing Forums in the Discussion Forums
# feature.
class ManageForums < JForumsBase

  forums_page_elements

  # Clicks the Add button
  action(:add) { |b| b.frm.button(:value=>"Add").click }

  # Clicks the Update button
  action(:update){ |b| b.frm.button(:value=>"Update").click }

  element(:forum_name) { |b| b.frm.text_field(:name=>"forum_name") }
  element(:category) { |b| b.frm.select(:id=>"categories_id") }
  element(:description) { |b| b.frm.text_field(:name=>"description") }

end

# Page for editing/creating Bookmarks in Discussion Forums.
class MyBookmarks < JForumsBase

  forums_page_elements


end

# The page for adding a new discussion topic.
class NewTopic < JForumsBase

  include FCKEditor
  forums_page_elements

  # Enters the specified string into the FCKEditor for the Message.
  def message_text=(text)
    frm.frame(:id, "message___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(:home)
    frm.frame(:id, "message___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  # Clicks the Preview button and instantiates the PreviewDiscussionTopic Class.
  button "Preview"

  #TODO: redefine the file fields

  element(:subject) { |b| b.frm.text_field(:id=>"subject") }
  button "Attach Files"
  button "Add another file"

end

# Viewing a Topic/Message
class ViewTopic < JForumsBase

  forums_page_elements

  # Gets the text of the Topic title.
  # Useful for verification.
  value(:topic_name) { |b| b.frm.link(:id=>"top", :class=>"maintitle").text }

  # Gets the message text for the specified message (not zero-based).
  # Useful for verification.
  def message_text(message_number)
    frm.span(:class=>"postbody", :index=>message_number.to_i-1).text
  end

  # Clicks the Post Reply button, then
  # instantiates the NewTopic Class.
  action(:post_reply) { |b| b.frm.image(:alt=>"Post Reply").fire_event("onclick") }

  # Clicks the Quick Reply button
  # and does not instantiate any page classes.
  action(:quick_reply) { |b| b.frm.image(:alt=>"Quick Reply").fire_event("onclick") }

  element(:reply_text) { |b| b.frm.text_field(:name=>"quickmessage") }

end

# The Profile page for Discussion Forums
class DiscussionsMyProfile < JForumsBase

  forums_page_elements

  # Gets the text at the top of the table.
  # Useful for verification.
  value(:header_text) { |b| b.frm.table(:class=>"forumline").span(:class=>"gens").text }

  # Enters the specified filename in the file field.
  #
  # The method takes the filepath as an optional second parameter.
  def avatar(filename, filepath="")
    frm.file_field(:name=>"avatar").set(filepath + filename)
  end

  element(:icq_uin) { |b| b.frm.text_field(:name=>"icq") }
  element(:aim) { |b| b.frm.text_field(:name=>"aim") }
  element(:web_site) { |b| b.frm.text_field(:name=>"website") }
  element(:occupation) { |b| b.frm.text_field(:name=>"occupation") }
  element(:view_email) { |b| b.radio(:name=>"viewemail") }

end

# The List of Members of a Site's Discussion Forums
class DiscussionMemberListing < JForumsBase

  forums_page_elements

  # Checks if the specified Member name appears
  # in the member listing.
  def name_present?(name)
    member_links = frm.links.find_all { |link| link.href=~/user.profile/ }
    member_names = []
    member_links.each { |link| member_names << link.text }
    member_names.include?(name)
  end

end

# The page where users go to read their private messages in the Discussion
# Forums.
class PrivateMessages < JForumsBase

  forums_page_elements

  # Clicks the "New PM" button, then
  # instantiates the NewPrivateMessage Class.
  action(:new_pm) { |b| b.frm.image(:alt=>"New PM").fire_event("onclick") }

  # Clicks to open the specified message,
  # then instantiates the ViewPM Class.
  action(:open_message) { |title, b| b.frm.link(:class=>"topictitle", :text=>title).click }

  # Collects all subject text strings of the listed
  # private messages and returns them in an Array.
  def pm_subjects
    anchor_objects = frm.links.find_all { |link| link.href=~/pm.read.+page/ }
    subjects = []
    anchor_objects.each { |link| subjects << link.text }
    return subjects
  end

end

# The page of Viewing a particular Private Message.
class ViewPM < BasePage

  frame_element

  # Clicks the Reply Quote button, then
  # instantiates the NewPrivateMessage Class.
  action(:reply_quote) { |b| b.frm.image(:alt=>"Reply Quote").fire_event("onclick") }

end

# New Private Message page in Discussion Forums.
class NewPrivateMessage < JForumsBase

  forums_page_elements

  # Enters text into the FCKEditor text area, after
  # going to the beginning of any existing text in the field.
  def message_body=(text)
    frm.frame(:id, "message___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(:home)
    frm.frame(:id, "message___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  # Enters the specified filename in the file field.
  def filename1(filename) #FIXME!
    frm.file_field(:name=>"file_0").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle-test-api/" + filename)
  end

  # Enters the specified filename in the file field.
  #
  # Note that the file should be inside the data/sakai-cle-test-api folder.
  # The file or folder name used for the filename variable
  # should not include a preceding / character.
  def filename2(filename) # FIXME!
    frm.file_field(:name=>"file_1").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle-test-api/" + filename)
  end

  element(:to_user) { |b| b.frm.select(:name=>"toUsername") }
  element(:subject) { |b| b.frm.text_field(:id=>"subject") }
  action(:attach_files) { |b| b.frm.button(:value=>"Attach Files").click }
  action(:add_another_file) { |b| b.frm.button(:value=>"Add another file").click }


end

# The page that appears when you've done something in discussions, like
# sent a Private Message.
class Information < JForumsBase

  forums_page_elements

  # Gets the information message on the page.
  # Useful for verification.
  value(:information_text) { |b| b.frm.table(:class=>"forumline").span(:class=>"gen").text }

end