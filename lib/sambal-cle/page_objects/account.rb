#================
# User's Account Page - in "My Settings"
#================

# The Page for editing User Account details
class EditAccount < UsersBase

  user_fields

  element(:current_password) { |b| b.frm.text_field(:id=>"pwcur") }

end

# A Non-Admin User's Account page
class UserAccount < BasePage

  frame_element

  # Clicks the Modify Details button. Instantiates the EditAccount class.
  action(:modify_details) {|b| b.frm.button(:name=>"eventSubmit_doModify").click }

  # Gets the text of the User ID field.
  value(:user_id) { |b| b.frm.table(:class=>"itemSummary", :index=>0)[0][1].text }

  # Gets the text of the First Name field.
  value(:first_name) {|b| b.frm.table(:class=>"itemSummary", :index=>0)[1][1].text }

  # Gets the text of the Last Name field.
  value(:last_name) {|b| b.frm.table(:class=>"itemSummary", :index=>0)[2][1].text }

  # Gets the text of the Email field.
  value(:email) {|b| b.frm.table(:class=>"itemSummary", :index=>0)[3][1].text }

  # Gets the text of the Type field.
  value(:type) {|b| b.frm.table(:class=>"itemSummary", :index=>0)[4][1].text }

  # Gets the text of the Created By field.
  value(:created_by) {|b| b.frm.table(:class=>"itemSummary", :index=>1)[0][1].text }

  # Gets the text of the Created field.
  value(:created) {|b| b.frm.table(:class=>"itemSummary", :index=>1)[1][1].text }

  # Gets the text of the Modified By field.
  value(:modified_by) {|b| b.frm.table(:class=>"itemSummary", :index=>1)[2][1].text }

  # Gets the text of the Modified (date) field.
  value(:modified) {|b| b.frm.table(:class=>"itemSummary", :index=>1)[3][1].text }

end