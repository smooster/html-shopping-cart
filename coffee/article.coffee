articleHelper = 
	sum: ->
		sum = this.price
		sum = sum + this.aluFramePrice if this.aluFrame
		$.observable(this).setProperty("gross_sum", sum);
		sum