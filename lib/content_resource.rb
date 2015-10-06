require 'chronic'


class ContentResource
  attr_reader :title, :description, :date, :url, :path, :source_name,
    :full_title, :image_url
  def friendly_week_date
    @date.strftime("%B %-d")
  end

  def date_slug
    @date.strftime("%Y-%m-%d") if @date
  end
end


class MiddlemanContentResource < ContentResource
  attr_reader :middleman_resource, :source_file, :ranking
  def initialize(resource)
    @middleman_resource = resource
    @source_file = resource.source_file
    @url    = resource.url
    @image_url = resource.image_url
    @path   = resource.path
    @title  = resource.data.title
    @ranking = resource.data.ranking || 99999
    @_listed = resource.data.listed
    @source_name = nil
    @full_title = @title
    @date   = Chronic.parse(resource.data.date) if resource.data.date
    @description = resource.data.description
  end

  def content_size
    File.size(@source_file)
  end

  def stub?
    content_size < 1024
  end


  def listed?
    @_listed == true
  end

  def self.set_sitemap(sitemap) #UGGHGHGHGHTK
    @sitemap = sitemap
  end

  def self.sitemap_resources
    @sitemap.resources # theoretically could be scoped to just briefs/tutorials/etc
  end

  # rel_url is a String: /articles/my-fav-article
  #  trailing slash is optional
  def self.find_sitemap_resource_by_relative_url(rel_url)
    rel_url += '/' unless rel_url[-1] == '/'
    r = self.sitemap_resources.find{|p| p.url == rel_url }
  end
end

def MiddlemanContentResource(obj)
  if obj.is_a?(String)
    obj = MiddlemanContentResource.find_sitemap_resource_by_relative_url(obj)
  end
  MiddlemanContentResource.new(obj)
end


class HashContentResource < ContentResource
  def initialize(h)
    resource = ActiveSupport::HashWithIndifferentAccess.new(h)
    @url    = resource[:url]
    @path   = resource[:path] || @url
    @image_url = resource[:image_url]
    @title  = resource[:title]
    if resource[:source]
      @source_name = resource[:source]
    else
      _u = URI.parse(@url)
      if _u.absolute?
        @source_name = _u.host.sub(/^www\./, '')
      else
        @source_name = nil
      end
    end
    @full_title = [@title, @source_name].compact.join(' | ')
    @uid    = @url
    @date   = Chronic.parse(resource[:date]) if resource[:date]
    @description = resource[:description]
  end
end



def ContentResource(obj)
  if obj.is_a?(ContentResource)
    obj
  elsif obj.is_a?(Hash)
    HashContentResource.new(obj)
  else
    MiddlemanContentResource(obj)
  end
end


require 'lib/assignment_resource'
require 'lib/tutorial_resource'
require 'lib/week_resource'
