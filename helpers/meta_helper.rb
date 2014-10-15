def page_title
  if (t = current_page.data.title)
    if t != 'Public Affairs Data Journalism'
      t.to_s + " | " + config[:site_title]
    else
      'Public data journalism, lectures and tutorials'
    end
  else
    config[:site_title]
  end
end

def page_description
  current_page.data.description || config[:site_description]
end


def make_markdown(str)
  Kramdown::Document.new(str.to_s).to_html
end
