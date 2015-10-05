def schedule
  sitemap.resources.select{|r| r.path =~ /weeks\/2015/
    }.map{|r| WeekResource(r)
    }.sort_by{|r| r.date}
end

def assignments
  sitemap.resources.select{|r| r.path =~ /assignments\/.+/
    }.map{|r| AssignmentResource(r)
    }.sort_by{|r| r.date_slug }
end

def current_assignments
  assignments.select{|a| a.assigned? }
end

def projected_assignments
  assignments.select{|a| a.projected? }
end

def tutorials
  sitemap.resources.select{ |r| r.path =~ /tutorials\/.+/
    }.map{ |r| TutorialResource(r)
    }.select{ |r| r.listed?
    }.sort_by{ |r| r.ranking }
end


def schedule_first_week_date
  schedule.first.date
end

def schedule_last_week_date
  schedule.last.date
end
