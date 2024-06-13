class Player
  attr_reader :name
  
  def initialize(name = 'RandomName')
    @name = name
  end
end