local HttpService = game:GetService("HttpService")

local t = require(script.Parent.Parent.t)

local MockDataStoreConstants = require(script.Parent.Parent.MockDataStoreService.MockDataStoreService.MockDataStoreConstants)

MockDataStoreConstants.WRITE_COOLDOWN = 0
MockDataStoreConstants.BUDGETING_ENABLED = false

local getTime = require(script.Parent.getTime)

local total = 0
function getTime.getTime()
	return total
end

function getTime.testProgressTime(p)
	total += p
end

local testProgressTime = getTime.testProgressTime

local MockDataStoreService = require(script.Parent.Parent.MockDataStoreService)

MockDataStoreService:ImportFromJSON("\t{\n\t\t\"DataStore\": {\n\t\t\t\"playerData\": {\n\t\t\t\t\"_package/eryn.io/quicksave\": {\n\t\t\t\t\t\"evaera\": {\"data\":\"{\\\"generation\\\":1,\\\"data\\\":{\\\"lockedAt\\\":1603680426,\\\"updatedAt\\\":1603680426,\\\"lockId\\\":\\\"{614A5286-A137-4598-A3EF-54825220DEDC}\\\",\\\"data\\\":{\\\"foo\\\":\\\"bar\\\"},\\\"createdAt\\\":1603680426}}\",\"scheme\":\"raw/1\"},\n\t\t\t\t\t\"locked\": {\"data\":\"{\\\"generation\\\":1,\\\"data\\\":{\\\"lockedAt\\\":9999999999,\\\"updatedAt\\\":1603680426,\\\"lockId\\\":\\\"{614A5286-A137-4598-A3EF-54825220DEDC}\\\",\\\"data\\\":{\\\"foo\\\":\\\"bar\\\"},\\\"createdAt\\\":1603680426}}\",\"scheme\":\"raw/1\"}\n\t\t\t\t}\n\t\t\t},\n\t\t\t\"migrationTests\": {\n\t\t\t\t\"_package/eryn.io/quicksave\": {\n\t\t\t\t\t\"migrationTest\": {\"data\":\"{\\\"generation\\\":0,\\\"data\\\":{\\\"lockedAt\\\":1603680426,\\\"updatedAt\\\":1603680426,\\\"lockId\\\":\\\"{614A5286-A137-4598-A3EF-54825220DEDC}\\\",\\\"data\\\":{\\\"oldKey\\\":\\\"foobar\\\"},\\\"createdAt\\\":1603680426}}\",\"scheme\":\"raw/1\"}\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\t}\n")

return function()
	warn("Running tests at", "super speed")

	local parentModule = require(script.Parent)

	describe("Quicksave", function()
		it("should be able to create collections", function()
			parentModule.createCollection("collectionName", {
				schema = {
					foo = t.optional(t.string),
					key = t.optional(t.string),
					oldKey = t.none,
					newKey = t.optional(t.string),
					["1234"] = t.optional(t.exactly("foo"))
				},
				defaultData = {}
			})
		end)

		it("should not allow duplicate collections", function()
			expect(function()
				parentModule.createCollection("collectionName", { schema = {}, migrations = {} })
			end).to.throw()
		end)

		it("should be able to get collections", function()
			local collection = parentModule.getCollection("collectionName")

			expect(collection).to.be.ok()
			print(collection.name)
			expect(collection.name).to.equal("collectionName")
			expect(parentModule.getCollection("collectionName")).to.equal(collection)
		end)
	end)

	describe("Collection", function()
		it("should be able to get documents", function()
			local collection = parentModule.getCollection("collectionName")

			local expect2 = collection:getDocument("foobar"):expect()

			expect(expect2.collection).to.equal(collection)
			expect(expect2.name).to.equal("foobar")

			expect(collection:getDocument("foobar"):expect()).to.equal(expect2)
		end)
	end)

	describe("Document", function()
		parentModule.createCollection("playerData", {
			schema = {
				foo = t.optional(t.string),
				key = t.optional(t.string),
				oldKey = t.none,
				newKey = t.optional(t.string),
				["1234"] = t.optional(t.exactly("foo"))
			},
			defaultData = {}
		})

		local v = nil
		local v2 = nil

		beforeEach(function()
			v2 = HttpService:GenerateGUID()
			v = parentModule.getCollection("playerData"):getDocument(v2):expect()
		end)

		it("should not be able to load a locked document", function()
			local v3, v4 = parentModule.getCollection("playerData"):getDocument("locked"):await()

			expect(v3).to.equal(false)
			expect(v4.kind).to.equal(parentModule.Error.Kind.CouldNotAcquireLock)
		end)

		it("should compress large data", function()
			local expect2 = parentModule.getCollection("playerData"):getDocument("large"):expect()

			expect2:set("foo", string.rep("a", 2000))
			testProgressTime(7)
			expect2:close():expect()

			local async = MockDataStoreService:GetDataStore("playerData", "_package/eryn.io/quicksave"):GetAsync("large")

			expect(#async < 2000).to.equal(true)

			testProgressTime(7)

			local expect3 = parentModule.getCollection("playerData"):getDocument("large"):expect()
			expect(expect3:get("foo")).to.equal(string.rep("a", 2000))
		end)

		it("should be able to load existing data", function()
			local expect2 = parentModule.getCollection("playerData"):getDocument("evaera"):expect()

			expect(expect2:get("foo")).to.equal("bar")
		end)

		it("should be able to load existing data with a migration", function()
			parentModule.createCollection("migrationTests", {
				schema = { oldKey = t.none, newKey = t.string },
				defaultData = { newKey = "hi" },
				migrations = { function(p)
						return { newKey = p.oldKey }
					end }
			})

			local expect2 = parentModule.getCollection("migrationTests"):getDocument("migrationTest"):expect()

			expect(expect2:get("newKey")).to.equal("foobar")
			expect(expect2:get("oldKey")).to.never.be.ok()
		end)

		it("should give new keys as nil", function()
			expect(v:get("key")).to.equal(nil)
		end)

		it("should be able to retrieve keys", function()
			v:set("key", "foo")

			expect(v:get("key")).to.equal("foo")
		end)

		it("should be able to save", function()
			v:set("foo", "bar")

			testProgressTime(7)

			v:save():expect()
		end)

		it("should error when writing to a closed document", function()
			v:set("foo", "bar")

			v:close()

			expect(function()
				v:set("foo", "not bar")
			end).to.throw()

			expect(function()
				v:save():expect()
			end).to.throw()
		end)

		it("should be able to save, unlock, relock and load the same data", function()
			v:set("foo", "bar")

			testProgressTime(7)

			v:close():expect()

			testProgressTime(7)

			local expect2 = parentModule.getCollection("playerData"):getDocument(v2):expect()

			expect(v).to.never.equal(expect2)

			expect(expect2:get("foo")).to.equal("bar")
		end)

		it("should convert number keys to strings", function()
			v:set(1234, "foo")

			expect(v:get("1234")).to.equal("foo")
		end)

		itSKIP("should disallow unserializable objects from being set", function()
			expect(function()
				v:set("key", workspace)
			end).to.throw()

			expect(function()
				v:set("key", { workspace })
			end).to.throw()

			expect(function()
				v:set("key", { nested = workspace })
			end).to.throw()

			expect(function()
				v:set("key", (Vector3.new()))
			end).to.throw()
		end)

		itSKIP("should disallow tables with metatables from being set", function()
			expect(function()
				v:set("key", (setmetatable({}, {})))
			end).to.throw()

			expect(function()
				v:set("key", { nested = setmetatable({}, {}) })
			end).to.throw()
		end)
	end)
end