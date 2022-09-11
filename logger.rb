require 'logger'
require 'terminfo'

LOGGER = Logger.new(STDOUT)

def log string
  LOGGER.info string[0..TermInfo.screen_size[1]-51]
end
