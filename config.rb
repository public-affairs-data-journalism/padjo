# Kramdown
set :markdown_engine, :kramdown
set :markdown, :toc_levels => 1..3
set :trailing_slash, true

# Plugins
activate :directory_indexes
activate :i18n, :mount_at_root => :en
activate :livereload
activate :syntax, :line_numbers => false


activate :onthestreet_extension
puts config[:services]

## SETTINGS
set :layout, :page


# Build-specific configuration
configure :build do

end




activate :s3_sync do |s3_sync|
  s3_sync.bucket                     = 'fall2015.padjo.org' # The name of the S3 bucket you are targetting. This is globally unique.
  s3_sync.region                     = 'us-east-1'     # The AWS region for your bucket.
  s3_sync.delete                     = false # We delete stray files by default.
  s3_sync.after_build                = true # We do not chain after the build step by default.
  s3_sync.prefer_gzip                = false
  s3_sync.path_style                 = true
  s3_sync.reduced_redundancy_storage = false
  s3_sync.acl                        = 'public-read'
  s3_sync.encryption                 = false
  s3_sync.prefix                     = ''
end
