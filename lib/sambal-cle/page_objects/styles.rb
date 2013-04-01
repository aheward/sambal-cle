#================
# Styles pages in a Portfolio Site
#================

# 
class Styles < BasePage

  frame_element

  link 'Add'

end

# 
class AddStyle < BasePage

  frame_element

  button 'Add Style'

  link 'Select File'

  element(:name) { |b| b.frm.text_field(:id=>'name-id') }
  element(:description) { |b| b.frm.text_field(:id=>'descriptionTextArea') }

end



