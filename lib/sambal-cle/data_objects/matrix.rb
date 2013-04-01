class MatrixObject

  include Foundry
  include DataFactory
  include StringFactory
  include Navigation
  
  attr_accessor :portfolio, :title, :description, :columns, :rows, :status, :cells
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :title=>random_alphanums,
      :description=>random_alphanums,
      :columns=>[
          {:name=>random_alphanums, :bg_color=>random_hex_color, :font_color=>random_hex_color},
          {:name=>random_alphanums, :bg_color=>random_hex_color, :font_color=>random_hex_color},
          {:name=>random_alphanums, :bg_color=>random_hex_color, :font_color=>random_hex_color}
      ],
      :rows=>[
          {:name=>random_alphanums, :bg_color=>random_hex_color, :font_color=>random_hex_color},
          {:name=>random_alphanums, :bg_color=>random_hex_color, :font_color=>random_hex_color},
          {:name=>random_alphanums, :bg_color=>random_hex_color, :font_color=>random_hex_color}
      ],
      :cells=>[]
    }
    set_options(defaults.merge(opts))
    requires :portfolio

  end
    
  def create
    open_my_site_by_name @portfolio
    matrices
    on Matrices do |list|
      list.add
    end
    on AddEditMatrix do |add|
      add.title.set @title

      # TODO Add filling in the non-essential fields.

    end
    @columns.each do |column|
      on AddEditMatrix do |add|
        add.add_column
      end
      on AddEditColumn do |add|
        add.name.set column[:name]
        add.background_color.set column[:bg_color]
        add.font_color.set column[:font_color]
        add.update
      end
    end
    @rows.each do |row|
      on AddEditMatrix do |add|
        add.add_row
      end
      on AddEditRow do |add|
        add.name.set row[:name]
        add.background_color.set row[:bg_color]
        add.font_color.set row[:font_color]
        add.update
      end
    end
    on AddEditMatrix do |add|
      add.save_changes
    end
    on EditMatrixCells do |matrix|
      matrix.return_to_list
    end
  end
    
  def edit opts={}
    
    set_options(opts)
  end
    
  def view
    
  end
    
  def delete
    
  end

  def publish

  end

  def export

  end

end
    
class CellObject

  include Foundry
  include DataFactory
  include StringFactory
  include Navigation
  
  attr_accessor :title, :instructions, :rationale, :examples, :matrix, :row, :column, :id
  
  def initialize(browser, opts={})
    @browser = browser
    
    defaults = {
      :title=>random_alphanums,
      :instructions=>random_alphanums,
      :rationale=>random_alphanums,
      :examples=>random_alphanums
    }
    
    set_options(defaults.merge(opts))
    requires @matrix, @row, @column
  end
    
  def create
    #:id=>cell.html[/(?<=hrefViewCell\(\').+(?=')/]
  end
    
  def edit opts={}
    
    set_options(opts)
  end
    
  def view
    
  end
    
  def delete
    
  end
  
end
    
            