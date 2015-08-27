require 'pry'

set :markdown_engine, :kramdown
set :markdown, :layout_engine => :slim,
  tables: true,
  coderay_line_numbers: nil

set :trailing_slash, true
set :site_title, 'Public Affairs Data Journalism at Stanford University'
set :site_description, "Civic accountability journalism taught at the Stanford University Graduate Journalism Program"
set :typekit_id, 'deu1taf'
set :google_analytics_id, 'UA-55019978-1'

activate :i18n, :mount_at_root => :en
activate :livereload
# Slim configuration
set :slim, {
  :format  => :html5,
  :indent => '    ',
  :pretty => true,
  :sort_attrs => false
}
::Slim::Engine.set_default_options lang: I18n.locale, locals: {}

# Compass configuration
set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :files_dir, 'assets/files'

# Build-specific configuration
configure :build do
  ignore 'images/*.psd'
  ignore 'stylesheets/lib/*'
  ignore 'stylesheets/vendor/*'
  ignore 'javascripts/lib/*'
  ignore 'javascripts/vendor/*'

  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript




  # Enable cache buster
  # activate :cache_buster

  # Use relative URLs
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end


activate :blog do |class_blog|
  class_blog.name = "lectures"
  class_blog.sources = "/lectures/{course}/{term}/{year}-{month}-{day}.html"
  # class_blog.permalink = "/lectures/{course}/{term}/{year}-{month}-{day}"
  # this will probably bite me in the ass if I decide to store
  # multiple terms/classes in this thing, but it sure is convenient right now:
  class_blog.permalink = "/{year}-{month}-{day}"
  class_blog.layout = "lecture"
  class_blog.publish_future_dated = true
  class_blog.summary_separator = /SPLIT_SUMMARY_BEFORE_THIS/
  # blog.custom_collections = {
  #   term: {
  #     link: '/classes/{term}.html',
  #     # template: 'layouts/term.html'
  #   }
  # }
end

activate :blog do |tutorial_blog|
  tutorial_blog.name = "tutorials"
  tutorial_blog.sources = "/tutorials/{topic}/{title}.html"
  tutorial_blog.permalink = "/tutorials/{topic}/{title}"
  tutorial_blog.summary_separator = /<!-- SPLIT_SUMMARY -->/
  tutorial_blog.layout = "tutorial"
  tutorial_blog.publish_future_dated = true
end


activate :s3_sync do |s3_sync|
  s3_sync.bucket                     = 'fall2014.padjo.org' # The name of the S3 bucket you are targetting. This is globally unique.
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


activate :directory_indexes


ready do
  # Add bower's directory to sprockets asset path
  @bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
  sprockets.append_path File.join "#{root}", @bower_config["directory"]
end


## -------------------------------------------------------------------
## -------------------------------------------------------------------
## -------------------------------------------------------------------
## -------------------------------------------------------------------

###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end


# # More Build-specific configuration
# configure :build do
#   # Enable cache buster
#   # activate :cache_buster

#   # Use relative URLs
#   # activate :relative_assets

#   # Compress PNGs after build
#   # First: gem install middleman-smusher
#   # require "middleman-smusher"
#   # activate :smusher

#   # Or use a different image path
#   # set :http_path, "/Content/images/"
# end



### S3 stuff

