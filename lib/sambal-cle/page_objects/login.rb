#================
# Login Page
#================

# This is the page where users log in to the site.
class Login < BasePage

  def search_public_courses_and_projects
    @browser.frame(:index=>0).link(:text=>"Search Public Courses and Projects").click
  end

  # Logs in to Sakai using the
  # specified credentials. Then it
  # instantiates the MyWorkspace class.
  def login(username, password)
    frame = @browser.frame(:id, "ifrm")
    frame.text_field(:id, "eid").set username
    frame.text_field(:id, "pw").set password
    frame.form(:method, "post").submit
  end

end