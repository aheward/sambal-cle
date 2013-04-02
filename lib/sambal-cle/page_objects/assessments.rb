
#================
# Assessments pages - "Samigo", a.k.a., "Tests & Quizzes"
#================

# Base Class for building Assessments
class AssessmentsBase <BasePage

  frame_element
  class << self
    def menu_bar_elements
      link 'Assessments'
      link 'Assessment Types'
      link 'Question Pools'
      action(:questions) { |b| b.frm.link(:text=>/Questions:/).click }
    end

    def question_page_elements
      element(:answer_point_value) { |b| b.frm.text_field(:id=>'itemForm:answerptr') }
      element(:assign_to_part) { |b| b.frm.select(:id=>'itemForm:assignToPart') }
      element(:assign_to_pool) { |b| b.frm.select(:id=>'itemForm:assignToPool') }
      element(:question_text) { |b| b.frm.text_field(:class=>'simple_text_area', :index=>0) }
      button 'Save'
      action(:cancel) { |b| b.frm.button(:id=>'itemForm:_id63').click }
      button 'Add Attachments'
    end

    def pool_page_elements
      element(:pool_name) { |b| b.frm.text_field(:id=>/:namefield/) }
      element(:department_group) { |b| b.frm.text_field(:id=>/:orgfield/) }
      element(:description) { |b| b.frm.text_field(:id=>/:descfield/) }
      element(:objectives) { |b| b.frm.text_field(:id=>/:objfield/) }
      element(:keywords) { |b| b.frm.text_field(:id=>/:keyfield/) }
      # QuestionPoolsList
      action(:save) { |b| b.frm.button(:id=>'questionpool:submit').click }
    end
  end
end

# The Course Tools "Tests and Quizzes" page for a given site.
# (Instructor view)
class AssessmentsList < AssessmentsBase

  menu_bar_elements

  expected_element :title

  # If the assessment is going to be made in the builder, then
  # use EditAssessment. There's no page class for markup text, yet.
  button 'Create'

  # Collects the titles of the Assessments listed as "Pending"
  # then returns them as an Array.
  def pending_assessment_titles
    titles =[]
    1.upto(pending_table.rows.size-1) do |x|
      titles << pending_table[x][1].span(:id=>/assessmentTitle/).text
    end
    titles
  end

  # Collects the titles of the Assessments listed as "Published"
  # then returns them as an Array.
  def published_assessment_titles
    titles =[]
    1.upto(published_table.rows.size-1) do |x|
      titles << published_table[x][1].span(:id=>/publishedAssessmentTitle/).text
    end
    titles
  end

  # Returns an Array of the inactive Assessment titles displayed
  # in the list.
  def inactive_assessment_titles
    titles =[]
    1.upto(inactive_table.rows.size-1) do |x|
      titles << inactive_table[x][1].span(:id=>/inactivePublishedAssessmentTitle/).text
    end
    titles
  end

  # Opens the selected test for scoring
  # then instantiates the AssessmentTotalScores class.
  # @param test_title [String] the title of the test to be clicked.
  action(:score_test) { |test_title, b| b.frm.tbody(:id=>'authorIndexForm:_id88:tbody_element').row(:text=>/#{Regexp.escape(test_title)}/).link(:id=>/authorIndexToScore/).click }

  action(:publish) { |test_title, b| b.pending_table.tr(:text=>/#{Regexp.escape(test_title)}/).select(:name=>/Select/).select 'Publish' }

  action(:edit) { |test_title, b| b.frm.form(:id=>'authorIndexForm').tr(:text=>/#{Regexp.escape(test_title)}/).select(:name=>/Select/).select 'Edit' }

  element(:title) { |b| b.frm.text_field(:id=>'authorIndexForm:title') }
  element(:pending_table) { |b| b.frm.table(:id=>'authorIndexForm:coreAssessments') }
  element(:published_table) { |b| b.frm.div(:class=>'tier2', :index=>2).table(:class=>'listHier', :index=>0) }
  element(:inactive_table) { |b| b.frm.div(:class=>'tier2', :index=>2).table(:id=>'authorIndexForm:inactivePublishedAssessments') }
  element(:create_using_builder) { |b| b.frm.radio(:name=>'authorIndexForm:_id29', :index=>0) }
  element(:create_using_text) { |b| b.frm.radio(:name=>'authorIndexForm:_id29') }
  element(:select_assessment_type) { |b| b.frm.select(:id=>'authorIndexForm:assessmentTemplate') }
  action(:import) { |b| b.frm.button(:id=>'authorIndexForm:import').click }

end

# Page of Assessments accessible to a student user
#
# It may be that we want to deprecate this class and simply use
# the AssessmentsList class alone.
class StudentAssessmentsList < AssessmentsBase

  # Returns an array containing the assessment names that appear on the page.
  def available_assessments
    list = []
    table = available_assessments_table.to_a
    table.delete_at(0)
    table.each { |row| list<<row[0].gsub(/\s+$/, "") unless row[0]=="" }
    list
  end

  # Method to get the titles of assessments that
  # the student user has submitted. The titles are
  # returned in an Array object.
  def submitted_assessments
    table_array = @browser.frame(:index=>1).table(:id=>'selectIndexForm:reviewTable').to_a
    table_array.delete_at(0)
    titles = []
    table_array.each { |row|
      unless row[0] == ''
        titles << row[0]
      end
    }

    titles

  end

  # Clicks the specified assessment
  # @param name [String] the name of the assessment you want to take
  def take_assessment(name)
    begin
      frm.link(:text=>name).click
    rescue Watir::Exception::UnknownObjectException
      frm.link(:text=>CGI::escapeHTML(name)).click
    end
  end

  # TODO This method is in need of improvement to make it more generalized for finding the correct test.
  #
  def feedback(test_name)
    test_table = submitted_assessments_table.to_a
    test_table.delete_if { |row| row[3] != 'Immediate' }
    index_value = test_table.index { |row| row[0] == test_name }
    frm.link(:text=>'Feedback', :index=>index_value).click
  end

  element(:available_assessments_table) { |b| b.frm.table(:id=>'selectIndexForm:selectTable') }
  element(:submitted_assessments_table) { |b| b.frm.table(:id=>'selectIndexForm:reviewTable') }

end

# Page that appears when previewing an assessment.
# It shows the basic information about the assessment.
class PreviewOverview < BasePage

  frame_element

  # Scrapes the value of the due date from the page. Returns it as a string.
  value(:due_date) { |b| b.frm.frm.div(:class=>'tier2').table(:index=>0)[0][0].text }

  # Scrapes the value of the time limit from the page. Returns it as a string.
  value(:time_limit) { |b| b.frm.frm.div(:class=>'tier2').table(:index=>0)[3][0].text }

  # Scrapes the submission limit from the page. Returns it as a string.
  value(:submission_limit) { |b| b.frm.frm.div(:class=>'tier2').table(:index=>0)[6][0].text }

  # Scrapes the Feedback policy from the page. Returns it as a string.
  value(:feedback) { |b| b.frm.div(:class=>'tier2').table(:index=>0)[9][0].text }

  # Clicks the Done button, then instantiates
  # the EditAssessment class.
  action(:done) { |b| b.frm.button(:name=>'takeAssessmentForm:_id5').click }

  action(:begin_assessment) { |b| b.frm.button(:id=>'takeAssessmentForm:beginAssessment3').click }

end

# The Settings page for a particular Assessment
class AssessmentSettings < AssessmentsBase

  menu_bar_elements

  expected_element :cancel_button

  # Scrapes the Assessment Type from the page and returns it as a string.
  value(:assessment_type_title) { |b| b.frm.div(:class=>'tier2').table(:index=>0)[0][1].text }

  # Scrapes the Assessment Author information from the page and returns it as a string.
  value(:assessment_type_author) { |b| b.frm.div(:class=>'tier2').table(:index=>0)[1][1].text }

  # Scrapes the Assessment Type Description from the page and returns it as a string.
  value(:assessment_type_description) { |b| b.frm.div(:class=>'tier2').table(:index=>0)[2][1].text }

  # Clicks the Save Settings and Publish button
  # then instantiates the PublishAssessment class.
  action(:save_and_publish) { |b| b.frm.button(:value=>'Save Settings and Publish').click }
  
  action(:open) { |b| b.frm.link(:text=>'Open').click }
  action(:close) { |b| b.frm.link(:text=>'Close').click }
  # Introduction
  element(:title) { |b| b.frm.text_field(:id=>'assessmentSettingsAction:intro:assessment_title') }
  element(:authors) { |b| b.frm.text_field(:id=>'assessmentSettingsAction:intro:assessment_author') }
  element(:description) { |b| b.frm.text_field(:id=>'assessmentSettingsAction:intro:_id44_textinput') }
  action(:add_attachments_to_intro) { |b| b.frm.button(:name=>'assessmentSettingsAction:intro:_id90').click }
  # Delivery Dates
  element(:available_date) { |b| b.frm.text_field(:id=>'assessmentSettingsAction:startDate') }
  element(:due_date) { |b| b.frm.text_field(:id=>'assessmentSettingsAction:endDate') }
  element(:retract_date) { |b| b.frm.text_field(:id=>'assessmentSettingsAction:retractDate') }
  # Assessment Released To
  element(:released_to_anonymous) { |b| b.frm.radio(:value=>'Anonymous Users') }
  element(:released_to_site) { |b| b.frm.radio(:name=>'assessmentSettingsAction:_id117', :index=>1) }
  element(:specified_ips) { |b| b.frm.text_field(:name=>'assessmentSettingsAction:_id132') }
  # High Security
  element(:secondary_id) { |b| b.frm.text_field(:id=>'assessmentSettingsAction:username') }
  element(:secondary_pw) { |b| b.frm.text_field(:id=>'assessmentSettingsAction:password') }
  element(:allow_specified_ips) { |b| b.frm.text_field(:name=>'assessmentSettingsAction:_id132') }
  element(:timed_assessment) { |b| b.frm.checkbox(:id=>'assessmentSettingsAction:selTimeAssess') }
  element(:limit_hour) { |b| b.frm.select(:id=>'assessmentSettingsAction:timedHours') }
  element(:limit_mins) { |b| b.frm.select(:id=>'assessmentSettingsAction:timedMinutes') }
  # Assessment Organization
  element(:linear_access) { |b| b.frm.radio(:name=>'assessmentSettingsAction:itemNavigation', :value=>'1') }
  element(:random_access) { |b| b.frm.radio(:name=>'assessmentSettingsAction:itemNavigation', :value=>'2') }
  element(:question_per_page) { |b| b.frm.radio(:name=>'assessmentSettingsAction:assessmentFormat', :value=>'1') }
  element(:part_per_page) { |b| b.frm.radio(:name=>'assessmentSettingsAction:assessmentFormat', :value=>'2') }
  element(:assessment_per_page) { |b| b.frm.radio(:name=>'assessmentSettingsAction:assessmentFormat', :value=>'3') }
  element(:continuous_numbering) { |b| b.frm.radio(:name=>'assessmentSettingsAction:itemNumbering', :value=>'1') }
  element(:restart_per_part) { |b| b.frm.radio(:name=>'assessmentSettingsAction:itemNumbering', :value=>'2') }
  # Mark for review
  element(:add_mark_for_review) { |b| b.frm.text_field(:id=>'assessmentSettingsAction:markForReview1') }
  element(:unlimited_submissions) { |b| b.frm.radio(:name=>'assessmentSettingsAction:unlimitedSubmissions', :value=>'1') }
  element(:only_x_submissions) { |b| b.frm.radio(:name=>'assessmentSettingsAction:unlimitedSubmissions', :value=>'0') }
  element(:allowed_submissions) { |b| b.frm.text_field(:id=>'assessmentSettingsAction:submissions_Allowed') }
  element(:late_submissions_not_accepted) { |b| b.frm.radio(:name=>'assessmentSettingsAction:lateHandling', :value=>'2') }
  element(:late_submissions_accepted) { |b| b.frm.radio(:name=>'assessmentSettingsAction:lateHandling', :value=>'1') }
  # Submission Message
  element(:submission_message) { |b| b.frm.text_field(:id=>/assessmentSettingsAction:_id\d+_textinput/) }
  element(:final_page_url) { |b| b.frm.text_field(:id=>'assessmentSettingsAction:finalPageUrl') }
  # Feedback
  element(:question_level_feedback) { |b| b.frm.radio(:name=>'assessmentSettingsAction:feedbackAuthoring', :value=>'1') }
  element(:selection_level_feedback) { |b| b.frm.radio(:name=>'assessmentSettingsAction:feedbackAuthoring', :value=>'2') }
  element(:both_feedback_levels) { |b| b.frm.radio(:name=>'assessmentSettingsAction:feedbackAuthoring', :value=>'3') }
  element(:immediate_feedback) { |b| b.frm.radio(:name=>'assessmentSettingsAction:feedbackDelivery', :value=>'1') }
  element(:feedback_on_submission) { |b| b.frm.radio(:name=>'assessmentSettingsAction:feedbackDelivery', :value=>'4') }
  element(:no_feedback) { |b| b.frm.radio(:name=>'assessmentSettingsAction:feedbackDelivery', :value=>'3') }
  element(:feedback_on_date) { |b| b.frm.radio(:name=>'assessmentSettingsAction:feedbackDelivery', :value=>'2') }
  element(:feedback_date) { |b| b.frm.text_field(:id=>'assessmentSettingsAction:feedbackDate') }
  element(:only_release_scores) { |b| b.frm.radio(:name=>'assessmentSettingsAction:feedbackComponentOption', :value=>'1') }
  element(:release_questions_and) { |b| b.frm.radio(:name=>'assessmentSettingsAction:feedbackComponentOption', :value=>'2') }
  element(:release_student_response) { |b| b.frm.checkbox(:id=>'assessmentSettingsAction:feedbackCheckbox1') }
  element(:release_correct_response) { |b| b.frm.checkbox(:id=>'assessmentSettingsAction:feedbackCheckbox3') }
  element(:release_students_assessment_scores) { |b| b.frm.checkbox(:id=>'assessmentSettingsAction:feedbackCheckbox5') }
  element(:release_students_question_and_part_scores) { |b| b.frm.checkbox(:id=>'assessmentSettingsAction:feedbackCheckbox7') }
  element(:release_question_level_feedback) { |b| b.frm.checkbox(:id=>'assessmentSettingsAction:feedbackCheckbox2') }
  element(:release_selection_level_feedback) { |b| b.frm.checkbox(:id=>'assessmentSettingsAction:feedbackCheckbox4') }
  element(:release_graders_comments) { |b| b.frm.checkbox(:id=>'assessmentSettingsAction:feedbackCheckbox6') }
  element(:release_statistics) { |b| b.frm.checkbox(:id=>'assessmentSettingsAction:feedbackCheckbox8') }
  # Grading
  element(:student_ids_seen) { |b| b.frm.radio(:name=>'assessmentSettingsAction:anonymousGrading1', :value=>'2') }
  element(:anonymous_grading) { |b| b.frm.radio(:name=>'assessmentSettingsAction:anonymousGrading1', :value=>'1') }
    #radio_button(:no_gradebook_options) { |b| b.frm.radio(:name=>"") }
    #radio_button(:grades_sent_to_gradebook) { |b| b.frm.radio(:name=>"") }
  # Graphics
    #radio_button(:record_highest_score) { |b| b.frm.radio(:name=>"") }
    #radio_button(:record_last_score) { |b| b.frm.radio(:name=>"") }
    #radio_button(:background_color) { |b| b.frm.radio(:name=>"") }
    #text_field(:color_value, :id=>"") }
    #radio_button(:background_image) { |b| b.frm.radio(:name=>"") }
    #text_field(:image_name, :=>"") }
  # Metadata
    #text_field(:keywords, :=>"") }
    #text_field(:objectives, :=>"") }
    #text_field(:rubrics, :=>"") }
    #checkbox(:record_metadata_for_questions, :=>"") }
  button 'Save Settings' 
  button 'Cancel' 

end

# Instructor's view of Students' assessment scores
class AssessmentTotalScores < BasePage

  frame_element

  # Gets the user ids listed in the
  # scores table, returns them as an Array
  # object.
  #
  # Note that this method is only appropriate when student
  # identities are not being obscured on this page. If student
  # submissions are set to be anonymous then this method will fail
  # to return any ids.
  def student_ids
    ids = []
    scores_table = frm.table(:id=>"editTotalResults:totalScoreTable").to_a
    scores_table.delete_at(0)
    scores_table.each { |row| ids << row[1] }
    ids
  end

  # Adds a comment to the specified student's comment box.
  #
  # Note that this method assumes that the student identities are not being
  # obscured on this page. If they are, then this method will not work for
  # selecting the appropriate comment box.
  # @param student_id [String] the target student id
  # @param comment [String] the text of the comment being made to the student
  action(:comment_for_student) { |student_id, comment, b|
    index_val = b.student_ids.index(student_id)
    b.frm.text_field(:name=>"editTotalResults:totalScoreTable:#{index_val}:_id345").value=comment
  }

  # Clicks the Submit Date link in the table header to sort/reverse sort the list.
  action(:sort_by_submit_date) { |b| b.frm.link(:text=>'Submit Date').click }

  # Enters the specified string into the topmost box listed on the page.
  #
  # This method is especially useful when the student identities are obscured, since
  # in that situation you can't target a specific student's comment box, obviously.
  # @param comment [String] the text to be entered into the Comment box
  def comment_in_first_box=(comment)
    frm.text_field(:name=>'editTotalResults:totalScoreTable:0:_id345').value=comment
  end

  button 'Update'

  link 'Assessments'

end

# The page that appears when you're creating a new quiz
# or editing an existing one
class EditAssessment < AssessmentsBase

  menu_bar_elements

  # Allows insertion of a question at a specified
  # point in the Assessment. Must include the
  # part number, the question number, and the type of
  # question. Question Type must match the Type
  # value in the drop down.
  def insert_question_after(part_num, question_num, qtype)
    if question_num.to_i == 0
      frm.select(:id=>"assesssmentForm:parts:#{part_num.to_i - 1}:changeQType").select(qtype)
    else
      frm.select(:id=>"assesssmentForm:parts:#{part_num.to_i - 1}:parts:#{question_num.to_i - 1}:changeQType").select(qtype)
    end
  end

  # Allows removal of question by part number and question number.
  # @param part_num [String] the Part number containing the question you want to remove
  # @param question_num [String] the number of the question you want to remove
  def remove_question(part_num, question_num)
    frm.link(:id=>"assesssmentForm:parts:#{part_num.to_i-1}:parts:#{question_num.to_i-1}:deleteitem").click
  end

  # Allows editing of a question by specifying its part number
  # and question number.
  # @param part_num [String] the Part number containing the question you want
  # @param question_num [String] the number of the question you want
  def edit_question(part_num, question_num)
    frm.link(:id=>"assesssmentForm:parts:#{part_num.to_i-1}:parts:#{question_num.to_i-1}:modify").click
  end

  # Allows copying an Assessment part to a Pool.
  # @param part_num [String] the part number of the assessment you want
  def copy_part_to_pool(part_num)
    frm.link(:id=>"assesssmentForm:parts:#{part_num.to_i-1}:copyToPool").click
  end

  # Allows removing a specified
  # Assessment part number.
  # @param part_num [String] the part number of the assessment you want
  action(:remove_part) { |part_num, b| b.frm.link(:xpath, "//a[contains(@onclick, 'assesssmentForm:parts:#{part_num.to_i-1}:copyToPool')]").click }

  link 'Add Part'

  # Selects the desired question type from the
  # drop down list at the top of the page.
  action(:question_type) { |qtype, b| b.frm.select(:id=>'assesssmentForm:changeQType').select(qtype) }

  link 'Preview' 

  link 'Settings'

  link 'Publish'

  # Allows retrieval of a specified question's
  # text, by part and question number.
  # @param part_num [String] the Part number containing the question you want
  # @param question_num [String] the number of the question you want
  action(:get_question_text) { |part_number, question_number, b|  b.frm.table(:id=>"assesssmentForm:parts:#{part_number.to_i-1}:parts").div(:class=>"tier3", :index=>question_number.to_i-1).text }

  action(:print) { |b| b.frm.button(:text=>'Print').click }
  action(:update_points) { |b| b.frm.button(:id=>'assesssmentForm:pointsUpdate').click }

  # TODO: Fix this method. It doesn't work for some reason...
  action(:add_question_to_part) { |part, p| p.assessment_form.row(:text=>/#{Regexp.escape(part)}/).select(:id=>/changeQType/) }

  element(:assessment_form) { |b| b.table(:id=>'assesssmentForm:parts') }

end

# This is the page for adding and editing a part of an assessment
class AddEditAssessmentPart < BasePage

  frame_element

  # Clicks the Save button
  def save
    frm.button(:name=>'modifyPartForm:_id89').click
  end

  element(:title) { |b| b.frm.text_field(:id=>'modifyPartForm:title') }
  element(:information) { |b| b.frm.text_field(:id=>'modifyPartForm:_id10_textinput') }
  action(:add_attachments) { |b| b.frm.button(:name=>'modifyPartForm:_id54').click }
  element(:one_by_one) { |b| b.frm.radio(:index=>0, :name=>'modifyPartForm:_id60') }
  element(:random_draw) { |b| b.frm.radio(:index=>1, :name=>'modifyPartForm:_id60') }
  element(:pool_name) { |b| b.frm.select(:id=>'modifyPartForm:assignToPool') }
  element(:number_of_questions) { |b| b.frm.text_field(:id=>'modifyPartForm:numSelected') }
  element(:point_value_of_questions) { |b| b.frm.text_field(:id=>'modifyPartForm:numPointsRandom') }
  element(:negative_point_value) { |b| b.frm.text_field(:id=>'modifyPartForm:numDiscountRandom') }
  element(:randomized_each_time) { |b| b.frm.radio(:index=>0, :name=>'modifyPartForm:randomizationType') }
  element(:randomized_once) { |b| b.frm.radio(:index=>1, :name=>'modifyPartForm:randomizationType') }
  element(:order_as_listed) { |b| b.frm.radio(:index=>0, :name=>'modifyPartForm:_id81') }
  element(:random_within_part) { |b| b.frm.radio(:index=>1, :name=>'modifyPartForm:_id81') }
  element(:objective) { |b| b.frm.text_field(:id=>'modifyPartForm:obj') }
  element(:keyword) { |b| b.frm.text_field(:id=>'modifyPartForm:keyword') }
  element(:rubric) { |b| b.frm.text_field(:id=>'modifyPartForm:rubric') }
  action(:cancel) { |b| b.frm.button(:name=>'modifyPartForm:_id90').click }

end

# The review page once you've selected to Save and Publish
# the assessment
class PublishAssessment < BasePage

  frame_element
  basic_page_elements

  button 'Publish'

  action(:edit) { |b| b.frm.button(:name=>'publishAssessmentForm:_id23').click }
  element(:notification) { |b| b.frm.select(:id=>'publishAssessmentForm:number') }

end

# The page for setting up a multiple choice question
class MultipleChoice < AssessmentsBase

  menu_bar_elements
  question_page_elements

  link "(What's This?)"
  element(:single_correct) { |b| b.frm.radio(:name=>'itemForm:chooseAnswerTypeForMC', :index=>0) }
  element(:enable_negative_marking) { |b| b.frm.radio(:name=>'itemForm:partialCreadit_NegativeMarking', :index=>0) }

    # Element present when negative marking selected:
  element(:negative_point_value) { |b| b.frm.text_field(:id=>'itemForm:answerdsc') }

  element(:enable_partial_credit) { |b| b.frm.radio(:name=>'itemForm:partialCreadit_NegativeMarking', :index=>1) }
  action(:reset_to_default) { |b| b.frm.link(:text=>'Reset to Default Grading Logic').click }
  element(:multi_single) { |b| b.frm.radio(:name=>'itemForm:chooseAnswerTypeForMC', :index=>1) }
  element(:multi_multi) { |b| b.frm.radio(:name=>'itemForm:chooseAnswerTypeForMC', :index=>2) }

  action(:correct_answer) { |answer, b| b.frm.radio(:value=>answer) }
  action(:answer_text) { |answer, b| b.frm.text_field(:name=>"itemForm:mcchoices:#{answer.ord-65}:_id144_textinput") }
  action(:answer_feedback_text) { |answer, b| b.frm.text_field(:name=>"itemForm:mcchoices:#{answer.ord-65}:_id147_textinput") }

  element(:correct_answer_feedback) { |b| b.frm.text_field(:id=>'itemForm:_id190_textinput') }
  element(:incorrect_answer_feedback) { |b| b.frm.text_field(:id=>'itemForm:_id198_textinput') }

  link 'Reset Score Values'

  action(:remove_last_answer) { |b| b.frm.link(:text=>'Remove', :index=>-1).click }

  element(:insert_additional_answers) { |b| b.frm.select(:id=>'itemForm:insertAdditionalAnswerSelectMenu') }
  element(:randomize_answers_yes) { |b| b.frm.radio(:index=>0, :name=>'itemForm:_id166') }
  element(:randomize_answers_no) { |b| b.frm.radio(:index=>1, :name=>'itemForm:_id166') }
  element(:require_rationale_yes) { |b| b.frm.radio(:index=>0, :name=>'itemForm:_id170') }
  element(:require_rationale_no) { |b| b.frm.radio(:index=>1, :name=>'itemForm:_id170') }

end

# The page for setting up a Survey question
class Survey < AssessmentsBase

  menu_bar_elements
  question_page_elements

  element(:yes_no) { |b| b.frm.radio(:index=>0, :name=>'itemForm:selectscale') }
  element(:disagree_agree) { |b| b.frm.radio(:index=>1, :name=>'itemForm:selectscale') }
  element(:disagree_undecided) { |b| b.frm.radio(:index=>2, :name=>'itemForm:selectscale') }
  element(:below_above) { |b| b.frm.radio(:index=>3, :name=>'itemForm:selectscale') }
  element(:strongly_agree) { |b| b.frm.radio(:index=>4, :name=>'itemForm:selectscale') }
  element(:unacceptable_excellent) { |b| b.frm.radio(:index=>5, :name=>'itemForm:selectscale') }
  element(:one_to_five) { |b| b.frm.radio(:index=>6, :name=>'itemForm:selectscale') }
  element(:one_to_ten) { |b| b.frm.radio(:index=>7, :name=>'itemForm:selectscale') }
  element(:feedback) { |b| b.frm.text_field(:id=>'itemForm:_id144_textinput') }

end

#  The page for setting up a Short Answer/Essay question
class ShortAnswer < AssessmentsBase

  cke_elements
  menu_bar_elements
  question_page_elements

  element(:model_short_answer) { |b| b.frm.text_field(:id=>'itemForm:_id129_textinput') }
  element(:feedback) { |b| b.frm.text_field(:id=>'itemForm:_id133_textinput') }

  action(:toggle_question_editor) { |b| b.frm.link(:id=>'itemForm:_id69_toggle').click; b.editor.wait_until_present }

  action(:information=) { |text, b| b.rich_text_field('modifyPartForm:_id10_textinput').send_keys text }

end

#  The page for setting up a Fill-in-the-blank question
class FillInBlank < AssessmentsBase

  menu_bar_elements
  question_page_elements

  element(:case_sensitive) { |b| b.frm.checkbox(:name=>'itemForm:_id76') }
  element(:mutually_exclusive) { |b| b.frm.checkbox(:name=>'itemForm:_id78') }
  element(:correct_answer_feedback) { |b| b.frm.text_field(:id=>'itemForm:_id144_textinput') }
  element(:incorrect_answer_feedback) { |b| b.frm.text_field(:id=>'itemForm:_id147_textinput') }

end

#  The page for setting up a numeric response question
class NumericResponse < AssessmentsBase

  menu_bar_elements
  question_page_elements

  element(:correct_answer_feedback) { |b| b.frm.text_field(:id=>'itemForm:_id141_textinput') }
  element(:incorrect_answer_feedback) { |b| b.frm.text_field(:id=>'itemForm:_id143_textinput') }

end

#  The page for setting up a matching question
class Matching < AssessmentsBase

  menu_bar_elements
  question_page_elements

  element(:choice) { |b| b.frm.text_field(:id=>'itemForm:_id147_textinput') }
  element(:match) { |b| b.frm.text_field(:id=>'itemForm:_id151_textinput') }
  element(:correct_match_feedback) { |b| b.frm.text_field(:id=>'itemForm:_id155_textinput') }
  element(:incorrect_match_feedback) { |b| b.frm.text_field(:id=>'itemForm:_id160_textinput') }
  element(:correct_answer_feedback) { |b| b.frm.text_field(:id=>'itemForm:_id184_textinput') }
  element(:incorrect_answer_feedback) { |b| b.frm.text_field(:id=>'itemForm:_id189_textinput') }

  action(:distractor) { |b| b.frm.select(:id=>'itemForm:controllingSequence').select '*distractor*' }
  action(:save_pairing) { |b| b.frm.button(:name=>'itemForm:_id164').click }

end

#  The page for setting up a True/False question
class TrueFalse < AssessmentsBase

  menu_bar_elements
  question_page_elements

  element(:negative_point_value) { |b| b.frm.text_field(:id=>'itemForm:answerdsc') }
  action(:answer) { |answer, b| b.frm.radio(:value=>answer, :name=>'itemForm:TF') }
  element(:required_rationale_yes) { |b| b.frm.radio(:index=>0, :name=>'itemForm:rational') }
  element(:required_rationale_no) { |b| b.frm.radio(:index=>1, :name=>'itemForm:rational') }
  element(:correct_answer_feedback) { |b| b.frm.text_field(:id=>'itemForm:_id148_textinput') }
  element(:incorrect_answer_feedback) { |b| b.frm.text_field(:id=>'itemForm:_id152_textinput') }

end

#  The page for setting up a question that requires an audio response
class AudioRecording < AssessmentsBase

  menu_bar_elements
  question_page_elements

  element(:time_allowed) { |b| b.frm.text_field(:id=>'itemForm:timeallowed') }
  element(:number_of_attempts) { |b| b.frm.select(:id=>'itemForm:noattempts') }
  element(:feedback) { |b| b.frm.text_field(:id=>'itemForm:_id146_textinput') }

end

# The page for setting up a question that requires
# attaching a file
class FileUpload < AssessmentsBase

  menu_bar_elements
  question_page_elements
  element(:feedback) { |b| b.frm.text_field(:id=>'itemForm:_id130_textinput') }

end

#  The page for setting up a calculated question
class CalculatedQuestions < AssessmentsBase

  menu_bar_elements
  question_page_elements

  action(:extract_vs_and_fs) { |b| b.frm.button(:value=>'Extract Variables and Formulas').click; b.variables_table.wait_until_present }

  action(:min_value) { |variable_name, p| p.variables_table.td(:text=>variable_name).parent.text_field(:name=>/itemForm:pairs:.:_id167/) }
  action(:max_value) { |variable_name, p| p.variables_table.td(:text=>variable_name).parent.text_field(:name=>/_id170/) }
  action(:var_decimals) { |variable_name, p| p.variables_table.td(:text=>variable_name).parent.select(:name=>/_id173/) }
  action(:formula) { |formula_name, p| p.formulas_table.td(:text=>formula_name).parent.text_field(:name=>/_id186/) }
  action(:tolerance) { |formula_name, p| p.formulas_table.td(:text=>formula_name).parent.text_field(:name=>/_id189/) }
  action(:form_decimals) { |formula_name, p| p.formulas_table.td(:text=>formula_name).parent.select(:name=>/assignToPart/) }
  element(:variables_table) { |b| b.frm.table(:id=>'itemForm:pairs') }
  element(:formulas_table) { |b| b.frm.table(:id=>'itemForm:formulas') }

  element(:correct_answer_feedback) { |b| b.frm.text_field(:id=>'itemForm:_id207_textinput') }
  element(:incorrect_answer_feedback) { |b| b.frm.text_field(:id=>'itemForm:_id211_textinput') }

end

# The page that appears when you are editing a type of assessment
class EditAssessmentType < AssessmentsBase


end

# The Page that appears when adding a new question pool
class AddQuestionPool < AssessmentsBase

  pool_page_elements

end

# The Page that appears when editing an existing question pool
class EditQuestionPool < AssessmentsBase

  pool_page_elements

  # Clicks the Add Question link, then
  # instantiates the SelectQuestionType class.
  action(:add_question) { |b| b.frm.link(:id=>'editform:addQlink').click }

  action(:question_pools) { |b| b.frm.link(:text=>'Question Pools').click }

  action(:update) { |b| b.frm.button(:id=>'editform:Update').click }

end

# The page with the list of existing Question Pools
class QuestionPoolsList < AssessmentsBase

  # Clicks the edit button
  # @param name [String] the name of the pool you want to edit
  action(:edit_pool) { |name, b| b.frm.span(:text=>name).fire_event('onclick') }

  link 'Add New Pool'

  # Returns an array containing strings of the pool names listed
  # on the page.
  def pool_names
    names= []
    frm.table(:id=>'questionpool:TreeTable').rows.each do | row |
      if row.span(:id=>/questionpool.+poolnametext/).exist?
        names << row.span(:id=>/questionpool.+poolnametext/).text
      end
    end
    names
  end

  link 'Import'
  link 'Assessments'

end

# The page that appears when you click to import
# a pool.
class PoolImport < AssessmentsBase

  # Enters the target file into the Choose File
  # file field. Including the file path separately is optional.
  # @param file_name [String] the name of the file you want to choose. Can include path info, if desired.
  # @param file_path [String] Optional. This is the path information for the file location.
  def choose_file(file_name, file_path='')
    frm.file_field(:name=>'importPoolForm:_id6.upload').set(file_path + file_name)
  end

  button 'Import'

end

# This page appears when adding a question to a pool
class SelectQuestionType < AssessmentsBase

  # Selects the specified question type from the
  # drop-down list, then instantiates the appropriate
  # page class, based on the question type selected.
  # @param qtype [String] the text of the question type you want to select from the drop down list.
  def select_question_type(qtype)
    frm.select(:id=>'_id1:selType').select(qtype)
    frm.button(:value=>'Save').click
  end

  action(:cancel) { |b| b.frm.button(:value=>'Cancel').click }

end


# The student view of the overview/intro page of an Assessment
class BeginAssessment < BasePage

  frame_element

  button 'Begin Assessment'

  value(:assessment_introduction) { |b| b.frm.div(:class=>'assessmentIntroduction').text }

  element(:info_table) { |b| b.frm.table(:index=>0) }

  #TODO: Write methods to extract pertinent info from the info table.

end

# Pages student sees when taking an assessment
# Note that this class will only work when the Assessment being taken
# is set up to only display one question per page.
class TakeAssessment < AssessmentsBase

  action(:multiple_choice_answer) { |answer_text, b| b.frm } # TODO: Finish this method definition

  action(:fill_in_blank_answer) { |box, b| b.frm.text_field(:name=>/deliverFillInTheBlank:_id.+:#{box.to_i}/) }
  action(:numeric_answer) { |box, b| b.frm.text_field(:name=>/deliverFillInNumeric:_id.+:#{box.to_i}/) }

  # Clicks either the True or the False radio button, as specified.
  def true_false_answer(answer)
    answer.upcase=~/t/i ? index = 0 : index = 1
    frm.radio(:name=>/deliverTrueFalse/, :index=>index).set
  end

  # Enters the specified string into the Rationale text box.
  def true_false_rationale(text)
    frm.text_field(:name=>/:deliverTrueFalse:rationale/).value=text
  end

  element(:short_answer) { |b| b.frm.text_field(:name=>/deliverShortAnswer/) }

  action(:match_answer) { |match_text, b| b.frm.td(:text=>/#{Regexp.escape(match_text)}/).parent.select(:index=>0) }

  # Enters the specified file name in the file field. You can include the path to the file
  # as an optional second parameter.
  def file_answer(file_name, file_path='')
    frm.file_field(:name=>/deliverFileUpload/).set(file_path + file_name)
    frm.button(:value=>'Upload').click
  end

  # Clicks the Next button and instantiates the BeginAssessment Class.
  action(:next) { |b| b.frm.button(:value=>'Next').click }

  button 'Submit for Grading'

end

# The confirmation page that appears when submitting an Assessment.
# The last step before actually submitting the the Assessment.
class ConfirmSubmission < AssessmentsBase

  # Clicks the Submit for Grading button and instantiates
  # the SubmissionSummary Class.
  button 'Submit for Grading'
  
  value(:validation) { |b| b.frm.span(:class=>'validation').text }

end

# The summary page that appears when an Assessment has been submitted.
class SubmissionSummary < AssessmentsBase

  button 'Continue'

  value(:summary_info) { |b| b.frm.div(:class=>'tier1').text }

end
