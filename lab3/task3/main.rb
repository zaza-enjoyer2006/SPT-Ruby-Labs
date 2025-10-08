#!/usr/bin/env ruby
# Лабораторна робота: Сканер дублікатів у файловій системі
# Виконує рекурсивний обхід каталогу, пошук дублікатів та формування duplicates.json

require 'digest'
require 'json'
require 'find'

# === Конфігурація ===
ROOT_DIR = File.join(__dir__, 'task3_data')
IGNORE_DIRS = ['.git', 'node_modules', '__pycache__'] # Ігноровані директорії
REPORT_FILE = File.join(ROOT_DIR, 'duplicates.json')

# === Збір усіх файлів ===
def collect_files(root, ignore_dirs)
  files = []
  Find.find(root) do |path|
    if File.directory?(path)
      if ignore_dirs.any? { |d| File.basename(path) == d }
        Find.prune
      end
      next
    end
    next unless File.file?(path)
    files << { path: path, size: File.size(path) }
  end
  files
end

# === Групування потенційних дублікатів ===
def group_by_size(files)
  files.group_by { |f| f[:size] }.select { |_size, arr| arr.size > 1 }
end

# === Перевірка дублікатів за хешем ===
def group_by_hash(groups)
  new_groups = []
  groups.each do |size, files|
    hash_groups = files.group_by do |f|
      Digest::SHA256.file(f[:path]).hexdigest rescue nil
    end
    hash_groups.each_value do |hgroup|
      new_groups << { size_bytes: size, files: hgroup.map { |f| f[:path] } } if hgroup.size > 1
    end
  end
  new_groups
end

# === Побайтна перевірка ===
def byte_compare(f1, f2)
  File.open(f1, 'rb') do |a|
    File.open(f2, 'rb') do |b|
      until a.eof? || b.eof?
        return false unless a.read(4096) == b.read(4096)
      end
    end
  end
  true
end

def confirm_duplicates(groups)
  confirmed = []
  all_files = groups.flat_map { |g| g[:files] }
  unique_files = []

  groups.each do |g|
    unique_in_group = []
    g[:files].each do |file|
      if unique_in_group.none? { |u| byte_compare(u, file) }
        unique_in_group << file
      end
    end
    if unique_in_group.size < g[:files].size
      confirmed << {
        size_bytes: g[:size_bytes],
        saved_if_dedup_bytes: g[:size_bytes] * (g[:files].size - unique_in_group.size),
        files: g[:files]
      }
      unique_files.concat(unique_in_group)
    end
  end

  # Повертаємо confirmed і обчислюємо загальну кількість дублікатів
  [confirmed, all_files.size - unique_files.uniq.size]
end

# === Основна логіка ===
puts "🔍 Сканування каталогу: #{ROOT_DIR}..."
files = collect_files(ROOT_DIR, IGNORE_DIRS)
puts "📁 Знайдено файлів: #{files.size}"

size_groups = group_by_size(files)
puts "📦 Потенційних груп за розміром: #{size_groups.size}"

hash_groups = group_by_hash(size_groups)
puts "🔑 Груп після хешування: #{hash_groups.size}"

confirmed_groups, total_duplicates = confirm_duplicates(hash_groups)
puts "✅ Підтверджено дублікатів: #{total_duplicates}"

# === Формування звіту ===
report = {
  scanned_files: files.size,
  groups: confirmed_groups
}

confirmed_groups.each_with_index do |group, i|
  puts "\nГрупа ##{i + 1}:"
  puts "  Розмір файлів: #{group[:size_bytes]} байт"
  puts "  Дублікатів: #{group[:files].size - 1}" # Кількість дублікатів у групі
  puts "  Файли:"
  group[:files].each { |f| puts "    - #{f}" }
end

File.write(REPORT_FILE, JSON.pretty_generate(report))
puts "\nЗвіт збережено у #{REPORT_FILE}"