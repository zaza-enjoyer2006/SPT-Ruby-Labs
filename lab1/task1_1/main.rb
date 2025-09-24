def word_stats(text)
  return { words: 0, longest: "", unique: 0 } if text.empty?

  words = text.split
  word_count = words.length
  longest_word = words.max_by { |word| word.length }
  unique_words = words.map { |word| word.downcase }.uniq.length

  { words: word_count, longest: longest_word, unique: unique_words }
end

if __FILE__ == $PROGRAM_NAME
  puts "Введіть рядок тексту:"
  text = gets.chomp
  result = word_stats(text)
  puts "#{result[:words]} слів, найдовше: #{result[:longest]}, унікальних: #{result[:unique]}"
end