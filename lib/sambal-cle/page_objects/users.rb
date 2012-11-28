#================
# Users Pages - From the Workspace
#================

# The Page for editing User Account details
class EditUser < BasePage

  frame_element

  def update_details
    frm.button(:name=>"eventSubmit_doSave").click
    frm.link(:text=>"Search").wait_until_present
  end

  link "Remove User"
  element(:first_name) { |b| b.frm.text_field(:id=>"first-name") }
  element(:last_name) { |b| b.frm.text_field(:id=>"last-name") }
  element(:email) { |b| b.frm.text_field(:id=>"email") }
  element(:create_new_password) { |b| b.frm.text_field(:id=>"pw") }
  element(:verify_new_password) { |b| b.frm.text_field(:id=>"pw0") }
  action(:cancel_changes) { |b| b.frm.button(:name=>"eventSubmit_doCancel").click }

end

# The Users page - "icon-sakai-users"
class Users < BasePage

  frame_element

  link "New User"

  # Returns the contents of the Name cell
  # based on the specified user ID value.
  action(:name) { |user_id, b| b.frm.table(:class=>"listHier lines").row(:text=>/#{Regexp.escape(user_id)}/i)[1].text }

  # Returns the contents of the Email cell
  # based on the specified user ID value.
  action(:email) { |user_id, b| b.frm.table(:class=>"listHier lines").row(:text=>/#{Regexp.escape(user_id)}/i)[2].text }

  # Returns the contents of the Type cell
  # based on the specified user ID value.
  action(:type) { |user_id, b| b.frm.table(:class=>"listHier lines").row(:text=>/#{Regexp.escape(user_id)}/i)[3].text }

  action(:search_button) { |b| b.frm.link(:text=>"Search").click; b.frm.table(:class=>"listHier lines").wait_until_present }

  link "Clear Search"
  element(:search_field) { |b| b.frm.text_field(:id=>"search") }
  element(:select_page_size) { |b| b.frm.select_list(:name=>"selectPageSize") }
  action(:next) { |b| b.frm.button(:name=>"eventSubmit_doList_next").click }
  action(:last) { |b| b.frm.button(:name=>"eventSubmit_doList_last").click }
  action(:previous) { |b| b.frm.button(:name=>"eventSubmit_doList_prev").click }
  action(:first) { |b| b.frm.button(:name=>"eventSubmit_doList_first").click }

end


# The Create New User page
class CreateNewUser < BasePage

  frame_element

  action(:save_details) { |b| b.frm.button(:name=>"eventSubmit_doSave").click }

  element(:user_id) { |b| b.frm.text_field(:id=>"eid") }
  element(:first_name) { |b| b.frm.text_field(:id=>"first-name") }
  element(:last_name) { |b| b.frm.text_field(:id=>"last-name") }
  element(:email) { |b| b.frm.text_field(:id=>"email") }
  element(:create_new_password) { |b| b.frm.text_field(:id=>"pw") }
  element(:verify_new_password) { |b| b.frm.text_field(:id=>"pw0") }
  element(:type) { |b| b.frm.select_list(:name=>"type") }
  action(:cancel_changes) { |b| b.frm.button(:name=>"eventSubmit_doCancel").click }
end