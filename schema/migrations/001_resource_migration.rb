class ResourceMigration < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :name
      t.string :url
      t.string :changesURL
      t.string :rssURL
      t.string :tag
  
      t.timestamps
    end
 
  end

  def self.down
    drop_table :resources
  end
end
