solution "proof_of_concept"
	configurations { "debug", "release" }
--	location "build" -- optional, but cleaner
--  targetdir "bin"  -- optional, same here

	configuration "debug"
		flags { "Symbols" }     -- turns on '-debug'
        buildoptions { "-gc -unittest -D -color=on -v" }  -- pass through to compiler

	configuration "release"
		flags { "Optimize" } -- turns on '-O -release'

	project "pbd_logger"
		kind "ConsoleApp"
		language "D"         -- enables D language processing
		files { "policy_based_design-proof_of_concept.d" }

	project "mixinlogger"
		kind "ConsoleApp"
		language "D"         -- enables D language processing
		files { "mixin_logger-proof_of_concept.d" }

	project "package"
		kind "ConsoleApp"
		language "D"         -- enables D language processing
		files { "*.d" }

