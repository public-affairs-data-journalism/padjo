def render_toc(opts = {})
  return %Q{

## Table of contents
{:.no_toc}

* Table of contents
{:toc}

}
end


def content_row_side_by_side(mk1, mk2)

  col_1 = content_tag(:div, markdownify(mk1), :class => 'col-sm-6')
  col_2 = content_tag(:div, markdownify(mk2), :class => 'col-sm-6')

  content_tag(:div, col_1 + col_2, :class => 'row')
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

