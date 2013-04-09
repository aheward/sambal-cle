class BasePage < PageFactory

  class << self

    def frame_element
      element(:frm) { |b| b.frame(:class=>'portletMainIframe') }
    end

    def basic_page_elements
      # Returns the text of the error message box
      value(:alert_box) { |b| b.frm.div(:class=>'alertMessage').text }
      # Returns the text of the header.
      value(:header) { |b| b.frm.div(:class=>'portletBody').h3.text }
      button('Cancel')
      button('Save')
      button('Back')
    end

    def link(link_text)
      element(damballa(link_text+'_link')) { |b| b.frm.link(:text=>link_text) }
      action(damballa(link_text)) { |b| b.frm.link(:text=>link_text).click }
    end

    def button(button_text)
      element(damballa(button_text+'_button')) { |b| b.frm.button(:value=>button_text) }
      action(damballa(button_text)) { |b| b.frm.button(:value=>button_text).click }
    end

    def damballa(text)
      text.gsub(/([+=|\\\.~@#'"\?`!\{\}\[\]\$%\^&\*\(\)])/, "").
          gsub(/([-\/\ ])/,"_").
          downcase.
          to_sym
    end

    def cke_elements
      action(:editor) { |index=0, b| b.frm.table(class: 'cke_editor', index: index) }
      action(:source) { |index=0, b| b.editor(index).link(title: 'Source').click }
      action(:select_all) { |index=0, b| b.editor(index).link(title: 'Select All').click }
      action(:source_field) { |index=0, b| b.editor(index).text_field(class: 'cke_source cke_enable_context_menu') }
      action(:rich_text_field) { |editor_name, b| b.frm.frame(title: "Rich text editor, #{editor_name}, press ALT 0 for help.") }
      action(:open_link_tool) { |index=0, b|
        b.editor(index).link(title: 'Link').click
        b.frm.link(title: 'Browse Server', index: index).wait_until_present
        b.frm.link(title: 'Browse Server', index: index).click
        }
      action(:url_field) { |index=0, b| b.frm.label(text: 'URL', index: index).parent.text_field }
    end

    # Any additional needed element group defs go here...

  end

end
