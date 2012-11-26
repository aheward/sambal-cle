#===============
# Podcast pages
#================

#
class Podcasts < BasePage

  frame_element

  action(:add) { |b| b.frm.link(:text=>"Add").click }

  def podcast_titles
    titles = []
    frm.spans.each do |span|
      if span.class_name == "podTitleFormat"
        titles << span.text
      end
    end
    return titles
  end

end