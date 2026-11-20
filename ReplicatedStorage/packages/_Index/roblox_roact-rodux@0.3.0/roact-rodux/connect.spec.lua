return function()
	local connect = require(script.Parent.connect)

	local StoreProvider = require(script.Parent.StoreProvider)

	local Roact = require(script.Parent.Parent.Roact)
	local Rodux = require(script.Parent.Parent.Rodux)

	local function noop(): nil
		return nil
	end

	local function NoopComponent(): nil
		return nil
	end

	local function countReducer(value, p)
		value = value or 0

		if p.type == "increment" then
			return value + 1
		end

		return value
	end

	local combineReducers = Rodux.combineReducers({ count = countReducer })

	describe("Argument validation", function()
		it("should accept no arguments", function()
			connect()
		end)

		it("should accept one function", function()
			connect(noop)
		end)

		it("should accept two functions", function()
			connect(noop, noop)
		end)

		it("should accept only the second function", function()
			connect(nil, function() end)
		end)

		it("should accept one table of action creators", function()
			connect(nil, {
				foo = function() end
			})
		end)

		it("should throw if not passed a component", function()
			local function fn(_)
				return {}
			end

			expect(function()
				connect(fn)(nil)
			end).to.throw()
		end)
	end)

	it("should throw if not mounted under a StoreProvider", function()
		local v = connect()(NoopComponent)

		expect(function()
			Roact.mount(Roact.createElement(v))
		end).to.throw()
	end)

	it("should accept a higher-order function mapStateToProps", function()
		local function mapStateToProps()
			return function(p)
				return { count = p.count }
			end
		end

		local v = connect(mapStateToProps)(NoopComponent)

		local store = Rodux.Store.new(combineReducers)
		local element = Roact.createElement(StoreProvider, { store = store }, {
			someComponent = Roact.createElement(v)
		})

		local v2 = Roact.mount(element)

		Roact.unmount(v2)
	end)

	it("should not accept a higher-order mapStateToProps that returns a non-table value", function()
		local function mapStateToProps()
			return function(_): string
				return "nope"
			end
		end

		local v = connect(mapStateToProps)(NoopComponent)

		local store = Rodux.Store.new(combineReducers)
		local element = Roact.createElement(StoreProvider, { store = store }, {
			someComponent = Roact.createElement(v)
		})

		expect(function()
			Roact.mount(element)
		end).to.throw()
	end)

	it("should not accept a mapStateToProps that returns a non-table value", function()
		local function mapStateToProps(): string
			return "nah"
		end

		local v = connect(mapStateToProps)(NoopComponent)

		local store = Rodux.Store.new(combineReducers)
		local element = Roact.createElement(StoreProvider, { store = store }, {
			someComponent = Roact.createElement(v)
		})

		expect(function()
			Roact.mount(element)
		end).to.throw()
	end)

	it("should abort renders when mapStateToProps returns the same data", function()
		local function mapStateToProps(p)
			return { count = p.count }
		end

		local count = 0
		local function SomeComponent(_)
			count += 1
		end

		local v = connect(mapStateToProps)(SomeComponent)

		local store = Rodux.Store.new(combineReducers)
		local element = Roact.createElement(StoreProvider, { store = store }, {
			someComponent = Roact.createElement(v)
		})

		local v2 = Roact.mount(element)

		expect(count).to.equal(1)

		store:dispatch({ type = "an unknown action" })
		store:flush()

		expect(count).to.equal(1)

		store:dispatch({ type = "increment" })
		store:flush()

		expect(count).to.equal(2)

		Roact.unmount(v2)
	end)

	it("should only call mapDispatchToProps once and never re-render if no mapStateToProps was passed", function()
		local count = 0
		local function fn(callback)
			count += 1

			return {
				increment = function()
					return callback({ type = "increment" })
				end
			}
		end

		local count2 = 0
		local function SomeComponent(_)
			count2 += 1
		end

		local v = connect(nil, fn)(SomeComponent)

		local store = Rodux.Store.new(combineReducers)
		local element = Roact.createElement(StoreProvider, { store = store }, {
			someComponent = Roact.createElement(v)
		})

		local v2 = Roact.mount(element)

		expect(count).to.equal(1)
		expect(count2).to.equal(1)

		store:dispatch({ type = "an unknown action" })
		store:flush()

		expect(count).to.equal(1)
		expect(count2).to.equal(1)

		store:dispatch({ type = "increment" })
		store:flush()

		expect(count).to.equal(1)
		expect(count2).to.equal(1)

		Roact.unmount(v2)
	end)

	it("should dispatch the action using a table of action creators", function()
		local function SomeComponent(p)
			p.increment()
		end

		local v = connect(nil, {
			increment = function()
				return { type = "increment" }
			end
		})(SomeComponent)

		local store = Rodux.Store.new(combineReducers)
		local element = Roact.createElement(StoreProvider, { store = store }, {
			someComponent = Roact.createElement(v)
		})

		local v2 = Roact.mount(element)

		store.changed:connect(function(p)
			expect(p.count).to.equal(1)
		end)

		Roact.unmount(v2)
	end)

	it("should return result values from the dispatch passed to mapDispatchToProps", function()
		local function reducer(): number
			return 0
		end

		local function fiveThunk(): number
			return 5
		end

		local dispatch = nil
		local function SomeComponent(p)
			dispatch = p.dispatch
		end

		local function mapDispatchToProps(dispatch2)
			return { dispatch = dispatch2 }
		end

		local v = connect(nil, mapDispatchToProps)(SomeComponent)

		local store = Rodux.Store.new(reducer, nil, { Rodux.thunkMiddleware })
		local element = Roact.createElement(StoreProvider, { store = store }, {
			someComponent = Roact.createElement(v)
		})

		local v2 = Roact.mount(element)

		expect(dispatch).to.be.a("function")
		expect(dispatch(fiveThunk)).to.equal(5)

		Roact.unmount(v2)
	end)

	it("should render parent elements before children", function()
		local function mapStateToProps(p)
			return { count = p.count }
		end

		local v = false

		local function ChildComponent(p)
			if p.count > p.parentCount then
				v = true
			end
		end

		local v2 = connect(mapStateToProps)(ChildComponent)

		local function ParentComponent(p)
			return Roact.createElement(v2, { parentCount = p.count })
		end

		local v3 = connect(mapStateToProps)(ParentComponent)

		local store = Rodux.Store.new(combineReducers)
		local element = Roact.createElement(StoreProvider, { store = store }, {
			parent = Roact.createElement(v3)
		})

		local v4 = Roact.mount(element)

		store:dispatch({ type = "increment" })
		store:flush()

		store:dispatch({ type = "increment" })
		store:flush()

		Roact.unmount(v4)

		expect(v).to.equal(false)
	end)
end