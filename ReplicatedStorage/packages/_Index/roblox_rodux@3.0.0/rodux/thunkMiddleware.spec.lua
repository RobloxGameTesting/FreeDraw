return function()
	local Store = require(script.Parent.Store)
	local thunkMiddleware = require(script.Parent.thunkMiddleware)

	it("should dispatch thunks", function()
		local function reducer(p, _)
			return p
		end

		local v = Store.new(reducer, {}, { thunkMiddleware })
		local count = 0

		local function thunk(_)
			count += 1
		end

		v:dispatch(thunk)

		expect(count).to.equal(1)
	end)

	it("should allow normal actions to pass through", function()
		local count = 0

		local function reducer(p, _)
			count += 1
			return p
		end

		Store.new(reducer, {}, { thunkMiddleware }):dispatch({ type = "test" })

		expect(count).to.equal(2)
	end)

	it("should return the value from the thunk", function()
		local function reducer(p, _)
			return p
		end

		local function thunk(_): string
			return "test"
		end

		local v = Store.new(reducer, {}, { thunkMiddleware }):dispatch(thunk)

		expect(v).to.equal("test")
	end)

	it("should report errors captured in thunks via the provided error reporter", function()
		local v = nil
		local v2 = nil
		local v3 = nil
		local v4 = {
			reportReducerError = function(p, p2, p3)
				v = p
				v2 = p2
				v3 = p3
			end
		}

		local function reducer(p, _)
			return p
		end

		local function thunk(_)
			error("thunk failed")
		end

		Store.new(reducer, { Value = 1 }, { thunkMiddleware }, v4):dispatch(thunk)

		expect(v.Value).to.equal(1)
		expect(v2).to.equal(thunk)
		expect(v3.message).to.equal("Caught error in thunk")
	end)

	it("should recover and continue to update after a thunk errors", function()
		local v = nil
		local v2 = {
			reportReducerError = function(_, _, p)
				v = p
			end
		}

		local function reducer(p, _)
			return p
		end

		local v3 = Store.new(reducer, { Value = 1 }, { thunkMiddleware }, v2)

		local function errorThunk(_)
			error("thunk failed")
		end
		local v4 = false
		local function safeThunk(_)
			v4 = true
		end

		v3:dispatch(errorThunk)
		expect(v.message).to.equal("Caught error in thunk")

		v3:dispatch(safeThunk)
		expect(v4).to.equal(true)
	end)
end