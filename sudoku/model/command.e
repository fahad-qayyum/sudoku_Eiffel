note
	description: "Summary description for {COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	COMMAND

--feature --attributes

--	number : INTEGER
--	row : INTEGER
--	column : INTEGER

--feature
--	make (num : INTEGER ; r : INTEGER ; col : INTEGER)
--		do
--			number := num
--			row := r
--			column := col
--		end

feature

	undo deferred end
	redo deferred end
	get_value : INTEGER deferred end
	get_row : INTEGER deferred end
	get_column : INTEGER deferred end

end
