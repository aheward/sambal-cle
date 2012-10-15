class UserObject

  include PageHelper
  include Utilities
  include Randomizers
  include DateMakers
  include Workflows
  
  attr_accessor :id, :first_name, :last_name, :password, :email, :type,
<<<<<<< HEAD
<<<<<<< HEAD
                :created_by, :creation_date, :modified_by, :modified_date, :internal_id,
                :full_name, :long_name, :ln_fn_id
=======
                :created_by, :creation_date, :modified_by, :modified_date, :internal_id
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.
=======
                :created_by, :creation_date, :modified_by, :modified_date, :internal_id,
                :full_name, :long_name, :ln_fn_id
>>>>>>> 8c662f2... Added the set_options method to the PageHelper module. Updated the data object classes to use this method.
  
  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        :id=>random_alphanums,
        :first_name=>random_alphanums,
        :last_name=>random_alphanums,
        :email=>random_email,
        :type=>"Student",
        :password=>random_alphanums,
    }
    options = defaults.merge(opts)

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 8c662f2... Added the set_options method to the PageHelper module. Updated the data object classes to use this method.
    set_options(options)
    @full_name="#{@first_name} #{last_name}"
    @long_name="#{@first_name} #{last_name} (#{@id})"
    @ln_fn_id="#{@last_name}, #{@first_name} (#{@id})"
<<<<<<< HEAD
=======
    @id=options[:id]
    @first_name=options[:first_name]
    @last_name=options[:last_name]
    @email=options[:email]
    @type=options[:type]
    @password=options[:password]
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.
=======
>>>>>>> 8c662f2... Added the set_options method to the PageHelper module. Updated the data object classes to use this method.
  end
    
  def create
    # TODO
  end
    
  def edit opts={}
    # TODO
  end
    
  def view
    # TODO
  end
    
  def delete
    # TODO
  end

  def exist?
    # TODO
  end

  def log_in
    if logged_in?
      # do nothing
    else # see if we're on the login screen
      if @browser.frame(:id, "ifrm").text_field(:id, "eid").present?
        userlogin
      else # Log the current user out, then log in
<<<<<<< HEAD
<<<<<<< HEAD
        log_out
=======
        logout
>>>>>>> c3a8c8c... Created the UserObject class and methods.  Started updating the scripts to properly use them.
=======
        log_out
>>>>>>> feb4534... Finished the Assignments Grading spec.
        userlogin
      end
    end
  end
  alias login log_in

  def logged_in?
    welcome=@browser.span(:class=>"welcome")
    if welcome.present?
      welcome.text=~/#{@first_name}/ ? true : false
    else
      return false
    end
  end

  def log_out
    @browser.link(:text=>"Logout").click
  end

  private

  def userlogin
    on Login do |page|
      page.login_with @id, @password
    end
  end

end
    
      