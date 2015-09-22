def sitemap_content_resources
  sitemap.resources # theoretically could be scoped to just briefs/tutorials/etc
end
# TK: this is already included in onthestreet gem
# resource has a url and/or title


def to_content_resource(obj)
  if obj.is_a?(String) # assume it is a relative url
    resource = find_middleman_resource_by_relative_url(obj)
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


def render_content_resource_element(obj, opts = {})
  resource = to_content_resource(obj)
  my_opts = {}
  my_opts[:class] = (opts[:class].to_s + ' resource item').strip
  content_tag(:div, my_opts) do
    s = ActiveSupport::SafeBuffer.new
    _title_link = my_link_to_resource(resource, :class => 'title')
    if resource.source_name
      _title_source = content_tag(:span, resource.source_name, {:class => 'source'})
    else
      _title_source = nil
    end
    _title_matter = [_title_link, _title_source].compact.join(' | ')
    c_title_matter = content_tag(:div, _title_matter)
    c_description = content_tag(:div, resource.description, {:class => 'description'})
    s.safe_concat(c_title_matter)
    s.safe_concat(c_description)
    s
  end
end

# rel_url is a String: /articles/my-fav-article
#  trailing slash is optional
def find_middleman_resource_by_relative_url(rel_url)
  rel_url += '/' unless rel_url[-1] == '/'
  r = sitemap_content_resources.find{|p| p.url == rel_url }
  return MiddlemanContentResource.new(r)
end