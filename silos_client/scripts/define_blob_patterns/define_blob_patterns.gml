function define_blob_patterns() {
	global.blob_patterns = {
		low: [
			[".xx",
			 "xx.",
			 ".x."],
			 
			[".x.",
			 "xxx",
			 ".xx"],
			 
			["...",
			 ".xx",
			 "xxx"],
			 
			["x..",
			 "xxx",
			 ".xx"],
			 
			["xx.",
			 "xx.",
			 "x.."],
		],
		medium: [
			[".x..",
			 ".xx.",
			 "xxx.",
			 ".x.."],
			 
			[".x..",
			 "xxxx",
			 ".xxx",
			 "...."],
			 
			[".x..",
			 "xxx.",
			 "xxx.",
			 "..x."],
			 
			["..xx",
			 "..xx",
			 ".xxx",
			 "...."],
			 
			["..x.",
			 ".xx.",
			 "xxx.",
			 ".x.."],
		],
		high: [
			[".....",
			 ".xx..",
			 "xxxx.",
			 ".xxxx",
			 "..x.."], 
			 
			["..xx.",
			 ".xxx.",
			 "xxxx.",
			 "xxx..",
			 "....."], 
			 
			[".....",
			 ".xx..",
			 "xxxxx",
			 ".xxx.",
			 "..x.."], 
			
			["xxx..",
			 "xxx..",
			 ".xxx.",
			 "...x.",
			 "...x."], 
			 
			[".....",
			 ".....",
			 ".xxx.",
			 "xxxx.",
			 ".xxxx"], 
		]
	}
}