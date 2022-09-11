# frozen_string_literal: true

require_relative '../initialize'

directories = [
  # '/data/populacja/ciochon/tabele'
  '/data/populacja/maciejewska/tabele'
]

log 'Normalizing table filenames in directories:'
log directories

directories.each do |directory_path|
  targetted_directory = PROJECT_DIRECTORY + directory_path
  log "Getting files from #{targetted_directory}"
  Dir["#{targetted_directory}/*.csv"].each do |file|
    log "- processing #{File.basename(file, '.*')}"
    unless File.file?(file)
      log 'Subdirectory skipped'
      next
    end

    old_name = File.basename(file, '.*')
    # ciochon:
    # new_name = (old_name[-4..] || old_name).strip.chars.take(3).join
    # maciejewska:
    # new_name = "HM#{old_name[16..17]}"
    new_path = "#{targetted_directory}/#{new_name}.csv"
    File.rename(file, new_path)
    log "Renamed #{file} to #{new_name}"
  end
end
