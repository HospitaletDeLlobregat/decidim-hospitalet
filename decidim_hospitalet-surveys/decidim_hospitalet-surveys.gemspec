$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "decidim_hospitalet-surveys"
  s.summary     = "A surveys component for decidim's L'Hospitalet installation."
  s.description = s.summary
  s.version = "0.0.1"
  s.authors = ["Josep Jaume Rey Peroy", "Marc Riera Casals", "Oriol Gual Oliva"]
  s.email = ["josepjaume@gmail.com", "mrc2407@gmail.com", "oriolgual@gmail.com"]

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "decidim-core"
  s.add_dependency "rectify"

  s.add_development_dependency "decidim-dev"
  s.add_development_dependency "decidim-proposals"
end
