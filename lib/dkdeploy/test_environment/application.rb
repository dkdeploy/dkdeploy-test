require 'fileutils'
require 'pathname'
require_relative 'constants'
require_relative 'remote'
require_relative 'steps'
require_relative 'env'
require_relative 'mysql'
require_relative 'path'

module Dkdeploy
  module TestEnvironment
    # Test application for capistrano with vagrant
    #
    # @!attribute [r] remote
    #   @return [Dkdeploy::TestEnvironment::Remote]
    class Application
      include Dkdeploy::TestEnvironment::Constants

      attr_reader :remote
      attr_accessor :mysql_connection_settings

      def initialize(base, hostname, ssh_config = {})
        Dkdeploy::TestEnvironment::Constants.class_variable_set :@@root, base
        @remote = Dkdeploy::TestEnvironment::Remote.new hostname, ssh_config
        @mysql_connection_settings = {}
      end

      # Install test environment
      #
      def install
        create_clean_test_application
        initialize_environment
      end

      # Copy test application to temporary dirctory
      #
      def create_clean_test_application
        # Clean old test app path
        FileUtils.rm_rf test_app_path
        # Create test app path parent directory, if not exists
        FileUtils.mkdir_p tmp_path
        # Copy test app to new location
        FileUtils.cp_r template_path, test_app_path
      end

      # Initialize rvm and bundler environment
      #
      def initialize_environment
        # Call command at test bundler environment. Not with gem bundler environment
        Bundler.with_clean_env do
          cd test_app_path do
            # Install necessary gems
            `bundle check || bundle install`
            raise "Error running 'bundle install'" unless $?.success?
          end
        end
      end
    end
  end
end
