# Creates a file on the remote server with the pre defined content
#
# @yieldparam path [String] the file name
# @yieldparam file_content [String] the content to be inserted in the file
Given(/^a remote file named "([^"]*)" with:$/) do |path, file_content|
  path = resolve_path path
  TEST_APPLICATION.remote.create_file path, file_content
end

# Creates an empty file on the remote server
#
# @yieldparam path [String] the file name
Given(/^a remote empty file named "([^"]*)"$/) do |path|
  path = resolve_path path
  TEST_APPLICATION.remote.run("mkdir -p #{File.dirname(path)}")
  TEST_APPLICATION.remote.run("touch #{path}")
end

# Creates a directory on the remote server
#
# @yieldparam path [String] the directory to be created
Given(/^a remote directory named "([^"]*)"$/) do |path|
  path = resolve_path path
  TEST_APPLICATION.remote.create_directory path
end

# Test if the remote directory exists.
#
# @yieldparam path [String] the name of the target directory
# @yieldparam should_or_not [String] decides if it should be tested in a positive or a negative way
#
Then(/^a remote directory named "([^"]*)" (should|should not) exist$/) do |path, should_or_not|
  path = resolve_path path
  decision = TEST_APPLICATION.remote.directory_exists?(path)
  if should_or_not == 'should'
    expect(decision).to be true
  else
    expect(decision).to be false
  end
end

# Test if the remote file exists.
#
# @yieldparam remote_path [String] the name of the file
# @yieldparam should_or_not [String] decides if it should be tested in a positive or a negative way
Then(/^a remote file named "([^"]*)" (should|should not) exist$/) do |path, should_or_not|
  path = resolve_path path
  decision = TEST_APPLICATION.remote.file_exists?(path)
  if should_or_not == 'should'
    expect(decision).to be true
  else
    expect(decision).to be false
  end
end

# Test if the remote symlink exists.
#
# @yieldparam remote_path [String] the name of the symlink
# @yieldparam should_or_not [String] decides if it should be tested in a positive or a negative way
Then(/^a remote symlink named "([^"]*)" (should|should not) exist$/) do |path, should_or_not|
  path = resolve_path path
  decision = TEST_APPLICATION.remote.symlink_exists?(path)
  if should_or_not == 'should'
    expect(decision).to be true
  else
    expect(decision).to be false
  end
end

# Test if the remote file content matches the test string.
#
# @yieldparam path [String] file path on the remote server
# @yieldparam exact_content [String] the content to be tested with
Then(/^the remote file "([^"]*)" should contain exactly:$/) do |path, exact_content|
  path = resolve_path path
  content = TEST_APPLICATION.remote.get_file_content(path)
  expect(content).to eq exact_content
end

# Test if the owner of the remote resource matches the expected one
#
# @yieldparam resource [String] file or directory on the remote server
# @yieldparam owner [String] the expected unix owner of the remote resource
Then(/^remote owner of "([^"]*)" should be "([^"]*)"$/) do |path, owner|
  path = resolve_path path
  expect(TEST_APPLICATION.remote.get_resource_property(path, 'owner')).to eq owner
end

# Test if the group of the remote resource matches the expected one
#
# @yieldparam resource [String] file or directory on the remote server
# @yieldparam group [String] the expected unix group of the remote resource
Then(/^remote group of "([^"]*)" should be "([^"]*)"$/) do |path, group|
  path = resolve_path path
  expect(TEST_APPLICATION.remote.get_resource_property(path, 'group')).to eq group
end

# Test if the given resource contain the examined permission
#
# @yieldparam resource [String] file or directory on the remote server
# @yieldparam should_or_not [String] decides if it should be tested in a positive or a negative way
# @yieldparam permission [String] the unix permission. Possible values ['read', 'write', 'execute']
# @yieldparam permission_section [String] the unix permission section. Possible values ['user', 'group', 'others']
Then(/^remote permissions of "([^"]*)" (should|should not) contain "(user|group|others)" "(read|write|execute)"$/) do |path, should_or_not, permission_section, permission|
  path = resolve_path path
  all_permissions = TEST_APPLICATION.remote.get_resource_property(path, 'permissions')

  case permission
  when 'read'
    permission = 'r'
  when 'write'
    permission = 'w'
  when 'execute'
    permission = 'x'
  else
    raise ArgumentError, 'The given permissions can not be mapped'
  end

  case permission_section
  when 'user'
    decision = TEST_APPLICATION.remote.user_has_permission?(all_permissions, permission)
  when 'group'
    decision = TEST_APPLICATION.remote.group_has_permission?(all_permissions, permission)
  when 'others'
    decision = TEST_APPLICATION.remote.others_has_permission?(all_permissions, permission)
  else
    raise ArgumentError, 'The given permissions can not be mapped'
  end

  if should_or_not == 'should'
    expect(decision).to be true
  else
    expect(decision).to be false
  end
end

When(/^I store the symlink source of current$/) do
  @symlink_source_of_current = TEST_APPLICATION.remote.source_of_symlink(resolve_path('current_path'))
end

Then(/^the symlink source of current should not have changed$/) do
  expect(TEST_APPLICATION.remote.source_of_symlink(resolve_path('current_path'))).to eq @symlink_source_of_current
end
