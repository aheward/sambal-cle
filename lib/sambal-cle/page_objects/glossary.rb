#================
# Glossary Pages - for a Portfolio Site
#================

class Glossary < BasePage

  frame_element

  action(:add) { |b| b.frm.link(:text=>"Add").click }
  action(:import) { |b| b.frm.link(:text=>"Import").click }

  action(:edit) { |term, b| b.frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(term)}/).link(:text=>"Edit").click }
  action(:delete) { |term, b| b.frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(term)}/).link(:text=>"Delete").click }

  action(:open) do |term, b|
    b.frm.link(:text=>term).click
    b.window(:title=>term).use
  end

  # Returns an array containing the string values of the terms
  # displayed in the list.
  def terms
    term_list = []
    frm.table(:class=>"listHier lines nolines").rows.each do |row|
      term_list << row[0].text
    end
    term_list.delete_at(0)
    return term_list
  end

end

class AddEditTerm < BasePage

  include FCKEditor
  frame_element

  expected_element :editor

  def add_term
    frm.button(:value=>"Add Term").click
  end

  def save_changes
    frm.button(:value=>"Save Changes").click
  end

  def long_description=(text)
    editor.td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  element(:editor) { |b| b.frm.frame(:id, "longDescription___Frame") }
  element(:term) { |b| b.frm.text_field(:id=>"term-id") }
  element(:short_description) { |b| b.frm.text_field(:id=>"description-id") }

end

# Page for importing Glossary files into a Glossary
class GlossaryImport < BasePage

  frame_element

  action(:select_file) { |b| b.frm.link(:text=>"Select file...").click }

  action(:import) { |b| b.frm.button(:value=>"Import").click }

end