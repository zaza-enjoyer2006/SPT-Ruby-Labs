class Ingredient
  attr_reader :name, :unit, :calories_per_unit

  VALID_UNITS = [:g, :kg, :ml, :l, :pcs]

  def initialize(name, unit, calories_per_unit)
    raise "Невірна одиниця виміру" unless VALID_UNITS.include?(unit)
    @name = name
    @unit = unit
    @calories_per_unit = calories_per_unit
  end
end
