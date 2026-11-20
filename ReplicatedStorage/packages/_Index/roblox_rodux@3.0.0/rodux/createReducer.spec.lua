return function()
	local createReducer = require(script.Parent.createReducer)

	it("should handle actions", function()
		local reducer = createReducer({ a = 0, b = 0 }, {
			a = function(p, _)
				return {
					a = p.a + 1,
					b = p.b
				}
			end,
			b = function(p, _)
				return {
					a = p.a,
					b = p.b + 2
				}
			end
		})

		local v = reducer({ a = 0, b = 0 }, { type = "a" })

		expect(v.a).to.equal(1)

		local v2 = reducer(v, { type = "b" })

		expect(v2.b).to.equal(2)
	end)

	it("should return the initial state if the state is nil", function()
		local v = createReducer({ a = 0, b = 0 }, {})(nil, {})
		expect(v).to.be.ok()
		expect(v.a).to.equal(0)
		expect(v.b).to.equal(0)
	end)

	it("should still run action handlers if the state is nil", function()
		local count = 0

		local reducer = createReducer(0, {
			foo = function(_, _): nil
				count += 1
				return nil
			end
		})

		expect(count).to.equal(0)

		local v = reducer(nil, { type = "foo" })

		expect(count).to.equal(1)
		expect(v).to.equal(nil)

		local v2 = reducer(v, { type = "foo" })

		expect(count).to.equal(2)
		expect(v2).to.equal(nil)
	end)

	it("should return the same state if the action is not handled", function()
		local v = { a = 0, b = 0 }

		local v2 = createReducer(v, {
			a = function(p, _)
				return {
					a = p.a + 1,
					b = p.b
				}
			end,
			b = function(p, _)
				return {
					a = p.a,
					b = p.b + 2
				}
			end
		})(v, { type = "c" })

		expect(v2).to.equal(v)
	end)
end