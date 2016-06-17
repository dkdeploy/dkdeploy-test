# Install test application for capistrano
#
Given(/^a test app with the default configuration$/) do
  TEST_APPLICATION.install
end

# Remove capistrano application at remote server
#
Given(/^the remote server is cleared$/) do
  TEST_APPLICATION.remote.remove_deploy_to_path
end

# Extend the dev capistrano configuration to the given variable/value paar
#
# @yieldparam variable [String] the name of the variable to be set
# @yieldparam value [Object] the value of the variable to be set. Example: 'test' or Array.new
#
# Note: We used to call   step %(I append to "#{TEST_APPLICATION.config_dev_path}" with "#{extension_content}\n")
# but this seems to be broken due to a wrong path expansion
When(/^I extend the development capistrano configuration variable (.+?) with value (.+?)$/) do |variable, value|
  extension_content = "set :#{variable}, #{value}"
  file_name = TEST_APPLICATION.config_dev_path

  Aruba.platform.mkdir(File.dirname(file_name))
  File.open(file_name, 'a') { |f| f << "\n#{extension_content}\n" }
end

# Extend the dev capistrano configuration to the content from the given fixture file
#
# @yieldparam file [String] the fixture file which content should extend capistrano configuration
When(/^I extend the development capistrano configuration from the fixture file (.+?)$/) do |file|
  extension_content = File.read(File.join(TEST_APPLICATION.capistrano_configuration_fixtures_path, file))
  file_name = TEST_APPLICATION.config_dev_path

  Aruba.platform.mkdir(File.dirname(file_name))
  File.open(file_name, 'a') { |f| f << "\n#{extension_content}\n" }
end

# Execute the cap deploy task on the dev server
When(/^the project is deployed$/) do
  step 'I successfully run `cap dev deploy`'
end
