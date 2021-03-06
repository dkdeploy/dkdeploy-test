# Navigation helper module for cucumber steps
#
module NavigationHelpers
  # Mapping for path names to real remote path
  #
  # @param path [String]
  # @return [String]
  def path_to(path)
    case path
    when 'deploy_path'
      TEST_APPLICATION.deploy_to
    when 'current_path'
      TEST_APPLICATION.current_path
    when 'config_path'
      TEST_APPLICATION.remote.config_path
    when 'releases_path'
      TEST_APPLICATION.remote.releases_path
    when 'shared_path'
      TEST_APPLICATION.remote.shared_path
    when 'assets_path'
      TEST_APPLICATION.remote.assets_path
    when 'tmp_path'
      TEST_APPLICATION.remote_tmp_path
    else
      path
    end
  end

  def resolve_path(path)
    splitted = path.split '/'
    splitted[0] = path_to splitted[0]
    splitted.join '/'
  end
end

World(NavigationHelpers)
