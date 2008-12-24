Merb.logger.info("Loaded RAKE Environment...")
Merb::Config.use { |c|
  c[:exception_details] = true
  c[:reload_classes]  = false
  c[:log_auto_flush ] = true
<<<<<<< HEAD:config/environments/rake.rb
<<<<<<< HEAD:config/environments/rake.rb
  c[:log_file] = Merb.log_path / 'merb_rake.log'
}
=======
=======
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:config/environments/rake.rb

  c[:log_stream] = STDOUT
  c[:log_file]   = nil
  # Or redirect logging into a file:
  # c[:log_file]  = Merb.root / "log" / "development.log"
}
<<<<<<< HEAD:config/environments/rake.rb
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:config/environments/rake.rb
=======
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:config/environments/rake.rb
