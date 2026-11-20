return function()
	local combineReducers = require(script.Parent.combineReducers)

	it("should invoke each sub-reducer for every action", function()
		local count = 0
		local count2 = 0

		combineReducers({
			a = function(_, _)
				count += 1
			end,
			b = function(_, _)
				count2 += 1
			end
		})({}, {})
		expect(count).to.equal(1)
		expect(count2).to.equal(1)
	end)

	it("should assign each sub-reducer's value to the new state", function()
		local v = combineReducers({
			a = function(value, _)
				return (value or 0) + 1
			end,
			b = function(value, _)
				return (value or 0) + 3
			end
		})({}, {})
		expect(v.a).to.equal(1)
		expect(v.b).to.equal(3)
	end)

	it("should not throw when state is nil", function()
		local v = combineReducers({
			a = function(value, _)
				return (value or 0) + 1
			end,
			b = function(value, _)
				return (value or 0) + 3
			end
		})

		expect(function()
			v(nil, {})
		end).to.never.throw()
	end)
end