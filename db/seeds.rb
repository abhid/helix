# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'benchmark'

# Import OUIs
if ENV.fetch("IMPORT_OUI") { false }
  time = Benchmark.realtime do
    f = open("https://linuxnet.ca/ieee/oui/nmap-mac-prefixes")
    oui_list = []
    f.each_line do |entry|
      oui, vendor = entry.split(" ")
      rec = Oui.find_or_initialize_by(oui: "#{oui}000000")
      rec.vendor = vendor
      oui_list << rec if rec.new_record?
    end
    Oui.import oui_list
  end
  puts "Imported #{Oui.count} OUIs in #{"%.2f" % time} s"
end

# Import Settings
ad = {server: ENV["AD_SERVER"], base: ENV["AD_BASE"] ,domain: ENV["AD_DOMAIN"]}
Setting["ad"] = ad
ise = {mnt: ENV["ISE_MNT"], pan: ENV["ISE_PAN"], ise_username: ENV["ISE_USERNAME"], ise_password: ENV["ISE_PASSWORD"], pxgrid_username: ENV["PXGRID_USERNAME"], pxgrid_password: ENV["PXGRID_PASSWORD"]}
Setting["ise"] = ise
prime = {server: ENV["PRIME_IP"], username: ENV["PRIME_USERNAME"], password: ENV["PRIME_PASSWORD"]}
Setting["prime"] = prime
infoblox = {server: ENV["BLOX_SERVER"], username: ENV["BLOX_USERNAME"], password: ENV["BLOX_PASSWORD"]}
Setting["infoblox"] = infoblox
