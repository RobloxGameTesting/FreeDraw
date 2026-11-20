return function()
	local SingleMotor = require(script.Parent.SingleMotor)
	local Instant = require(script.Parent.Instant)

	it("should assign new state on step", function()
		local v = SingleMotor.new(0, false)

		v:setGoal(Instant.new(5))
		v:step(1 / 60)

		expect(v._state.complete).to.equal(true)
		expect(v._state.value).to.equal(5)
	end)

	it("should invoke onComplete listeners when the goal is completed", function()
		local v = SingleMotor.new(0, false)

		local v2 = false
		v:onComplete(function()
			v2 = true
		end)

		v:setGoal(Instant.new(5))
		v:step(1 / 60)

		expect(v2).to.equal(true)
	end)

	it("should start when the goal is set", function()
		local v = SingleMotor.new(0, false)

		local v2 = false
		v:onStart(function()
			v2 = not v2
		end)

		v:setGoal(Instant.new(5))

		expect(v2).to.equal(true)

		v:setGoal(Instant.new(5))

		expect(v2).to.equal(false)
	end)
end