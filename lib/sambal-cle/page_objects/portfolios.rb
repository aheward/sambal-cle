#================
# Portfolios pages
#================

#
class Portfolios < BasePage

  frame_element

  link "Create New Portfolio"

  def list
    list = []
    frm.table(:class=>"listHier ospTable").rows.each do |row|
      list << row[0].text
    end
    list.delete_at(0)
    return list
  end

  action(:shared) { |portfolio_name, b| b.frm.table(:class=>"listHier ospTable").row(:text=>/#{Regexp.escape(portfolio_name)}/)[5].text }

end

#
class AddPortfolio < BasePage

  frame_element

  button "Create"
  element(:name) { |b| b.frm.text_field(:name=>"presentationName") }
  element(:design_your_own_portfolio) { |b| b.frm.radio(:id=>"templateId-freeForm") }

end

#
class EditPortfolio < BasePage

  frame_element

  link("Add/Edit Content")
  link("Edit Title")
  link("Save Changes")
  element(:active) { |b| b.frm.radio(:id=>"btnActive") }
  element(:inactive) { |b| b.frm.radio(:id=>"btnInactive") }

end

#
class AddEditPortfolioContent < BasePage

  frame_element

  link "Add Page"
  link "Share with Others"
  button "Save Changes"

end

#
class AddEditPortfolioPage < BasePage

  frame_element
  cke_elements

  link 'Add Page'
  link 'Select Layout'
  link 'Select Style'

  ##TODO: Add rich_text_editor element for new content

  element(:title) { |b| b.frm.text_field(:id=>"_id1:title") }
  element(:description) { |b| b.frm.text_field(:id=>"_id1:description") }
  element(:keywords) { |b| b.frm.text_field(:id=>"_id1:keywords") }

end

#
class ManagePortfolioLayouts < BasePage

  frame_element

  action(:select) { |layout_name, b| b.frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(layout_name)}/).link(:text=>"Select").click }

  button "Go Back"

end

#
class SharePortfolio < BasePage

  frame_element

  link "Click here to share with others"
  link "Summary"

  element(:everyone_on_the_internet) { |b| b.frm.checkbox(:id=>"public_checkbox") }

end

#
class AddPeopleToShare < BasePage

  frame_element

end