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

def content_card(title = nil, &blk) # takes block
  txt = ""
  txt += content_tag( :div, title, :class => 'header') if title
  txt += content_tag :div, markdownify(capture(&blk)), :class => 'body'
  concat content_tag(:div, txt, :class => 'content-card')
end


# helper method for getting config[:services][:service_name][:id]
def site_service_id(service_name, error_on_nil = false)
  begin
    s_id = config[:services][service_name.to_sym][:id]
  rescue NoMethodError => e
    if error_on_nil == false
      return nil
    else
      raise e
    end
  else
    return s_id
  end
end

# config[:services][:github_repo][:id] must be set
#  or error will be thrown
def github_repo_base_url
  URI.join('https://github.com/', site_service_id(:github_repo, true)).to_s
end


def github_repo_branch
  return config[:services][:github_repo][:branch] || 'master'
end

def github_repo_branch_path(use_branch = true)
   b = use_branch ? "tree/#{github_repo_branch}" :  ''
   File.join site_service_id(:github_repo, true), b
end



# a link to a Github file as it appears on Github
def path_to_github_repo_file(root_path, use_branch = true)
  bpath = use_branch ? "tree/#{github_repo_branch}" : 'tree/master'
  file_path = File.join bpath, root_path
  File.join(github_repo_base_url, file_path).sub('//', '/')
end

# use this to refer to source files relative to Middleman build
def path_to_github_repo_source_file(source_path, use_branch = true)
  sp = File.join('source', source_path)
  URI.escape path_to_github_repo_file(sp, use_branch)
end


def link_to_github_repo_source_file(title, source_path, opts = {})
    c_opts = opts.clone()
    use_br = c_opts.delete(:use_branch) == false ? false : true
    sp = path_to_github_repo_source_file(source_path, use_br)
    if (line_no = c_opts.delete(:line))
      sp << "#L#{line_no}"
    end

    return link_to(title, sp, c_opts)
end
