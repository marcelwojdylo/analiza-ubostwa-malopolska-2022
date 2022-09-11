require 'logger'
LOGGER = Logger.new(STDOUT)
def log string
  LOGGER.info string
end
