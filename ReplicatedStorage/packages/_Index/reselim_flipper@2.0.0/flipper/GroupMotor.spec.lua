return function()
	local GroupMotor = require(script.Parent.GroupMotor)

	local Instant = require(script.Parent.Instant)
	local Spring = require(script.Parent.Spring)

	it("should complete when all child motors are complete", function()
		local v = GroupMotor.new({ A = 1, B = 2 }, false)

		expect(v._complete).to.equal(true)

		v:setGoal({
			A = Instant.new(3),
			B = Spring.new(4, { frequency = 7.5, dampingRatio = 1 })
		})

		expect(v._complete).to.equal(false)

		v:step(1 / 60)

		expect(v._complete).to.equal(false)

		for _ = 1, 30 do
			v:step(1 / 60)
		end

		expect(v._complete).to.equal(true)
	end)

	it("should start when the goal is set", function()
		local v = GroupMotor.new({ A = 0 }, false)

		local v2 = false
		v:onStart(function()
			v2 = not v2
		end)

		v:setGoal({ A = Instant.new(1) })

		expect(v2).to.equal(true)

		v:setGoal({ A = Instant.new(1) })

		expect(v2).to.equal(false)
	end)

	it("should properly return all values", function()
		local value = GroupMotor.new({ A = 1, B = 2 }, false):getValue()

		expect(value.A).to.equal(1)
		expect(value.B).to.equal(2)
	end)

	it("should error when a goal is given to GroupMotor.new", function()
		local v = pcall(function()
			GroupMotor.new(Instant.new(0))
		end)

		expect(v).to.equal(false)
	end)

	it("should error when a single goal is provided to GroupMotor:step", function()
		local v = pcall(function()
			GroupMotor.new({ a = 1 }):setGoal(Instant.new(0))
		end)

		expect(v).to.equal(false)
	end)
end