def course_name(cslug)
#  cslug = article.metadata[:page]['course']
  cslug.upcase.sub('_', ' ')
end

def get_lecture_data(course_slug, lecture_date)
  data_lectures = data.lectures
  data_lectures[course_slug].andand[date_slug(lecture_date)] || Hash.new{|h, k| h[k] = []}
end

def get_lecture_object(article)
  course_slug = article.metadata[:page]['course']
  term_slug = article.metadata[:page]['term']
  xdata = get_lecture_data course_slug, article.date
  k = Hashie::Mash.new
  k[:title] = article.data.title
  k[:description] = article.data.description
  k[:date] = article.date
  k[:excerpt] = article.summary
  k[:topics] = Array(xdata[:topics])
  k[:homework] = Array(xdata[:homework])
  k[:course_name] = course_name course_slug
  k[:term_name] = term_name term_slug
  k[:url] = article.url
  return k
end

def term_name(cslug)
#  cslug = article.metadata[:page]['term']
  cslug.split('_').reverse.join(' ').titleize
end


def friendly_schedule_date(d)
  _to_date(d).strftime('%A, %B %-d')
end



# TODO: make this more like object-oriented and stuff
# this returns an object:
# {
#  name: comm_273d,
#  term: fall_2014,
#  lectures: []
# }
# lectures will have lecture data attached to it
def current_course_schedule
  h = Hashie::Mash.new
  h[:course_slug] = 'comm_273d' # hardcoded
  h[:term_slug] = 'fall_2014'  # hardcoded
  h[:course_name] = course_name h[:course_slug]
  h[:term_name] = term_name h[:term_slug]
  # this seems incredibly sketchy
  h[:lectures] = blog('lectures').articles.sort_by{|a| a.date }.map do |lecture|
    get_lecture_object(lecture)
  end

  return h
end


# returns 3 most relevant lectures
# note: this will be deprecated in favor of doing it in javascript
# but it works for now
def previewed_lectures
  lectures = current_course_schedule.lectures
  cdx = lectures.index{|x| date_slug(x.date) >= date_slug( Time.now)}
  preview_lectures = if cdx == 0
      lectures[0..2]
    elsif cdx.nil? || cdx >= lectures.length
      lectures[-3..-1]
    else
      lectures[(cdx-1)..(cdx+1)]
  end
end
