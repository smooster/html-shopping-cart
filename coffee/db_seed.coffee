#list of products
products = [
  id: 1
  name: "Sterntaufe"
  price: 39.0
  tax: 19.0
  star_picture: false,
  aluFramePrice: 15.0
,
  id: 2
  name: "Sternbild"
  price: 59.0
  tax: 19.0
  star_picture: true
  aluFramePrice: 15.0
,
  id: 3
  name: "Doppelstern"
  price: 79.0
  tax: 19.0
  star_picture: true
  double_fulfillment: true
  aluFramePrice: 15.0
]

#current selected product
current_product = 
  id: 1
  sum_price: ->
  	console.log("ups")

accounting_settings =
  symbol: "€" # default currency symbol is '$'
  format: "%v %s" # controls output: %s = symbol, %v = value/number (can be object: see below)
  decimal: "," # decimal point separator
  thousand: "." # thousands separator
  precision: 2 # decimal places

# All data for the app
data =
  products: products
  current_product: current_product