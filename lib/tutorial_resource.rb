class TutorialResource < MiddlemanContentResource
  attr_reader :takeaways
  def initialize(obj)
    super(obj)
    @takeaways = obj.data.takeaways || []
  end

  def listed?
    assigned?
  end
end

def TutorialResource(obj)
  if obj.is_a?(String)
    obj = MiddlemanContentResource.find_sitemap_resource_by_relative_url(obj)
  end
  TutorialResource.new(obj)
end

