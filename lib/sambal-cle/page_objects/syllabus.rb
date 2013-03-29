#================
# Syllabus pages in a Site
#================

class SyllabusBase < BasePage

  frame_element
  basic_page_elements

  class << self

    def menu_elements
      link('Create/Edit')
      link('Add')
      link('Redirect')
      link('Preview')
    end

  end

end

# The topmost page in the Syllabus feature.
# If there are no syllabus items it will appear
# differently than if there are.
class Syllabus < SyllabusBase

  menu_elements

  def attachments_list
    list = []
    frm.div(:class=>"portletBody").links.each { |link| list << link.text }
    list
  end

end

# This is the page that lists Syllabus sections, allows for
# moving them up or down in the list, and allows for removing
# items from the syllabus.
class SyllabusEdit < SyllabusBase

  menu_elements

  # Clicks the checkbox for the item with the
  # specified title.
  def check_title(title)
    index=syllabus_titles.index(title)
    frm.checkbox(:index=>index).set
  end

  #
  def move_title_up(title)
    #FIXME
  end

  #
  def move_title_down(title)
    #FIXME
  end

  button("Update")

  # Opens the specified item
  action(:open_item) { |title, b| b.frm.link(:text=>title).click }

  # Returns an array containing the titles of the syllabus items
  # displayed on the page.
  def syllabus_titles
    titles = []
    s_table = frm.table(:class=>"listHier lines nolines")
    1.upto(s_table.rows.size-1) do |x|
      titles << s_table[x][0].text
    end
    titles
  end

  # ==========
  private
  # ==========



end

#
class AddEditSyllabusItem < SyllabusBase

  menu_elements
  cke_elements

  expected_element :editor

  button("Post")

  # Sends the specified string to the FCKEditor text area on the page.
  def content=(text)
    rich_text_field.send_keys(text)
  end

  button("Add attachments")

  # Returns an array of the filenames in the attachments
  # table
  def files_list
    names = []
    frm.table(:class=>"listHier lines nolines").rows.each do |row|
      if row.td(:class=>"item").exist?
        names << row.td(:class=>"item").h4.text
      end
    end
    return names
  end

  button("Preview")

  element(:title) { |b| b.frm.text_field(:id=>"_id4:title") }
  element(:only_members_of_this_site) { |b| b.frm.radio_button(:name=>/_id\d+:_id\d+/, :value=>"no") }
  element(:publicly_viewable) { |b| b.frm.radio_button(:name=>/_id\d+:_id\d+/, :value=>"yes") }

end

# The page for previewing a syllabus.
class SyllabusPreview < SyllabusBase

  menu_elements

  button 'Edit'

end

#
class SyllabusRedirect < SyllabusBase

  menu_elements

  element(:url) { |b| b.frm.text_field(:id=>"redirectForm:urlValue") }

end

# The page where Syllabus Items can be deleted.
class DeleteSyllabusItems < SyllabusBase

  menu_elements

  button 'Delete'

end

class CreateEditSyllabus < SyllabusBase

  menu_elements

end