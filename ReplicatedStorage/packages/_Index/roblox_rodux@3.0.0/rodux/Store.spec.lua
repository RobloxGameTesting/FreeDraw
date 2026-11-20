return function()
	local Store = require(script.Parent.Store)

	describe("new", function()
		it("should instantiate with a reducer", function()
			local v = Store.new(function(_, _): string
				return "hello, world"
			end)

			expect(v).to.be.ok()
			expect(v:getState()).to.equal("hello, world")

			v:destruct()
		end)

		it("should instantiate with a reducer and an initial state", function()
			local v = Store.new(function(p, _)
				return p
			end, "initial state")

			expect(v).to.be.ok()
			expect(v:getState()).to.equal("initial state")

			v:destruct()
		end)

		it("should instantiate with a reducer, initial state, and middlewares", function()
			local v = Store.new(function(p, _)
				return p
			end, "initial state", {})

			expect(v).to.be.ok()
			expect(v:getState()).to.equal("initial state")

			v:destruct()
		end)

		it("should modify the dispatch method when middlewares are passed", function()
			local count = 0
			local count2 = 0
			local v = nil
			local v2 = nil
			local v3 = nil

			local function reducer(p, p2)
				if p2.type == "test" then
					return "test state"
				end

				return p
			end

			local function testMiddleware(callback, p)
				count += 1
				v = callback
				v2 = p

				return function(p2)
					count2 += 1
					v3 = p2

					callback(p2)
				end
			end

			local v4 = Store.new(reducer, "initial state", { testMiddleware })

			expect(count).to.equal(1)
			expect(count2).to.equal(0)
			expect(v).to.be.a("function")
			expect(v2).to.equal(v4)

			v4:dispatch({ type = "test" })

			expect(count).to.equal(1)
			expect(count2).to.equal(1)
			expect(v3.type).to.equal("test")

			v4:flush()

			expect(v4:getState()).to.equal("test state")

			v4:destruct()
		end)

		it("should execute middleware left-to-right", function()
			local v = {}

			local function reducer(p)
				return p
			end

			local function middlewareA(callback, _)
				table.insert(v, "instantiate a")
				return function(p)
					table.insert(v, "execute a")
					return callback(p)
				end
			end

			local function middlewareB(callback, _)
				table.insert(v, "instantiate b")
				return function(p)
					table.insert(v, "execute b")
					return callback(p)
				end
			end

			local v2 = Store.new(reducer, 5, { middlewareA, middlewareB })

			expect(#v).to.equal(2)
			expect(v[1]).to.equal("instantiate b")
			expect(v[2]).to.equal("instantiate a")

			v2:dispatch({ type = "test" })

			expect(#v).to.equal(4)
			expect(v[3]).to.equal("execute a")
			expect(v[4]).to.equal("execute b")

			v2:destruct()
		end)

		it("should send an initial action with a 'type' field", function()
			local v = nil
			local count = 0

			local v2 = Store.new(function(p, p2)
				v = p2
				count += 1

				return p
			end)

			expect(count).to.equal(1)
			expect(v).to.be.a("table")
			expect(v.type).to.be.ok()

			v2:destruct()
		end)

		it("should report a reducer error thrown when handling the INIT action", function()
			local v = nil
			local v2 = nil
			local v3 = nil
			local v4 = {
				reportReducerError = function(p, p2, p3)
					v = p
					v2 = p2
					v3 = p3
				end,
				reportUpdateError = function() end
			}

			local v5 = Store.new(function(_, _)
				error("Z4PH0D")
			end, { Value = 1 }, nil, v4)

			expect(v.Value).to.equal(1)
			expect(v2.type).to.equal("@@INIT")
			expect(v3.message).to.equal("Caught error in reducer with init")
			expect(string.find(v3.thrownValue, "Z4PH0D")).to.be.ok()

			expect(string.find(v3.thrownValue, script.Name)).to.be.ok()

			v5:destruct()
		end)

		it("should report a reducer error thrown when handling a subsequent action", function()
			local v = nil
			local v2 = nil
			local v3 = nil
			local v4 = {
				reportReducerError = function(p, p2, p3)
					v = p
					v2 = p2
					v3 = p3
				end,
				reportUpdateError = function() end
			}

			local v5 = Store.new(function(p, p2)
				if p2.type == "ThrowError" then
					error("Z4PH0D")
					return p
				end

				if p2.type == "Increment" then
					return {
						Value = p.Value + 1
					}
				end

				return p
			end, { Value = 1 }, nil, v4)

			expect(v).to.equal(nil)
			expect(v2).to.equal(nil)
			expect(v3).to.equal(nil)

			v5:dispatch({ type = "Increment" })
			v5:dispatch({ type = "ThrowError" })

			expect(v.Value).to.equal(2)
			expect(v2.type).to.equal("ThrowError")
			expect(v3.message).to.equal("Caught error in reducer")
			expect(string.find(v3.thrownValue, "Z4PH0D")).to.be.ok()

			expect(string.find(v3.thrownValue, script.Name)).to.be.ok()

			v5:destruct()
		end)
	end)

	describe("getState", function()
		it("should get the current state", function()
			local v = Store.new(function(_, _): string
				return "foo"
			end)

			local state = v:getState()

			expect(state).to.equal("foo")

			v:destruct()
		end)

		it("should throw errors if triggered during dispatches", function()
			local v = nil
			v = Store.new(function(_, p)
				if p.type ~= "@@INIT" then
					v:getState()
				end
			end)

			expect(function()
				v:dispatch({ type = "SomeAction" })
			end).to.throw()

			v:destruct()
		end)
	end)

	describe("dispatch", function()
		it("should be sent through the reducer", function()
			local v = Store.new(function(value, p)
				if p.type == "act" then
					return "bar"
				end

				return value or "foo"
			end)

			expect(v).to.be.ok()
			expect(v:getState()).to.equal("foo")

			v:dispatch({ type = "act" })

			v:flush()

			expect(v:getState()).to.equal("bar")

			v:destruct()
		end)

		it("should trigger the changed event after a flush", function()
			local v = Store.new(function(value, p)
				value = value or 0

				if p.type == "increment" then
					return value + 1
				end

				return value
			end)

			local count = 0

			v.changed:connect(function(p, p2)
				expect(p2).to.equal(0)
				expect(p).to.equal(1)

				count += 1
			end)

			v:dispatch({ type = "increment" })

			v:flush()

			expect(count).to.equal(1)

			v:destruct()
		end)

		it("should handle actions dispatched within the changed event", function()
			local v = Store.new(function(p, p2)
				local selected = p or { value = 0 }

				if p2.type == "increment" then
					return {
						value = selected.value + 1
					}
				end

				if p2.type == "decrement" then
					return {
						value = selected.value - 1
					}
				end

				return selected
			end)

			local count = 0

			v.changed:connect(function(p, p2)
				expect(p).never.to.equal(p2)

				if p.value > 0 then
					v:dispatch({ type = "decrement" })
				end

				count += 1
			end)

			v:dispatch({ type = "increment" })

			v:flush()
			v:flush()

			expect(count).to.equal(2)

			v:destruct()
		end)

		it("should prevent yielding from changed handler", function()
			local message = nil
			local thrownValue = nil
			local v = {
				reportUpdateError = function(_, _, _, p)
					message = p.message
					thrownValue = p.thrownValue
				end,
				reportReducerError = function() end
			}

			local count = 0
			local count2 = 0

			local v2 = Store.new(function(value, _)
				return (value or 0) + 1
			end, nil, nil, v)

			v2.changed:connect(function(_, _)
				count += 1
				wait()
				count2 += 1
			end)

			v2:dispatch({ type = "increment" })

			v2:flush()

			expect(count).to.equal(1)
			expect(count2).to.equal(0)

			expect(message).to.equal("Caught error flushing store updates")

			local expect2 = expect
			local v3 = thrownValue
			expect2(string.find(v3, script.Name)).to.be.ok()

			expect(string.find(thrownValue, "to yield")).to.be.ok()

			v2:destruct()
		end)

		it("should throw if an action is dispatched without a type field", function()
			local v = Store.new(function(p, _)
				return p
			end)

			expect(function()
				v:dispatch({})
			end).to.throw()

			v:destruct()
		end)

		it("should throw if the action is not a function or table", function()
			local v = Store.new(function(p, _)
				return p
			end)

			expect(function()
				v:dispatch(1)
			end).to.throw()

			v:destruct()
		end)

		it("should report an error if the listeners error when flushing", function()
			local v = nil
			local v2 = nil
			local v3 = nil
			local v4 = nil
			local v5 = {
				reportReducerError = function() end,
				reportUpdateError = function(p, p2, p3, p4)
					v = p
					v2 = p2
					v3 = p3
					v4 = p4
				end
			}

			local v6 = Store.new(function(p, p2)
				if p2.type == "Increment" then
					return {
						Value = p.Value + p2.amount
					}
				end

				return p
			end, { Value = 1 }, nil, v5)

			v6.changed:connect(function(p, _)
				if p.Value == 15 then
					error("Z4PH0D")
				end
			end)

			local v7 = {
				{ type = "Increment", amount = 1 },
				{ type = "Increment", amount = 3 },
				{ type = "Increment", amount = 10 }
			}

			for _, v8 in ipairs(v7) do
				v6:dispatch(v8)
			end

			v6:flush()

			expect(v4.message).to.equal("Caught error flushing store updates")

			expect(string.find(v4.thrownValue, script.Name)).to.be.ok()

			expect(v3[1]).to.equal(v7[1])
			expect(v3[2]).to.equal(v7[2])
			expect(v3[3]).to.equal(v7[3])

			expect(v.Value).to.equal(1)
			expect(v2.Value).to.equal(15)

			v6:destruct()
		end)

		it("should throw errors if dispatching while a dispatch is already happening", function()
			local v = nil
			v = Store.new(function(_, p)
				if p.type == "SomeAction" then
					v:dispatch({ type = "MidDispatchAction" })
				end
			end)

			expect(function()
				v:dispatch({ type = "SomeAction" })
			end).to.throw()

			v:destruct()
		end)
	end)

	describe("flush", function()
		it("should not fire a changed event if there were no dispatches", function()
			local v = Store.new(function() end)

			local count = 0
			v.changed:connect(function()
				count += 1
			end)

			v:flush()

			expect(count).to.equal(0)

			v:dispatch({ type = "increment" })

			v:flush()

			expect(count).to.equal(1)

			v:flush()

			expect(count).to.equal(1)

			v:destruct()
		end)
	end)
end