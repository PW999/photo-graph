require 'logging'

Logging.logger.root.level = :debug
Logging.logger.root.appenders = Logging.appenders.stdout

Logging.logger['Test'].level = :debug
