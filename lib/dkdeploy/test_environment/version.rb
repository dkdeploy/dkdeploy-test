module Dkdeploy
  module TestEnvironment
    # Class for version number
    #
    class Version
      MAJOR = 1
      MINOR = 0
      PATCH = 0

      def self.to_s
        [MAJOR, MINOR, PATCH].join('.')
      end
    end
  end
end
