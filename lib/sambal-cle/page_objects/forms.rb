#================
# Forms Pages - Portfolio Site
#================

# The topmost page of Forms in a Portfolio Site.
class Forms < BasePage

  frame_element

  action(:add) { |b| b.frm.link(:text=>"Add").click }

  # Clicks the Publish buton for the specified
  # Form
  action(:publish) { |form_name, b| b.frm.table(:class=>"listHier lines nolines").tr(:text, /#{Regexp.escape(form_name)}/).link(:text=>/Publish/).click }

  # Clicks the Import button
  action(:import) { |b| b.frm.link(:text=>"Import").click }

end

class ImportForms < BasePage

  frame_element

  action(:import) { |b| b.frm.button(:value=>"Import").click }

  action(:select_file) { |b| b.frm.link(:text=>"Select File...").click }

end

class AddForm < BasePage

  include FCKEditor
  frame_element

  action(:select_schema_file) { |b| b.frm.link(:text=>"Select Schema File").click }

  def instruction=(text)
    frm.frame(:id, "instruction___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  action(:add_form) { |b| b.frm.button(:value=>"Add Form").click }

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

  action(:continue) { |b| b.frm.button(:value=>"Continue").click }

end

class PublishForm < BasePage

  frame_element

  action(:yes) { |b| b.frm.button(:value=>"Yes").click }

end