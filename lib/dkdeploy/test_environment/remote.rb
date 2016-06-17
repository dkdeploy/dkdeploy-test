require 'shellwords'
require 'sshkit'

require_relative 'constants'

module Dkdeploy
  module TestEnvironment
    # Class for remote actions
    #
    class Remote
      include Dkdeploy::TestEnvironment::Constants
      include SSHKit::DSL

      attr_accessor :last_command_result, :host, :ssh_config

      def initialize(hostname, ssh_config = {})
        ssh_config[:compression] = 'none'
        @host = SSHKit::Host.new hostname: hostname, ssh_options: ssh_config
      end

      # Check if remote directory exists
      #
      # @param path [String] Remote path
      # @return [Boolean]
      def directory_exists?(path)
        exists? 'd', path
      end

      # Check if remote symlink exists
      #
      # @param path [String] Remote path
      # @return [Boolean]
      def symlink_exists?(path)
        exists? 'L', path
      end

      # Check if remote file exists
      #
      # @param path [String] Remote path
      # @return [Boolean]
      def file_exists?(path)
        exists? 'f', path
      end

      # Execute remote if condition
      #
      # @param type [String] Type of if condition
      # @param path [String] Remote path
      # @return [Boolean]
      def exists?(type, path)
        run %([ -#{type} "#{path}" ] && exit 0 || exit 1)
      end

      # Creates the remote directory
      #
      # @param remote_directory_name [String] the remote directory name
      # @return [Boolean]
      def create_directory(remote_directory_name)
        run %(mkdir -p "#{remote_directory_name}")
      end

      # Creates the remote file with the given content
      #
      # @param file_path [String] the file path to be created
      # @param content [String] the content to be put into the created file
      # @return [Boolean]
      def create_file(file_path, content)
        run %(echo "#{content}" > "#{file_path}")
      end

      # Removes the remote file or directory
      #
      # @param resource_path [String] the remote file or directory path
      # @return [Boolean]
      def remove_resource(resource_path)
        run %(rm -rf "#{resource_path}")
      end

      # Remove the deploy_to path
      #
      # @return [Boolean]
      def remove_deploy_to_path
        run %(sudo rm -rf -R "#{deploy_to}")
      end

      # Remove the source of a symlink
      #
      # @return [String]
      def source_of_symlink(target_symlink_path)
        run %(readlink "#{target_symlink_path}")
      end

      # Execute command on server
      #
      # @param command [String]
      # @return [Boolean]
      def run(command)
        success = false
        result = '' # we need a local variable to capture result from sshkit block
        begin
          on @host do
            result = capture command
          end
          @last_command_result = result
          success = true
        rescue SSHKit::Command::Failed, SSHKit::Runner::ExecuteError
          success = false
        end
        success
      end

      # Gets the remote file content
      #
      # @param file_path [String]
      # @return [Boolean]
      def get_file_content(file_path)
        raise 'Internal server error.' unless run %(less #{file_path})
        last_command_result
      end

      # Gets one of the properties of resource
      #
      # Examples:
      #   get_resource_property('/a/b/c/', 'group') -> www-data
      #   get_resource_property('/a/b/c/', 'group') -> -rwxr-xr--
      #
      # @param path [String] path to the remote file or directory to be examined
      # @param property [String] the property to be returned
      # @return [String] resource property
      def get_resource_property(path, property)
        # run the ls command
        raise 'Internal server error.' unless run %(ls -lad "#{path}")

        # Parses the returned string value and converts it to an array
        # Example: Array[drwxrwxr-x, 3, vagrant, www-data,  4096, Apr, 25, 14:12]
        properties = (last_command_result || '').split(' ')
        # property mapping to the number of the array element
        case property
        when 'permissions'
          property = 0
        when 'owner'
          property = 2
        when 'group'
          property = 3
        else
          raise ArgumentError, 'The given property can not be mapped.'
        end
        properties.at(property) if property.between?(0, properties.count)
      end

      # Checks, if the actually permissions include the expected user permission
      #
      # @param all_permissions [String] Example: -rwxr-xr--
      # @param examined_user_permission [String] Example: w
      # @return [Boolean]
      def user_has_permission?(all_permissions, examined_user_permission)
        user_permissions = all_permissions[1, 3].delete('-') # Example -rwxr-xr-- -> rwx
        user_permissions.include?(examined_user_permission)
      end

      # Checks, if the actually permissions include the expected group permission
      #
      # @param all_permissions [String] Example: -rwxr-xr--
      # @param examined_group_permission [String] Example: w
      # @return [Boolean]
      def group_has_permission?(all_permissions, examined_group_permission)
        group_permissions = all_permissions[4, 3].delete('-') # Example -rwxr-xr-- -> rx
        group_permissions.include?(examined_group_permission)
      end

      # Checks, if the actually permissions include the expected others permission
      #
      # @param all_permissions [String] Example: -rwxr-xr--
      # @param examined_others_permission [String] Example: r
      # @return [Boolean]
      def others_has_permission?(all_permissions, examined_others_permission)
        others_permissions = all_permissions[7, 3].delete('-') # Example -rwxr-xr-- -> r
        others_permissions.include?(examined_others_permission)
      end
    end
  end
end
