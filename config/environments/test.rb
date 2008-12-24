Merb.logger.info("Loaded TEST Environment...")
Merb::Config.use { |c|
<<<<<<< HEAD:config/environments/test.rb
  c[:testing] = true
=======
  c[:testing]           = true
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:config/environments/test.rb
  c[:exception_details] = true
<<<<<<< HEAD:config/environments/test.rb
  c[:log_auto_flush ] = true
}
=======
  c[:log_auto_flush ]   = true
  # log less in testing environment
  c[:log_level]         = :error

  #c[:log_file]  = Merb.root / "log" / "test.log"
  # or redirect logger using IO handle
  c[:log_stream] = STDOUT
}
>>>>>>> dcf87dbaf6e4daa0f80ba12f6ebc919976a2cc75:config/environments/test.rb
