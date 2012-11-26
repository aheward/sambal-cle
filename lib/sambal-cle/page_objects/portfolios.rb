#================
# Portfolios pages
#================

#
class Portfolios < BasePage

  frame_element

  action(:create_new_portfolio) { |b| b.frm.link(:text=>"Create New Portfolio").click }

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

  action(:create) { |b| b.frm.button(:value=>"Create").click }


  element(:name) { |b| b.frm.text_field(:name=>"presentationName") }
  element(:design_your_own_portfolio) { |b| b.frm.radio(:id=>"templateId-freeForm") }

end

#
class EditPortfolio < BasePage

  frame_element

  action(:add_edit_content) { |b| b.frm.link(:text=>"Add/Edit Content").click }
  action(:edit_title) { |b| b.frm.link(:text=>"Edit Title").click }
  action(:save_changes) { |b| b.frm.link(:text=>"Save Changes").click }
  element(:active) { |b| b.frm.radio(:id=>"btnActive") }
  element(:inactive) { |b| b.frm.radio(:id=>"btnInactive") }

end

#
class AddEditPortfolioContent < BasePage

  frame_element

  action(:add_page) { |b| b.frm.link(:text=>"Add Page").click }

  action(:share_with_others) { |b| b.frm.link(:text=>"Share with Others").click }

  action(:save_changes) { |b| b.frm.button(:value=>"Save Changes").click }

end

#
class AddEditPortfolioPage < BasePage

  include FCKEditor
  frame_element

  action(:add_page) { |b| b.frm.link(:text=>"Add Page").click }

  action(:select_layout) { |b| b.frm.link(:text=>"Select Layout").click }

  action(:select_style) { |b| b.frm.link(:text=>"Select Style").click }

  def simple_html_content=(text)
    frm.frame(:id, "_id1:arrange:_id49_inputRichText___Frame").div(:title=>"Select All").fire_event("onclick")
    frm.frame(:id, "_id1:arrange:_id49_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys :backspace
    frm.frame(:id, "_id1:arrange:_id49_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  element(:title) { |b| b.frm.text_field(:id=>"_id1:title") }
  element(:description) { |b| b.frm.text_field(:id=>"_id1:description") }
  element(:keywords) { |b| b.frm.text_field(:id=>"_id1:keywords") }

end

#
class ManagePortfolioLayouts < BasePage

  frame_element

  action(:select) { |layout_name, b| b.frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(layout_name)}/).link(:text=>"Select").click }

  action(:go_back) { |b| b.frm.button(:value=>"Go Back").click }

end

#
class SharePortfolio < BasePage

  frame_element

  action(:click_here_to_share_with_others) { |b| b.frm.link(:text=>"Click here to share with others").click }

  action(:summary) { |b| b.frm.link(:text=>"Summary").click }

  element(:everyone_on_the_internet) { |b| b.frm.checkbox(:id=>"public_checkbox") }

end

#
class AddPeopleToShare < BasePage

  frame_element

end