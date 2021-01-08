require 'logging'

Logging.logger.root.level = :info
Logging.logger.root.appenders = Logging.appenders.stdout

Logging.logger['FileWalker'].level = :debug
Logging.logger['Test'].level = :debug
