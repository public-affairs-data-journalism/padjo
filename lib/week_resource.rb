class WeekResource < MiddlemanContentResource
  attr_reader :lessons, :assignments
  def initialize(obj)
    super(obj)
    @lessons = (obj.data.lessons || []).map{|x| ContentResource(x)}
    @assignments = (obj.data.assignments || []).map{|x| AssignmentResource(x)}
  end

  def assignments?
    !assignments.empty?
  end

  def lessons?
    !lessons.empty?
  end
end

# todo: proper class hierarchy
def WeekResource(obj)
  if obj.is_a?(String)
    obj = MiddlemanContentResource.find_sitemap_resource_by_relative_url(obj)
  end
  WeekResource.new(obj)
end


