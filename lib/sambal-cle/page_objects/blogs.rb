class BlogsBase < BasePage

  frame_element

  class << self
    def menu_elements
      # AddBlogEntry
      link 'Add blog entry'
    end
  end
end

class Blogs < BlogsBase

  menu_elements

  # Returns an array containing the list of Bloggers
  # in the 'All the blogs' table.
  def blogger_list
    bloggers = []
    frm.table(:class=>'listHier lines').rows.each do |row|
      bloggers << row[1].text
    end
    bloggers.delete_at(0)
    return bloggers
  end
end

class AddBlogEntry < BlogsBase

  menu_elements
  cke_elements

  expected_element :editor

  ##TODO: Keep tabs on the status of the blog tool's need for the cke_editor

  def blog_text=(text)
    rich_text_field.wait_until_present
    rich_text_field.send_keys(text)
  end

  button 'Publish entry'
  button 'Save Draft'

  element(:title) { |b| b.frm.text_field(:name=>'title-input') }
  element(:only_site_admins) { |b| b.frm.radio(:id=>'instructors-only-radio') }
  element(:all_members) { |b| b.frm.radio(:id=>'all-members-radio') }
  element(:publicly_viewable) { |b| b.frm.radio(:id=>'public-viewable-radio') }

end

class BlogsList < BlogsBase

  menu_elements

end