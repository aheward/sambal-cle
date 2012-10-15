#================
# Login Page
#================

# This is the page where users log in to the site.
class Login < BasePage

<<<<<<< HEAD
<<<<<<< HEAD
  page_url $base_url

  action(:search_public_courses_and_projects) { |b| b.frame(:index=>0).link(:text=>"Search Public Courses and Projects").click }
=======
  def search_public_courses_and_projects
    @browser.frame(:index=>0).link(:text=>"Search Public Courses and Projects").click
  end
>>>>>>> 20d9a61... Now working on the Assignments Submissions Spec.  Small tweaks to other scripts because of a change to the basic log_in method.
=======
  page_url $base_url

  action(:search_public_courses_and_projects) { |b| b.frame(:index=>0).link(:text=>"Search Public Courses and Projects").click }
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.

  # Logs in to Sakai using the
  # specified credentials. Then it
  # instantiates the MyWorkspace class.
  def login_with username, password
    frame = @browser.frame(:id, "ifrm")
    frame.text_field(:id, "eid").set username
    frame.text_field(:id, "pw").set password
    frame.form(:method, "post").submit
  end

end