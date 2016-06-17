Given(/^I want to use the database `(.*)`$/) do |database|
  @database_name = database
  mysql_client = instantiate_mysql_client
  mysql_client.query "DROP DATABASE IF EXISTS #{mysql_client.escape(@database_name)};"
  mysql_client.query "CREATE DATABASE #{mysql_client.escape(@database_name)};"
end

Then(/^the database (should|should not) have a table `(.*)` with column `(.*)`$/) do |should_or_not, table, column|
  mysql_client = instantiate_mysql_client
  query_string = "SELECT COUNT(*) AS number_of_columns
                    FROM information_schema.columns
                   WHERE table_schema = '#{mysql_client.escape(@database_name)}'
                     AND table_name = '#{mysql_client.escape(table)}'
                     AND column_name = '#{mysql_client.escape(column)}';"
  result = mysql_client.query query_string
  number_of_columns = result.first.fetch('number_of_columns')
  expectation = should_or_not == 'should' ? 1 : 0
  expect(number_of_columns).to eq expectation
end

Then(/^the database (should|should not) have a value `(.*)` in table `(.*)` for column `(.*)`$/) do |should_or_not, row, table, column|
  mysql_client = instantiate_mysql_client
  query_string = "SELECT COUNT(*) AS number_of_rows
                    FROM #{mysql_client.escape(@database_name)}.#{mysql_client.escape(table)}
                   WHERE #{mysql_client.escape(column)} = '#{mysql_client.escape(row)}';"
  result = mysql_client.query query_string
  number_of_rows = result.first.fetch('number_of_rows')
  expectation = should_or_not == 'should' ? 1 : 0
  expect(number_of_rows).to eq expectation
end
