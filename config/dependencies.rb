# dependencies are generated using a strict version, don't forget to edit the dependency versions when upgrading.
merb_gems_version = "1.0.15"
dm_gems_version   = "~> 0.10"

# For more information about each component, please read http://wiki.merbivore.com/faqs/merb_components
dependency "merb-helpers", merb_gems_version
dependency "merb-slices", merb_gems_version  
# dependency "merb-auth-core", merb_gems_version
# dependency "merb-auth-more", merb_gems_version
# dependency "merb-auth-slice-password", merb_gems_version
dependency "merb-param-protection", merb_gems_version
dependency "merb-exceptions", merb_gems_version

dependency "nokogiri",          ">=1.4.1"

dependency "pg",                ">= 0.8.0"
dependency "activerecord",      "= 2.3.5", :immediate => true
dependency "merb_activerecord", "1.0.0.1"

# need to give activerecord a chance to load before hitting this one
Merb::BootLoader.after_app_loads do
  dependency "GeoRuby",                 "= 1.6.3", :require_as => "geo_ruby"
  dependency "merb_has_rails_plugins",  ">= 0.1.0"
end

