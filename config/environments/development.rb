Merb.logger.info("Loaded DEVELOPMENT Environment...")
Merb::Config.use { |c|
  c[:exception_details] = true
<<<<<<< HEAD:config/environments/development.rb
=======
  c[:reload_templates] = true
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:config/environments/development.rb
  c[:reload_classes] = true
  c[:reload_time] = 0.5
<<<<<<< HEAD:config/environments/development.rb
=======
  c[:ignore_tampered_cookies] = true
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:config/environments/development.rb
  c[:log_auto_flush ] = true
<<<<<<< HEAD:config/environments/development.rb
}
=======
  c[:log_level] = :debug

  c[:log_stream] = STDOUT
  c[:log_file]   = nil
  # Or redirect logging into a file:
  # c[:log_file]  = Merb.root / "log" / "development.log"
}
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:config/environments/development.rb
