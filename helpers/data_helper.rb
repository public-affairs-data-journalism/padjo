def listicle(slug)
  return data.listicles[slug].map{|a| ContentResource(a)}
end
