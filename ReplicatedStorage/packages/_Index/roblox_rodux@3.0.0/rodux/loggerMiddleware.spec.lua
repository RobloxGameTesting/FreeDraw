return function()
	local Store = require(script.Parent.Store)
	local loggerMiddleware = require(script.Parent.loggerMiddleware)

	it("should print whenever an action is dispatched", function()
		local count = 0
		local v = nil

		local function reducer(p, _)
			return p
		end

		local v2 = Store.new(reducer, {
			fooValue = 12345,
			barValue = { bazValue = "hiBaz" }
		}, { loggerMiddleware.middleware })

		function loggerMiddleware.outputFunction(p)
			count += 1
			v = p
		end

		v2:dispatch({ type = "testActionType" })

		expect(count).to.equal(1)
		expect(v:find("testActionType")).to.be.ok()
		expect(v:find("fooValue")).to.be.ok()
		expect(v:find("12345")).to.be.ok()
		expect(v:find("barValue")).to.be.ok()
		expect(v:find("bazValue")).to.be.ok()
		expect(v:find("hiBaz")).to.be.ok()

		loggerMiddleware.outputFunction = print
	end)
end