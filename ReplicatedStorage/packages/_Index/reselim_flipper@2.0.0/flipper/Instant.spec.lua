return function()
	local Instant = require(script.Parent.Instant)

	it("should return a completed state with the provided value", function()
		local v = Instant.new(1.23):step(0.1, { value = 0, complete = false })
		expect(v.complete).to.equal(true)
		expect(v.value).to.equal(1.23)
	end)
end