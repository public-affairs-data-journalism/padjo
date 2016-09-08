require 'yaml'
require 'active_support/core_ext/date'

CLASS_START_DATE = Date.new(2015, 9, 22)

def class_dates(some_date)
  wd = some_date.beginning_of_week()
  return [wd + 1, wd + 3]
end


desc "Just push it, via middleman s3_sync push"
task :shoop do |t, args|
  puts "Pushing it real good..."
  IO.popen("bundle exec middleman build && bundle exec middleman s3_sync").each do |line|
    p line.chomp
  end
end


namespace :bootstrap do
  task :weeks do
    (0...10).each do |wnum|
      tuesday = CLASS_START_DATE + wnum * 7
      puts(tuesday)

      open("./source/weeks/#{tuesday}.md.erb", "w") do |f|
        f.write(%Q{---
title: Week of #{tuesday}
description: Week of #{tuesday}
date: #{tuesday}
---
})
      end
    end
  end
end
