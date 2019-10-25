# frozen_string_literal: true

# Loggable
#
#   Application logging additions
#
module Loggable

  protected

  def log_info(message)
    logger.info(message)
  end

  def log_error(message)
    logger.error(message)
  end

  def logger
    Elplano::Loggers::AppLogger
  end
end
