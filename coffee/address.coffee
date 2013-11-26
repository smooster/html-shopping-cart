class kauAddress
	constructor: (firstname="", lastname="", mail="", phone="", street="", postcode="", city="", country="") ->
		@firstname = firstname
		@lastname = lastname
		@mail = mail
		@phone = phone 
		@street = street
		@postcode = postcode
		@city = city
		@country = country

		@debugMsg "new address for #{lastname} created"


include kauAddress, debuggerHelper