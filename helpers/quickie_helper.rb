def render_toc(opts = {})
  return %Q{

## Table of contents
{:.no_toc}

* Table of contents
{:toc}

}
end

# def content_tag_markdownify(tag_name, opts = {}, &blk)
#   txt = markdownify(capture(&blk))
#   concat content_tag(tag_name, txt, opts)
# end

def content_card(title = nil, opts = {}, &blk) # takes block
  o = ActiveSupport::HashWithIndifferentAccess.new(opts)
  o[:markdown] = true unless o[:markdown] == false
  rtext = capture(&blk)
  rtext = markdownify(rtext) if o[:markdown]
  txt = ""
  txt += content_tag(:div, title, :class => 'header') if title
  txt += content_tag :div, rtext, :class => 'body'
  klasses = o[:class] ? "content-card #{o[:class]}" : "content-card"
  concat content_tag(:div, txt, :class => klasses)
end

