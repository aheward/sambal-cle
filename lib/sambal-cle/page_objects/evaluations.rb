#================
# Evaluation System Pages
#================

class EvaluationSystemBase < BasePage

  frame_element

  class << self

    def menu_elements
      link('Administrate')
      link('Evaluations dashboard')
      link('My Evaluations')
      link('My Templates')
      link('My Items')
      link('My Scales')
      link('My Email Templates')
      action(:take_evaluation) { |evaluation_name, b| b.frm.div(:class=>'summaryBox').table(:text=>/#{Regexp.escape(evaluation_name)}/).link.click }
      action(:status_of) { |evaluation_name, b| b.frm.div(:class=>'summaryBox').table(:text=>/#{Regexp.escape(evaluation_name)}/)[1][1].text }

    end

  end

end

class EvaluationAdministrate < EvaluationSystemBase

  menu_elements

  # TODO: The 'Search' link will need to be defined differently because there are multiple 'Searches' on the page

  link('Control Reporting')
  link('Control Email Settings')
  link('Control Eval Admin')
  link('Test EvalGroupProvider')
  link('Synchronize Group Memberships')

  button('Save Settings')

end

class EvaluationsDashboard < EvaluationSystemBase

  menu_elements

  link('Add Template')
  link('Add Evaluation')

end

#
class AddTemplateTitle < EvaluationSystemBase

  menu_elements
  basic_page_elements

  element(:title) { |b| b.frm.text_field(:id=>'title') }
  element(:description) { |b| b.frm.text_area(:id=>'description') }

end

#
class EditTemplate < BasePage

  frame_element
  cke_elements

  link('New evaluation')

  def add
    frm.button(:value=>'Add').click
    rich_text_field.wait_until_present
  end

  def save_item
    frm.button(:value=>'Save item').click
    frm.link(:text=>'New evaluation').wait_until_present
  end

  element(:item) { |b| b.frm.select_list(:id=>'add-item-control::add-item-classification-selection').click }

end


#
class NewEvaluation < BasePage

  frame_element
  cke_elements

  expected_element :editor

  button('Continue to Settings')

  def instructions=(text)
    rich_text_field.send_keys(text)
  end

  element(:title) { |b| b.frm.text_field(:id=>'title') }

end

#
class EvaluationSettings < BasePage

  frame_element

  button('Continue to Assign to Courses')

end

#
class EditEvaluationAssignment < BasePage

  frame_element

  button('Save Assigned Groups')

  def check_group(title)
    frm.table(:class=>'listHier lines nolines').wait_until_present
    frm.table(:class=>'listHier lines nolines').row(:text=>/#{Regexp.escape(title)}/).checkbox(:name=>'selectedGroupIDs').set
  end

  link('Assign to Evaluation Groups')

end


#
class ConfirmEvaluation < BasePage

  frame_element

  action(:done) { |b| b.frm.button(:value=>'Done').click }

end

#
class MyEvaluations < EvaluationSystemBase

  menu_elements

  link('Add Evaluation')

end

class MyTemplates < EvaluationSystemBase

  menu_elements

end

class MyItems < EvaluationSystemBase

  menu_elements

end

class MyScales < EvaluationSystemBase

  menu_elements

end

class MyEmailTemplates < EvaluationSystemBase

  menu_elements

end

#
class TakeEvaluation < BasePage

  frame_element

  action(:submit_evaluation) { |b| b.frm.button(:value=>'Submit Evaluation').click }

end