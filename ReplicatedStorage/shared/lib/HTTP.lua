local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Promise = require(ReplicatedStorage.packages.Promise)
local Sift = require(ReplicatedStorage.packages.Sift)
local t = require(ReplicatedStorage.packages.t)

local strictInterface = t.strictInterface({
	url = t.any,
	method = t.string,
	body = t.optional(t.union(t.string, t.table)),
	headers = t.optional(t.map(t.string, t.any)),
	query = t.optional(t.map(t.string, t.union(t.string, t.array(t.string)))),
	json = t.optional(t.boolean)
})

local function buildQueryString(query)
	local v = {}

	for k, item in query do
		if type(item) == "string" then
			table.insert(v, ("%s=%s"):format(k, item))
		elseif type(item) == "table" then
			for _, item2 in item do
				table.insert(v, ("%s[]=%s"):format(k, item2))
			end
		end
	end

	return table.concat(v, "&")
end

local function buildRequest(data)
	local url = data.url
	local method = data.method
	local body = data.body
	local headers = data.headers or {}
	local query = data.query

	local mapped = Sift.Dictionary.map(headers, function(p, value)
		return p, value:lower()
	end)

	if body ~= nil and (data.json or type(body) ~= "string" and data.json == nil) then
		body = HttpService:JSONEncode(body)
		mapped["content-type"] = "application/json"
	end

	if query and next(query) then
		local queryString = buildQueryString(query)

		if typeof(url) == "Secret" then
			url = url:AddSuffix("?" .. queryString)
		else
			url ..= "?" .. queryString
		end
	end

	return { Url = url, Method = method, Body = body, Headers = mapped }
end

local function parseResponse(data)
	local success = data.Success
	local statusCode = data.StatusCode
	local statusMessage = data.StatusMessage
	local headers = data.Headers
	local body = data.Body

	local contenttype = headers["content-type"]

	if contenttype and contenttype:match("^([^;]+)") == "application/json" then
		body = HttpService:JSONDecode(body)
	end

	return {
		success = success,
		statusCode = statusCode,
		statusMessage = statusMessage,
		headers = headers,
		body = body
	}
end

local function request(p)
	assert(strictInterface(p))

	return Promise.new(function(callback, callback2)
		local v = parseResponse(HttpService:RequestAsync(buildRequest(p)))

		if v.success then
			callback(v)
			return
		end

		warn(("HTTP request failed: %d %s"):format(v.statusCode, v.statusMessage))

		if RunService:IsStudio() then
			warn("Request", p)
			warn("Response", v)
		end

		callback2(v)
	end)
end

local function joinOverride(p, p2)
	if p2 ~= nil then
		return p2
	end

	return if p ~= nil then p else nil
end

local v = {
	url = function(p, p2)
		return p .. p2
	end,
	method = function(_, p)
		return p
	end,
	headers = Sift.Dictionary.join,
	query = Sift.Dictionary.join,
	data = joinOverride,
	json = joinOverride
}
local function createRequestBuilder(p)
	local function join(items)
		local copy = Sift.Dictionary.copy(p)

		for k, item in items do
			local v2 = copy[k]

			if v2 == nil then
				copy[k] = item
			else
				copy[k] = v[k](v2, item)
			end
		end

		return copy
	end

	local function perform(p2)
		return request(join(p2))
	end

	local function extend(p2)
		return createRequestBuilder(join(p2))
	end

	return (setmetatable({ perform = perform, extend = extend }, {
		__call = function(_, p2)
			return perform(p2)
		end
	}))
end

return {
	request = createRequestBuilder({ method = "GET" })
}