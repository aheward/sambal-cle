require 'rspec'
require "#{File.dirname(__FILE__)}/../lib/sambal-cle"
require 'yaml'

describe "Assignment Due Date on Calendar" do

  include Utilities
  include Navigation
  include Foundry
  include StringFactory
  include DateFactory

  before :all do

    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SambalCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser

    @student = make UserObject, :id=>@directory['person1']['id'], :password=>@directory['person1']['password'],
                    :first_name=>@directory['person1']['firstname'], :last_name=>@directory['person1']['lastname']
    @instructor1 = make UserObject, :id=>@directory['person3']['id'], :password=>@directory['person3']['password'],
                        :first_name=>@directory['person3']['firstname'], :last_name=>@directory['person3']['lastname'],
                        :type=>"Instructor"
    @instructor2 = make UserObject, :id=>@directory['person4']['id'], :password=>@directory['person4']['password'],
                        :first_name=>@directory['person4']['firstname'], :last_name=>@directory['person4']['lastname'],
                        :type=>"Instructor"
    @instructor1.log_in

    @site = make CourseSiteObject
    @site.create
    @site.add_official_participants @student.type, @student.id
    @site.add_official_participants @instructor2.type, @instructor2.id

    @assignment1 = make AssignmentObject, :site=>@site.name, :title=>random_string, :grade_scale=>"Letter grade", :instructions=>random_multiline(200, 10, :string), :open=>minutes_ago(5)
    @assignment2 = make AssignmentObject, :allow_resubmission=>:set, :add_due_date=>:set, :site=>@site.name, :title=>random_nicelink(15), :open=>hours_ago(5), :student_submissions=>"Inline only", :grade_scale=>"Letter grade", :instructions=>random_multiline(300, 13, :string)

    @assignment1.create
    @assignment2.create

  end

  after :all do
    # Close the browser window
    @sakai.browser.close
  end

  it "When 'add due date to schedule' not checked, Assignment does not appear on the Calendar" do
    calendar

    on Calendar do |calendar|
      # List events on the expected due date for Assignment 2
      calendar.view.select "List of Events"
      calendar.show_events.select "Custom date range"
      calendar.start_month.select @assignment1.due[:MON]
      calendar.start_day.select @assignment1.due[:day_of_month]
      calendar.start_year.select @assignment1.due[:year]
      calendar.end_month.select @assignment1.due[:MON]
      calendar.end_day.select @assignment1.due[:day_of_month]
      calendar.end_year.select @assignment1.due[:year]
      calendar.filter_events

      calendar.events_list.should_not include "Due #{@assignment1.title}"
    end
  end

  it "When 'add due date to schedule' is checked, Assignment appears on the Calendar" do
    on Calendar do |calendar|
      calendar.start_month.select @assignment2.due[:MON]
      calendar.start_day.select @assignment2.due[:day_of_month]
      calendar.start_year.select @assignment2.due[:year]
      calendar.end_month.select @assignment2.due[:MON]
      calendar.end_day.select @assignment2.due[:day_of_month]
      calendar.end_year.select @assignment2.due[:year]
      calendar.filter_events

      calendar.events_list.should include "Due #{@assignment2.title}"

    end
  end

  it "Students see expected assignments on the calendar" do
    @student.log_in
    calendar
    on Calendar do |calendar|
      calendar.view.select "List of Events"
      calendar.show_events.select "Custom date range"
      calendar.start_month.select @assignment1.due[:MON]
      calendar.start_day.select @assignment1.due[:day_of_month]
      calendar.start_year.select @assignment1.due[:year]
      calendar.end_month.select @assignment1.due[:MON]
      calendar.end_day.select @assignment1.due[:day_of_month]
      calendar.end_year.select @assignment1.due[:year]
      calendar.filter_events

      calendar.events_list.should_not include "Due #{@assignment1.title}"

      calendar.start_month.select @assignment2.due[:MON]
      calendar.start_day.select @assignment2.due[:day_of_month]
      calendar.start_year.select @assignment2.due[:year]
      calendar.end_month.select @assignment2.due[:MON]
      calendar.end_day.select @assignment2.due[:day_of_month]
      calendar.end_year.select @assignment2.due[:year]
      calendar.filter_events

      calendar.events_list.should include "Due #{@assignment2.title}"
    end
  end

  it "Other instructors see expected assignments on the calendar" do
    @instructor2.log_in
    calendar
    on Calendar do |calendar|
      calendar.view.select "List of Events"
      calendar.show_events.select "Custom date range"
      calendar.start_month.select @assignment1.due[:MON]
      calendar.start_day.select @assignment1.due[:day_of_month]
      calendar.start_year.select @assignment1.due[:year]
      calendar.end_month.select @assignment1.due[:MON]
      calendar.end_day.select @assignment1.due[:day_of_month]
      calendar.end_year.select @assignment1.due[:year]
      calendar.filter_events

      calendar.events_list.should_not include "Due #{@assignment1.title}"

      calendar.start_month.select @assignment2.due[:MON]
      calendar.start_day.select @assignment2.due[:day_of_month]
      calendar.start_year.select @assignment2.due[:year]
      calendar.end_month.select @assignment2.due[:MON]
      calendar.end_day.select @assignment2.due[:day_of_month]
      calendar.end_year.select @assignment2.due[:year]
      calendar.filter_events

      calendar.events_list.should include "Due #{@assignment2.title}"
    end
  end

end