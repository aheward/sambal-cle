class Forums < BasePage

  frame_element

  # Pass this method a string that matches
  # the title of a Forum on the page, it returns
  # True if the specified forum row has "DRAFT" in it.
  def draft?(title)
    frm.table(:id=>"msgForum:forums").row(:text=>/#{Regexp.escape(title)}/).span(:text=>"DRAFT").exist?
  end

  action(:new_forum) { |b| b.frm.link(:text=>"New Forum").click }

  # AddEditTopic
  def new_topic_for_forum(name)
    index = forum_titles.index(name)
    frm.link(:text=>"New Topic", :index=>index).click
  end

  # OrganizeForums
  link "Organize"

  # ForumTemplateSettings
  link "Template Settings"

  element(:forums_table) { |b| b.frm.div(:class=>"portletBody").table(:id=>"msgForum:forums") }

  def forum_titles
    titles = []
    title_links = frm.div(:class=>"portletBody").links.find_all { |link| link.class_name=="title" && link.id=="" }
    title_links.each { |link| titles << link.text }
    return titles
  end

  def topic_titles
    titles = []
    title_links = frm.div(:class=>"portletBody").links.find_all { |link| link.class_name == "title" && link.id != "" }
    title_links.each { |link| titles << link.text }
    return titles
  end

  # EditForum
  def forum_settings(name)
    index = forum_titles.index(name)
    frm.link(:text=>"Forum Settings", :index=>index).click
  end

  # AddEditTopic
  def topic_settings(name)
    index = topic_titles.index(name)
    frm.link(:text=>"Topic Settings", :index=>index).click
  end

  # EditForum
  def delete_forum(name)
    index = forum_titles.index(name)
    frm.link(:id=>/msgForum:forums:\d+:delete/,:text=>"Delete", :index=>index).click
  end

  # AddEditTopic
  def delete_topic(name)
    index = topic_titles.index(name)
    frm.link(:id=>/topics:\d+:delete_confirm/, :text=>"Delete", :index=>index).click
  end

  def open_forum(title)
    frm.link(:text=>/#{title}/).wait_until_present(7)
    frm.link(:text=>/#{title}/).click
  end
  alias open_topic open_forum

end

class TopicPage < BasePage

  frame_element

  # ComposeForumMessage
  link "Post New Thread"

  def thread_titles
    titles = []
    message_table = frm.table(:id=>"msgForum:messagesInHierDataTable")
    1.upto(message_table.rows.size-1) do |x|
      titles << message_table[x][1].span(:class=>"firstChild").link(:index=>0).text
    end
    return titles
  end

  # ViewForumThread
  def open_message(message_title)
    frm.div(:class=>"portletBody").link(:text=>message_title).click
  end

  # TopicPage
  link "Display Entire Message"

end

class ViewForumThread < BasePage

  frame_element

  # ComposeForumMessage
  link "Reply to Thread"

  # ComposeForumMessage
  # TODO: Figure out a better way to do this...
  def reply_to_message(index)
    frm.link(:text=>"Reply", :index=>(index.to_i - 1)).click
  end
end

class ComposeForumMessage < BasePage

  frame_element
  cke_elements

  expected_element :editor

  # TopicPage, probably
  button "Post Message"

  def message=(text)
    rich_text_field.send_keys(text)
  end

  value(:reply_text) { |b| b.frame(:index=>1).div(:class=>"singleMessageReply").text }

  button "Cancel"

  element(:title) { |b| b.frm.text_field(:id=>"dfCompose:df_compose_title") }

end

class ForumTemplateSettings < BasePage

  frame_element
  basic_page_elements

  value(:page_title) { |b| b.frm.div(:class=>"portletBody").h3(:index=>0).text }

end

class OrganizeForums < BasePage

  frame_element
  basic_page_elements

  # These are set to so that the user
  # does not have to start the list at zero...
  # TODO: Is there any chance there's a better way to do this? It's friggin' ugly!
  def forum(index)
    frm.select(:id, "revise:forums:#{index.to_i - 1}:forumIndex")
  end

  def topic(forumindex, topicindex)
    frm.select(:id, "revise:forums:#{forumindex.to_i - 1}:topics:#{topicindex.to_i - 1}:topicIndex")
  end
end

class EditForum < BasePage

  frame_element
  basic_page_elements
  cke_elements

  # AddEditTopic
  action(:save_and_add) { |b| b.frm.button(:value=>"Save Settings & Add Topic").click }

  def description=(text)
    rich_text_field.send_keys(text)
  end

  #ForumsAddAttachments (or not, actually, now that I think of it)
  action(:add_attachments) { |b| b.frm.button(:value=>/attachments/).click }

  element(:title){ |b| b.frm.text_field(:id=>"revise:forum_title") }
  element(:short_description){ |b| b.frm.text_field(:id=>"revise:forum_shortDescription") }

end

class AddEditTopic < BasePage

  frame_element
  basic_page_elements
  cke_elements

  @@table_index=0 # TODO: Seriously think about a better way to do this

  def description=(text)
    rich_text_field.send_keys(text)
  end

  action(:add_attachments) { |b| b.frm.button(:value=>/Add.+ttachment/).click }

  def roles
    roles=[]
    options = frm.select(:id=>"revise:role").options.to_a
    options.each { |option| roles << option.text }
    return roles
  end

  def site_role=(role)
    frm.select(:id=>"revise:role").select(role)
    0.upto(frm.select(:id=>"revise:role").length - 1) do |x|
      if frm.div(:class=>"portletBody").table(:class=>"permissionPanel jsfFormTable lines nolines", :index=>x).visible?
        @@table_index = x

        def permission_level=(value)
          frm.select(:id=>"revise:perm:#{@@table_index}:level").select(value)
        end

      end
    end
  end

  element(:title) { |b| b.frm.text_field(:id=>"revise:topic_title") }
  element(:short_description) { |b| b.frm.text_field(:id=>"revise:topic_shortDescription") }

end

class ForumView < BasePage

  frame_element

  action(:view_full_description) { |b| b.frm.link(id: "msgForum:forum_extended_show").click }
  action(:hide_full_description) { |b| b.frm.link(id: "msgForum:forum_extended_hide").click }

  value(:short_description) { |b| b.frm.span(class: "shortDescription").text }
  value(:description_html) { |b| b.frm.div(class: "toggle").div(class: "textPanel").html }

end