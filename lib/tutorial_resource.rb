class TutorialResource < MiddlemanContentResource
  attr_reader :takeaways, :next_tutorials, :previous_tutorials
  def initialize(obj)
    super(obj)
    @takeaways = obj.data.takeaways || []
    @next_tutorials = Array(obj.data.next)
    @previous_tutorials = Array(obj.data.previous)
  end

  def next_tutorials?
    !@next_tutorials.empty?
  end

  def previous_tutorials?
    !@previous_tutorials.empty?
  end


end

def TutorialResource(obj)
  if obj.is_a?(String)
    obj = MiddlemanContentResource.find_sitemap_resource_by_relative_url(obj)
  end
  TutorialResource.new(obj)
end

