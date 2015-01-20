#!/usr/bin/env ruby

require 'mysql2'
require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require 'openssl'
require 'date'

# My libs
require_relative 'config'
require_relative 'collectors'
require_relative 'updaters'

begin
	# Create the connection to MySQL
	if not RTPIConfig::MYSQL_SOCKET == ''
		con = Mysql2::Client.new(:socket => "#{RTPIConfig::MYSQL_SOCKET}", :database => "#{RTPIConfig::MYSQL_DB}", :username => "#{RTPIConfig::MYSQL_USER}", :password => "#{RTPIConfig::MYSQL_PASSWORD}")
	else
		con = Mysql2::Client.new(:host => "#{RTPIConfig::MYSQL_HOST}",:port => "#{RTPIConfig::MYSQL_PORT}", :database => "#{RTPIConfig::MYSQL_DB}", :username => "#{RTPIConfig::MYSQL_USER}", :password => "#{RTPIConfig::MYSQL_PASSWORD}")
	end

	# Check the asset attributes are in the database
	check_attribute_fields(con)

	# Get all the nodes from PuppetDB
	get_puppet_nodes.each do | node |

		# Get the facts for the current node
		facts = get_puppet_facts(node['name'])
		hostname = node['name'][/(.+?)(?=\.)/]
		
		if con.query("SELECT name FROM Object WHERE name = '#{hostname}'").count > 0
			update_server(con,hostname,facts)
		else
			add_new_server(con,hostname,facts)
			update_server(con,hostname,facts)
		end
	end

rescue Mysql2::Error => e
	puts e.errno
	puts e.error

ensure
	con.close if con
end
