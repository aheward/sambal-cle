#================
# Profile Pages
#================

#
class Profile < BasePage

  frame_element

  link "Edit my Profile"
  link "Show my Profile"

  def photo
    source = frm.image(:id=>"profileForm:image1").src
    return source.split("/")[-1]
  end

  action(:email) { |b| b.frm.link(:id=>"profileForm:email").text }

end

#
class EditProfile < BasePage

  frame_element

  button "Save"

  def picture_file(filename, filepath="")
    frm.file_field(:name=>"editProfileForm:uploadFile.uploadId").set(filepath + filename)
  end

  element(:first_name) { |b| b.frm.text_field(:id=>"editProfileForm:first_name") }
  element(:last_name) { |b| b.frm.text_field(:id=>"editProfileForm:lname") }
  element(:nickname) { |b| b.frm.text_field(:id=>"editProfileForm:nickname") }
  element(:position) { |b| b.frm.text_field(:id=>"editProfileForm:position") }
  element(:email) { |b| b.frm.text_field(:id=>"editProfileForm:email") }
  element(:upload_new_picture) { |b| b.frm.radio(:value=>"pictureUpload") }

end