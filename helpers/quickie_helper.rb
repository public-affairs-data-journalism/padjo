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


def github_repo_default_branch
  return config[:services][:github_repo][:default_branch] || 'master'
end

# config[:services][:github_repo][:id] must be set
#  or error will be thrown
def path_to_github_repo(use_default_branch = true)
  b = use_default_branch ? "tree/#{github_repo_default_branch}" :  ''
  path = File.join site_service_id(:github_repo, true), b
  URI.join('https://github.com/', path).to_s
end

# a link to a Github file as it appears on Github
def path_to_github_repo_file(root_path, use_default_branch = true)
  URI.join(path_to_github_repo(use_default_branch), root_path)
end

# use this to refer to source files relative to Middleman build
def path_to_github_repo_source_file(source_path, use_default_branch = true)
  sp = File.join('source', source_path)
  path_to_github_repo_file(sp, use_default_branch)
end


def link_to_github_repo_source_file(title, source_path, opts = {})
    c_opts = opts.clone()
    use_def_br = c_opts.delete(:use_default_branch) == false ? false : true
    sp = path_to_github_repo_source_file(source_path, use_def_br)
    if (line_no = c_opts.delete(:line))
      sp + "#L#{line_no}"
    end

    return link_to(title, sp, c_opts)
end
