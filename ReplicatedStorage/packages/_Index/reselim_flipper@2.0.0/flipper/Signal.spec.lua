return function()
	local Signal = require(script.Parent.Signal)

	it("should invoke all connections, instantly", function()
		local v = Signal.new()

		local v2 = nil
		local v3 = nil

		v:connect(function(p)
			v2 = p
		end)

		v:connect(function(p)
			v3 = p
		end)

		v:fire("hello")

		expect(v2).to.equal("hello")
		expect(v3).to.equal("hello")
	end)

	it("should return values when :wait() is called", function()
		local v = Signal.new()

		spawn(function()
			v:fire(123, "hello")
		end)

		local v2, v3 = v:wait()

		expect(v2).to.equal(123)
		expect(v3).to.equal("hello")
	end)

	it("should properly handle disconnections", function()
		local v = Signal.new()

		local v2 = false

		v:connect(function()
			v2 = true
		end):disconnect()

		v:fire()
		expect(v2).to.equal(false)
	end)
end