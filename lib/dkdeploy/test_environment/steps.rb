# Loads steps from directory `./step_definitions'.
Dir.glob(File.expand_path('../step_definitions/*.rb', __FILE__)).each { |step_file| require step_file }
