cartItemHelper = 
	remove: ->
		console.log(this)	

class kauCart
	constructor: (cart_list)->
		@cart_list = new Array
		if cart_list
		  @cart_list = cart_list
		  @clearance()

	add: (product, price, quantity=1) ->
		cart_item = 
		  product: product
		  price: price
		  quantity: quantity
		extend cart_item, cartItemHelper
		$.observable(@cart_list).insert(cart_item)		
		@debugMsg "added #{quantity} #{product} with #{price}"

	remove: (pos) ->
		$.observable(@cart_list).remove(pos)
		@debugMsg "deletes position #{pos} from cart"

	clear: ->
		$.observable(@cart_list).remove(0, (@cart_list.length-1))
		@debugMsg "clears cart - removes all products"

	items: ->
		@debugMsg "returns all products in the cart"
		@cart_list

	calc_net_total: ->
		net = 0.0
		for index, cart_item of @cart_list
		  break unless cart_item.product
		  net = net + (cart_item.price/(100+cart_item.product.tax)*100)*cart_item.quantity
		@debugMsg "returns the net total #{net} of the cart"
		$.observable(@).setProperty("net_total", net);

	calc_gross_total: ->
		gross = 0.0
		for index, cart_item of @cart_list
		  break unless cart_item.product
		  gross = gross + cart_item.price*cart_item.quantity	
		@debugMsg "returns the gross total #{gross} of the cart"
		$.observable(@).setProperty("gross_total", gross);

	calc_tax_total: ->
		tax = parseFloat(@gross_total) - parseFloat(@net_total)
		@debugMsg "returns the tax total #{tax} of the cart"
		$.observable(@).setProperty("tax_total", tax);

	clearance: ->
		@calc_net_total()
		@calc_gross_total()
		@calc_tax_total()

	total_unique_items: ->
		@cart_list.length

include kauCart, debuggerHelper


