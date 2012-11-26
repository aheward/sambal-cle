#================
# Styles pages in a Portfolio Site
#================

# 
class Styles < BasePage

  frame_element
  
  # Clicks the Add link and
  # instantiates the AddStyle Class.
  action(:add) { |b| b.frm.link(:text=>"Add").click }

end

# 
class AddStyle < BasePage

  frame_element
  
  # Clicks the Add Style button and
  # instantiates the Styles Class.
  action(:add_style) { |b| b.frm.button(:value=>"Add Style").click }
  
  # Clicks the "Select File" link and
  # instantiates the StylesAddAttachment Class.
  action(:select_file) { |b| b.frm.link(:text=>"Select File").click }

  element(:name) { |b| b.frm.text_field(:id=>"name-id") }
  element(:description) { |b| b.frm.text_field(:id=>"descriptionTextArea") }

end



