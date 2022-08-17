# frozen_string_literal: true

require 'rspec'
require 'pry'
Dir[File.join('.', 'lib/**/*.rb')].sort.each do |f|
  require f
end
require 'csv'

require_relative 'sources'
require_relative 'constants'
