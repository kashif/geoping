# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1) do

  create_table "pings", :force => true do |t|
    t.column "name", :string
    t.column "url", :string
    t.column "changes_url", :string
    t.column "feed_url", :string
    t.column "site_id", :integer
    t.column "created_at", :timestamp
    t.column "geom", :point, :srid => 4326, :null => false
  end

  add_index "pings", ["created_at"], :name => "index_pings_on_created_at"
  add_index "pings", ["geom"], :name => "index_pings_on_geom", :spatial=> true 
  add_index "pings", ["site_id"], :name => "index_pings_on_site_id"

  create_table "providers", :force => true do |t|
    t.column "identity_url", :string
    t.column "nickname", :string
    t.column "email", :string
    t.column "salt", :string
    t.column "crypted_password", :string
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
    t.column "default_location", :point, :srid => 4326
  end

  add_index "providers", ["default_location"], :name => "index_providers_on_default_location", :spatial=> true 
  add_index "providers", ["identity_url"], :name => "index_providers_on_identity_url"

  create_table "sites", :force => true do |t|
    t.column "name", :string
    t.column "url", :string
    t.column "feed_url", :string
    t.column "provider_id", :integer
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  add_index "sites", ["provider_id"], :name => "index_sites_on_provider_id"

end
