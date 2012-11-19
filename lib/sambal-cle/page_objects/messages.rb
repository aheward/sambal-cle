class Messages < BasePage

  frame_element

  value(:header) { |b| b.frm.div(:class=>"breadCrumb specialLink").text }
  value(:alert_message_text) { |b| b.frm.span(:class=>"success").text }
  action(:compose_message) { |b| b.frm.link(:text=>"Compose Message").click }
  action(:messages) { |b| b.frm.link(:text=>"Messages").click }
  action(:open_message) { |subject, b| b.frm.link(:text, /#{Regexp.escape(subject)}/).click }
  action(:check_message) { |subject, b|
    index=subjects.index(subject)
    b.frm.checkbox(:name=>"prefs_pvt_form:pvtmsgs:#{index}:_id122").set }
  action(:mark_read) { |b| b.frm.link(:text=>"Mark Read").click }
  element(:view) { |b| b.frm.select(:id=>"prefs_pvt_form:viewlist") }
  action(:check_all) { |b| b.frm.link(:text=>"Check All").click }
  action(:delete) { |b| b.frm.link(:text=>"Delete").click }
  action(:move) { |b| b.frm.link(:text, "Move").click }

  # Creates an array consisting of the
  # message subject lines.
  def subjects
    titles = []
    messages = frm.table(:id=>"prefs_pvt_form:pvtmsgs")
    1.upto(messages.rows.size-1) do |x|
      titles << messages.row(:index=>x).a.title
    end
    return titles
  end

  def unread_messages
    # TODO - Write this method
  end

end

class MessageFolders < BasePage

  frame_element

  action(:received) { |b| b.frm.link(:text=>"Received").click }
  action(:sent) { |b| b.frm.link(:text=>"Sent").click }
  action(:deleted) { |b| b.frm.link(:text=>"Deleted").click }
  action(:draft) { |b| b.frm.link(:text=>"Draft").click }
  action(:open_folder) { |foldername, b| b.frm.link(:text=>foldername).click }
  action(:new_folder) { |b| b.frm.link(:text=>"New Folder").click }
  action(:settings) { |b| b.frm.link(:text=>"Settings").click }

  # Gets the count of messages
  # in the specified folder
  # and returns it as a string
  action(:total_messages_in_folder) { |folder_name, b| b.frm.table(:id=>"msgForum:_id23:0:privateForums").row(:text=>/#{Regexp.escape(folder_name)}/).span(:class=>"textPanelFooter", :index=>0).text =~ /\d+/; return $~.to_s }

  # Gets the count of unread messages
  # in the specified folder and returns it
  # as a string
  action(:unread_messages_in_folder) { |folder_name, b| b.frm.table(:id=>"msgForum:_id23:0:privateForums").row(:text=>/#{Regexp.escape(folder_name)}/).span(:text=>/unread/).text =~ /\d+/; return $~.to_s }

  # Gets all the folder names
  def folders
    links = frm.table(:class=>"hierItemBlockWrapper").links.find_all { |link| link.title != /Folder Settings/ }
    folders = []
    links.each { |link| folders << link.text }
    return folders
  end

  action(:folder_settings) { |folder_name, b| b.frm.table(:class=>"hierItemBlockWrapper").row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Folder Settings").click }

end

# Page that appears when you want to move a message
# from one folder to another.
class MoveMessageTo < BasePage

  frame_element

  action(:move_messages) { |b| b.frm.button(:value=>"Move Messages").click }

  # Method for selecting any custom folders
  # present on the screen--and *only* the custom
  # folders. Count begins with "1" for the first custom
  # folder listed.
  action(:select_custom_folder_num) { |num, b| b.frm.radio(:index=>num.to_i+3).set }

  element(:received) { |b| b.frm.radio(:name=>"pvtMsgMove:_id16:0:privateForums:0:_id19") }
  element(:sent) { |b| b.frm.radio(:name=>"pvtMsgMove:_id16:0:privateForums:1:_id19") }
  element(:deleted) { |b| b.frm.radio(:name=>"pvtMsgMove:_id16:0:privateForums:2:_id19") }
  element(:draft) { |b| b.frm.radio(:name=>"pvtMsgMove:_id16:0:privateForums:3:_id19") }

end

# The Page where you are reading a Message.
class MessageView < BasePage

  frame_element

  # Returns the contents of the message body.
  value(:message_text) { |b| b.frm.div(:class=>"textPanel").text }

  action(:reply) { |b| b.frm.button(:value=>"Reply").click }

  action(:forward) { |b| b.frm.button(:value=>"Forward ").click }

  action(:received) { |b| b.frm.link(:text=>"Received").click }

  # Clicks the "Messages" breadcrumb link to return
  # to the top level of Messages. Then instantiates
  # the Messages class.
  action(:messages) { |b| b.frm.link(:text=>"Messages").click }

end

class ComposeMessage < BasePage

  include FCKEditor
  frame_element
  expected_element :editor

  element(:editor) { |b| b.frm.frame(:id, "compose:pvt_message_body_inputRichText___Frame") }
  action(:send) { |b| b.frm.button(:value=>"Send ").click }

  def message_text=(text)
    editor.td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  action(:add_attachments) { |b| b.frm.button(:value=>"Add attachments").click }

  action(:preview) { |b| b.frm.button(:value=>"Preview").click }

  action(:save_draft) {|b| b.frm.button(:value=>"Save Draft").click }
  element(:send_to) { |b| b.frm.select(:id=>"compose:list1") }
  element(:send_cc) { |b| b.frm.checkbox(:id=>"compose:send_email_out") }
  element(:subject) { |b| b.frm.text_field(:id=>"compose:subject") }

end

class ReplyToMessage < BasePage
  include FCKEditor
  frame_element

  expected_element :editor

  element(:editor) { |b| b.frm.frame(:id, "pvtMsgReply:df_compose_body_inputRichText___Frame") }
  action(:send) { |b| b.frm.button(:value=>"Send ").click }

  def message_text=(text)
    editor.td(:id, "xEditingArea").frame(:index=>0).send_keys(:home)
    editor.td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  action(:add_attachments) { |b| b.frm.button(:value=>"Add attachments").click }

  action(:preview) { |b| b.frm.button(:value=>"Preview").click }

  action(:save_draft) {|b| b.frm.button(:value=>"Save Draft").click }
  element(:select_additional_recipients) { |b| b.frm.select(:id=>"compose:list1") }
  element(:send_cc) { |b| b.frm.checkbox(:id=>"compose:send_email_out") }
  element(:subject) { |b| b.frm.text_field(:id=>"compose:subject") }

end

# The page for composing a message
class ForwardMessage < BasePage
  include FCKEditor
  frame_element

  expected_element :editor

  element(:editor) { |b| b.frm.frame(:id, "pvtMsgForward:df_compose_body_inputRichText___Frame") }
  action(:send) { |b| b.frm.button(:value=>"Send ").click }

  def message_text=(text)
    editor.td(:id, "xEditingArea").frame(:index=>0).send_keys(:home)
    editor.td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  action(:add_attachments) { |b| b.frm.button(:value=>"Add attachments").click }

  action(:preview) { |b| b.frm.button(:value=>"Preview").click }

  action(:save_draft) {|b| b.frm.button(:value=>"Save Draft").click }
  element(:select_forward_recipients) { |b| b.frm.select(:id=>"pvtMsgForward:list1") }
  element(:send_cc) { |b| b.frm.checkbox(:id=>"compose:send_email_out") }
  element(:subject) { |b| b.frm.text_field(:id=>"compose:subject") }

end

# The page that appears when you select to
# Delete a message that is already inside
# the Deleted folder.
class MessageDeleteConfirmation < BasePage

  frame_element

  value(:alert_message_text) { |b| b.frm.span(:class=>"alertMessage").text }

  action(:delete_messages) { |b| b.frm.button(:value=>"Delete Message(s)").click }

  #FIXME
  # Want eventually to have a method that will return
  # an array of Message subjects
end

# The page for creating a new folder for Messages
class MessagesNewFolder < BasePage

  frame_element

  action(:add) { |b| b.frm.button(:value=>"Add").click }

  element(:title) { |b| b.frm.text_field(:id=>"pvtMsgFolderAdd:title") }

end

# The page for editing a Message Folder's settings
class MessageFolderSettings < BasePage

  frame_element

  action(:rename_folder) { |b| b.frm.button(:value=>"Rename Folder").click }

  action(:add) { |b| b.frm.button(:value=>"Add").click }

  action(:delete) { |b| b.frm.button(:value=>"Delete").click }

end

# Page that confirms you want to delete the custom messages folder.
class FolderDeleteConfirm < BasePage

  frame_element

  action(:delete) { |b| b.frm.button(:value=>"Delete").click }

end
