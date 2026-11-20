local function move(list, list2)
	table.move(list, 1, #list, #list2 + 1, list2)
end

return move