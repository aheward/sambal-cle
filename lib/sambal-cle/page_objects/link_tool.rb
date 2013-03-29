class LinkTool < BasePage

  action(:open_site) { |name, b| b.use_linktool; b.sites_frame.link(text: name).click }
  action(:get_assignment_link) { |name, b| b.use_linktool; b.toggle_assignments; b.click_link(name) }
  action(:get_forum_link) { |name, b| b.use_linktool; b.toggle_forums; b.click_link(name) }
  alias_method :get_topic_link, :get_forum_link
  action(:get_resource_link) { |name, b| b.use_linktool; b.toggle_resources; b.click_link(name) }
  action(:get_assessment_link) { |name, b| b.use_linktool; b.toggle_assessments; b.click_link(name) }

  # ========
  private
  # ========

  element(:sites_frame) { |b| b.frame(name: 'frmFolders') }
  element(:links_frame) { |b| b.frame(name: 'frmResourcesList') }
  action(:use_linktool) { |b| b.windows.last.use }
  action(:switch_back) { |b| b.windows.first.use }
  action(:toggle_assignments) { |b| b.links_frame.image(id: 'imgAssignments').click }
  action(:toggle_forums) { |b| b.links_frame.image(id: 'imgForums').click }
  action(:toggle_resources) { |b| b.links_frame.image(id: 'imgResources').click }
  action(:toggle_assessments) { |b| b.links_frame.image(id: 'imgAssessments').click }
  action(:click_link) { |name, b| b.links_frame.link(text: name).click; b.switch_back }

end