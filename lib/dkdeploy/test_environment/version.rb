module Dkdeploy
  module TestEnvironment
    # Class for version number
    #
    class Version
      MAJOR = 2
      MINOR = 0
      PATCH = 1

      def self.to_s
        [MAJOR, MINOR, PATCH].join('.')
      end
    end
  end
end
