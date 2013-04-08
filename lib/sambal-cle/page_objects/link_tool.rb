class LinkTool < BasePage

  action(:open_site) { |name, b| b.use_linktool; b.sites_frame.link(text: name).click }

  # Note that this method assumes the child window is already active and the folder link is
  # in view...
  action(:open_folder) { |name, b| b.link(text: name).click }

  def self.link_getter(name)
    define_method "get_#{name}_link" do |item|
      use_linktool
      send("toggle_#{name}s")
      direct_link = link_html(item)
      close_linktool
      return direct_link[/(?<=onclick=\"LinkItem\(').+(?=')/]
    end
  end

  link_getter :forum
  link_getter :topic
  link_getter :resource
  link_getter :assessment
  link_getter :assignment

  # ========
  private
  # ========

  action(:use_linktool) { |b| b.window(title: 'Server Browser').use; b.links_frame.wait_until_present }
  action(:close_linktool) { |b| b.windows.last.close; b.windows.first.use }
  action(:toggle_assignments) { |b| b.links_frame.image(id: 'imgAssignments').click }
  action(:toggle_forums) { |b| b.links_frame.image(id: 'imgForums').click }
  alias_method :toggle_topics, :toggle_forums
  action(:toggle_resources) { |b| b.links_frame.image(id: 'imgResources').click }
  action(:toggle_assessments) { |b| b.links_frame.image(id: 'imgAssessments').click }
  action(:link_html) { |name, b| b.links_frame.link(text: name).html }
  element(:sites_frame) { |b| b.frame(name: 'frmFolders') }
  element(:links_frame) { |b| b.frame(name: 'frmResourcesList') }

end