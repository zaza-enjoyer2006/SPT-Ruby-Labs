def play_game
  target = rand(1..100)
  attempts = 0

  puts "Вгадайте число від 1 до 100!"
  loop do
    print "Ваше припущення: "
    guess = gets.chomp.to_i
    attempts += 1

    if guess == target
      puts "Вгадано! Число: #{target}. Кількість спроб: #{attempts}"
      break
    elsif guess < target
      puts "Більше"
    else
      puts "Менше"
    end
  end
end

play_game