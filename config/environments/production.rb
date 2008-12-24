Merb.logger.info("Loaded PRODUCTION Environment...")
Merb::Config.use { |c|
  c[:exception_details] = false
  c[:reload_classes] = false
  c[:log_level] = :error
<<<<<<< HEAD:config/environments/production.rb
  c[:log_file] = Merb.log_path + "/production.log"
}
=======
  
  c[:log_file]  = Merb.root / "log" / "production.log"
  # or redirect logger using IO handle
  # c[:log_stream] = STDOUT
}
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:config/environments/production.rb
