class BasePage < PageFactory

  class << self

    def frame_element
      element(:frm) { |b| b.frame(:class=>"portletMainIframe") }
    end

    def basic_page_elements
      # Returns the text of the error message box
      value(:alert_box) { |b| b.frm.div(:class=>"alertMessage").text }
      # Returns the text of the header.
      value(:header) { |b| b.frm.div(:class=>"portletBody").h3.text }
      button("Cancel")
      button("Save")
      button("Back")
    end

    def link(link_text)
      element(snakify(link_text+"_link")) { |b| b.frm.link(:text=>link_text) }
      action(snakify(link_text)) { |b| b.frm.link(:text=>link_text).click }
    end

    def button(button_text)
      element(snakify(button_text+"_button")) { |b| b.frm.button(:value=>button_text) }
      action(snakify(button_text)) { |b| b.frm.button(:value=>button_text).click }
    end

    def snakify(text)
      text.gsub(/([+=|\\\.~@#'"\?`!\{\}\[\]\$%\^&\*\(\)])/, "").
          gsub(/([-\/\ ])/,"_").
          downcase.
          to_sym
    end

    # Any additional needed element group defs go here...

  end

end
