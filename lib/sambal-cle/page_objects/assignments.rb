
# TODO: There's a lot of cleanup that can be done with the code in these
# classes--and it's probably even possible to completely eliminate one
# or more of them. I'm looking at YOU, AssignmentStudentPreview and AssignmentPreview.
# We could probably make an AssignmentViewBase class with a set of common elements--that's
# assuming we even need more than one generic View class, and it might turn out that
# we don't--unless we need one for students and one for instructors. Note that the
# elimination and/or renaming of classes and methods will break the assignments_submissions_spec
# (among others), so refactor with care (and use RubyMine to help).

#================
# Assignments Pages
#================

class AssignmentsBase < BasePage

  frame_element

  class << self

    def menu_elements
      action(:add_assignment) { |b| b.frm.link(:text=>"Add").click }
      action(:assignment_list) { |b| b.frm.link(:text=>"Assignment List").click }
      action(:grade_report) { |b| b.frm.link(:text=>"Grade Report").click }
      action(:student_view) { |b| b.frm.link(:text=>"Student View").click }
      action(:permissions) { |b| b.frm.link(:text=>"Permissions").click }
      action(:options) { |b| b.frm.link(:text=>"Options").click }
    end

    def listview_elements
      element(:select_page_size) { |b| b.frm.select(:name=>"selectPageSize") }
      action(:next) { |b| b.frm.button(:name=>"eventSubmit_doList_next").click }
      action(:last) { |b| b.frm.button(:name=>"eventSubmit_doList_last").click }
      action(:previous) { |b| b.frm.button(:name=>"eventSubmit_doList_prev").click }
      action(:first) { |b| b.frm.button(:name=>"eventSubmit_doList_first").click }
    end

  end

end

# The page where you create a new assignment
class AssignmentAdd < AssignmentsBase

  include FCKEditor
  menu_elements

  expected_element :editor

  # Clicks the Post button, then
  # next is the AssignmentsList page class.
  action(:post) { |b| b.frm.button(:value=>"Post").click }

  # Clicks the Cancel button, then
  # next is the AssignmentsList page class.
  action(:cancel) { |b| b.frm.button(:value=>"Cancel", :index=>-1).click }

  # Clicks the Save Draft button, then
  # next is the AssignmentsList page class.
  action(:save_draft) { |b| b.frm.button(:name=>"save").click }

  # Grabs the text contained in the alert box when
  # it is present on the page (will throw an error if
  # called when the box is not present).
  value(:alert_text) { |b| b.frm.div(:class=>"portletBody").div(:class=>"alertMessage").text }

  element(:editor) { |b| b.frm.frame(:id, "new_assignment_instructions___Frame") }

  # Sends the specified text to the text box in the FCKEditor
  # on the page.
  def instructions=(instructions)
    editor.td(:id, "xEditingArea").frame(:index=>0).send_keys([:command, 'a'], :backspace)
    editor.td(:id, "xEditingArea").frame(:index=>0).send_keys(instructions)
  end

  # Clicks the Preview button, next is
  # the AssignmentsPreview page class.
  action(:preview) { |b| b.frm.button(:value=>"Preview").click }

  # This is the warning message that appears when you
  # select to add an assignment to the gradebook.
  element(:gradebook_warning) { |b| b.frm.div(:class, "portletBody").span(:id, "gradebookListWarnAssoc") }

  # Clicks the Add Attachments button, then
  # next is the AssignmentAttachments page class.
  action(:add_attachments) { |b| b.frm.button(:value=>"Add Attachments").click }

  element(:assignment_id) { |b| b.frm.hidden(:name=>"assignmentId") }

  element(:title) { |b| b.frm.text_field(:id=>"new_assignment_title") }
  element(:open_month) { |b| b.frm.select(:id=>"new_assignment_openmonth") }
  element(:open_day) { |b| b.frm.select(:id=>"new_assignment_openday") }
  element(:open_year) { |b| b.frm.select(:id=>"new_assignment_openyear") }
  element(:open_hour) { |b| b.frm.select(:id=>"new_assignment_openhour") }
  element(:open_minute) { |b| b.frm.select(:id=>"new_assignment_openmin") }
  element(:open_meridian) { |b| b.frm.select(:id=>"new_assignment_openampm") }
  element(:due_month) { |b| b.frm.select(:id=>"new_assignment_duemonth") }
  element(:due_day) { |b| b.frm.select(:id=>"new_assignment_dueday") }
  element(:due_year) { |b| b.frm.select(:id=>"new_assignment_dueyear") }
  element(:due_hour) { |b| b.frm.select(:id=>"new_assignment_duehour") }
  element(:due_minute) { |b| b.frm.select(:id=>"new_assignment_duemin") }
  element(:due_meridian) { |b| b.frm.select(:id=>"new_assignment_dueampm") }
  element(:accept_month) { |b| b.frm.select(:id=>"new_assignment_closemonth") }
  element(:accept_day) { |b| b.frm.select(:id=>"new_assignment_closeday") }
  element(:accept_year) { |b| b.frm.select(:id=>"new_assignment_closeyear") }
  element(:accept_hour) { |b| b.frm.select(:id=>"new_assignment_closehour") }
  element(:accept_minute) { |b| b.frm.select(:id=>"new_assignment_closemin") }
  element(:accept_meridian) { |b| b.frm.select(:id=>"new_assignment_closeampm") }
  element(:student_submissions) { |b| b.frm.select(:id=>"subType") }
  element(:grade_scale) { |b| b.frm.select(:id=>"new_assignment_grade_type") }
  element(:allow_resubmission) { |b| b.frm.checkbox(:id=>"allowResToggle") }
  element(:num_resubmissions) { |b| b.frm.form(:name=>"newAssignmentForm").select(:id=>"allowResubmitNumber") }
  element(:resub_until_month) { |b| b.frm.form(:name=>"newAssignmentForm").select(:id=>"allow_resubmit_closeMonth") }
  element(:resub_until_day) { |b| b.frm.form(:name=>"newAssignmentForm").select(:id=>"allow_resubmit_closeDay") }
  element(:resub_until_year) { |b| b.frm.form(:name=>"newAssignmentForm").select(:id=>"allow_resubmit_closeYear") }
  element(:resub_until_hour) { |b| b.frm.form(:name=>"newAssignmentForm").select(:id=>"allow_resubmit_closeHour") }
  element(:resub_until_minute) { |b| b.frm.form(:name=>"newAssignmentForm").select(:id=>"allow_resubmit_closeMin") }
  element(:resub_until_meridian) { |b| b.frm.form(:name=>"newAssignmentForm").select(:id=>"allow_resubmit_closeAMPM") }
  element(:max_points) { |b| b.frm.text_field(:name=>"new_assignment_grade_points") }
  element(:add_due_date) { |b| b.frm.checkbox(:id=>"new_assignment_check_add_due_date") }
  element(:add_open_announcement) { |b| b.frm.checkbox(:id=>"new_assignment_check_auto_announce") }
  element(:add_honor_pledge) { |b| b.frm.checkbox(:id=>"new_assignment_check_add_honor_pledge") }

  element(:use_turnitin) { |b| b.frm.checkbox(:id=>"new_assignment_use_review_service") }
  element(:allow_students_to_view_report) { |b| b.frm.checkbox(:id=>"new_assignment_allow_student_view") }

  element(:do_not_add_to_gradebook) { |b| b.frm.radio(:id=>"no",:name=>"new_assignment_add_to_gradebook") }
  element(:add_to_gradebook) { |b| b.frm.radio(:id=>"add", :name=>"new_assignment_add_to_gradebook") }
  element(:do_not_send_notifications) { |b| b.frm.radio(:id=>"notsendnotif") }
  element(:send_notifications) { |b| b.frm.radio(:id=>"sendnotif") }
  element(:send_summary_email) { |b| b.frm.radio(:id=>"sendnotifsummary") }
  element(:do_not_send_grade_notif) { |b| b.frm.radio(:id=>"notsendreleasegradenotif") }
  element(:send_grade_notif) { |b| b.frm.radio(:id=>"sendreleasegradenotif") }
  action(:add_model_answer) { |b| b.frm.link(:id=>"modelanswer_add").click }
  action(:add_private_note) { |b| b.frm.link(:id=>"note_add").click }
  action(:add_all_purpose_item) { |b| b.frm.link(:id=>"allPurpose_add").click }

  element(:model_answer) { |b| b.frm.text_field(:id=>"modelanswer_text") }
  action(:model_answer_attach) { |b| b.frm.button(:name=>"modelAnswerAttach").click }
  element(:show_model_answer) { |b| b.frm.select(:id=>"modelanswer_to") }
  action(:save_model_answer) { |b| b.frm.button(:id=>"modelanswer_save").click }
  action(:cancel_model_answer) { |b| b.frm.button(:id=>"modelanswer_cancel").click }
  element(:private_note) { |b| b.frm.text_field(:id=>"note_text") }
  element(:share_note_with) { |b| b.frm.select(:id=>"note_to") }
  action(:save_note) { |b| b.frm.button(:id=>"note_save").click }
  action(:cancel_note) { |b| b.frm.button(:id=>"note_cancel").click }
  element(:all_purpose_title) { |b| b.frm.text_field(:id=>"allPurpose_title") }
  element(:all_purpose_text) { |b| b.frm.text_field(:id=>"allPurpose_text") }
  action(:add_all_purpose_attachments) { |b| b.frm.button(:id=>"allPurposeAttach").click }
  element(:show_this_all_purpose_item) { |b| b.frm.radio(:id=>"allPurposeHide1") }
  element(:hide_this_all_purpose_item) { |b| b.frm.radio(:id=>"allPurposeHide2") }
  element(:show_from) { |b| b.frm.checkbox(:id=>"allPurposeShowFrom") }
  element(:show_until) { |b| b.frm.checkbox(:id=>"allPurposeShowTo") }
  element(:show_from_month) { |b| b.frm.select(:id=>"allPurpose_releaseMonth") }
  element(:show_from_day) { |b| b.frm.select(:id=>"allPurpose_releaseDay") }
  element(:show_from_year) { |b| b.frm.select(:id=>"allPurpose_releaseYear") }
  element(:show_from_hour) { |b| b.frm.select(:id=>"allPurpose_releaseHour") }
  element(:show_from_minute) { |b| b.frm.select(:id=>"allPurpose_releaseMin") }
  element(:show_from_meridian) { |b| b.frm.select(:id=>"allPurpose_releaseAMPM") }
  element(:show_until_month) { |b| b.frm.select(:id=>"allPurpose_retractMonth") }
  element(:show_until_day) { |b| b.frm.select(:id=>"allPurpose_retractDay") }
  element(:show_until_year) { |b| b.frm.select(:id=>"allPurpose_retractYear") }
  element(:show_until_hour) { |b| b.frm.select(:id=>"allPurpose_retractHour") }
  element(:show_until_minute) { |b| b.frm.select(:id=>"allPurpose_retractMin") }
  element(:show_until_meridian) { |b| b.frm.select(:id=>"allPurpose_retractAMPM") }
  action(:expand_guest_list) { |b| b.frm.link(:id=>"expand_1").click }
  action(:collapse_guest_list) { |b| b.frm.link(:id=>"collapse_1").click }
  action(:expand_TA_list) { |b| b.frm.link(:id=>"expand_2").click }
  action(:collapse_TA_list) { |b| b.frm.link(:id=>"collapse_2").click }
  action(:expand_instructor_list) { |b| b.frm.link(:id=>"expand_3").click }
  action(:collapse_instructor_list) { |b| b.frm.link(:is=>"collapse_3").click }

  # Note that only the "All" checkboxes are defined, since other items may or may not be there
  element(:all_guests) { |b| b.frm.checkbox(:id=>"allPurpose_Guest") }
  element(:all_TAs) { |b| b.frm.checkbox(:id=>"allPurpose_Teaching Assistant") }
  element(:all_instructors) { |b| b.frm.checkbox(:id=>"allPurpose_Instructor") }

end

# Page that appears when you first click the Assignments link
class AssignmentsList < AssignmentsBase

  menu_elements
  listview_elements
  alias :add :add_assignment

  expected_element :page_title

  # Returns an array of the displayed assignment titles.
  # Use for verification of test steps.
  def assignments_titles
    titles = []
    a_table = frm.table(:class=>"listHier lines nolines")
    1.upto(a_table.rows.size-1) do |x|
      titles << a_table[x][1].h4(:index=>0).text
    end
    return titles
  end
  alias assignment_titles assignments_titles
  alias assignment_list assignments_titles
  alias assignments_list assignments_titles

  # Clicks the Edit link for the assignment with the specified
  # id, then instantiates the AssignmentAdd page class.
  def edit_assignment_id(id)
    frm.link(:href=>/#{Regexp.escape(id)}/).click
  end

  # Clicks the Edit link for the Assignment specified.
  # next is the AssignmentAdd page class.
  def edit_assignment(assignment_name)
    index = assignments_titles.index(assignment_name)
    frm.link(:text=>"Edit", :index=>index).click
  end

  # Checks the appropriate checkbox, based on the specified assignment_name
  # Then clicks the Update button and confirms the deletion request.
  def delete(assignment_name)
    assignments_table.row(:text=>/#{Regexp.escape(assignment_name)}/).checkbox(:name=>"selectedAssignments").set
    frm.button(:value=>"Update").click
    frm.button(:value=>"Delete").click
  end

  # Clicks on the Duplicate link for the Assignment specified.
  # Then instantiates the AssignmentsList page class.
  def duplicate(assignment_name)
    index = assignments_titles.index(assignment_name)
    frm.link(:text=>"Duplicate", :index=>index).click
  end

  # Gets the assignment id from the href of the specified
  # Assignment link.
  def get_assignment_id(assignment_name)
    assignment_href(assignment_name) =~ /(?<=\/a\/\S{36}\/).+(?=&pan)/
    $~.to_s
  end

  def assignment_href(name)
    frm.link(:text=>/#{Regexp.escape(name)}/).href
  end

  # Checks the checkbox for the specified Assignment,
  # using the assignment id as the identifier.
  def check_assignment(id) #FIXME to use name instead of id.
    frm.checkbox(:value, /#{id}/).set
  end

  # Opens the specified assignment for viewing
  def open_assignment(assignment_name)
    frm.link(:text=>assignment_name).click
  end

  # Gets the contents of the status column
  # for the specified assignment
  def status_of(assignment_name)
    assignments_table.row(:text=>/#{Regexp.escape(assignment_name)}/).td(:headers=>"status").text
  end

  # Clicks the View Submissions link for the specified
  # Assignment, then instantiates the AssignmentSubmissionList
  # page class.
  def view_submissions_for(assignment_name)
    assignments_table.row(:text=>/#{Regexp.escape(assignment_name)}/).link(:text=>"View Submissions").click
  end

  # Clicks the Grade link for the specified Assignment,
  # then instantiates the AssignmentSubmissionList page class.
  def grade(assignment_name)
    assignments_table.row(:text=>/#{Regexp.escape(assignment_name)}/).link(:text=>"Grade").click
  end

  action(:sort_assignment_title) { |b| b.frm.link(:text=>"Assignment title").click }
  action(:sort_status) { |b| b.frm.link(:text=>"Status").click }
  action(:sort_open) { |b| b.frm.link(:text=>"Open").click }
  action(:sort_due) { |b| b.frm.link(:text=>"Due").click }
  action(:sort_in) { |b| b.frm.link(:text=>"In").click }
  action(:sort_new) { |b| b.frm.link(:text=>"New").click }
  action(:sort_scale) { |b| b.frm.link(:text=>"Scale").click }
  element(:view) { |b| b.frm.select(:id=>"view") }
  action(:update) { |b| b.frm.button(:name=>"eventSubmit_doDelete_confirm_assignment").click }

  element(:assignments_table) { |b| b.frm.table(:class=>"listHier lines nolines") }
  element(:page_title) { |b| b.frm.div(:class=>"portletBody").h3(:text=>"Assignment List") }

end

# The Permissions Page in Assignments
class AssignmentsPermissions < AssignmentsBase

  # Clicks the Save button, next is
  # the AssignmentsList page class.
  action(:save) {|b| b.frm.button(:value=>"Save").click }

  def self.chekbocks(*method_names)
    method_names.each do |method_name|
      define_method method_name do |role|
        self.frm.checkbox(:id=>"#{role}asn.#{method_name.to_s.gsub("_", ".")}")
      end
    end
  end

  chekbocks :all_groups, :new, :submit, :delete, :read, :revise, :grade, :receive_notifications, :share_drafts

  action(:undo_changes) { |b| b.frm.link(:text=>"Undo changes").click }
  action(:cancel) { |b| b.frm.button(:name=>"eventSubmit_doCancel").click }
  action(:permission) { |b| b.frm.link(:text=>"Permission").click }
  action(:guest) { |b| b.frm.link(:text=>"Guest").click }
  action(:instructor) { |b| b.frm.link(:text=>"Instructor").click }
  action(:student) { |b| b.frm.link(:text=>"Student").click }
  action(:teaching_assistant) { |b| b.frm.link(:text=>"Teaching Assistant").click }
  action(:same_permissions_for_all_groups) { |b| b.frm.link(:text=>"Same site level permissions for all groups inside the site").click }
  action(:create_new_assignments) { |b| b.frm.link(:text=>"Create new assignment(s)").click }
  action(:submit_to_assignments) { |b| b.frm.link(:text=>"Submit to assignment(s)").click }
  action(:delete_assignments) { |b| b.frm.link(:text=>"Delete assignment(s)").click }
  action(:read_assignments) { |b| b.frm.link(:text=>"Read Assignment(s)").click }
  action(:revise_assignments) { |b| b.frm.link(:text=>"Revise assignment(s)").click }
  action(:grade_submissions) { |b| b.frm.link(:text=>"Grade assignment submission(s)").click }
  action(:receive_email_notifications) { |b| b.frm.link(:text=>"Receive email notifications").click }
  action(:view_drafts_from_others) { |b| b.frm.link(:text=>"Able to view draft assignment(s) created by other users").click }

end

# Page that appears when you click to preview an Assignment
class AssignmentsPreview < AssignmentsBase

  menu_elements

  # Returns the text content of the page header
  def header
    frm.div(:class=>"portletBody").h3.text
  end

  # Returns a hash object containing the contents of the Item Summary table.
  # The hash's Key is the header column and the value is the content column.
  def item_summary
    hash = {}
    frm.table(:class=>"itemSummary").rows.each do |row|
      hash.store(row.th.text, row.td.text)
    end
    return hash
  end

  # Grabs the Assignment Instructions text.
  def assignment_instructions
    frm.div(:class=>"textPanel").text
  end

  # Grabs the instructor comments text.
  def instructor_comments
    frm.div(:class=>"portletBody").div(:class=>"textPanel", :index=>2).text
  end

  #
  def back_to_list
    frm.button(:value=>"Back to list").click
    AssignmentsList.new(@browser)
  end

  # Clicks the Post button, then instantiates
  # the AssignmentsList page class.
  def post
    frm.button(:name=>"post").click
    AssignmentsList.new(@browser)
  end

  # Clicks the Cancel button and instantiates the
  # AssignmentsList Class.
  def cancel
    frm.button(:value=>"Cancel").click
    AssignmentsList.new(@browser)
  end

  element(:assignment_id) { |b| b.frm.hidden(:name=>"assignmentId") }
  action(:hide_assignment) { |b| b.frm.link(:href=>/doHide_preview_assignment_assignment/).click }
  action(:show_assignment) { |b| b.frm.link(:href=>/doShow_preview_assignment_assignment/).click }
  action(:hide_student_view) { |b| b.frm.link(:href=>/doHide_preview_assignment_student_view/).click }
  action(:show_student_view) { |b| b.frm.link(:href=>/doShow_preview_assignment_student_view/).click }
  action(:edit) { |b| b.frm.button(:name=>"revise").click }
  action(:save_draft) { |b| b.frm.button(:name=>"save").click }
  action(:done) { |b| b.frm.button(:name=>"done").click }

end

# The reorder page for Assignments
class AssignmentsReorder < AssignmentsBase

  menu_elements

  # Clicks the Save button, then instantiates
  # the AssignmentsList page class.
  def save
    frm.button(:value=>"Save").click
  end

  # Clicks the Cancel button, then instantiates
  # the AssignmentsList Class.
  def cancel
    frm.button(:value=>"Cancel").click
  end

  action(:sort_by_title) { |b| b.frm.link(:text=>"Sort by title").click }
  action(:sort_by_open_date) { |b| b.frm.link(:text=>"Sort by open date").click }
  action(:sort_by_due_date) { |b| b.frm.link(:text=>"Sort by due date").click }
  action(:undo_last) { |b| b.frm.link(:text=>"Undo last").click }
  action(:undo_all) { |b| b.frm.link(:text=>"Undo all").click }

end

# A Student user's page for editing/submitting/view an assignment.
class AssignmentStudent < BasePage

  include FCKEditor
  frame_element

  expected_element :editor

  # Returns the text content of the page header
  value(:header) { |b| b.frm.div(:class=>"portletBody").h3.text }

  # Returns the contents of the alert box (when present)
  value(:alert_text) { |b| b.frm.div(:class=>"portletBody").div(:class=>"alertMessage").text }

  # Returns a hash object containing the contents of the Item Summary table.
  # The hash's Key is the header column and the value is the content column.
  def item_summary
    hash = {}
    frm.table(:class=>"itemSummary").rows.each do |row|
      hash.store(row.th.text, row.td.text)
    end
    return hash
  end

  # Grabs the instructor comments text.
  def instructor_comments
    frm.div(:class=>"portletBody").div(:class=>"textPanel", :index=>2).text
  end

  element(:editor) { |b| b.frm.frame(:id, "Assignment.view_submission_text___Frame") }

  # Enters the specified text into the Assignment Text FCKEditor.
  def assignment_text=(text)
    remove_assignment_text
    editor.td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  # Clears out any existing text from the Assignment Text FCKEditor.
  def remove_assignment_text
    editor.div(:title=>"Select All").fire_event("onclick")
    editor.td(:id, "xEditingArea").frame(:index=>0).send_keys :backspace
  end

  # TODO: Rethink all this in light of the fact that we're now using the DataObject class model...
  # This class variable allows adding an arbitrary number of
  # files to the page, as long as the adding steps alternate between
  # selecting the file and clicking the add more files button
  @@file_number = 0

  # Enters the specified file name into the file field. Entering the path
  # separately is optional.
  # Once the filename is entered in the field, the
  # @@file_number class variable is increased by one
  # in case any more files need to be added to the upload
  # list.
  def select_file(file_name, file_path="")
    #frm.file_field(:id=>"clonableUpload", :name=>"upload#{@@file_number}").set(file_path + file_name)
    @@file_number += 1
  end

  element(:submit_button) { |b| b.frm.button(:value=>"Submit") }

  # Clicks the Submit button, then instantiates
  # the appropriate page class, based on the
  # page that gets loaded.
  def submit
    submit_button.click
    @@file_number=0
  end

  element(:resubmit_button) { |b| b.frm.button(:value=>"Resubmit") }

  # Clicks the Resubmit button, then instantiates
  # the appropriate page class, based on the
  # page that gets loaded.
  #
  # Resets @@file_number to zero so that file
  # uploads will work if this page is visited again
  # in the same script.
  def resubmit
    resubmit_button.click
    @@file_number=0
  end

  # Clicks the Preview button, then
  # instantiates the AssignmentStudentPreview page class.
  #
  # Resets @@file_number to zero so that file
  # uploads will work if this page is visited again
  # in the same script.
  def preview
    frm.button(:value=>"Preview").click
    @@file_number=0
  end

  # Clicks the Save Draft button, then
  # instantiates the SubmissionConfirmation
  # page class.
  def save_draft
    frm.button(:value=>"Save Draft").click
  end

  # Clicks the link to select more files
  # from the Workspace. Then instantiates
  # the AssignmentAttachments page class.
  def select_more_files_from_workspace
    frm.link(:id=>"attach").click
  end

  # Clicks the Back to list button, then
  # instantiates the AssignmentList page class.
  def back_to_list
    frm.button(:value=>"Back to list").click
  end

  # Clicks the Cancel button and instantiates the
  # AssignmentsList Class.
  def cancel
    frm.button(:value=>"Cancel").click
  end

  action(:add_another_file) { |b| b.frm.link(:id=>"addMoreAttachmentControls") }

end

# Page that appears when
# 1) a Student User clicks to Preview an
# assignment that is in progress.
# 2) A Student views a submitted Assignment (in which case
# some of the methods in the class will be inappropriate, but
# useful for verification purposes, nonetheless)
class AssignmentStudentPreview < BasePage

  frame_element

  element(:submit_button) { |b| b.frm.button(:value=>"Submit") }
  element(:resubmit_button) { |b| b.frm.button(:value=>"Resubmit") }
  element(:save_draft_button) { |b| b.frm.button(:value=>"Save Draft") }

  # Clicks the Submit button
  action(:submit) { |p| p.submit_button.click }

  # Clicks the Save Draft button
  action(:save_draft) { |p| p.frm.button(:value=>"Save Draft").click }

  action(:back_to_list) { |b| b.frm.button(:value=>"Back to list").click }

  # Returns the contents of the submission box.
  def submission_text
    frm.div(:class=>"portletBody").div(:class=>/textPanel/).text
  end

  # returns a hash containing the info in the Summary table.
  # Header fields are the keys and their associated tds are the values.
  # Note that the whitespace is trimmed off the keys, so, for example,
  # the key for "Submitted Date" becomes "SubmittedDate"
  def summary_info
    hash={}
    array = frm.table(:class=>"itemSummary").to_a
    array.each do |subarray|
      hash.store(subarray[0], subarray[1])
    end
    hash
  end

  # Returns an array of strings. Each element in the
  # array is the name of attached files.
  def attachments
    names = []
    frm.ul(:class=>"attachList indnt1").links.each { |link| names << link.text }
    return names
  end

end

# The page that appears when a Student user has fully submitted an assignment
# or saves it as a draft.
class SubmissionConfirmation < BasePage

  frame_element

  # Returns the text of the success message on the page.
  value(:confirmation_text) { |b| b.frm.div(:class=>"portletBody").div(:class=>"success").text }

  # Returns the text of the assignment submission.
  value(:submission_text) { |b| b.frm.div(:class=>"portletBody").div(:class=>"textPanel indnt2").text }

  # Clicks the Back to list button, then
  # instantiates the AssignmentsList page class.
  action(:back_to_list) { |b| b.frm.button(:value=>"Back to list").click }

  def summary_info
    hash={}
    array = frm.table(:class=>"itemSummary").to_a
    array.each do |subarray|
      hash.store(subarray[0], subarray[1])
    end
    hash
  end

end

# The page that appears when you click on an assignment's "Grade" or "View Submission" link
# as an instructor. Shows the list of students and their
# assignment submission status.
class AssignmentSubmissionList < AssignmentsBase

  menu_elements
  listview_elements

  # Clicks the Show Resubmission Settings button
  action(:show_resubmission_settings) { |b| b.frm.image(:src, "/library/image/sakai/expand.gif?panel=Main").click }

  # Clicks the Show Assignment Details button.
  action(:show_assignment_details) { |b| b.frm.image(:src, "/library/image/sakai/expand.gif").click }

  # Gets the Student table text and returns it in an Array object.
  def student_table
    frm.table(:class=>"listHier lines nolines").to_a
  end

  # Clicks the Grade link for the specified student, then
  # instantiates the AssignmentSubmission page class.
  def grade(student_name)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(student_name)}/).link(:text=>"Grade").click
  end

  # Gets the value of the status field for the specified
  # Student. Note that the student's name needs to be entered
  # so that it's unique for the row, but it does not have
  # to match the entire name/id value--unless there are two
  # students with the same name.
  #
  # Useful for verification purposes.
  def submission_status_of(student_name)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(student_name)}/)[4].text
  end

  element(:search_input) { |b| b.frm.text_field(:id=>"search") }
  action(:find) { |b| b.frm.button(:value=>"Find").click }
  action(:clear) { |b| b.frm.button(:value=>"Clear").click }
  action(:download_all) { |b| b.frm.link(:text=>"Download All").click }
  action(:upload_all) { |b| b.frm.link(:text=>"Upload All").click }
  action(:release_grades) { |b| b.frm.link(:text=>"Release Grades").click }
  action(:sort_by_student) { |b| b.frm.link(:text=>"Student").click }
  action(:sort_by_submitted) { |b| b.frm.link(:text=>"Submitted").click }
  action(:sort_by_status) { |b| b.frm.link(:text=>"Status").click }
  action(:sort_by_grade) { |b| b.frm.link(:text=>"Grade").click }
  action(:sort_by_release) { |b| b.frm.link(:text=>"Release").click }
  element(:default_grade) { |b| b.frm.select(:id=>"defaultGrade_1") }
  action(:apply) { |b| b.frm.button(:name=>"apply").click }
  element(:num_resubmissions) { |b| b.frm.select(:id=>"allowResubmitNumber") }
  element(:accept_until_month) { |b| b.frm.select(:id=>"allow_resubmit_closeMonth") }
  element(:accept_until_day) { |b| b.frm.select(:id=>"allow_resubmit_closeDay") }
  element(:accept_until_year) { |b| b.frm.select(:id=>"allow_resubmit_closeYear") }
  element(:accept_until_hour) { |b| b.frm.select(:id=>"allow_resubmit_closeHour") }
  element(:accept_until_min) { |b| b.frm.select(:id=>"allow_resubmit_closeMin") }
  element(:accept_until_meridian) { |b| b.frm.select(:id=>"allow_resubmit_closeAMPM") }
  action(:update) { |b| b.frm.button(:id=>"eventSubmit_doSave_resubmission_option").click }
  action(:delete) { |b| b.frm.button(:name=>"eventSubmit_doDelete_confirm_assignment").click }

end

# The page that shows a student's submitted assignment to an instructor user.
class AssignmentSubmission < BasePage

  include FCKEditor
  frame_element

  expected_element :assignment_submission

  element(:assignment_submission) { |b| b.frm.frame(:id, "grade_submission_feedback_text___Frame") }
  element(:instructor_comments) { |b| b.frm.frame(:id, "grade_submission_feedback_comment___Frame") }

  # Enters the specified text string in the FCKEditor box for the assignment text.
  def assignment_text=(text)
    assignment_submission.td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  # Removes all the contents of the FCKEditor Assignment Text box.
  def remove_assignment_text
    assignment_submission.div(:title=>"Select All").fire_event("onclick")
    assignment_submission.td(:id, "xEditingArea").frame(:index=>0).send_keys :backspace
  end

  # Enters the specified string into the Instructor Comments FCKEditor box.
  def instructor_comments=(text)
    instructor_comments.td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  # Clicks the Add Attachments button, then instantiates the AssignmentAttachments Class.
  action(:add_attachments) { |b| b.frm.button(:name=>"attach").click }

  # Clicks the Return to List button, then instantiates the
  # AssignmentSubmissionList Class.
  action(:return_to_list) { |b| b.frm.button(:value=>"Return to List").click }

  element(:grade) { |b| b.frm.select(:name=>"grade_submission_grade") }
  element(:allow_resubmission) { |b| b.frm.checkbox(:id=>"allowResToggle") }
  element(:num_resubmissions) { |b| b.frm.select(:id=>"allowResubmitNumberSelect") }
  element(:accept_until_month) { |b| b.frm.select(:id=>"allow_resubmit_closeMonth") }
  element(:accept_until_day) { |b| b.frm.select(:id=>"allow_resubmit_closeDay") }
  element(:accept_until_year) { |b| b.frm.select(:id=>"allow_resubmit_closeYear") }
  element(:accept_until_hour) { |b| b.frm.select(:id=>"allow_resubmit_closeHour") }
  element(:accept_until_min) { |b| b.frm.select(:id=>"allow_resubmit_closeMin") }
  element(:accept_until_meridian) { |b| b.frm.select(:id=>"allow_resubmit_closeAMPM") }
  action(:save_and_release) { |b| b.frm.button(:value=>"Save and Release to Student").click }
  action(:save_and_dont_release) { |b| b.frm.button(:value=>"Save and Don't Release to Student").click }

end

# The Grade Report page accessed from the Assignments page
class GradeReport < BasePage

  frame_element

end