# The page where you search for public courses and projects.
class SearchPublic < BasePage

  frame_element

  action(:home) { |b| b.frame(:index=>0).link(:text=>"Home").click }
  element(:search_for) { |b| b.frame(:index=>0).text_field(:id=>"searchbox") }
  action(:search_for_sites) { |b| b.frame(:index=>0).button(:value=>"Search for Sites").click }

end

# The page showing the results list of Site matches to a search of public sites/projects.
class SearchPublicResults < BasePage

  frame_element

  action(:click_site) { |site_name, b| b.frame(:index=>0).link(:text=>site_name).click }
  action(:home) { |b| b.frame(:id=>"ifrm").link(:text=>"Home").click }

end

# The page that appears when you click a Site in the Site Search Results page, when not logged
# in to Sakai.
class SiteSummaryPage < BasePage

  frame_element

  action(:return_to_list) { |b| b.frame(:index=>0).button(:value=>"Return to List").click }

  def syllabus_attachments
    links = []
    @browser.frame(:id=>"ifrm").links.each do |link|
      if link.href=~/Syllabus/
        links << link.text
      end
    end
    return links
  end

end