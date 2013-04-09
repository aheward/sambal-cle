#================
# Administrative Search Pages
#================

# The Search page in the Administration Workspace - "icon-sakai-search"
class Search < BasePage

  frame_element

  link 'Admin'
  element(:search_field) { |b| b.frm.text_field(:id=>'search') }
  action(:search_button) { |b| b.frm.button(:name=>'sb').click }
  element(:this_site) { |b| b.frm.radio(:id=>'searchSite') }
  element(:all_my_sites) { |b| b.frm.radio(:id=>'searchMine') }

end


# The Search Admin page within the Search page in the Admin workspace
class SearchAdmin < BasePage

  frame_element

  link 'Search'
  link 'Rebuild Site Index'
  link 'Refresh Site Index'
  link 'Rebuild Whole Index'
  link 'Refresh Whole Index'
  link 'Remove Lock'
  link 'Reload Index'
  link 'Enable Diagnostics'
  link 'Disable Diagnostics'

end