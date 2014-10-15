require 'csv'
csv = CSV.open(File.expand_path('../rando_yos.csv', __FILE__), 'w', headers: true)
csv <<  [:recipient, :time, :message]
start_time = Time.new(2014,8,1).to_i
people = [['Pat', 0.15], ['Quinn', 0.40], ['Robin', 0.55], ['Sam', 0.80], ['Tracy', 1.0]]
msg_weights = [11, 10, 9, 8.5, 8, 7.6, 6, 5.5, 5.5, 5.2, 4.5, 4.7, 4.5, 4, 3.3, 2.7].inject([]) do |a, w|
  z = w / 100.0
  a << (a.empty? ? z : a[-1] + z)
end

1500.times do
  r = rand
  name = people.find{|(n, w)| w >= r }[0]
  mr = rand
  seconds = case name
    when 'Sam'
      msg_weights.index{|w| w >= mr } * 86400 + rand(rand < 0.9 ? 66400..86400 : 86400)
    when 'Quinn'
      (14 + 16 - msg_weights.index{|w| w >= mr }) * 86400 + rand(rand < 0.9 ? 66400..86400 : 86400)
    else
      (rand(31) * 86400) + rand(mr < 0.85 ? 32400..66000 : 86400)
    end

  csv << {recipient: name, time: Time.at(start_time + seconds).strftime('%Y-%m-%d %H:%m:%S'), message: 'Yo'}
end

csv.close

