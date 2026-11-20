return function()
	local isMotor = require(script.Parent.isMotor)

	local SingleMotor = require(script.Parent.SingleMotor)
	local GroupMotor = require(script.Parent.GroupMotor)

	local v = SingleMotor.new(0)
	local v2 = GroupMotor.new({})

	it("should properly detect motors", function()
		expect(isMotor(v)).to.equal(true)
		expect(isMotor(v2)).to.equal(true)
	end)

	it("shouldn't detect things that aren't motors", function()
		expect(isMotor({})).to.equal(false)
	end)

	it("should return the proper motor type", function()
		local _, v3 = isMotor(v)
		local _, v4 = isMotor(v2)

		expect(v3).to.equal("Single")
		expect(v4).to.equal("Group")
	end)
end