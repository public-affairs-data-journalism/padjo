def schedule
  sitemap.resources.select{|r| r.path =~ /weeks\/2015/
    }.map{|r| WeekLesson.new(r)
    }.sort_by{|r| r.date}
end
