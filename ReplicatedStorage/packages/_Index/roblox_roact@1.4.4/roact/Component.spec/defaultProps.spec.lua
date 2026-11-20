return function()
	local assertDeepEqual = require(script.Parent.Parent.assertDeepEqual)
	local createElement = require(script.Parent.Parent.createElement)
	local createReconciler = require(script.Parent.Parent.createReconciler)
	local None = require(script.Parent.Parent.None)
	local NoopRenderer = require(script.Parent.Parent.NoopRenderer)

	local Component = require(script.Parent.Parent.Component)

	local reconciler = createReconciler(NoopRenderer)

	it("should fill in when mounting before init", function()
		local defaultProps = { a = 3, b = 2 }

		local extended = Component:extend("Foo")

		extended.defaultProps = defaultProps

		local props = nil
		function extended.init(p)
			props = p.props
		end

		function extended.render(_) end

		local v = { b = 4, c = 6 }

		local element = createElement(extended, v)

		reconciler.mountVirtualNode(element, nil, "Some Foo")

		local v2 = { a = defaultProps.a, b = v.b, c = v.c }

		assertDeepEqual(props, v2)
	end)

	it("should fill in when updating via props", function()
		local defaultProps = { a = 3, b = 2 }

		local extended = Component:extend("Foo")

		extended.defaultProps = defaultProps

		local props = nil
		function extended.render(p)
			props = p.props
		end

		local element = createElement(extended, { b = 4, c = 6 })

		local v = reconciler.mountVirtualNode(element, nil, "Some Foo")

		local v2 = { c = 5 }

		local element2 = createElement(extended, v2)

		reconciler.updateVirtualNode(v, element2)

		local v3 = { a = defaultProps.a, b = defaultProps.b, c = v2.c }

		assertDeepEqual(props, v3)
	end)

	it("should respect None to override a default prop with nil", function()
		local defaultProps = { a = 3, b = 2 }

		local extended = Component:extend("Foo")

		extended.defaultProps = defaultProps

		local props = nil
		function extended.render(p)
			props = p.props
		end

		local v = { b = None, c = 4 }

		local element = createElement(extended, v)

		reconciler.mountVirtualNode(element, nil, "Some Foo")

		local v2 = { a = defaultProps.a, b = nil, c = v.c }

		assertDeepEqual(props, v2)
	end)
end