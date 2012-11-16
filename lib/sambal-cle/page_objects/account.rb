#================
# User's Account Page - in "My Settings"
#================

# The Page for editing User Account details
class EditAccount < BasePage

  frame_element

  action(:update_details) {|b| b.frm.button(:value=>"Update Details").click }

  element(:first_name) { |b| b.frm.text_field(:id=>"first-name") }
  element(:last_name) { |b| b.frm.text_field(:id=>"last-name") }
  element(:email) { |b| b.frm.text_field(:id=>"email") }
  element(:current_password) { |b| b.frm.text_field(:id=>"pwcur") }
  element(:create_new_password) { |b| b.frm.text_field(:id=>"pw") }
  element(:verify_new_password) { |b| b.frm.text_field(:id=>"pw0") }

end

# A Non-Admin User's Account page
class UserAccount < BasePage

  def frm
    self.frame(:index=>0) #TODO: Test that this really is needed instead of the frame_element
  end

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