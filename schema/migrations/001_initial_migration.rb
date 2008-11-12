class InitialMigration < ActiveRecord::Migration
  def self.up
    
    say "Creating Providers"
    create_table :providers, :force => true do |t|
      t.string      :identity_url
      t.string      :nickname
      t.string      :email
      t.column      :default_location, :point, :null=>false, :srid => 4326
      t.timestamps
    end
    add_index :providers, :identity_url
    add_index :providers, :default_location, :spatial=>true
    
    create_table :sites, :force => true do |t|
      t.string      :name
      t.string      :domain
      t.string      :base_path
      t.string      :feed_url
      t.integer     :provider_id
      t.timestamps
    end
    add_index :sites, :provider_id
    
    say "Creating Pings Table"
    create_table :pings, :force => true do |t|
      t.string      :name
      t.string      :url
      t.string      :changes_url
      t.string      :feed_url
      t.integer     :site_id
      t.column      :geom, :point, :null => false, :srid => 4326
      t.datetime    :created_at
    end
    add_index :pings, :site_id
    add_index :pings, :created_at
    add_index :pings, :geom, :spatial => true
    
  end

  def self.down
  end
end
