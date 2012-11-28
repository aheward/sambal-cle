#================
# Sites Page - from Administration Workspace
#================

# Sites page - arrived at via the link with class="icon-sakai-sites"
class Sites < BasePage

  frame_element

  # Clicks the first site Id link
  # listed. Useful when you've run a search and
  # you're certain you've got the result you want.
  action(:click_top_item) { |b| b.frm.link(:href, /#{Regexp.escape("&panel=Main&sakai_action=doEdit")}/).click }

  # Clicks the specified Site in the list, using the
  # specified id value to determine which item to click.
  # It then instantiates the EditSiteInfo page class.
  # Use this method when you know the target site ID.
  def edit_site_id(id)
    frm.text_field(:id=>"search_site").value=id
    frm.link(:text=>"Site ID").click
    frm.link(:text, id).click
  end

  link "New Site"

  element(:search_field) { |b| b.frm.text_field(:id=>"search") }
  action(:search_button) { |b| b.frm.link(text=>"Search").click }
  element(:search_site_id) { |b| b.frm.text_field(:id=>"search_site") }
  action(:search_site_id_button) { |b| b.frm.link(text=>"Site ID").click }
  element(:search_user_id) { |b| b.frm.text_field(:id=>"search_user") }
  action(:search_user_id_button) { |b| b.frm.link(text=>"User ID").click }
  action(:next) { |b| b.frm.button(:name=>"eventSubmit_doList_next").click }
  action(:last) { |b| b.frm.button(:name=>"eventSubmit_doList_last").click }
  action(:previous) { |b| b.frm.button(:name=>"eventSubmit_doList_prev").click }
  action(:first) { |b| b.frm.button(:name=>"eventSubmit_doList_first").click }
  element(:select_page_size) { |b| b.frm.select_list(:name=>"selectPageSize") }

end


# Page that appears when you've clicked a Site ID in the
# Sites section of the Administration Workspace.
class EditSiteInfo < BasePage

  include FCKEditor
  frame_element

  link("Remove Site")
  button("Save")
  link("Save As")

  # Gets the Site ID from the page.
  action(:site_id_read_only) { |b| b.frm.table(:class=>"itemSummary").td(:class=>"shorttext", :index=>0).text }

  # Enters the specified text string in the text area of
  # the FCKEditor.
  def description=(text)
    editor.frame(:index=>0).send_keys(text)
  end

  # The FCKEditor object
  element(:editor) { |b| b.frm.frame(:id, "description___Frame").td(:id, "xEditingArea") }

  button("Properties")
  button("Pages")

  # Non-navigating, interactive page objects go here
  element(:site_id) { |b| b.frm.text_field(:id=>"id") }
  element(:title) { |b| b.frm.text_field(:id=>"title") }
  element(:type) { |b| b.frm.text_field(:id=>"type") }
  element(:short_description) { |b| b.frm.text_field(:id=>"shortDescription") }
  element(:unpublished) { |b| b.frm.select_list(:id=>"publishedfalse") }
  element(:published) { |b| b.frm.select_list(:id=>"publishedtrue") }
  element(:public_view_yes) { |b| b.frm.select_list(:id=>"pubViewtrue") }
end

# The page you come to when editing a Site in Sites
# and you click on the Pages button
class AddEditPages < BasePage

  frame_element

  link("New Page")

end

# Page for adding a new page to a Site.
class NewPage < BasePage

  frame_element

  button("Tools")

  # Interactive page objects that do no navigation
  # or page refreshes go here.
  element(:title) { |b| b.frm.text_field(:id=>"title") }

end



# Page when editing a Site and adding/editing tools for pages.
class AddEditTools < BasePage

  frame_element

  link("New Tool")
  button("Save")

end

# Page for creating a new tool for a page in a site
class NewTool < BasePage

  frame_element

  button("Done")

  # Interactive page objects that do no navigation
  # or page refreshes go here.
  element(:title) { |b| b.frm.text_field(:id=>"title") }
  element(:layout_hints) { |b| b.frm.text_field(:id=>"layoutHints") }
  element(:resources) { |b| b.frm.select_list(:id=>"feature80") }
end


# Page that appears when you click "Remove Site" when editing a Site in Sites
class RemoveSite < BasePage

  frame_element

  button("Remove")

end

# Page that appears when you click "Save As" when editing a Site in Sites
class SiteSaveAs < BasePage

    frame_element

    button("Save")

    element(:site_id) { |b| b.frm.text_field(:id=>"id") }

end

class AddEditSiteProperties < BasePage

  frame_element

  button("New Property")
  button("Done")
  button("Save")

  element(:name) { |b| b.frm.text_field(:id=>"new_name") }
  element(:value) { |b| b.frm.text_field(:id=>"new_value") }

end