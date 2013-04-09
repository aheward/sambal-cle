class RwikiBase < BasePage

  frame_element
  class << self
    def menu_elements
      action(:home) { |b| b.frm.link(id: 'homelink').click }
      action(:view) { |b| b.frm.link(id: 'viewLink').click }
      action(:edit) { |b| b.frm.link(id: 'editLink').click }
      action(:info) { |b| b.frm.link(id: 'infoLink').click }
      action(:history) { |b| b.frm.link(id: 'historyLink').click }
      action(:watch) { |b| b.frm.link(id: 'watchLink').click }
      element(:search_field) { |b| b.frm.text_field(id: 'searchField') }
      element(:rss_link) { |b| b.frm.link(id: 'rssLink') }
    end
  end
end

class Rwiki < RwikiBase

  menu_elements

  element(:content) { |b| b.frm.text_field(id: "content") }
  button 'Save'
  button 'Cancel'

  action(:open_wiki) { |title, b| b.frm.link(:text=>title).click }

  action(:wiki_href) { |title, b| b.frm.link(:text=>title).href }

end