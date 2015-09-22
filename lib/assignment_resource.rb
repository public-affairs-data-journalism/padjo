class AssignmentResource < MiddlemanContentResource
  attr_reader :deliverables, :points, :requirements
  def initialize(resource)
    super(resource)
    @deliverables = resource.data.deliverables
    @requirements = resource.data.requirements
    @points = resource.data.points
    @assigned = resource.data.assigned == true ? true : false
  end

  def assigned?
    @assigned == true
  end

  def projected?
    !assigned?
  end

  def date_slug
    if @date
      super
    else
      'TBA'
    end
  end
end



# todo: proper class hierarchy
def AssignmentResource(obj)
  if obj.is_a?(String)
    obj = MiddlemanContentResource.find_sitemap_resource_by_relative_url(obj)
  end
  AssignmentResource.new(obj)
end

