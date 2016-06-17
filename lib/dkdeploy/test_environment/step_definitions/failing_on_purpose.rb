Given(/^I provoke an exception for testing purposes before symlinking the new release$/) do
  extension_content = "after 'deploy:updating', 'deploy:fail'"
  file_name = TEST_APPLICATION.config_dev_path

  Aruba.platform.mkdir(File.dirname(file_name))
  File.open(file_name, 'a') { |f| f << "\n#{extension_content}\n" }
end

Given(/^I provoke an exception for testing purposes after symlinking the new release$/) do
  extension_content = "before 'deploy:finishing', 'deploy:fail'"
  file_name = TEST_APPLICATION.config_dev_path

  Aruba.platform.mkdir(File.dirname(file_name))
  File.open(file_name, 'a') { |f| f << "\n#{extension_content}\n" }
end
