# @codekit-prepend "app.coffee";

class kauApp
	constructor: (data, debug=false) ->
		@data = data
		@debug = debug
		# return current product from products list
		@current_product = @find_product_by_id(data.current_product.id)

		# reload data from localstorage if exists
		if $.jStorage.get("current_product")
		  @debugMsg("loaded current product via local storage")
		  @current_product = $.jStorage.get("current_product")
		
		# debug
		@debugMsg(@current_product)

		# add articleHelper to product
		extend @current_product, articleHelper

		$(@current_product).on "propertyChange", (ev, eventArgs) =>
		  @current_product.sum()

		# saving current_product to prevent data loos on page reload
		@saveOnPropertyChange("current_product", @current_product)

		@initialize_cart()

		cartItemTmpl = $.templates("#cartItemTmpl")
		cartItemTmpl.link("#cartItems", @cart.items()).on "click", ".remove_item", =>
	      view = $.view(this)
	      $.observable(@cart.items()).remove(view.index)	  

		current_productTmpl = $.templates("#current_productTmpl")

		current_productTmpl.link("#current_product", @current_product).on "click", "#add_to_cart", =>
		  newObject = jQuery.extend(true, {}, @current_product)
		  @cart.add(newObject,newObject.sum())

		cartSumTmpl = $.templates("#cartSumTmpl")
		cartSumTmpl.link("#cartSum", @cart)		

		@initialize_delivery_address()
		@initialize_invoice_address()
		@initialize_current_payment()

		deliveryTmpl = $.templates("#addressTmpl")
		deliveryTmpl.link("#delivery", { name: "Versandinformation", address: @delivery_address, payment: @current_payment })	

		deliveryTmpl = $.templates("#addressTmpl")
		deliveryTmpl.link("#invoice", { name: "Rechnungsinformation", address: @invoice_address })		  			  

		$('#next_to_overview').on 'click', () =>
			delivery_article = delivery_articles.default
			delivery_article = delivery_articles.deutschland if @delivery_address.country is "Deutschland"
			@cart.add(delivery_article,delivery_article.price,1,true)
			if @current_payment.type is "nachname"
				delivery_article = delivery_articles.nachname 
				@cart.add(delivery_article,delivery_article.price,1,true)

		deliveryOutputTmpl = $.templates("#addressOutputTmpl")
		deliveryOutputTmpl.link("#deliveryOutput", @delivery_address)		

		cartItemOutputTmpl = $.templates("#cartItemOutputTmpl")
		cartItemOutputTmpl.link("#cartItemsOutput", @cart.items())

		cartSumOutputTmpl = $.templates("#cartSumTmpl")
		cartSumOutputTmpl.link("#cartSumOutput", @cart)		


	initialize_cart: () ->
		if $.jStorage.get("cart_list")
		  @debugMsg("loaded cart via local storage")
		  cart = new kauCart($.jStorage.get("cart_list"))
		else
		  cart = new kauCart()			

		$.observe cart.items(), (ev, eventArgs) =>
		  cart.clearance()
		  @debugMsg "saving...cart"		  
		  @debugMsg($.jStorage.set("cart_list", cart.items()))	

		@cart = cart

	initialize_delivery_address: () ->
		if $.jStorage.get("delivery_address")
		  @debugMsg("loaded delivery address via local storage")
		  tmp = $.jStorage.get("delivery_address")
		  @delivery_address = new kauAddress(tmp.firstname, tmp.lastname, tmp.mail, tmp.phone, tmp.street, tmp.postcode, tmp.city, tmp.country)
		else
		  @delivery_address = new kauAddress()

		@saveOnPropertyChange("delivery_address", @delivery_address)

	initialize_invoice_address: () ->
		if $.jStorage.get("invoice_address")
		  @debugMsg("loaded invoice address via local storage")
		  tmp = $.jStorage.get("invoice_address")
		  @invoice_address = new kauAddress(tmp.firstname, tmp.lastname, tmp.mail, tmp.phone, tmp.street, tmp.postcode, tmp.city, tmp.country)
		else
		  @invoice_address = new kauAddress()

		@saveOnPropertyChange("invoice_address", @invoice_address, =>
			$.observable(@delivery_address).setProperty(@invoice_address) if @invoice_address.invoiceAndDeliveryAddress == "true"
		)

	initialize_current_payment: () ->
		if $.jStorage.get("current_payment")
		  @debugMsg("loaded current_payment via local storage")
		  tmp = $.jStorage.get("current_payment")
		  @current_payment = new kauPayment(tmp.type)
		else
		  @current_payment = new kauPayment()
		@saveOnPropertyChange("current_payment", @current_payment)

	saveOnPropertyChange: (key, object, callback=null) ->
		$(object).on "propertyChange", (ev, eventArgs) =>
		  @debugMsg "saving...#{key}"		 
		  @debugMsg($.jStorage.set(key, object))
		  callback() if callback


	set_current_product: (new_id) ->
		product = @find_product_by_id(new_id)
		$.observable(@current_product).setProperty product

	find_product_by_id: (id) ->
		$.grep(data.products, (e) ->
		  e.id is id
		)[0]

include kauApp, debuggerHelper

$ ->
	cartApp = new kauApp(data, true)
	cartApp.set_current_product(2)

	
	



