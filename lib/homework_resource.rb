class HomeworkResource < MiddlemanContentResource
  attr_reader :deliverables, :points, :requirements
  def initialize(resource)
    super(resource)
    @deliverables = resource.data.deliverables
    @requirements = resource.data.requirements
    @points = resource.data.points

  end

  def date_slug
    if @date
      super
    else
      'TBA'
    end
  end
end
