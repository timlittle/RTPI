# Function for checking if the right fields are in the Attribute table
def check_attribute_fields(con)
	# Check for Warranty start date
	if not con.query("SELECT name FROM Attribute WHERE name = 'Warranty start'").count > 0
		con.query("INSERT INTO Attribute (id,type,name) VALUES (10000,'date','Warranty start')")
		con.query("INSERT INTO AttributeMap (objtype_id,attr_id) VALUES (4,10000)")
	end

	# Check for Warranty Level
	if not con.query("SELECT name FROM Attribute WHERE name = 'Warranty level'").count > 0
		con.query("INSERT INTO Attribute (id,type,name) VALUES (10001,'string','Warranty level')")
		con.query("INSERT INTO AttributeMap (objtype_id,attr_id) VALUES (4,10001)")
	end

	# Check for CPU cores
	if not con.query("SELECT name FROM Attribute WHERE name = 'CPU cores'").count > 0
		con.query("INSERT INTO Attribute (id,type,name) VALUES (10002,'uint','CPU cores')")
		con.query("INSERT INTO AttributeMap (objtype_id,attr_id) VALUES (4,10002)")
	end

	# Check for RAM
	if not con.query("SELECT name FROM Attribute WHERE name = 'RAM'").count > 0
		con.query("INSERT INTO Attribute (id,type,name) VALUES (10003,'string','RAM')")
		con.query("INSERT INTO AttributeMap (objtype_id,attr_id) VALUES (4,10003)")
	end

	# Check for Serial Number
	if not con.query("SELECT name FROM Attribute WHERE name = 'Serial number'").count > 0
		con.query("INSERT INTO Attribute (id,type,name) VALUES (10004,'string','Serial number')")
		con.query("INSERT INTO AttributeMap (objtype_id,attr_id) VALUES (4,10004)")
	end

	# Check for Product name
	if not con.query("SELECT name FROM Attribute WHERE name = 'Product name'").count > 0
		con.query("INSERT INTO Attribute (id,type,name) VALUES (10005,'string','Product name')")
		con.query("INSERT INTO AttributeMap (objtype_id,attr_id) VALUES (4,10005)")
	end

	# Check for Operating system
	if not con.query("SELECT name FROM Attribute WHERE name = 'Operating system'").count > 0
		con.query("INSERT INTO Attribute (id,type,name) VALUES (10006,'string','Operating system')")
		con.query("INSERT INTO AttributeMap (objtype_id,attr_id) VALUES (4,10006)")
		con.query("INSERT INTO AttributeMap (objtype_id,attr_id) VALUES (1504,10006)")
	end

	# Check for Operating system release
	if not con.query("SELECT name FROM Attribute WHERE name = 'Operating system release'").count > 0
		con.query("INSERT INTO Attribute (id,type,name) VALUES (10007,'string','Operating system release')")
		con.query("INSERT INTO AttributeMap (objtype_id,attr_id) VALUES (4,10007)")
		con.query("INSERT INTO AttributeMap (objtype_id,attr_id) VALUES (1504,10007)")
	end

	# Check for Processor
	if not con.query("SELECT name FROM Attribute WHERE name = 'Processor'").count > 0
		con.query("INSERT INTO Attribute (id,type,name) VALUES (10008,'string','Processor')")
		con.query("INSERT INTO AttributeMap (objtype_id,attr_id) VALUES (4,10008)")
	end

	# Check for Warranty End date
	if not con.query("SELECT name FROM Attribute WHERE name = 'Warranty end'").count > 0
		con.query("INSERT INTO Attribute (id,type,name) VALUES (10009,'date','Warranty end')")
		con.query("INSERT INTO AttributeMap (objtype_id,attr_id) VALUES (4,10009)")
	end

end

# Function for adding a server to the database
def add_new_server(con,hostname,facts)

	if facts['virtual'] == 'physical'
		# Physical
		con.query("INSERT INTO Object (name,label,objtype_id) VALUES ('#{hostname}','#{hostname}',4)")
	else
		# Virtual
		con.query("INSERT INTO Object (name,label,objtype_id) VALUES ('#{hostname}','#{hostname}',1504)")
	end
end

# Function for updating a prexisiting server
def update_server(con,hostname,facts)
	objectid = get_object_id(con,hostname)
	objecttypeid = get_object_type_id(con,hostname)

	# FQDN
	if not con.query("SELECT string_value FROM AttributeValue WHERE object_id = #{objectid} AND attr_id = 3").count > 0
		con.query("INSERT INTO AttributeValue (object_id,object_tid,attr_id,string_value) VALUES (#{objectid},#{objecttypeid},3,'#{facts['fqdn']}')")
		puts "Added FQDN for #{hostname}"
	end
	# Operating System
	if not con.query("SELECT string_value FROM AttributeValue WHERE object_id = #{objectid} AND attr_id = 10006").count > 0
		con.query("INSERT INTO AttributeValue (object_id,object_tid,attr_id,string_value) VALUES (#{objectid},#{objecttypeid},10006,'#{facts['operatingsystem']}')")
		puts "Added OS for #{hostname}"
	end
	# Operating System Release
	if not con.query("SELECT string_value FROM AttributeValue WHERE object_id = #{objectid} AND attr_id = 10007").count > 0
		con.query("INSERT INTO AttributeValue (object_id,object_tid,attr_id,string_value) VALUES (#{objectid},#{objecttypeid},10007,'#{facts['operatingsystemrelease']}')")
		puts "Added OS Release for #{hostname}"
	end

	if facts['virtual'] == 'physical'

		if facts['manufacturer'] == 'Dell Inc.'
			if not con.query("SELECT uint_value FROM AttributeValue WHERE object_id = #{objectid} AND attr_id = 10009").count > 0
				warranty = get_dell_warranty_info(facts['serialnumber'])

				# Warranty end
				enddate = DateTime.parse(warranty[:enddate]).to_time.to_i
				con.query("INSERT INTO AttributeValue (object_id,object_tid,attr_id,uint_value) VALUES (#{objectid},#{objecttypeid},10009,'#{enddate}')")
				puts "Added Warranty End for #{hostname}"

				# Warranty Start
				if not con.query("SELECT uint_value FROM AttributeValue WHERE object_id = #{objectid} AND attr_id = 10000").count > 0
					startdate = DateTime.parse(warranty[:startdate]).to_time.to_i
					con.query("INSERT INTO AttributeValue (object_id,object_tid,attr_id,uint_value) VALUES (#{objectid},#{objecttypeid},10000,'#{startdate}')")
					puts "Added Warranty Start for #{hostname}"
				end

				# Warranty Level
				if not con.query("SELECT string_value FROM AttributeValue WHERE object_id = #{objectid} AND attr_id = 10001").count > 0
					con.query("INSERT INTO AttributeValue (object_id,object_tid,attr_id,string_value) VALUES (#{objectid},#{objecttypeid},10001,'#{warranty[:level]}')")
					puts "Added Warranty Level for #{hostname}"
				end
			end
		end

		# Serial Number/Service tag
		if not con.query("SELECT string_value FROM AttributeValue WHERE object_id = #{objectid} AND attr_id = 10004").count > 0
			con.query("INSERT INTO AttributeValue (object_id,object_tid,attr_id,string_value) VALUES (#{objectid},#{objecttypeid},10004,'#{facts['serialnumber']}')")
			puts "Added Serial Number for #{hostname}"
		end

		# CPU
		if not con.query("SELECT string_value FROM AttributeValue WHERE object_id = #{objectid} AND attr_id = 10008").count > 0
			con.query("INSERT INTO AttributeValue (object_id,object_tid,attr_id,string_value) VALUES (#{objectid},#{objecttypeid},10008,'#{facts['processor']}')")
			puts "Added Processor for #{hostname}"
		end

		# CPU Number
		if not con.query("SELECT uint_value FROM AttributeValue WHERE object_id = #{objectid} AND attr_id = 10002").count > 0
			con.query("INSERT INTO AttributeValue (object_id,object_tid,attr_id,uint_value) VALUES (#{objectid},#{objecttypeid},10002,'#{facts['processorcount']}')")
			puts "Added Processor Number for #{hostname}"
		end

		# RAM
		if not con.query("SELECT string_value FROM AttributeValue WHERE object_id = #{objectid} AND attr_id = 10003").count > 0
			con.query("INSERT INTO AttributeValue (object_id,object_tid,attr_id,string_value) VALUES (#{objectid},#{objecttypeid},10003,'#{facts['memorysize']}')")
			puts "Added RAM for #{hostname}"
		end

		# Product Name
		if not con.query("SELECT string_value FROM AttributeValue WHERE object_id = #{objectid} AND attr_id = 10005").count > 0
			con.query("INSERT INTO AttributeValue (object_id,object_tid,attr_id,string_value) VALUES (#{objectid},#{objecttypeid},10005,'#{facts['productname']}')")
			puts "Added Product Name for #{hostname}"
		end

	end

end
