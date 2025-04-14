require 'fileutils'

namespace :hashcash do
  desc "Copy hashcash.js from the gem to app/packs/src/vendor"
  task :copy_js do
    source = Gem.loaded_specs['active_hashcash'].full_gem_path + '/app/assets/javascripts/hashcash.js'
    destination = 'app/packs/src/vendor/hashcash.js'
    FileUtils.cp(source, destination)
    puts "Copied #{source} to #{destination}"
  end
end