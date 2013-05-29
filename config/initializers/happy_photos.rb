require 'yaml'

begin
  HAPPY_PHOTOS = YAML::load(File.read('config/happy_photos.yml'))
rescue
  puts "You need to put a happy_photos.yml file in config directory. see happy_photos.sample.yml for example."
end