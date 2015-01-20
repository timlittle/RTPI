# Function for getting the warranty information for a machine from the Dell public API
def get_dell_warranty_info(servicetag)
	uri = URI.parse('https://api.dell.com/support/v2/assetinfo/warranty/tags.json')
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	params = {:svctags => "#{servicetag}", :apikey => '1adecee8a60444738f280aad1cd87d0e'}
	uri.query = URI.encode_www_form(params)
	json = JSON.parse(http.request(Net::HTTP::Get.new(uri.request_uri)).body)['GetAssetWarrantyResponse']['GetAssetWarrantyResult']['Response']['DellAsset']['Warranties']['Warranty']

	if json[0]
		response = {:startdate => "#{json[0]['StartDate']}", :enddate => "#{json[0]['EndDate']}",:level => "#{json[0]['ServiceLevelDescription']}"}
	else
		response = {:startdate => "#{json['StartDate']}", :enddate => "#{json['EndDate']}",:level => "#{json['ServiceLevelDescription']}"}
	end
	return response
end

# Function for getting the server facts from our PuppetDB server
def get_puppet_facts(hostname)
	facturi = URI.parse("https://#{RTPIConfig::PUPPETDB_HOST}:8081/v3/facts")
	facthttp = Net::HTTP.new(facturi.host,facturi.port)
	facthttp.use_ssl = true
	facthttp.verify_mode = OpenSSL::SSL::VERIFY_NONE
	factparams = {:query => '["=","certname","' + "#{hostname}" + '"]'}
	facturi.query= URI.encode_www_form(factparams)
	json = JSON.parse(facthttp.request(Net::HTTP::Get.new(facturi.request_uri)).body)
	facts = Hash.new
	json.each{|fact| facts[fact['name']] = fact['value']}
	return facts
end

# Function for getting all the nodes from PuppetDB
def get_puppet_nodes()
	nodeuri = URI.parse("https://#{RTPIConfig::PUPPETDB_HOST}:8081/v3/nodes/")
	nodehttp = Net::HTTP.new(nodeuri.host,nodeuri.port)
	nodehttp.use_ssl = true
	nodehttp.verify_mode = OpenSSL::SSL::VERIFY_NONE
	nodes = JSON.parse(nodehttp.request(Net::HTTP::Get.new(nodeuri.request_uri)).body)
end

# Gets the object id for a server from the database
def get_object_id(con,hostname)
	rs = con.query("SELECT id FROM Object WHERE name = '#{hostname}'")
	objectid = ''
	if not rs.count == 0
		rs.each{| row | objectid = row['id']}
	end
	return objectid
end

# Gets the object type id for a server from the database
def get_object_type_id(con,hostname)
	rs = con.query("SELECT objtype_id FROM Object WHERE name = '#{hostname}'")
	objecttypeid = ''
	if not rs.count == 0
		rs.each{| row | objecttypeid = row['objtype_id']}
	end
	return objecttypeid
end
