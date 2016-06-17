require 'fileutils'

module Dkdeploy
  module TestEnvironment
    # Dkdeploy test constants.
    #
    module Constants
      include FileUtils

      @@root = File.expand_path '../..', __FILE__ # rubocop:disable Style/ClassVars

      # Gem root path
      #
      # @return [String]
      def gem_root
        @@root
      end

      # Test app template path
      #
      # @return [String]
      def template_path
        File.join gem_root, 'spec', 'fixtures', 'application'
      end

      # Path to temporary directory
      #
      # @return [String]
      def tmp_path
        File.join gem_root, 'tmp'
      end

      # Test app path
      #
      # @return [String]
      def test_app_path
        File.join tmp_path, 'aruba'
      end

      # Capistrano configuration fixtures path
      #
      # @return [String]
      def capistrano_configuration_fixtures_path
        File.join gem_root, 'spec', 'fixtures', 'capistrano', 'configuration'
      end

      # Capistrano config dev path
      #
      # @return [String]
      def config_dev_path
        File.join test_app_path, 'config', 'deploy', 'dev.rb'
      end

      # Capistrano stage for tests
      #
      # @return [String]
      def stage
        'dev'
      end

      # Url to vagrant server
      #
      # @return [String]
      def server_url
        'dkdeploy.dev'
      end

      # Deploy to path
      #
      # @return [String]
      def deploy_to
        File.join('/', 'var', 'www', 'dkdeploy')
      end

      # Shared path
      #
      # @return [String]
      def shared_path
        File.join deploy_to, 'shared'
      end

      # Assets path
      #
      # @return [String]
      def assets_path
        File.join shared_path, 'assets'
      end

      # Current path
      #
      # @return [String]
      def current_path
        File.join deploy_to, 'current'
      end

      # Release path
      #
      # @return [String]
      def releases_path
        File.join deploy_to, 'releases'
      end

      # maintenance config file path
      #
      # @return [String]
      def maintenance_config_file_path
        File.join shared_path, 'config', 'maintenance.json'
      end

      # remote temporary directory path
      #
      # @return [String]
      def remote_tmp_path
        '/tmp'
      end
    end
  end
end
