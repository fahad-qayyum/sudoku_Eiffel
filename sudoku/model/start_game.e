note
	description: "Summary description for {START_GAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	START_GAME

inherit
	COMMAND
redefine
	undo,redo,get_value,get_row,get_column
	end

create make

feature
	make(num : INTEGER;r:INTEGER;c:INTEGER)

		do
			model := model_access.m
			create msg.make_empty
			number := num
			row := r
			column := c

		end

feature --Attributes

	model : SUDOKU
	model_access : SUDOKU_ACCESS
	msg : STRING
	number : INTEGER
	row : INTEGER
	column : INTEGER

feature -- undo, redo
	undo
		do
			model.set_game_started (FALSE)
			model.grid.force (number, row, column)
			model.set_undo_pointer (model.get_undo_pointer-1)
		end
	redo
		do
			model.set_undo_pointer(model.get_undo_pointer+1)
			model.set_switch(TRUE)
			model.set_game_started(TRUE)
			model.set_redo_switch(TRUE)
		end
feature --queries	
	get_row : INTEGER
		do
			result := row
		end
	get_column : INTEGER
		do
			result := column
		end
	get_value : INTEGER
		do
			result := number
		end
end
