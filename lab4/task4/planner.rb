class Planner
  def self.plan(recipes, pantry, price_list)
    total_need = Hash.new { |h, k| h[k] = { qty: 0, unit: nil, ingredient: nil } }

    recipes.each do |recipe|
      recipe.need.each do |item|
        ing_name = item[:ingredient].name
        total_need[ing_name][:qty] += item[:qty]
        total_need[ing_name][:unit] = item[:unit]
        total_need[ing_name][:ingredient] = item[:ingredient]
      end
    end

    puts "Інгредієнт | Потрібно | Є | Дефіцит"
    puts "-" * 50

    total_calories = 0
    total_cost = 0

    total_need.each do |name, info|
      have = pantry.available_for(name)
      have_qty = have ? have[:qty] : 0
      need_qty = info[:qty]
      deficit = [need_qty - have_qty, 0].max

      ingredient = info[:ingredient]
      total_calories += ingredient.calories_per_unit * need_qty
      total_cost += price_list[name] * need_qty if price_list[name]

      puts "#{name.ljust(10)} | #{need_qty.round(2)}#{info[:unit].to_s.ljust(3)} | #{have_qty.round(2)}#{info[:unit].to_s.ljust(3)} | #{deficit.round(2)}#{info[:unit]}"
    end

    puts "-" * 50
    puts "Total calories: #{total_calories.round(2)}"
    puts "Total cost: #{total_cost.round(2)}"
  end
end