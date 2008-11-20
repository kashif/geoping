# dependencies are generated using a strict version, don't forget to edit the dependency versions when upgrading.
merb_gems_version = "1.0.1"
dm_gems_version   = "0.9.7"

# For more information about each component, please read http://wiki.merbivore.com/faqs/merb_components
dependency "merb-helpers", merb_gems_version
dependency "merb-slices", merb_gems_version  
# dependency "merb-auth-core", merb_gems_version
# dependency "merb-auth-more", merb_gems_version
# dependency "merb-auth-slice-password", merb_gems_version
dependency "merb-param-protection", merb_gems_version
dependency "merb-exceptions", merb_gems_version

dependency "nokogiri", ">=1.0.2"

dependency "postgres",          ">= 0.7.9.2008.01.28"
dependency "activerecord",      "= 2.1.2", :immediate => true
dependency "merb_activerecord", "0.9.9"

# need to give activerecord a chance to load before hitting this one
Merb::BootLoader.after_app_loads do
  dependency "GeoRuby",           "= 1.3.3", :require_as => "geo_ruby"
  dependency "merb_has_rails_plugins", ">= 0.1.0"
end

