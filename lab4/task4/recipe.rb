require_relative "unit_converter"

class Recipe
  attr_reader :name, :steps, :items

  def initialize(name, steps = [], items = [])
    @name = name
    @steps = steps
    @items = items
  end

  def need
    @items.map do |item|
      base_unit = base_unit(item[:unit])
      qty_base = UnitConverter.convert(item[:qty], item[:unit], base_unit)
      { ingredient: item[:ingredient], qty: qty_base, unit: base_unit }
    end
  end

  private

  def base_unit(unit)
    case unit
    when :kg then :g
    when :l then :ml
    else unit
    end
  end
end