require_relative "unit_converter"

class Pantry
  def initialize
    @items = Hash.new { |h, k| h[k] = { qty: 0.0, unit: nil } }
  end

  def add(name, qty, unit)
    base_qty = UnitConverter.convert(qty, unit, base_unit(unit))
    @items[name][:qty] += base_qty
    @items[name][:unit] = base_unit(unit)
  end

  def available_for(name)
    @items[name]
  end

  def to_h
    @items
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