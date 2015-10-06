class TutorialResource < MiddlemanContentResource
  def listed?
    assigned?
  end
end

def TutorialResource(obj)
  if obj.is_a?(String)
    obj = MiddlemanContentResource.find_sitemap_resource_by_relative_url(obj)
  end
  WeekResource.new(obj)
end

