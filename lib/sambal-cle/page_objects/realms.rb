#================
# Realms Pages
#================

# Realms page
class Realms < BasePage

  frame_element

  link('New Realm')
  link('Search')
  element(:select_page_size) { |b| b.frm.select_list(:name=>'selectPageSize') }
  action(:next) { |b| b.frm.button(:name=>'eventSubmit_doList_next').click }
  action(:last) { |b| b.frm.button(:name=>'eventSubmit_doList_last').click }
  action(:previous) { |b| b.frm.button(:name=>'eventSubmit_doList_prev').click }
  action(:first) { |b| b.frm.button(:name=>'eventSubmit_doList_first').click }


end