class UserObject

  include Foundry
  include DataFactory
  include StringFactory
  include DateFactory
  include Navigation
  
  attr_accessor :id, :first_name, :last_name, :password, :email, :type,
                :created_by, :creation_date, :modified_by, :modified_date, :internal_id,
                :full_name, :long_name, :ln_fn_id
  
  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        :id=>random_alphanums,
        :first_name=>random_alphanums,
        :last_name=>random_alphanums,
        :email=>random_email,
        :type=>'Student',
        :password=>random_alphanums,
    }
    set_options(defaults.merge(opts))
    @full_name="#{@first_name} #{last_name}"
    @long_name="#{@first_name} #{last_name} (#{@id})"
    @ln_fn_id="#{@last_name}, #{@first_name} (#{@id})"
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
      if @browser.text_field(:id, 'eid').present?
        userlogin
      else # Log the current user out, then log in
        log_out
        userlogin
      end
    end
  end
  alias_method :login, :log_in
  alias_method :sign_in, :log_in

  def logged_in?
    submenu=@browser.div(id: 'LoginLinks')
    if submenu.present?
      submenu.span(class: 'nav-menu').html=~/#{@first_name}/ ? true : false
    else
      return false
    end
  end

  def log_out
    @browser.link(:text=>'Logout').click
  end

  private

  def userlogin
    on Login do |page|
      page.user_id.set @id
      page.password.set @password
      page.login
    end
  end

end
    
      