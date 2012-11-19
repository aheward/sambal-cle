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
      element(:cancel_button) { |b| b.frm.button(:value=>"Cancel") }
      action(:cancel) { |p| p.cancel_button.click }
      action(:save) { |b| b.frm.button(:value=>"Save").click }
      action(:back) {|b| b.button(:value=>"Back").click }
    end

    # More element group defs go here...

  end

end
