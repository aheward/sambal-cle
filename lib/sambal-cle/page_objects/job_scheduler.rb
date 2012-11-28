#================
# Job Scheduler pages in Admin Workspace
#================

# The topmost page in the Job Scheduler in Admin Workspace
class JobScheduler < BasePage

  frame_element

  # Clicks the Jobs link, then instantiates
  # the JobList Class.
  link "Jobs"

end

# The list of Jobs (click the Jobs button on Job Scheduler)
class JobList < BasePage

  frame_element

  # Clicks the New Job link, then
  # instantiates the CreateNewJob Class.
  link "New Job"

  action(:triggers) { |job_name, b| b.frm.div(:class=>"portletBody").table(:class=>"listHier lines").row(:text=>/#{Regexp.escape(job_name)}/).link(:text=>/Triggers/).click }

  link "Event Log"

end

# The Create New Job page
class CreateNewJob < BasePage

  frame_element

  # Clicks the Post button, then
  # instantiates the JobList Class.
  button "Post"

  element(:job_name) { |b| b.frm.text_field(:id=>"_id2:job_name") }
  element(:type) { |b| b.frm.select_list(:name=>"_id2:_id10") }

end

# The page for Editing Triggers
class EditTriggers < BasePage

  frame_element

  # Clicks the "Run Job Now" link, then
  # instantiates the RunJobConfirmation Class.
  action(:run_job_now) { |b| b.frm.div(:class=>"portletBody").link(:text=>"Run Job Now").click }

  link "Return_to_Jobs"
  link "New Trigger"

end

# The Create Trigger page
class CreateTrigger < BasePage

  frame_element

  button "Post"

  element(:name) { |b| b.frm.text_field(:id=>"_id2:trigger_name") }
  element(:cron_expression) { |b| b.frm.text_field(:id=>"_id2:trigger_expression") }

end


# The page for confirming you want to run a job
class RunJobConfirmation < BasePage

  frame_element

  # Clicks the "Run Now" button, then
  # instantiates the JobList Class.
  button "Run Now"

end

# The page containing the Event Log
class EventLog < BasePage

  frame_element

end