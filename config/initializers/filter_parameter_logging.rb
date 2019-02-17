# Configure sensitive parameters which will be filtered from the log file.
#
# NOTE : Be sure to restart your server when you modify this file.
#
# Parameters filtered:
#
#   - Any parameter ending with `token`
#   - Any parameter containing `password`
#   - Any parameter containing `secret`
#   - Any parameter ending with `key`
#
Rails.application.config.filter_parameters += [/token$/, /password/, /secret/, /key$/]
