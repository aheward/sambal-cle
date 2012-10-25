module DataFactory

  def set_options(hash)
    hash.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end
  alias update_options set_options

  def requires(*elements)
    elements.each do |inst_var|
      raise "You must explicitly define the #{inst_var} variable for the #{self}." if inst_var==nil
    end
  end

  def make data_object_class, opts={}
    data_object_class.new @browser, opts
  end

  # Transform for use with data object instance variables
  # that refer to checkboxes or radio buttons. Instead of
  # returning true or false, it returns :set or :clear
  def checkbox_setting(checkbox)
    checkbox.set? ? :set : :clear
  end
  alias radio_setting checkbox_setting

end