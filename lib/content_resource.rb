require 'chronic'
class ContentResource
  attr_reader :title, :description, :date, :url, :path, :slug
  def initialize(resource)
    @url    = resource.url
    @path   = resource.path
    @title  = resource.data.title
    @slug   = File.basename(@path).gsub(/\.\w{2,4}$/, '')
    @date   = Chronic.parse(resource.data.date)
    @description = resource.data.description
  end

  def friendly_week_date
    @date.strftime("%B %-d")
  end
end
