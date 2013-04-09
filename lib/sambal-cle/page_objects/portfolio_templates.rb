#================
# Portfolio Templates pages
#================

#
class PortfolioTemplates < BasePage

  frame_element

  # Clicks the Add link and instantiates the
  # AddPortfolioTemplate class.
  link "Add"

  # Clicks the "Publish" link for the specified Template.
  action(:publish) { |templatename, b| b.template_table.row(:text=>/#{Regexp.escape(templatename)}/).link(:text=>'Publish').click }

  # Clicks the 'Edit' link for the specified Template.
  action(:edit) { |templatename, b| b.template_table.row(:text=>/#{Regexp.escape(templatename)}/).link(:text=>'Edit').click }

  # Clicks the 'Delete' link for the specified Template.
  action(:delete) { |templatename, b| b.template_table.row(:text=>/#{Regexp.escape(templatename)}/).link(:text=>'Delete').click }

  # Clicks the 'Copy' link for the specified Template.
  action(:copy) { |templatename, b| b.template_table.row(:text=>/#{Regexp.escape(templatename)}/).link(:text=>'Copy').click }

  # Clicks the 'Export' link for the specified Template.
  action(:export) { |templatename, b| b.template_table.row(:text=>/#{Regexp.escape(templatename)}/).link(:text=>'Export').click }

  # ========
  private
  # ========
  
  element(:template_table) { |b| b.frm.table(:class=>'listHier lines nolines') }
  
end

#
class AddPortfolioTemplate < BasePage

  frame_element

  # Clicks the Continue button and instantiates the BuildTemplate Class.
  button 'Continue'

  element(:name) { |b| b.frm.text_field(:id=>'name-id') }
  element(:description) { |b| b.frm.text_field(:id=>'description') }

end

#
class BuildTemplate < BasePage

  frame_element

  link 'Select File'
  button 'Continue'

  element(:outline_options_form_type) { |b| b.frm.select(:id=>'propertyFormType-id') }

end

#
class PortfoliosUploadFiles < BasePage # TODO - This class can probably be removed completely

  frame_element

  @@filex=0

  # Note that the file_to_upload method can be used
  # multiple times, but it assumes
  # that the add_another_file method is used
  # before it, every time except before the first time.
  def file_to_upload(file_name, file_path)
    frm.file_field(:id, "content_#{@@filex}").set(file_path + file_name)
    @@filex+=1
  end

  # Clicks the Upload Files Now button and instantiates the
  # PortfolioAttachFiles Class.
  def upload_files_now
    frm.button(:value=>'Upload Files Now').click
    sleep 1 # TODO - use a wait clause here
    @@filex=0
    PortfolioAttachFiles.new(@browser)
  end

  # Clicks the Add Another File link.
  link 'Add Another File'

end

#
class PortfolioContent < BasePage

  frame_element

  button 'Continue'
  element(:type) { |b| b.frm.select(:id=>'item.type') }
  element(:name) { |b| b.frm.text_field(:id=>'item.name-id') }
  element(:title) { |b| b.frm.text_field(:id=>'item.title-id') }
  element(:description) { |b| b.frm.text_field(:id=>'item.description-id') }
  button 'Add To List'
  element(:image) { |b| b.frm.checkbox(:id=>'image-id') }

end

#
class SupportingFilesPortfolio < BasePage

  frame_element

  button 'Finish'
  link 'Select File'
  button 'Add To List'
  element(:name) { |b| b.frm.text_field(:id=>'fileRef.usage-id') }

end