return function()
	local Symbol = require(script.Parent.Symbol)

	describe("named", function()
		it("should give an opaque object", function()
			local named = Symbol.named("foo")

			expect(named).to.be.a("userdata")
		end)

		it("should coerce to the given name", function()
			local named = Symbol.named("foo")

			expect(tostring(named):find("foo")).to.be.ok()
		end)

		it("should be unique when constructed", function()
			local named = Symbol.named("abc")
			local named2 = Symbol.named("abc")

			expect(named).never.to.equal(named2)
		end)
	end)

	describe("unnamed", function()
		it("should give an opaque object", function()
			local unnamed = Symbol.unnamed()

			expect(unnamed).to.be.a("userdata")
		end)

		it("should coerce to some string", function()
			local unnamed = Symbol.unnamed()

			expect((tostring(unnamed))).to.be.a("string")
		end)

		it("should be unique when constructed", function()
			local unnamed = Symbol.unnamed()
			local unnamed2 = Symbol.unnamed()

			expect(unnamed).never.to.equal(unnamed2)
		end)
	end)
end