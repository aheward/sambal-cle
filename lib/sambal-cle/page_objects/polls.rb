#================
# Polls pages
#================

#
class Polls < BasePage

  frame_element

  link "Add"

  def questions
    questions = []
    polls_table.rows.each do |row|
      questions << row[0].link.text
    end
    return questions
  end

  # Returns an array containing the list of poll questions displayed.
  def list
    list = []
    polls_table.rows.each_with_index do |row, index|
      next if index==0
      list << row[0].link(:href=>/voteQuestion/).text
    end
    return list
  end

  # ========
  private
  # ========
  
  element(:polls_table) { |b| b.frm.table(:id=>'sortableTable') }
  
end

#
class AddEditPoll < BasePage

  frame_element
  cke_elements

  expected_element :editor

  action(:additional_instructions=) { |text, b| b.rich_text_field('newpolldescr::input').send_keys text }

  button 'Save and add options'
  button 'Save'
  element(:question) { |b| b.frm.text_field(:id=>'new-poll-text') }

end

#
class AddAnOption < BasePage

  frame_element
  cke_elements

  expected_element :editor

  action(:answer_option=) { |text, b| b.rich_text_field('optText::input').send_keys text }

  button 'Save and add options'
  button 'Save'

end