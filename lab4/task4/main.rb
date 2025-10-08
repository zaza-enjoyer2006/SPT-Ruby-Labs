require_relative "ingredient"
require_relative "recipe"
require_relative "pantry"
require_relative "unit_converter"
require_relative "planner"

# --- Інгредієнти ---
flour = Ingredient.new("борошно", :g, 3.64)
milk  = Ingredient.new("молоко", :ml, 0.06)
egg   = Ingredient.new("яйце", :pcs, 72)
pasta = Ingredient.new("паста", :g, 3.5)
sauce = Ingredient.new("соус", :ml, 0.2)
cheese= Ingredient.new("сир", :g, 4.0)

# --- Комора ---
pantry = Pantry.new
pantry.add("борошно", 1, :kg)
pantry.add("молоко", 0.5, :l)
pantry.add("яйце", 6, :pcs)
pantry.add("паста", 300, :g)
pantry.add("сир", 150, :g)

# --- Ціни за базову одиницю ---
prices = {
  "борошно" => 0.02,
  "молоко"  => 0.015,
  "яйце"    => 6.0,
  "паста"   => 0.03,
  "соус"    => 0.025,
  "сир"     => 0.08
}

# --- Рецепти ---
omelet = Recipe.new("Омлет", ["збити яйця", "додати молоко"], [
  { ingredient: egg, qty: 3, unit: :pcs },
  { ingredient: milk, qty: 100, unit: :ml },
  { ingredient: flour, qty: 20, unit: :g }
])

pasta_dish = Recipe.new("Паста", ["відварити пасту", "додати соус"], [
  { ingredient: pasta, qty: 200, unit: :g },
  { ingredient: sauce, qty: 150, unit: :ml },
  { ingredient: cheese, qty: 50, unit: :g }
])

# --- План ---
Planner.plan([omelet, pasta_dish], pantry, prices)