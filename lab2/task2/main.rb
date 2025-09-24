def cut_cake(cake)
  rows = cake.size
  cols = cake.first.size
  raisins = []

  # Збираємо координати родзинок
  cake.each_with_index do |row, r|
    row.chars.each_with_index do |ch, c|
      raisins << [r, c] if ch == 'o' || ch == '0'
    end
  end

  n = raisins.size
  if n <= 1
    puts "Має бути більше ніж 1 родзинка"
    exit
  end

  total_area = rows * cols
  if total_area % n != 0
    puts "Неможливо поділити торт на рівні шматки"
    exit
  end

  piece_area = total_area / n

  solutions = []

  # горизонтальне різання (шматки однакової висоти)
  if rows % n == 0
    h = rows / n
    parts = []
    valid = true
    (0...n).each do |i|
      part = cake[i*h...(i+1)*h]
      count_raisins = part.join.count('o') + part.join.count('0')
      valid = false unless count_raisins == 1
      parts << part
    end
    solutions << parts if valid
  end

  # вертикальне різання (шматки однакової ширини)
  if cols % n == 0
    w = cols / n
    parts = []
    valid = true
    (0...n).each do |i|
      sub = cake.map { |row| row[i*w...(i+1)*w] }
      count_raisins = sub.join.count('o') + sub.join.count('0')
      valid = false unless count_raisins == 1
      parts << sub
    end
    solutions << parts if valid
  end

  # довільні прямокутники з однаковою площею
  if solutions.empty?
    used = Array.new(rows) { Array.new(cols, false) }
    parts = []
    valid = true

    raisins.each do |r, c|
      found = false
      (1..rows).each do |h|
        next unless piece_area % h == 0
        w = piece_area / h

        (0..r).each do |top|
          (0..c).each do |left|
            bottom = top + h - 1
            right = left + w - 1
            next if bottom >= rows || right >= cols

            sub = cake[top..bottom].map { |row| row[left..right] }
            count_raisins = sub.join.count('o') + sub.join.count('0')

            if count_raisins == 1
              overlap = false
              (top..bottom).each do |rr|
                (left..right).each do |cc|
                  overlap = true if used[rr][cc]
                end
              end
              next if overlap

              (top..bottom).each do |rr|
                (left..right).each do |cc|
                  used[rr][cc] = true
                end
              end

              parts << sub
              found = true
              break
            end
          end
          break if found
        end
        break if found
      end
      valid = false unless found
    end

    solutions << parts if valid && parts.size == n
  end

  if solutions.empty?
    puts "Рішення не знайдено"
    exit
  end

  best = solutions.max_by { |parts| parts.first.first.size }
  best
end

puts "Введіть кількість рядків торта:"
rows = gets.to_i
cake = []
puts "Введіть торт рядок за рядком ('.' - пусто, 'o' або '0' - родзинка):"
rows.times do
  cake << gets.strip
end

result = cut_cake(cake)
result.each_with_index do |piece, i|
  puts "Шматок #{i+1}:"
  puts piece
  puts
end