$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "decidim/meetings/extras/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "decidim-meetings-extras"
  spec.version     = Decidim::Meetings::Extras::VERSION
  spec.authors     = ["Alexandru Emil Lupu"]
  spec.email       = ["contact@alecslupu.ro"]
  spec.homepage    = "https://github.com/tremend-cofe/decidim-meetings-extras"
  spec.summary     = "Decidim meetings enhancements"
  spec.description = "Decidim meetings enhancements"
  spec.license     = "AGPL-3.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "deface"
  spec.add_dependency "decidim-admin"
  spec.add_dependency "decidim-core"
  spec.add_dependency "decidim-meetings"
  spec.add_dependency "virtus"
  spec.add_development_dependency "decidim-dev"
  spec.add_development_dependency "decidim-proposals"
end
