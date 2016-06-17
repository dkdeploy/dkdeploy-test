require 'mysql2'

# helper to connect to DB
module MySQLClientHelpers
  def instantiate_mysql_client(database = nil)
    connection_settings = TEST_APPLICATION.mysql_connection_settings
    connection_settings[:database] = database if database

    Mysql2::Client.new(connection_settings)
  end
end

World(MySQLClientHelpers)
