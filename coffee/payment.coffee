class kauPayment
	# type = paypal, vorkasse, nachname
	constructor: (type="paypal") ->
		@type = type		
		@debugMsg "new payment of type #{type} created"


include kauPayment, debuggerHelper