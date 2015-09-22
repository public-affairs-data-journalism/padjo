require 'chronic'


class ContentResource
  attr_reader :title, :description, :date, :url, :path, :source_name,
    :full_title
  def friendly_week_date
    @date.strftime("%B %-d")
  end

  def date_slug
    @date.strftime("%Y-%m-%d") if @date
  end
end


class MiddlemanContentResource < ContentResource
  def initialize(resource)
    @url    = resource.url
    @path   = resource.path
    @title  = resource.data.title
    @source_name = nil
    @full_title = @title
    @date   = Chronic.parse(resource.data.date) if resource.data.date
    @description = resource.data.description
  end
end


class HashContentResource < ContentResource
  def initialize(h)
    resource = ActiveSupport::HashWithIndifferentAccess.new(h)
    @url    = resource[:url]
    @path   = resource[:path] || @url
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
    MiddlemanContentResource.new(obj)
  end
end



require 'lib/homework_resource'
require 'lib/week_resource'
