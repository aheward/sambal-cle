#================
# Polls pages
#================

#
class Polls < BasePage

  frame_element

  link "Add"

  def questions
    questions = []
    frm.table(:id=>"sortableTable").rows.each do |row|
      questions << row[0].link.text
    end
    return questions
  end

  # Returns an array containing the list of poll questions displayed.
  def list
    list = []
    frm.table(:id=>"sortableTable").rows.each_with_index do |row, index|
      next if index==0
      list << row[0].link(:href=>/voteQuestion/).text
    end
    return list
  end

end

#
class AddEditPoll < BasePage

  frame_element
  cke_elements

  expected_element :editor

  action(:additional_instructions=) { |text, b| b.rich_text_field('newpolldescr::input').send_keys text }

  button "Save and add options"
  button "Save"
  element(:question) { |b| b.frm.text_field(:id=>"new-poll-text") }

end

#
class AddAnOption < BasePage

  frame_element
  cke_elements

  expected_element :editor

  action(:answer_option=) { |text, b| b.rich_text_field('optText::input').send_keys text }

  button "Save and add options"
  button "Save"

end