class ChatRoomObject

  include Foundry
  include DataFactory
  include StringFactory
  include Navigation
  
  attr_accessor :title, :description, :chat_display, :allow_change, :site
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :title=>random_alphanums,
      :description=>random_alphanums,
      :chat_display=>:show_all_messages,
      :allow_change=>:set
    }
    options = defaults.merge(opts)
    
    set_options(options)
    requires :site
  end
    
  def create
    open_my_site_by_name @site
    chat_room
    on ChatRoom do |chat|
      chat.options
    end
    on ManageRooms do |manage|
      manage.add_room
    end
    #TODO: finish this method
  end
    
  def edit opts={}
    
  end
    
  def view
    
  end
    
  def delete
    
  end
  
end
    
      