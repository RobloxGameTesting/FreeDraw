return function()
	local shallowEqual = require(script.Parent.shallowEqual)

	it("should compare dictionaries", function()
		local v = { a = "a", b = {}, c = 6 }

		local v2 = { b = v.b, c = v.c, a = v.a }

		local v3 = { b = {}, a = v.a, c = v.c }

		local v4 = { a = v.a, b = v.b, c = v.c, d = "hello" }

		expect(shallowEqual(v, v)).to.equal(true)
		expect(shallowEqual(v, v2)).to.equal(true)
		expect(shallowEqual(v, v3)).to.equal(false)
		expect(shallowEqual(v2, v3)).to.equal(false)
		expect(shallowEqual(v, v4)).to.equal(false)
		expect(shallowEqual(v2, v4)).to.equal(false)
	end)

	it("should handle nil for either argument", function()
		local v = {}

		expect(shallowEqual(nil, nil)).to.equal(true)
		expect(shallowEqual(v, nil)).to.equal(false)
		expect(shallowEqual(nil, v)).to.equal(false)
	end)
end