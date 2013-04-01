#================
# Glossary Pages - for a Portfolio Site
#================

class Glossary < BasePage

  frame_element

  link("Add")
  link("Import")

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

  frame_element
  cke_elements

  expected_element :editor

  button("Add Term")
  button("Save Changes")

  action(:long_description=) { |text, b| b.rich_text_field('LongDescription').send_keys text }

  element(:term) { |b| b.frm.text_field(:id=>"term-id") }
  element(:short_description) { |b| b.frm.text_field(:id=>"description-id") }

end

# Page for importing Glossary files into a Glossary
class GlossaryImport < BasePage

  frame_element

  link("Select file...")
  link("Import")

end