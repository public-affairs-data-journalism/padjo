require 'yaml'
require 'active_support/core_ext/date'

CLASS_START_DATE = Date.new(2015, 9, 22)

def class_dates(some_date)
  wd = some_date.beginning_of_week()
  return [wd + 1, wd + 3]
end



namespace :bootstrap do
  task :weeks do
    (1..10).each do |wnum|
      open("./source/weeks/#{wnum}.md.erb", "w") do |f|
        f.write("hey")



      end
    end
  end
end
