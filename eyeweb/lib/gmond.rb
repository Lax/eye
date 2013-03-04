#!/usr/bin/env ruby
require 'socket'
require 'nokogiri'

class Eye
	class Gmond
		def self.fetch(host_name, port)
			file = TCPSocket.open(host_name, port)
			doc = Nokogiri::XML file
			cluster = doc.at('GANGLIA_XML/CLUSTER')

			data = {}
			cluster.css("HOST").each do |host|
				ip = host["IP"]
				data[ip] = Hash.new
				host.css("METRIC").each do |metric|
					case metric["NAME"]
					when 'sq_request_hit_ratio' then
						data[ip]['squid'] ||= Hash.new(0)
						data[ip]['squid']['sq_request_hit_ratio'] = metric["VAL"]
					when 'sq_request_mem_hit_ratio' then
						data[ip]['squid'] ||= Hash.new(0)
						data[ip]['squid']['sq_request_mem_hit_ratio'] = metric["VAL"]
					when 'sq_request_disk_hit_ratio' then
						data[ip]['squid'] ||= Hash.new(0)
						data[ip]['squid']['sq_request_disk_hit_ratio'] = metric["VAL"]
					else
					end
				end
			end

			return data
		end

	end
end

if $0 == __FILE__
  puts Eye::Gmond.fetch('CdnXianTelecom.ganglia.d.xiaonei.com', 8649)
end
