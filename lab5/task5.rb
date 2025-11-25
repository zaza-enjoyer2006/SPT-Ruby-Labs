# Лямбда для суми 3-х чисел
sum3 = ->(a, b, c) { a + b + c }

# Реалізація каррінга (Currying)
def curry3(fn)
  # Рекурсивна лямбда для накопичення аргументів
  accumulator = ->(*prev_args) do
    ->(*new_args) do
      all_args = prev_args + new_args

      if all_args.size == 3
        fn.call(*all_args)
      elsif all_args.size > 3
        raise ArgumentError, "Забагато аргументів: #{all_args.size} (очікується 3)"
      else
        # Повертаємо нову лямбду, що тримає в собі all_args (замикання)
        accumulator.call(*all_args)
      end
    end
  end

  accumulator.call
end

curried_sum = curry3(sum3)

puts "=== Частина 1: Автоматичні тести ==="
puts "curry3(sum3).call(1).call(2).call(3) => #{curried_sum.call(1).call(2).call(3)}"
puts "curry3(sum3).call(1, 2).call(3)      => #{curried_sum.call(1, 2).call(3)}"
puts "--- Тести пройдено ---\n\n"

puts "=== Частина 2: Інтерактив  ==="
puts "Уявімо, що перше число - це 'базова ставка', яку ми задаємо один раз."
print "Введіть перше число (базу): "
base_num = gets.chomp.to_i

# Вже має перше число всередині.
puts "Створюємо часткову функцію..."
partial_calculator = curried_sum.call(base_num)

puts "Тепер ця функція чекає ще 2 числа."
puts "Введіть друге число: "
second_num = gets.chomp.to_i

puts "Введіть третє число: "
third_num = gets.chomp.to_i

result = partial_calculator.call(second_num, third_num)

puts "\nРЕЗУЛЬТАТ: #{result}"
puts "(Логіка: #{base_num} + #{second_num} + #{third_num})"