#!/usr/bin/ruby

entries = {}
hosts_file = "/etc/hosts_puppet"

if File.exists?(hosts_file)
  hosts = File.open(hosts_file, "r")
  while (line = hosts.gets)
    ip, *host = line.split(" ")
    entries[ip]=host
  end
  hosts.close
end

hosts = File.open(hosts_file, "w+")
puppet_log = File.open("/var/log/puppet/masterhttp.log", "r")

while (line = puppet_log.gets)
  if line.include? "GET /production/node/"
    ip = line.match('(?:[0-9]{1,3}\.){3}[0-9]{1,3}').to_s
    host = line.match('node\/(.*)\?').captures.first
    entries.delete_if {| key, value | value==host }
    entries[ip] = host
  end
end

entries.each {|ip, host|
  hosts.write("#{ip} #{host}\n")
}

hosts.close
puppet_log.close

system "killall -HUP dnsmasq"