#================
# Users Pages - From the Workspace
#================

class UsersBase < BasePage

  frame_element

  class << self

    def user_fields
      action(:save) { |b| b.frm.button(:name=>'eventSubmit_doSave').click }
      alias_method :update, :save
      element(:user_id) { |b| b.frm.text_field(:id=>'eid') }
      element(:first_name) { |b| b.frm.text_field(:id=>'first-name') }
      element(:last_name) { |b| b.frm.text_field(:id=>'last-name') }
      element(:email) { |b| b.frm.text_field(:id=>'email') }
      element(:create_new_password) { |b| b.frm.text_field(:id=>'pw') }
      element(:verify_new_password) { |b| b.frm.text_field(:id=>'pw0') }
      element(:type) { |b| b.frm.select(:name=>'type') }
      action(:cancel) { |b| b.frm.button(:name=>'eventSubmit_doCancel').click }
    end

  end
end

# The Users page - 'icon-sakai-users'
class UsersList < UsersBase

  link 'New User'

  # Returns the contents of the Name cell
  # based on the specified user ID value.
  action(:name) { |user_id, b| b.users_table.row(:text=>/#{Regexp.escape(user_id)}/i)[1].text }

  # Returns the contents of the Email cell
  # based on the specified user ID value.
  action(:email) { |user_id, b| b.users_table.row(:text=>/#{Regexp.escape(user_id)}/i)[2].text }

  # Returns the contents of the Type cell
  # based on the specified user ID value.
  action(:type) { |user_id, b| b.users_table.row(:text=>/#{Regexp.escape(user_id)}/i)[3].text }

  action(:search_button) { |b| b.frm.link(:text=>'Search').click; b.users_table.wait_until_present }

  link 'Clear Search'
  element(:search_field) { |b| b.frm.text_field(:id=>'search') }
  element(:select_page_size) { |b| b.frm.select(:name=>'selectPageSize') }
  action(:next) { |b| b.frm.button(:name=>'eventSubmit_doList_next').click }
  action(:last) { |b| b.frm.button(:name=>'eventSubmit_doList_last').click }
  action(:previous) { |b| b.frm.button(:name=>'eventSubmit_doList_prev').click }
  action(:first) { |b| b.frm.button(:name=>'eventSubmit_doList_first').click }

  # =========
  private
  # =========

  element(:users_table) { |b| b.frm.table(:class=>'listHier lines') }

end

# The Page for editing User Account details
class AccountDetails < UsersBase

  user_fields

  link 'Remove User'

end

# The Create New User page
class CreateNewUser < UsersBase

  user_fields

end