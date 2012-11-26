#================
# Portfolio Templates pages
#================

#
class PortfolioTemplates < BasePage

  frame_element

  # Clicks the Add link and instantiates the
  # AddPortfolioTemplate class.
  action(:add) { |b| b.frm.link(:text=>"Add").click }

  # Clicks the "Publish" link for the specified Template.
  action(:publish) { |templatename, b| b.frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(templatename)}/).link(:text=>"Publish").click }

  # Clicks the "Edit" link for the specified Template.
  action(:edit) { |templatename, b| b.frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(templatename)}/).link(:text=>"Edit").click }

  # Clicks the "Delete" link for the specified Template.
  action(:delete) { |templatename, b| b.frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(templatename)}/).link(:text=>"Delete").click }

  # Clicks the "Copy" link for the specified Template.
  action(:copy) { |templatename, b| b.frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(templatename)}/).link(:text=>"Copy").click }

  # Clicks the "Export" link for the specified Template.
  action(:export) { |templatename, b| b.frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(templatename)}/).link(:text=>"Export").click }

end

#
class AddPortfolioTemplate < BasePage

  frame_element

  # Clicks the Continue button and instantiates the BuildTemplate Class.
  action(:continue) { |b| b.frm.button(:value=>"Continue").click }

  element(:name) { |b| b.frm.text_field(:id=>"name-id") }
  element(:description) { |b| b.frm.text_field(:id=>"description") }

end

#
class BuildTemplate < BasePage

  frame_element

  action(:select_file) { |b| b.frm.link(:text=>"Select File").click }

  action(:continue) { |b| b.frm.button(:value=>"Continue").click }

  element(:outline_options_form_type) { |b| b.frm.select(:id=>"propertyFormType-id") }

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
    frm.button(:value=>"Upload Files Now").click
    sleep 1 # TODO - use a wait clause here
    @@filex=0
    PortfolioAttachFiles.new(@browser)
  end

  # Clicks the Add Another File link.
  action(:add_another_file) { |b| b.frm.link(:text=>"Add Another File").click }

end

#
class PortfolioContent < BasePage

  frame_element

  action(:continue) { |b| b.frm.button(:value=>"Continue").click }
  element(:type) { |b| b.frm.select(:id=>"item.type") }
  element(:name) { |b| b.frm.text_field(:id=>"item.name-id") }
  element(:title) { |b| b.frm.text_field(:id=>"item.title-id") }
  element(:description) { |b| b.frm.text_field(:id=>"item.description-id") }
  action(:add_to_list) { |b| b.frm.button(:value=>"Add To List").click }
  element(:image) { |b| b.frm.checkbox(:id=>"image-id") }

end

#
class SupportingFilesPortfolio < BasePage

  frame_element

  action(:finish) { |b| b.frm.button(:value=>"Finish").click }
  action(:select_file) { |b| b.frm.link(:text=>"Select File").click }
  action(:add_to_list) { |b| b.frm.button(:value=>"Add To List").click }
  element(:name) { |b| b.frm.text_field(:id=>"fileRef.usage-id") }

end