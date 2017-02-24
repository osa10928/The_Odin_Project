require "csv"

puts "Event Manager Initialize!"



def clean_phone_number(number)
	number = number.scan(/\d/).join("")
	if number.length < 10 || number.length > 11 || (number.length == 11 && number[0] != "1")
		number = nil
	elsif number.length == 11 && number[0] == "1"
		number = number[1..-1]
	end
	number
end


contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

reg_hour = Hash.new 0
reg_wday = Hash.new 0

contents.each do |row|
  name = row[:first_name] 

  phone = clean_phone_number(row[:homephone])

  date = DateTime.strptime(row[:regdate], "%m/%d/%Y %H:%M")
  reg_hour[date.hour] += 1
  reg_wday[date.wday] += 1

  puts "#{name} #{phone} #{date.strftime("%H:%M")} #{date.strftime("%A")}"

end
puts "Most popular hour of day: #{reg_hour.key reg_hour.values.max}"
puts "Most popular day: #{Date::DAYNAMES[reg_wday.key reg_wday.values.max]}"

