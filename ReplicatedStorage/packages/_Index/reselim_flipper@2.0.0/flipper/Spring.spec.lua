return function()
	local SingleMotor = require(script.Parent.SingleMotor)
	local Spring = require(script.Parent.Spring)

	describe("completed state", function()
		local v = SingleMotor.new(0, false)

		v:setGoal((Spring.new(1, { frequency = 2, dampingRatio = 0.75 })))

		for _ = 1, 100 do
			v:step(1 / 60)
		end

		it("should complete", function()
			expect(v._state.complete).to.equal(true)
		end)

		it("should be exactly the goal value when completed", function()
			expect(v._state.value).to.equal(1)
		end)
	end)

	it("should inherit velocity", function()
		local v = SingleMotor.new(0, false)
		v._state = { complete = false, value = 0, velocity = -5 }

		v:setGoal((Spring.new(1, { frequency = 2, dampingRatio = 1 })))
		v:step(1 / 60)

		expect(v._state.velocity < 0).to.equal(true)
	end)
end