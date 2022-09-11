# frozen_string_literal: true

require 'logger'
require 'terminfo'

LOGGER = Logger.new($stdout)

def log(string)
  LOGGER.info string[0..TermInfo.screen_size[1] - 51]
end
