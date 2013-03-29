#================
# Forms Pages - Portfolio Site
#================

# The topmost page of Forms in a Portfolio Site.
class Forms < BasePage

  frame_element

  link "Add"

  # Clicks the Publish buton for the specified
  # Form
  action(:publish) { |form_name, b| b.frm.table(:class=>"listHier lines nolines").tr(:text, /#{Regexp.escape(form_name)}/).link(:text=>/Publish/).click }

  link "Import"

end

class ImportForms < BasePage

  frame_element

  button "Import"

  link "Select File..."

end

class AddForm < BasePage

  frame_element
  cke_elements

  link "Select Schema File"

  def instruction=(text)
    rich_text_field.send_keys(text)
  end

  button "Add Form"

  element(:name) { |b| b.frm.text_field(:id=>"description-id") }

end

class SelectSchemaFile < BasePage

  frame_element

  action(:show_other_sites) { |b| b.frm.link(:title=>"Show other sites").click }

  action(:open_folder) { |name, b| b.frm.link(:text=>name).click }

  action(:select_file) { |filename, b| b.frm.table(:class=>"listHier lines").tr(:text, /#{Regexp.escape(filename)}/).link(:text=>"Select").click }

  def file_names #FIXME
    names = []
    resources_table = frm.table(:class=>"listHier lines")
    1.upto(resources_table.rows.size-1) do |x|
      if resources_table[x][0].link.exist? && resources_table[x][0].a(:index=>0).title=~/File Type/
        names << resources_table[x][0].text
      end
    end
    return names
  end

  button "Continue"

end

class PublishForm < BasePage

  frame_element

  button "Yes"

end