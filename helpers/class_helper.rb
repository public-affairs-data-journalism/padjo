def schedule
  sitemap.resources.select{|r| r.path =~ /weeks\/2015/
    }.map{|r| WeekLesson.new(r)
    }.sort_by{|r| r.date}
end

    # TK: this is already included in onthestreet gem
    # resource has a url and/or title
    def link_to_resource(obj, opts = {})
      if obj.is_a?(Hash)
        obj = ActiveSupport::HashWithIndifferentAccess.new(obj)
        url = obj[:url]
        title = obj[:title] || url
      else
        url = obj.url
        title = obj.title || url
      end

      return link_to(title, url, opts)
    end
