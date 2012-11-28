#===============
# Podcast pages
#================

#
class Podcasts < BasePage

  frame_element

  link "Add"

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