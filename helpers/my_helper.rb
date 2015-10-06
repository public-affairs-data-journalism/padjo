def sitemap_content_resources
  MiddlemanContentResource.sitemap_resources
end
# TK: this is already included in onthestreet gem
# resource has a url and/or title


def to_content_resource(obj)
  if obj.is_a?(String) # assume it is a relative url
    resource = MiddlemanContentResource(obj)
  else
    resource = ContentResource(obj)
  end
end

## Warning, this overrides OntheStreet::Helpers.link_to_resource
def my_link_to_resource(obj, opts = {})
  resource = to_content_resource(obj)
  url = resource.url
  title = resource.title || url

  return link_to(title, url, opts)
end


def render_content_resource_box(obj, opts = {})
  box = render_content_resource_element(obj, opts)
  content_tag :div, box, :class => 'content-box'
end

def render_content_resource_row(obj, opts = {})
    box = render_content_resource_element(obj, opts)
    content_tag :div, box, :class => 'content-row'
end

def render_content_resource_element(obj, opts = {})
  resource = to_content_resource(obj)
  my_opts = {}
  my_opts[:class] = (opts[:class].to_s + ' resource item content-resource').strip
  content_tag(:div, my_opts) do
    s = ActiveSupport::SafeBuffer.new
    _title_link = my_link_to_resource(resource, :class => 'title')
    # add image
    if resource.image_url
      imgtag = image_tag(resource.image_url, :alt => "image #{resource.title}")
      imglink = link_to(imgtag, resource.url)
      s.safe_concat content_tag(:div, imglink, :class => "image")
    end


    if resource.source_name
      _title_source = content_tag(:span, resource.source_name, {:class => 'source'})
    else
      _title_source = nil
    end
    _title_matter = [_title_link, _title_source].compact.join(' | ')
    c_title_matter = content_tag(:div, _title_matter)
    c_description = content_tag(:div, resource.description, {:class => 'description'})
    c_text = content_tag(:div, c_title_matter + c_description, :class => 'text')
    s.safe_concat(c_text)
    s
  end
end

