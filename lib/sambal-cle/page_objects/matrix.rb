#================
# Matrix Pages for a Portfolio Site
#================

#
class Matrices < BasePage

  frame_element

  # Clicks the Add link and instantiates
  # the AddEditMatrix Class.
  link 'Add'
  link 'Import'
  link 'Manage Site Associations'
  link 'Permissions'
  link 'My Preferences'

  # Clicks the "Edit" link for the specified
  # Matrix item, then instantiates the EditMatrixCells.
  action(:edit) { |matrixname, b| b.matrix_table.tr(:text=>/#{Regexp.escape(matrixname)}/).link(:text=>'Edit').click }

  # Clicks the 'Preview' link for the specified
  # Matrix item.
  action(:preview) { |matrixname, b| b.matrix_table.tr(:text=>/#{Regexp.escape(matrixname)}/).link(:text=>'Preview').click }

  # Clicks the 'Publish' link for the specified
  # Matrix item, then instantiates the ConfirmPublishMatrix Class.
  action(:publish) { |matrixname, b| b.matrix_table.tr(:text=>/#{Regexp.escape(matrixname)}/).link(:text=>'Publish').click }

  action(:delete) { |matrixname, b| b.matrix_table.tr(:text=>/#{Regexp.escape(matrixname)}/).link(:text=>'Delete').click }

  action(:export) { |matrixname, b| b.matrix_table.tr(:text=>/#{Regexp.escape(matrixname)}/).link(:text=>'Export').click }

  element(:matrix_table) { |b| b.frm.table(:class=>'listHier lines nolines') }

  def matrices_list
    text_array = matrix_table.to_a
    text_array.delete_at(0) # deletes the header row which is useless
    list=[]
    text_array.each do |line|
      list << line[0]
    end
    list
  end

end

#
class AddEditMatrix < BasePage

  frame_element
  cke_elements

  expected_element :editor

  # Clicks the "Create Matrix" button
  button 'Create Matrix'

  # Clicks the 'Save Changes' button
  button 'Save Changes'

  # Clicks the 'Select Style' link
  link 'Select Style'

  # Clicks the 'Add Column' link
  link 'Add Column'

  # Clicks the 'Add Row' link
  link 'Add Row'

  element(:title) { |b| b.frm.text_field(:id=>'title-id') }

  action(:description=) { |text, b| b.rich_text_field('descriptionTextArea').send_keys text }

end

#
class SelectMatrixStyle < BasePage

  frame_element

  button 'Go Back'

  # Clicks the "Select" link for the specified
  # Style, then instantiates the AddEditMatrix Class.
  action(:select_style) { |stylename, b| b.frm.table(:class=>/listHier lines/).tr(:text=>/#{Regexp.escape(stylename)}/).link(:text=>'Select').click }

end

class RowColumnCommon < BasePage

  frame_element
  class << self
    def table_elements
      button 'Update'
      element(:name) { |b| b.frm.text_field(:name=>'description') }
      element(:background_color) { |b| b.frm.text_field(:id=>'color-id') }
      element(:font_color) { |b| b.frm.text_field(:id=>'textColor-id') }
    end
  end
end

#
class AddEditColumn < RowColumnCommon

  table_elements

end

#
class AddEditRow < RowColumnCommon

  table_elements

end

#
class EditMatrixCells < BasePage

  frame_element

  # Clicks on the cell that is specified, based on
  # the "id" found in the onclick tag for the cell.
  action(:edit_cell_by_id) { |id, b| b.matrix_scaffolding.td(:html=>/#{id}/).fire_event('onclick') }

  link 'Return to List'

  element(:matrix_scaffolding) { |b| b.frm.div(:class=>'portletBody').table(:summary=>'Matrix Scaffolding (click on a cell to edit)') }

  element(:cells) { |b| b.frm.tds(:class=>/matrix-cell-border/).to_a }

  element(:column_headers) { |b| b.matrix_scaffolding.tr(:index=>0).ths.to_a }

  def edit_cell_by_row_and_column(row, column)
    columns = []
    column_headers.each { |col| columns << col.text }
    columns.delete_at(0)
    matrix_scaffolding.row(:text=>/#{Regexp.escape(row)}/).td(:index=>columns.index(column)).fire_event('onclick')
  end

end

#
class EditCell < BasePage

  frame_element

  expected_element :select_evaluators_link

  link 'Select Evaluators'
  button 'Save Changes'

  element(:title) { |b| b.frm.text_field(:id=>'title-id') }
  element(:use_default_reflection_form) { |b| b.frm.checkbox(:id=>'defaultReflectionForm') }
  element(:reflection) { |b| b.frm.select(:id=>'reflectionDevice-id') }
  element(:use_default_feedback_form) { |b| b.frm.checkbox(:id=>'defaultFeedbackForm') }
  element(:feedback) { |b| b.frm.select(:id=>'reviewDevice-id') }
  element(:use_default_evaluation_form) { |b| b.frm.checkbox(:id=>'defaultEvaluationForm') }
  element(:evaluation) { |b| b.frm.select(:id=>'evaluationDevice-id') }
  element(:use_default_evaluators) { |b| b.frm.checkbox(:id=>'defaultEvaluators') }

end

#
class SelectEvaluators < BasePage

  frame_element

  button 'Save'
  element(:users) { |b| b.frm.select(:id=>'mainForm:availableUsers') }
  element(:selected_users) { |b| b.frm.select(:id=>'mainForm:selectedUsers') }
  element(:roles) { |b| b.frm.select(:id=>'mainForm:audSubV11:availableRoles') }
  element(:selected_roles) { |b| b.frm.select(:id=>'mainForm:audSubV11:selectedRoles') }
  action(:add_users) { |b| b.frm.button(:id=>'mainForm:add_user_button').click }
  action(:remove_users) { |b| b.frm.button(:id=>'mainForm:remove_user_button').click }
  action(:add_roles) { |b| b.frm.button(:id=>'mainForm:audSubV11:add_role_button').click }
  action(:remove_roles) { |b| b.frm.button(:id=>'mainForm:audSubV11:remove_role_button').click }

end

#
class ConfirmPublishMatrix < BasePage

  frame_element

  button 'Continue'

end