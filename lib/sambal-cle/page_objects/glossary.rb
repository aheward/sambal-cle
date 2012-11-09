#================
# Glossary Pages - for a Portfolio Site
#================

class Glossary < BasePage

  frame_element

  def add
    frm.link(:text=>"Add").click
  end

  def import
    frm.link(:text=>"Import").click
  end

  def edit(term)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(term)}/).link(:text=>"Edit").click
  end

  def delete(term)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(term)}/).link(:text=>"Delete").click
  end

  def open(term)
    frm.link(:text=>term).click
    #FIXME!
    # Need to do special handling here because of the new window.
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

  def select_file
    frm.link(:text=>"Select file...").click
  end

  def import
    frm.button(:value=>"Import").click
  end

end