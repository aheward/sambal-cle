class Profile2Base <  BasePage

  frame_element

  class << self

    def profile2_elements
      action(:preferences) { |b| b.frm.link(:class=>"icon preferences").click }
      action(:privacy) { |b| b.frm.link(:text=>"Privacy").click }
      action(:my_profile) { |b| b.frm.link(:text=>"My profile").click }
      action(:connections) { |b| b.frm.link(:class=>"icon connections").click }
      action(:pictures) { |b| b.frm.link(:text=>"Pictures").click }
      action(:messages) { |b| b.frm.link(:text=>"Messages").click }
      action(:search_for_connections) { |b| b.frm.link(:class=>"icon search").click }
    end

  end

end
#
class Profile2 < Profile2Base

  profile2_elements

  element(:main_panel) { |b| b.frm.div(:id=>"mainPanel") }
  
  def edit_basic_info
    main_panel.span(:text=>"Basic Information").fire_event("onmouseover")
    main_panel.link(:href=>/myInfo:editButton/).click
  end

  def edit_contact_info
    main_panel.span(:text=>"Contact Information").fire_event("onmouseover")
    main_panel.link(:href=>/myContact:editButton/).click
  end

  def edit_staff_info
    main_panel.span(:text=>"Staff Information").fire_event("onmouseover")
    main_panel.link(:href=>/myStaff:editButton/).click
  end

  def edit_student_info
    main_panel.span(:text=>"Student Information").fire_event("onmouseover")
    main_panel.link(:href=>/myStudent:editButton/).click
  end

  def edit_social_networking
    main_panel.span(:text=>"Social Networking").fire_event("onmouseover")
    main_panel.link(:href=>/mySocialNetworking:editButton/).click
  end

  def edit_personal_info
    main_panel.span(:text=>"Personal Information").fire_event("onmouseover")
    main_panel.link(:href=>/myInterests:editButton/).click
  end

  def change_picture
    frm.div(:id=>"myPhoto").fire_event("onmouseover")
    frm.div(:id=>"myPhoto").link(:class=>"edit-image-button").click
  end

  # Enters the specified filename in the file field.
  #
  # Note that the file should be inside the data/sakai-cle-test-api folder.
  # The file or folder name used for the filename variable
  # should not include a preceding slash ("/") character.
  # TODO: This needs to be updated to use the filename plus filepath pattern.
  def image_file=(filename)
    frm.file_field(:name=>"picture").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle-test-api/" + filename)
  end

  action(:upload) { |b| b.frm.button(:value=>"Upload").click }

  def personal_summary=(text)
    frm.frame(:id=>"id1a_ifr").send_keys([:command, 'a'], :backspace)
    frm.frame(:id=>"id1a_ifr").send_keys(text)
  end

  def birthday(day, month, year)
    frm.text_field(:name=>"birthdayContainer:birthday").click
    frm.select(:class=>"ui-datepicker-new-year").wait_until_present
    frm.select(:class=>"ui-datepicker-new-year").select(year.to_i)
    frm.select(:class=>"ui-datepicker-new-month").select(month)
    frm.link(:text=>day.to_s).click
  end

  action(:save_changes) { |b| b.frm.button(:value=>"Save changes").click }

  # Returns the number (as a string) displayed next to
  # the "Connections" link in the menu. If there are no
  # connections then returns zero as a string object.
  def connection_requests
    begin
      frm.link(:class=>/icon connections/).span(:class=>"new-items-count").text
    rescue
      return "0"
    end
  end

  element(:say_something) { |b| b.frm.text_field(:id=>"id1") }
  action(:say_it) { |b| b.frm.button(:value=>"Say it").click }
    # Basic Information
  element(:nickname) { |b| b.frm.text_field(:name=>"nicknameContainer:nickname") }
    # Contact Information
  element(:email) { |b| b.frm.text_field(:name=>"emailContainer:email") }
  element(:home_page) { |b| b.frm.text_field(:name=>"homepageContainer:homepage") }
  element(:work_phone) { |b| b.frm.text_field(:name=>"workphoneContainer:workphone") }
  element(:home_phone) { |b| b.frm.text_field(:name=>"homephoneContainer:homephone") }
  element(:mobile_phone) { |b| b.frm.text_field(:name=>"mobilephoneContainer:mobilephone") }
  element(:facsimile) { |b| b.frm.text_field(:name=>"facsimileContainer:facsimile") }
  # Someday Staff Info fields should go here...

    # Student Information
  element(:degree_course) { |b| b.frm.text_field(:name=>"courseContainer:course") }
  element(:subjects) { |b| b.frm.text_field(:name=>"subjectsContainer:subjects") }
    # Social Networking

    # Personal Information
  element(:favorite_books) { |b| b.frm.text_field(:name=>"booksContainer:favouriteBooks") }
  element(:favorite_tv_shows) { |b| b.frm.text_field(:name=>"tvContainer:favouriteTvShows") }
  element(:favorite_movies) { |b| b.frm.text_field(:name=>"moviesContainer:favouriteMovies") }
  element(:favorite_quotes) { |b| b.frm.text_field(:name=>"quotesContainer:favouriteQuotes") }

end

#
class Profile2Preferences < Profile2Base

  profile2_elements

end

class Profile2Privacy < Profile2Base

  profile2_elements

  element(:profile_image) { |b| b.frm.select(:name=>"profileImageContainer:profileImage") }
  element(:basic_info) { |b| b.frm.select(:name=>"basicInfoContainer:basicInfo") }
  element(:contact_info) { |b| b.frm.select(:name=>"contactInfoContainer:contactInfo") }
  element(:staff_info) { |b| b.frm.select(:name=>"staffInfoContainer:staffInfo") }
  element(:student_info) { |b| b.frm.select(:name=>"studentInfoContainer:studentInfo") }
  element(:social_info) { |b| b.frm.select(:name=>"socialNetworkingInfoContainer:socialNetworkingInfo") }
  element(:personal_info) { |b| b.frm.select(:name=>"personalInfoContainer:personalInfo") }
  element(:view_connections) { |b| b.frm.select(:name=>"myFriendsContainer:myFriends") }
  element(:see_status) { |b| b.frm.select(:name=>"myStatusContainer:myStatus") }
  element(:view_pictures) { |b| b.frm.select(:name=>"myPicturesContainer:myPictures") }
  element(:send_messages) { |b| b.frm.select(:name=>"messagesContainer:messages") }
  element(:see_kudos_rating) { |b| b.frm.select(:name=>"myKudosContainer:myKudos") }
  element(:show_birth_year) { |b| b.frm.checkbox(:name=>"birthYearContainer:birthYear") }
  action(:save_settings) { |b| b.frm.button(:value=>"Save settings").click }

end

class Profile2Search < Profile2Base

  profile2_elements

  action(:search_by_name_or_email) { |b| b.frm.button(:value=>"Search by name or email").click }
  action(:search_by_common_interest) { |b| b.frm.button(:value=>"Search by common interest").click }

  def add_as_connection(name)
    frm.div(:class=>"search-result", :text=>/#{Regexp.escape(name)}/).link(:class=>"icon connection-add").click
    frm.div(:class=>"modalWindowButtons").wait_until_present
    frm.div(:class=>"modalWindowButtons").button(:value=>"Add connection").click
    frm.div(:class=>"modalWindowButtons").wait_while_present
  end

  action(:view) { |name, b| b.frm.link(:text=>name).click }

  # Returns an array containing strings of the names of the users returned
  # in the search.
  def results
    results = []
    frm.div(:class=>"portletBody").spans.each do |span|
      if span.class_name == "search-result-info-name"
        results << span.text
      end
    end
    return results
  end

  action(:clear_results) { |b| b.frm.button(:value=>"Clear results").click }
  element(:persons_name_or_email) { |b| b.frm.text_field(:name=>"searchName") }
  element(:common_interest) { |b| b.frm.text_field(:name=>"searchInterest") }

end

class Profile2Connections < Profile2Base

  profile2_elements

  def confirm_request(name)
    frm.div(:class=>"connection", :text=>name).link(:title=>"Confirm connection request").click
    frm.div(:class=>"modalWindowButtons").wait_until_present
    frm.div(:class=>"modalWindowButtons").button(:value=>"Confirm connection request").click
    frm.div(:class=>"modalWindowButtons").wait_while_present
  end

  # Returns an array containing the names of the connected users.
  def connections
    results = []
    frm.div(:class=>"portletBody").spans.each do |span|
      if span.class_name == "connection-info-name"
        results << span.text
      end
    end
    return results
  end

end

class Profile2View < Profile2Base

  profile2_elements
  #
  value(:connection) { |b| b.frm.div(:class=>"leftPanel").span(:class=>/instruction icon/).text }

  #
  def basic_information
    hash = {}
    begin
      frm.div(:class=>"mainSection", :text=>/Basic Information/).table(:class=>"profileContent").rows.each do |row|
        hash.store(row[0].text, row[1].text)
      end
    rescue Watir::Exception::UnknownObjectException
    end
    return hash
  end

  #
  def contact_information
    hash = {}
    begin
      frm.div(:class=>"mainSection", :text=>/Contact Information/).table(:class=>"profileContent").rows.each do |row|
        hash.store(row[0].text, row[1].text)
      end
    rescue Watir::Exception::UnknownObjectException
    end
    return hash
  end

  #
  def staff_information
    hash = {}
    begin
      frm.div(:class=>"mainSection", :text=>/Staff Information/).table(:class=>"profileContent").rows.each do |row|
        hash.store(row[0].text, row[1].text)
      end
    rescue Watir::Exception::UnknownObjectException
    end
    return hash
  end

  #
  def student_information
    hash = {}
    begin
      frm.div(:class=>"mainSection", :text=>/Student Information/).table(:class=>"profileContent").rows.each do |row|
        hash.store(row[0].text, row[1].text)
      end
    rescue Watir::Exception::UnknownObjectException
    end
    return hash
  end

  #
  def personal_information
    hash = {}
    begin
      frm.div(:class=>"mainSection", :text=>/Personal Information/).table(:class=>"profileContent").rows.each do |row|
        hash.store(row[0].text, row[1].text)
      end
    rescue Watir::Exception::UnknownObjectException
    end
    return hash
  end
end