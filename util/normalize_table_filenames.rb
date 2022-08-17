# frozen_string_literal: true

require_relative '../initialize'

directories = [
  # '/data/populacja/ciochon/tabele'
  '/data/populacja/maciejewska/tabele'
]

puts 'Normalizing table filenames in directories:'
puts directories

directories.each do |directory_path|
  targetted_directory = PROJECT_DIRECTORY + directory_path
  puts "Getting files from #{targetted_directory}"
  Dir[targetted_directory + '/*.csv'].each do |file|
    puts "- processing #{File.basename(file, '.*')}"
    unless File.file?(file)
      puts 'Subdirectory skipped'
      next
    end

    old_name = File.basename(file, '.*')
    # ciochon:
    # new_name = (old_name[-4..] || old_name).strip.chars.take(3).join
    # maciejewska:
    # new_name = "HM#{old_name[16..17]}"
    new_path = "#{targetted_directory}/#{new_name}.csv"
    File.rename(file, new_path)
    puts "Renamed #{file} to #{new_name}"
  end
end
