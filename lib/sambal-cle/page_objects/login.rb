#================
# Login Page
#================

# This is the page where users log in to the site.
class Login < BasePage

  page_url $base_url

  element(:user_id) { |b| b.text_field(id: 'eid') }
  element(:password) { |b| b.text_field(id: 'pw') }
  action(:login) { |b| b.button(id: 'submit') }

end