module UnitConverter
  MULTIPLIERS = {
    [:kg, :g] => 1000,
    [:g, :kg] => 1.0 / 1000,
    [:l, :ml] => 1000,
    [:ml, :l] => 1.0 / 1000,
    [:pcs, :pcs] => 1
  }

  def self.convert(qty, from, to)
    raise "Не можна конвертувати масу в об’єм" if mass_unit?(from) && volume_unit?(to)
    raise "Не можна конвертувати об’єм у масу" if volume_unit?(from) && mass_unit?(to)
    return qty if from == to

    multiplier = MULTIPLIERS[[from, to]]
    raise "Непідтримуване перетворення #{from} -> #{to}" unless multiplier
    qty * multiplier
  end

  def self.mass_unit?(u)
    [:g, :kg].include?(u)
  end

  def self.volume_unit?(u)
    [:ml, :l].include?(u)
  end
end