def topic_link(t, opts={})
  topic = extract_topic(t)

  link_to( topic_name(topic), "/tutorials##{topic_slug(topic)}", opts)
end

def topic_name(t)
  extract_topic(t).capitalize
end

def topic_slug(t)
  extract_topic(t).downcase
end

def topic_url(topic)
  "/tutorials/#{topic_slug(extract_topic topic)}"
end

def extract_topic(t)
  t.is_a?(String) ? t : t.metadata[:page]['topic']
end
