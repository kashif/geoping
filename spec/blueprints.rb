Sham.name  { Faker::Name.name }
Sham.email { Faker::Internet.email }
Sham.title { Faker::Lorem.sentence }
Sham.body  { Faker::Lorem.paragraph }
Sham.url   { Faker::Internet.domain_name }
Sham.lat   { (rand(180000) - 90000)/1000.0 }
Sham.long  { (rand(360000) - 180000)/1000.0 }
Sham.geo   { GeoRuby::SimpleFeatures::Point.from_coordinates([Sham.long, Sham.lat],:srid => 4326) }

Site.blueprint do
  name      { Sham.name }
  url       { Sham.url }
  feed_url  { Sham.url }
  provider  do 
    p = Provider.make_unsaved
    p.default_location = Sham.geo
    p.save
    p
  end
end

Provider.blueprint do
  identity_url      { Sham.url  }
  nickname          { Sham.name }
  email             { Sham.email}
end