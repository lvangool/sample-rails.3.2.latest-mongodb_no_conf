require 'dragonfly'
app = Dragonfly[:images]

app.configure_with(:imagemagick)
app.configure_with(:rails)
if Rails.env.production?
  app.configure do |c|
    c.datastore = Dragonfly::DataStorage::S3DataStore.new(
      :bucket_name => 'nzk-assets',
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET'],
      :region => 'eu-west-1'
    )
  end
end

app.define_macro_on_include(Mongoid::Document, :image_accessor)