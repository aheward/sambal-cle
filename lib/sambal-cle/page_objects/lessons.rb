
#================
# Lesson Pages
#================

# Contains items common to most Lessons pages.
class LessonsBase < BasePage

  frame_element

  class << self
    def menu_elements
      # Clicks on the Preferences link on the Lessons page,
      # next is the LessonPreferences class.
      action(:preferences) { |b| b.frm.link(:text=>"Preferences").click }

      action(:view) { |b| b.frm.link(:text=>"View").click }

      action(:manage) { |b| b.frm.link(:text=>"Manage").click }
    end
  end
end

# The Lessons page in a site ("icon-sakai-melete")
#
# Note that this class is inclusive of both the
# Instructor/Admin and the Student views of this page
# many methods will error out if used when in the
# Student view.
class Lessons < LessonsBase

  menu_elements

  expected_element :lessons_table

  element(:lessons_table) { |b| b.frm.table(:id=>/lis.+module.+form:table/) }

  # Clicks the Add Module link, then
  # next is the AddModule class.
  action(:add_module) { |b| b.frm.link(:text=>"Add Module").click }
  action(:add_content) { |b| b.frm.link(text: "Add Content").click }
  action(:edit) { |b| b.frm.link(text: "Edit").click }
  action(:left) { |b| b.frm.link(text: "Left").click }
  action(:right) { |b| b.frm.link(text: "Right").click }
  action(:delete) { |b| b.frm.link(text: "Delete").click }
  action(:archive) { |b| b.frm.link(text: "Archive").click }
  action(:move_sections) { |b| b.frm.link(text: "Move Section(s)").click }

  action(:open_lesson) { |name, b| b.frm.link(:text=>name).click }
  alias :open_section :open_lesson

  action(:href) { |name, b| b.frm.link(:text=>name).href }

  action(:check_lesson) { |name, b| b.frm.tr(text: /#{Regexp.escape(name)}/).td(class: "ModCheckClass").checkbox.set }

  action(:check_section) { |name, b| b.frm.td(class: "SectionClass", text: /#{Regexp.escape(name)}/).checkbox.set }

  # Returns an array of the Module titles displayed on the page.
  def lessons_list
    list = []
    lessons_table.links.each do |link|
      if link.id=~/lis.+module.+form:table:.+:(edit|view)Mod/
        list << link.text
      end
    end
    return list
  end

  # Returns and array containing the list of section titles for the
  # specified module.
  def sections_list(module_name)
    list = []
    if lessons_table.row(:text=>/#{Regexp.escape(module_name)}/).table(:id=>/tablesec/).exist?
      lessons_table.row(:text=>/#{Regexp.escape(module_name)}/).table(:id=>/tablesec/).links.each do |link|
        if link.id=~/Sec/
          list << link.text
        end
      end
    end
    return list
  end

end

# The student user's view of a Lesson Module or Section.
class ViewModule < LessonsBase

  menu_elements

  def sections_list
    list = []
    frm.table(:id=>"viewmoduleStudentform:tablesec").links.each { |link| list << link.text }
    return list
  end

  link "Next"

  # Returns the text of the Module title row
  value(:module_title) { |b| b.frm.span(:id=>/modtitle/).text }

  # Returns the text of the Section title row
  value(:section_title) { |b| b.frm.span(:id=>/form:title/).text }

  def content_include?(content)
    frm.form(:id=>"viewsectionStudentform").text.include?(content)
  end

end

# This is the Instructor's preview of the Student's view
# of the list of Lesson Modules.
class ViewModuleList < LessonsBase

  menu_elements

  # LessonStudentSide
  action(:open_lesson) { |name, b| b.frm.link(:text=>name).click }

  # SectionStudentSide
  action(:open_section) { |name, b| b.frm.link(:text=>name).click }

end

# The instructor's preview of the student view of the lesson.
class LessonStudentSide < LessonsBase

  menu_elements

end

# The instructor's preview of the student's view of the section.
class SectionStudentSide < LessonsBase

  menu_elements

end

# The Managing Options page for Lessons
class LessonManage < LessonsBase

  menu_elements

  link "Manage Content"
  link "Sort"
  link "Import/Export"

end

class LessonManageContent < LessonsBase

  menu_elements

end


# The Sorting Modules and Sections page in Lessons
class LessonManageSort < LessonsBase

  menu_elements

  action(:sort_modules) { |b| b.frm.link(:id=>"SortSectionForm:sortmod").click }
  action(:sort_sections) { |b| b.frm.link(:id=>"SortModuleForm:sortsec").click }

end

# The Import/Export page in Manage Lessons for a Site
class LessonImportExport < LessonsBase

  menu_elements

  # Uploads the file specified - meaning that it enters
  # the target file information, then clicks the import
  # button.
  #
  # The file path is an optional parameter.
  def upload_IMS(file_name, file_path="")
    frm.file_field(:name, "impfile").set(file_path + file_name)
    frm.link(:id=>"importexportform:importModule").click
    frm.table(:id=>"AutoNumber1").div(:text=>"Processing...").wait_while_present
  end

  # Returns the text of the alert box.
  value(:alert_text) { |b| b.frm.span(:class=>"BlueClass").text }

end

# The User preference options page for Lessons.
#
# Note that this class is inclusive of Student
# and Instructor views of the page. Thus,
# not all methods in the class will work
# at all times.
class LessonPreferences < LessonsBase

  menu_elements

  element(:expanded) { |b| b.frm.radio(:name=>"UserPreferenceForm:_id5", :index=>0) }
  element(:collapsed) { |b| b.frm.radio(:name=>"UserPreferenceForm:_id5", :index=>1) }
  action(:set) { |b| b.frm.link(:id=>"UserPreferenceForm:SetButton").click }
  
end

# This Class encompasses methods for both the Add and the Edit pages for Lesson Modules.
class AddEditModule < LessonsBase

  menu_elements

  expected_element :title

  # Clicks the Add button for the Lesson Module
  # next is the ConfirmModule class.
  action(:add) { |b| b.frm.link(:id=>/ModuleForm:submitsave/).click }

  # AddEditContentSection
  action(:add_content_sections) { |b| b.frm.link(:id=>/ModuleForm:sectionButton/).click }

  element(:title) { |b| b.frm.text_field(:name=>/ModuleForm:title/) }
  element(:description) { |b| b.frm.text_field(:id=>/ModuleForm:description/) }
  element(:keywords) { |b| b.frm.text_field(:id=>/ModuleForm:keywords/) }
  element(:start_date) { |b| b.frm.text_field(:id=>/ModuleForm:startDate/) }
  element(:end_date) { |b| b.frm.text_field( :id=>/ModuleForm:endDate/) }

end

# The confirmation page when you are saving a Lesson Module.
class ConfirmModule < LessonsBase

  menu_elements

  # Clicks the Add Content Sections button and
  # next is the AddEditSection class.
  action(:add_content_sections) { |b| b.frm.link(:id=>/ModuleConfirmForm:sectionButton/).click }

  # Clicks the Return to Modules button, then
  # instantiates the AddEditModule class.
  action(:return_to_modules) { |b| b.frm.link(:id=>/ModuleConfirmForm:returnButton/).click }

end

# Page for adding a section to a Lesson.
class AddEditContentSection < LessonsBase

  menu_elements
  cke_elements

  #expected_element :instructions

  # Clicks the Add button on the page
  # next is the ConfirmSectionAdd class.
  action(:add) { |b| b.frm.link(:id=>/SectionForm:submitsave/).click }

  def add_content=(text)
    rich_text_field.send_keys(text)
  end

  def clear_content  # FIXME - This is an extra method now that we have the FCKEditor module
    select_all
    editor.send_keys :backspace
  end

  # SelectingContent
  action(:select_url) { |b| b.frm.link(:id=>"AddSectionForm:ContentLinkView:serverViewButton").click }

  # This method clicks the Select button that appears on the page
  # then call the LessonAddAttachment class.
  action(:select_or_upload_file) { |b| b.frm.link(:id=>"AddSectionForm:ResourceHelperLinkView:serverViewButton").click }

  # Clicks the select button for "Upload or link to a file"
  # NOT for "Upload or link to a file in Resources"!
  action(:select_a_file) { |b| b.frm.link(:id=>"AddSectionForm:ContentUploadView:serverViewButton").click }

  element(:title) { |b| b.frm.text_field(:id=>/SectionForm:title/) }
  element(:instructions) { |b| b.frm.text_field(:id=>/SectionForm:instr/) }
  element(:content_type) { |b| b.frm.select(:id=>/SectionForm:contentType/) }
  element(:copyright_status) { |b| b.frm.select(:id=>/SectionForm:ResourcePropertiesPanel:licenseCodes/) }

  action(:check_auditory) { |b| b.frm.checkbox(:id=>/SectionForm:contentaudio/).set }
  action(:check_textual) { |b| b.frm.checkbox(:id=>/SectionForm:contentext/).set }
  action(:check_visual) { |b| b.frm.checkbox(:id=>/SectionForm:contentaudio/).set }
  action(:uncheck_auditory) { |b| b.frm.checkbox(:id=>/SectionForm:contentaudio/).clear }
  action(:uncheck_textual) { |b| b.frm.checkbox(:id=>/SectionForm:contentext/).clear }
  action(:uncheck_visual) { |b| b.frm.checkbox(:id=>/SectionForm:contentaudio/).clear }

  element(:url_title) { |b| b.frm.text_field(:id=>/SectionForm:ResourcePropertiesPanel:res_name/) }
  element(:url_description) { |b| b.frm.text_field(:id=>/SectionForm:ResourcePropertiesPanel:res_desc/) }
  element(:file_description) { |b| b.frm.text_field(:id=>/SectionForm:ResourcePropertiesPanel:res_desc/) }

  action(:add_another_section) { |b| frm.link(:id=>/:saveAddAnotherButton/).click }
  action(:finish) { |b| b.frm.link(id: /FinishButton/).click }
  action(:save) { |b| b.frm.link(id: /saveButton/).click }

end

# Confirmation page for Adding (or Editing)
# a Section to a Module in Lessons.
class ConfirmSectionAdd < LessonsBase

  menu_elements

  # Clicks the Add Another Section button
  # next is the AddEditContentSection class.
  action(:add_another_section) { |b| b.frm.link(:id=>/SectionConfirmForm:saveAddAnotherbutton/).click }

  # Clicks the Finish button
  # next is the Lessons class.
  action(:finish) { |b| b.frm.link(:id=>/Form:FinishButton/).click }

end

#
class SelectingContent < LessonsBase

  menu_elements

  # AddEditContentSection
  action(:continue) { |b| b.frm.link(:id=>"ServerViewForm:addButton").click }

  element(:new_url) { |b| b.frm.text_field(:id=>"ServerViewForm:link") }
  element(:url_title) { |b| b.frm.text_field(:id=>"ServerViewForm:link_title") }

end

#
class LessonAddAttachment < LessonsBase # TODO: DRY up this class

  menu_elements

  action(:continue) { |b| b.frm.link(:id=>"UploadServerViewForm:addButton").click }

  def upload_local_file(filename, filepath="")
    frm.file_field(:id=>"file1").set(filepath + filename)
  end

end