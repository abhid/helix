# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'benchmark'

time = Benchmark.realtime do
  f = open("https://linuxnet.ca/ieee/oui/nmap-mac-prefixes")
  f.each_line do |entry|
    oui, vendor = entry.split(" ")
    rec = Oui.find_or_create_by(oui: "#{oui}000000")
    rec.vendor = vendor
    rec.save
  end
end

puts "Imported #{Oui.count} OUIs in #{"%.2f" % time} s"
