class AssignmentPermissionsObject # TODO: Need to add support for Group-specific permissions

  include PageHelper
  include Utilities
  include Workflows
  
  attr_accessor :site, :group, :guest, :instructor, :student, :teaching_assistant
  
  def initialize(browser, opts={})
    @browser = browser
    checkboxes={:all_groups=>nil, :new=>nil, :submit=>nil, :delete=>nil, :read=>nil, :revise=>nil, :grade=>nil, :receive_notifications=>nil, :share_drafts=>nil}
    @guest=checkboxes
    @instructor=checkboxes
    @student=checkboxes
    @teaching_assistant=checkboxes
    @site=opts[:site]
    @group=opts[:group]
    raise "You must specify a Site for your Assignment Permissions" if @site==nil
    get
  end
    
  def set opts={}
    open_my_site_by_name @site unless @browser.title=~/#{@site}/
    assignments unless @browser.title=~/Assignments$/
    reset
    on AssignmentsList do |list|
      list.permissions
    end
    on AssignmentsPermissions do |perm|
      roles={:guest=>"Guest", :instructor=>"Instructor", :student=>"Student", :teaching_assistant=>"Teaching Assistant"}
      roles.each_pair do |role, title|
        if opts[role]!=nil
          opts[role].each_pair do |checkbox, setting|
            perm.send(checkbox, title).send(setting)
          end
        end
      end
      perm.save
    end
    @guest = @guest.merge(opts[:guest]) unless opts[:guest]==nil
    @instructor = @instructor.merge(opts[:instructor]) unless opts[:instructor]==nil
    @student = @student.merge(opts[:student]) unless opts[:student]==nil
    @teaching_assistant = @teaching_assistant.merge(opts[:teaching_assistant]) unless opts[:teaching_assistant]==nil
  end

  def get
    open_my_site_by_name @site unless @browser.title=~/#{@site}/
    assignments unless @browser.title=~/Assignments$/
    reset
    on AssignmentsList do |list|
      list.permissions
    end
    on AssignmentsPermissions do |perm|
      roles={@guest=>"Guest", @instructor=>"Instructor", @student=>"Student", @teaching_assistant=>"Teaching Assistant"}
      roles.each_pair do |role, name|
        role.each_key { |key| role.store(key, checkbox_setting(perm.send(key, name))) }
      end
      perm.cancel
    end
  end
  
end
    
      