def schedule
  sitemap.resources.select{|r| r.path =~ /weeks\/2015/
    }.map{|r| WeekResource.new(r)
    }.sort_by{|r| r.date}
end

def homeworks
  sitemap.resources.select{|r| r.path =~ /homework\/2015/
    }.map{|r| Homework.new(r)
    }.sort_by{|r| r.date_slug }
end



def schedule_first_week_date
  schedule.first.date
end

def schedule_last_week_date
  schedule.last.date
end
