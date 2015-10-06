def content_listicle(*slugs)
  listicle(*slugs).map{|a| ContentResource(a)}
end

def listicle(*slugs)
   slugs.inject(data.listicles) do |o, s|
      o[s]
    end
end
