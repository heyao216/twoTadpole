function createRectangle(w , h , ccf4)
	local shape = display.newRect(w, h)
	shape:setLineColor(ccf4)
	shape:setFill(true)
	return shape
end