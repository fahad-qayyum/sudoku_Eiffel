note
	description: "Summary description for {PUT_NUMBER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PUT_NUMBER

inherit
	COMMAND

create
	make

feature --Attributes

	number : INTEGER
	row : INTEGER
	column : INTEGER
	model : SUDOKU
	model_access : SUDOKU_ACCESS

feature
	make(num : INTEGER; r : INTEGER; c : INTEGER)
		do
			row := r
			column := c
			number := num
			model := model_access.m
		end

feature -- undo, redo

	redo
		do
			model.set_undo_pointer(model.get_undo_pointer+1)
			model.set_pn(TRUE)
			model.grid.force (number, row, column)
			model.set_redo_switch(TRUE)

		end
	undo
		do
			model.set_pn(TRUE)
			model.grid.force (0, row, column)
			model.set_undo_pointer (model.get_undo_pointer-1)
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

