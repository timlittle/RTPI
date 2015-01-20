class RTPIConfig 

	# Edit the following settings
	PUPPETDB_HOST  = 'puppetdb.example.com'
	MYSQL_SOCKET   = '/tmp/mysql.sock'
	MYSQL_HOST     = 'localhost'
	MYSQL_PORT     = '3306'
	MYSQL_DB 	   = 'racktables_db'
	MYSQL_USER 	   = 'racktables_user'
	MYSQL_PASSWORD = 'REPLACEWITHPASSWORD'
	

	# Addition Attirbutes for Racktables
	ATTRIBUTES = [
		{ :id => "10000", :type => "date", :name => "Warranty Start", :servers => ['4'] },
		{ :id => "10001", :type => "string", :name => "Warranty Level", :servers => ['4'] },
		{ :id => "10002", :type => "uint", :name => "CPU Cores", :servers => ['4'] },
		{ :id => "10003", :type => "string", :name => "RAM", :servers => ['4'] },
		{ :id => "10004", :type => "string", :name => "Serial Number", :servers => ['4'] },
		{ :id => "10005", :type => "string", :name => "Product Name", :servers => ['4'] },
		{ :id => "10006", :type => "string", :name => "Operating System", :servers => ['4','1504'] },
		{ :id => "10007", :type => "string", :name => "Operating System Release", :servers => ['4','1504'] },
		{ :id => "10008", :type => "string", :name => "Processor", :servers => ['4'] },
		{ :id => "10009", :type => "date", :name => "Warranty End", :servers => ['4'] },
	]
end
