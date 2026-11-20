return function()
	local RunService = game:GetService("RunService")

	local BaseMotor = require(script.Parent.BaseMotor)

	describe("connection management", function()
		local v = BaseMotor.new()

		it("should hook up connections on :start()", function()
			v:start()
			expect((typeof(v._connection))).to.equal("RBXScriptConnection")
		end)

		it("should remove connections on :stop() or :destroy()", function()
			v:stop()
			expect(v._connection).to.equal(nil)
		end)
	end)

	it("should call :step() with deltaTime", function()
		local v = BaseMotor.new()

		local v2 = nil
		function v.step(_, ...)
			v2 = { ... }
			v:stop()
		end

		v:start()

		local v3 = RunService.RenderStepped:Wait()

		RunService.RenderStepped:Wait()

		expect(v2).to.be.ok()
		expect(v2[1]).to.equal(v3)
	end)
end