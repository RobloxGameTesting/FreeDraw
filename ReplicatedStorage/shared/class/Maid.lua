local v = { "Destroy", "destroy", "Disconnect", "disconnect" }

local function dispose(task)
	local typeName = typeof(task)

	if typeName == "function" then
		task()
	elseif typeName == "table" or typeName == "userdata" then
		for _, v2 in v do
			local v3 = task[v2]

			if v3 then
				v3(task)
				return
			end
		end
	elseif typeName == "Instance" then
		task:Destroy()
	elseif typeName == "RBXScriptConnection" then
		task:Disconnect()
	end
end

local Maid = {}
Maid.__index = Maid

function Maid.new(p)
	local self = setmetatable({ _tasks = {}, _locked = false }, Maid)

	if p then
		self:giveTasks(p)
	end

	return self
end

function Maid:giveTask(p)
	assert(not self._locked, "Maid no longer usable, create a new maid if you wish to add events")
	table.insert(self._tasks, p)
end

function Maid:giveTasks(items)
	assert(not self._locked, "Maid no longer usable, create a new maid if you wish to add events")

	for _, item in items do
		self:giveTask(item)
	end
end

function Maid:clean()
	if not self._locked then
		self._locked = true

		for _, task in self._tasks do
			dispose(task)
		end

		self._tasks = nil
	end
end

return Maid