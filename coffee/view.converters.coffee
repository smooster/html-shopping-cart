$.views.converters "formatMoney", (val) -> 
	return accounting.formatMoney(val, accounting_settings)