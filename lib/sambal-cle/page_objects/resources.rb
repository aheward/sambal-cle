#================
# Resources Pages
#================

# This class consolidates the code that can be shared among all the
# File Upload and Attachment pages.
#
# Not every method in this class will be appropriate for every attachment page.
class ResourcesBase < BasePage

  frame_element

  class << self

    def resources_elements
      element(:files_table) { |b| b.frm.table(:class=>/listHier lines/) }

      # Use this as a means of checking if the file is visible or not
      action(:item) { |name, b| b.frm.link(:text=>name) }

      # Clicks the Select button next to the specified file.
      action(:select_file) { |filename, b| b.files_table.row(:text, /#{Regexp.escape(filename)}/).link(:text=>"Select").click }

      # Clicks the Remove button.
      action(:remove) { |b| b.frm.button(:value=>"Remove").click }

      # Clicks the remove link for the specified item in the attachment list.
      action(:remove_item) { |file_name, b| b.files_table.row(:text=>/#{Regexp.escape(file_name)}/).link(:href=>/doRemoveitem/).click }

      # Clicks the Move button.
      action(:move) { |b| b.frm.button(:value=>"Move").click }

      # Clicks the Show Other Sites link.
      action(:show_other_sites) { |b| b.frm.link(:text=>"Show other sites").click }

      action(:href) { |item, b| b.frm.link(:text=>item).href }

      # Clicks on the specified folder image, which
      # will open the folder tree and remain on the page.
      action(:open_folder) { |foldername, b| b.files_table.row(:text=>/#{Regexp.escape(foldername)}/).link(:title=>"Open this folder").click }

      # Clicks on the specified folder name, which should open
      # the folder contents on a refreshed page.
      action(:go_to_folder) { |foldername, b| b.frm.link(:text=>foldername).click }

      # Sets the URL field to the specified value.
      action(:url=) { |url_string, b| b.frm.text_field(:id=>"url").set(url_string) }

      # Clicks the Add button next to the URL field.
      action(:add) { |b| b.frm.button(:value=>"Add").click }

      # Gets the value of the access level cell for the specified
      # file.
      action(:access_level) { |filename, b| b.files_table.row(:text=>/#{Regexp.escape(filename)}/)[6].text }

      element(:upload_file_field) { |b| b.frm.file_field(:id=>"upload") }

    end

  end

end

# Resources page for a given Site, in the Course Tools menu
class Resources < ResourcesBase

  resources_elements

  # Returns an array of the displayed folder names.
  def folder_names
    names = []
    files_table.rows.each do |row|
      next if row.td(:class=>"specialLink").exist? == false
      next if row.td(:class=>"specialLink").link(:title=>"Folder").exist? == false
      names << row.td(:class=>"specialLink").link(:title=>"Folder").text
    end
    names
  end

  # Returns an array of the file names currently listed
  # on the page.
  #
  # It excludes folder names.
  def file_names
    names = []
    files_table.rows.each do |row|
      next if row.td(:class=>"specialLink").exist? == false
      next if row.td(:class=>"specialLink").link(:title=>"Folder").exist?
      names << row.td(:class=>"specialLink").link(:href=>/access.content/, :index=>1).text
    end
    names
  end

  # Enters the specified file into the file field name (assuming it's in the
  # data/sakai-cle-test-api folder or a subfolder therein)
  #
  def upload_file(filename, filepath="")
    upload_file_field.set(filepath + filename)
    if frm.div(:class=>"alertMessage").exist?
      sleep 2
      upload_file(filename)
    end
  end

  # Enters the specified file into the file field name (assuming it's in the
  # data/sakai-cle-test-api folder or a subfolder therein)
  #
  # Use this method ONLY for instances where there's a file field on the page
  # with an "upload" id.
  def upload_local_file(filename, filepath="")
    upload_file_field.set(filepath + filename)
    if frm.div(:class=>"alertMessage").exist?
      sleep 2
      upload_local_file(filename)
    end
  end

  # Clicks the Add Menu for the specified
  # folder, then selects the Upload Files
  # command in the menu that appears.
  def upload_files_to_folder(folder_name)
    if frm.li(:text=>/A/, :class=>"menuOpen").exist?
      files_table.row(:text=>/#{Regexp.escape(folder_name)}/).li(:text=>/A/, :class=>"menuOpen").fire_event("onclick")
    else
      files_table.row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Start Add Menu").fire_event("onfocus")
    end
    files_table.row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Upload Files").click
  end

  # Clicks the "Attach a copy" link for the specified
  # file.
  # If an alert box appears, the method will call itself again.
  # Note that this can lead to an infinite loop. Will need to fix later.
  def attach_a_copy(file_name)
    files_table.row(:text=>/#{Regexp.escape(file_name)}/).link(:href=>/doAttachitem/).click
    if frm.div(:class=>"alertMessage").exist?
      sleep 1
      attach_a_copy(file_name) # TODO - This can loop infinitely
    end
  end

  # Takes the specified array object containing pointers
  # to local file resources, then uploads those files to
  # the folder specified, checks if they all uploaded properly and
  # if not, re-tries the ones that failed the first time.
  #
  # Finally, it re-instantiates the appropriate page class.
  # Note that it expects all files to be located in the same folder (can be in subfolders of that folder).
  def upload_multiple_files_to_folder(folder, file_array, file_path="")

    upload = upload_files_to_folder folder

    file_array.each do |file|
      upload.file_to_upload(file, file_path)
      upload.add_another_file
    end

    resources = upload.upload_files_now

    file_array.each do |file|
      file =~ /(?<=\/).+/
      # puts $~.to_s # For debugging purposes
      unless resources.file_names.include?($~.to_s)
        upload_files = resources.upload_files_to_folder(folder)
        upload_files.file_to_upload(file, file_path)
        upload_files.upload_files_now
      end
    end
  end

  def edit_details(name)
    open_actions_menu(name)
    files_table.row(:text=>/#{Regexp.escape(name)}/).link(:text=>"Edit Details").click
  end

  def edit_content(html_page_name)
    open_actions_menu(html_page_name)
    files_table.row(:text=>/#{Regexp.escape(html_page_name)}/).link(:text=>"Edit Content").click
  end

  # Clicks the Create Folders menu item in the
  # Add menu of the specified folder.
  def create_subfolders_in(folder_name)
    open_add_menu(folder_name)
    files_table.row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Create Folders").click
  end

  def create_html_page_in(folder_name)
    open_add_menu(folder_name)
    files_table.row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Create HTML Page").click
  end

  # Clicks the Continue button
  def continue
    frm.div(:class=>"highlightPanel").span(:id=>"submitnotifxxx").wait_while_present
    frm.button(:value=>"Continue").click
  end

  action(:open_add_menu) { |folder_name, b| b.files_table.row(text: /#{Regexp.escape(folder_name)}/).li(class: 'menuOpen').click }

  def open_actions_menu(name)
    files_table.row(:text=>/#{Regexp.escape(name)}/).li(:text=>/Action/, :class=>"menuOpen").fire_event("onclick")
  end

end

class ResourcesUploadFiles < ResourcesBase

  resources_elements

  @@filex=0 # TODO: This is almost certainly not going to work right.

  # Enters the specified folder/filename value into
  # the file field on the page.
  # The method will throw an error if the specified file
  # is not found.
  #
  # This method is designed to be able to use
  # multiple times, but it assumes
  # that the add_another_file method is used
  # before it, every time except before the first time.
  def file_to_upload(file_name, file_path="")
    frm.file_field(:id, "content_#{@@filex}").set(file_path + file_name)
    @@filex+=1
  end

  # Clicks the Upload Files Now button, resets the
  # @@filex class variable back to zero, and instantiates
  # the Resources page class.
  def upload_files_now
    frm.button(:value=>"Upload Files Now").click
    @@filex=0
    # Resources.new(@browser)
  end

  # Clicks the Add Another File link.
  def add_another_file
    frm.link(:text=>"Add Another File").click
  end

end

class EditFileDetails < ResourcesBase

  # Clicks the Update button, then instantiates
  # the Resources page class.
  action(:update) { |b| b.frm.button(:value=>"Update").click }

  # Enters the specified string into the title field.
  element(:title) { b.frm.text_field(:id=>"displayName_0") }

  # Enters the specified string into the description field.
  element(:description) { |b| b.frm.text_field(:id=>"description_0") }

  element(:publicly_viewable) { |b| b.frm.radio(:id=>"access_mode_public_0") }

  element(:show_only_if_condition) { |b| b.frm.checkbox(:id=>"cbCondition_0") }

  # Selects the specified Gradebook item value in the
  # select list.
  element(:gradebook_item) { |b| b.frm.select(:id=>"selectResource_0") }

  # Selects the specified value in the item condition
  # field.
  element(:item_condition) { |b| b.frm.select(:id=>"selectCondition_0") }

  # Sets the Grade field to the specified value.
  element(:assignment_grade) { |b| b.frm.text_field(:id=>"assignment_grade_0") }

end

class CreateFolders < ResourcesBase

  element(:folder_name) { |b| b.frm.text_field(:id=>"content_0") }
  action(:create_folders_now) { |b| b.frm.button(:value=>"Create Folders Now").click }

end

class EditHTMLPageContent < BasePage

  frame_element
  cke_elements

  action(:continue) { |b| b.frm.button(id: "saveChanges").click }
  element(:email_notification) { |b| b.frm.select(:id=>"notify") }

end

class EditHTMLPageProperties < ResourcesBase

  element(:name) { |b| b.frm.text_field(id: "displayName_0") }
  element(:description) { |b| b.frm.text_field(id: "description_0") }

  action(:html_content=) { |text, b| b.rich_text_field('content').send_keys text }

  action(:finish) { |b| b.frm.button(id: "finish_button").click }

end