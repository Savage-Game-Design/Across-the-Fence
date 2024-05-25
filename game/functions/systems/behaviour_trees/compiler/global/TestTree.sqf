tree =createHashMapFromArray [
	["type", "sequence"],
	["name", "testsequence"],
	["children", [
		createHashMapFromArray [
			["type", "action"],
			["name", "testaction1"],
			["onEnter", { ["running"] }],
			["onTick", { ["succeeded"] }],
			["onExit", {}]
		],
		createHashMapFromArray [
			["type", "selector"],
			["name", "testselector"],
			["children", [
				createHashMapFromArray [
					["type", "decorator"],
					["name", "testdecorator"],
					["condition", {!isNil "treepass"}],
					["onEnter", {["running"]}],
					["abortLowerPriority", true],
					["onChildFinished", { _this # 2 }],
					["onExit", {}],
					["children", [
						createHashMapFromArray [
							["type", "action"],
							["name", "testaction4"],
							["onEnter", { ["running"] }],
							["onTick", { ["succeeded"] }],
							["onExit", {}]
						]
					]]
				],
				createHashMapFromArray [
					["type", "action"],
					["name", "testaction3"],
					["onEnter", { ["running"] }],
					["onTick", { ["running"] }],
					["onExit", {}]
				]
			]]
		],
		createHashMapFromArray [
			["type", "decorator"],
			["name", "testdecorator"],
			["onEnter", { ["failed"] }],
			["onChildFinished", { _this }],
			["onExit", {}],
			["children", [
				createHashMapFromArray [
					["type", "action"],
					["name", "testaction4"],
					["onEnter", { ["running"] }],
					["onTick", { ["succeeded"] }],
					["onExit", {}]
				]
			]]
		],
		createHashMapFromArray [
			["type", "action"],
			["name", "testaction5"],
			["onEnter", { ["running"] }],
			["onTick", { ["succeeded"] }],
			["onExit", {}]
		]
	]]

]




