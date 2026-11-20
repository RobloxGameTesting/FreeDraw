return function()
	local Signal = require(script.Parent.Signal)

	it("should construct from nothing", function()
		local v = Signal.new()

		expect(v).to.be.ok()
	end)

	it("should fire connected callbacks", function()
		local count = 0

		local function fn(p, p2)
			expect(p).to.equal("Hello World")
			expect(p2).to.equal(7)
			count += 1
		end

		local v = Signal.new()

		local connection = v:connect(fn)
		v:fire("Hello World", 7)

		expect(count).to.equal(1)

		connection:disconnect()
		v:fire("Hello World", 7)

		expect(count).to.equal(1)
	end)

	it("should disconnect handlers", function()
		local v = Signal.new()
		v:connect(function()
			error("Callback was called after disconnect!")
		end):disconnect()

		v:fire()
	end)

	it("should fire handlers in order", function()
		local v = Signal.new()
		local count = 0
		local count2 = 0

		local function fn()
			expect(count).to.equal(1)
			expect(count2).to.equal(0)
			count2 += 1
		end

		v:connect(function()
			expect(count).to.equal(0)
			expect(count2).to.equal(0)
			count += 1
		end)
		v:connect(fn)
		v:fire()

		expect(count).to.equal(1)
		expect(count2).to.equal(1)
	end)

	it("should continue firing despite mid-event disconnection", function()
		local v = Signal.new()
		local count = 0
		local count2 = 0

		local connection = nil
		connection = v:connect(function()
			connection:disconnect()
			count += 1
		end)

		v:connect(function()
			count2 += 1
		end)

		v:fire()

		expect(count).to.equal(1)
		expect(count2).to.equal(1)
	end)

	it("should skip listeners that were disconnected during event evaluation", function()
		local v = Signal.new()
		local count = 0
		local count2 = 0

		local connection = nil

		v:connect(function()
			count += 1
			connection:disconnect()
		end)

		connection = v:connect(function()
			count2 += 1
		end)

		v:fire()

		expect(count).to.equal(1)
		expect(count2).to.equal(0)
	end)

	it("should throw an error if the argument to `connect` is not a function", function()
		local v = Signal.new()
		expect(function()
			v:connect("not a function")
		end).to.throw()
	end)

	it("should throw an error when disconnecting more than once", function()
		local connection = Signal.new():connect(function() end)

		expect(connection.disconnect).never.to.throw()

		expect(connection.disconnect).to.throw()
	end)

	it("should throw an error when subscribing during dispatch", function()
		local v = { _isDispatching = false }

		local v2 = Signal.new(v)

		v2:connect(function()
			v2:connect(function() end)
		end)

		v._isDispatching = true
		expect(function()
			v2:fire()
		end).to.throw()
	end)

	it("should throw an error when unsubscribing during dispatch", function()
		local v = { _isDispatching = false }

		local v2 = Signal.new(v)

		local connection = nil
		connection = v2:connect(function()
			connection.disconnect()
		end)

		v._isDispatching = true
		expect(function()
			v2:fire()
		end).to.throw()
	end)
end