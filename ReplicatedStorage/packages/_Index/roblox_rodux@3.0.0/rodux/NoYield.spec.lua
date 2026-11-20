return function()
	local NoYield = require(script.Parent.NoYield)

	it("should call functions normally", function()
		local count = 0

		local function test(p, p2): (number, string)
			expect(p).to.equal(5)
			expect(p2).to.equal(6)

			count += 1

			return 11, "hello"
		end

		local v, v2 = NoYield(test, 5, 6)

		expect(v).to.equal(11)
		expect(v2).to.equal("hello")
	end)

	it("should throw on yield", function()
		local count = 0
		local count2 = 0

		local function testMethod()
			count += 1
			wait()
			count2 += 1
		end

		local success, result = pcall(NoYield, testMethod)

		expect(count).to.equal(1)
		expect(count2).to.equal(0)

		expect(success).to.equal(false)
		expect(result:find("Attempted to yield inside changed event!")).to.be.ok()
		expect(result:find("NoYield.spec")).to.be.ok()
	end)

	it("should propagate error messages", function()
		local count = 0

		local function test()
			count += 1
			error("foo")
		end

		local success, result = pcall(NoYield, test)

		expect(success).to.equal(false)
		expect(result:find("foo")).to.be.ok()
		expect(result:find("NoYield.spec")).to.be.ok()
	end)
end