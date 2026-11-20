return function()
	local SingleMotor = require(script.Parent.SingleMotor)
	local Linear = require(script.Parent.Linear)

	describe("completed state", function()
		local v = SingleMotor.new(0, false)

		v:setGoal((Linear.new(1, { velocity = 1 })))

		for _ = 1, 60 do
			v:step(1 / 60)
		end

		it("should complete", function()
			expect(v._state.complete).to.equal(true)
		end)

		it("should be exactly the goal value when completed", function()
			expect(v._state.value).to.equal(1)
		end)
	end)

	describe("uncompleted state", function()
		local v = SingleMotor.new(0, false)

		v:setGoal((Linear.new(1, { velocity = 1 })))

		for _ = 1, 59 do
			v:step(1 / 60)
		end

		it("should be uncomplete", function()
			expect(v._state.complete).to.equal(false)
		end)
	end)

	describe("negative velocity", function()
		local v = SingleMotor.new(1, false)

		v:setGoal((Linear.new(0, { velocity = 1 })))

		for _ = 1, 60 do
			v:step(1 / 60)
		end

		it("should complete", function()
			expect(v._state.complete).to.equal(true)
		end)

		it("should be exactly the goal value when completed", function()
			expect(v._state.value).to.equal(0)
		end)
	end)
end