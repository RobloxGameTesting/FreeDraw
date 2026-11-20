return function()
	describe("Rodux", function()
		it("should load", function()
			local parentModule = require(script.Parent)

			expect(parentModule.Store).to.be.ok()
		end)
	end)
end