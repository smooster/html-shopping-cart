# @codekit-prepend "app.coffee";

class kauApp
	constructor: (data) ->
		@data = data
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
		$(@current_product).on "propertyChange", (ev, eventArgs) =>
		  @debugMsg "saving...current_product"		  
		  @debugMsg($.jStorage.set("current_product", @current_product))

		if $.jStorage.get("cart_list")
		  @debugMsg("loaded cart via local storage")
		  cart = new kauCart($.jStorage.get("cart_list"))
		else
		  cart = new kauCart()
		
		$.observe cart.items(), (ev, eventArgs) =>
		  cart.clearance()
		  @debugMsg "saving...cart"		  
		  @debugMsg($.jStorage.set("cart_list", cart.items()))		  

		cartItemTmpl = $.templates("#cartItemTmpl")
		cartItemTmpl.link("#cartItems", cart.items()).on "click", ".remove_item", ->
	      view = $.view(this)
	      $.observable(cart.items()).remove(view.index)

		current_productTmpl = $.templates("#current_productTmpl")

		current_productTmpl.link("#current_product", @current_product).on "click", "#add_to_cart", =>
		  newObject = jQuery.extend(true, {}, @current_product)
		  cart.add(newObject,newObject.sum())

		cartSumTmpl = $.templates("#cartSumTmpl")
		cartSumTmpl.link("#cartSum", cart)		  

	set_current_product: (new_id) ->
		product = @find_product_by_id(new_id)
		$.observable(@current_product).setProperty product

	find_product_by_id: (id) ->
		$.grep(data.products, (e) ->
		  e.id is id
		)[0]

include kauApp, debuggerHelper

$ ->
	cartApp = new kauApp(data)
	cartApp.set_current_product(2)

	
	



