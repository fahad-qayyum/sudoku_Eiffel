note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	SUDOKU

inherit

	ANY
		redefine
			out
		end

create {SUDOKU_ACCESS}
	make

feature --Attributes

	grid: ARRAY2 [INTEGER]

	error: STRING

	counter: INTEGER

	switch: BOOLEAN

	pn: BOOLEAN

	sn: BOOLEAN

	new_line: BOOLEAN

	undo_switch: BOOLEAN

	history: ARRAY [COMMAND] --for undo,redo operations

	game_started: BOOLEAN --for undo,redo operation

	undo_pointer: INTEGER --for undo operation

	redo_switch: BOOLEAN -- for redo operation

	count_redo: INTEGER -- for redo operation

	count_undo: INTEGER -- for undo operation

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create grid.make_filled (0, 4, 4)
			create error.make_empty
			create history.make_empty
			redo_switch := FALSE
			sn := FALSE
			pn := FALSE
			switch := FALSE
			game_started := FALSE
			undo_pointer := 0
			count_redo := 0
			count_undo := 0
			undo_switch := FALSE
		end

feature -- QUERY

	number_of_elements: INTEGER
		do
			counter := 0
			across
				1 |..| grid.height as x
			loop
				across
					1 |..| grid.width as y
				loop
					if ((grid.item (x.item, y.item)) /~ 0) then
						counter := counter + 1
					end
				end
			end
			result := counter
		end

	get_sn: BOOLEAN
		do
			result := sn
		end

	check_game_status: STRING
		do
			if number_of_elements < 16 then
				result := "No"
			else
				result := "Yes"
			end
		end

	check_sub_grid (number: INTEGER; row: INTEGER; co: INTEGER): BOOLEAN
		do
			if (row <= 2 and co <= 2 and grid.item (1, 1) /~ number and grid.item (1, 2) /~ number and grid.item (2, 1) /~ number and grid.item (2, 2) /~ number) then
				result := true
			elseif (row <= 2 and co >= 2 and grid.item (1, 3) /~ number and grid.item (1, 4) /~ number and grid.item (2, 3) /~ number and grid.item (2, 4) /~ number) then
				result := true
			elseif (row >= 2 and co <= 2 and grid.item (3, 1) /~ number and grid.item (3, 2) /~ number and grid.item (4, 1) /~ number and grid.item (4, 2) /~ number) then
				result := true
			elseif (row >= 2 and co >= 2 and grid.item (3, 3) /~ number and grid.item (3, 4) /~ number and grid.item (4, 3) /~ number and grid.item (4, 4) /~ number) then
				result := true
			else
				result := FALSE
			end
		end

	get_undo_pointer: INTEGER
		do
			result := undo_pointer
		end

feature -- Command

	set_sn (arg: BOOLEAN)
		do
			sn := arg
		end

	set_pn (arg: BOOLEAN)
		do
			pn := arg
		end

	set_switch (arg: BOOLEAN)
		do
			switch := arg
		end

	set_game_started (arg: BOOLEAN)
		do
			game_started := arg
		end

	set_undo_pointer (value: INTEGER)
		do
			undo_pointer := value
		end

	set_error (msg: STRING)
		do
			error := msg
		end

	reset
			-- Reset model state.
		do
			make
		end

	undo
		require
			game_not_restarted: redo_switch ~ TRUE
			something_to_undo: undo_pointer >= 1
		do
			undo_switch := TRUE
			history [undo_pointer].undo
			count_undo := count_undo + 1
		end

	redo
		require
			redo_not_more_than_undo: count_redo < count_undo
			last_feature_redo_or_undo: undo_switch = TRUE
			something_to_redo: undo_pointer /~ history.count
			not_the_first_command: redo_switch = TRUE
		do
			count_redo := count_redo + 1
			undo_switch := TRUE
			history [undo_pointer + 1].redo
		end

	start_g
		do
			if (history.count >= 1) then
				history.force (create {START_GAME}.make (history [(undo_pointer)].get_value, history [(undo_pointer)].get_row, history [(undo_pointer)].get_column), undo_pointer + 1)
			else
				history.force (create {START_GAME}.make (0, 1, 1), undo_pointer + 1)
			end
			set_undo_pointer (undo_pointer + 1)
			count_redo := 0
			count_undo := 0
			switch := TRUE
			game_started := TRUE
			redo_switch := TRUE
			undo_switch := FALSE
		ensure
			game_started: switch = true
		end

	restart
		do
			make
		end

	set_redo_switch (b: BOOLEAN)
		do
			redo_switch := b
		end

	set_num (num: INTEGER; r: INTEGER; c: INTEGER)
		require else
			valid_row_in_set: r < 5 and r > 0
			valid_column_in_set: c < 5 and c > 0
			cell_not_already_filled: grid.item (r, c) ~ 0
			valid_value: num < 5 and num > 0
			value_not_exists_in_row: grid.item (r, 1) /~ num and grid.item (r, 2) /~ num and grid.item (r, 3) /~ num and grid.item (r, 4) /~ num
			value_not_exists_in_column: grid.item (1, c) /~ num and grid.item (2, c) /~ num and grid.item (3, c) /~ num and grid.item (4, c) /~ num
			value_not_exists_in_sub_grid: check_sub_grid (num, r, c)
		do
			count_redo := 0
			count_undo := 0
			set_undo_pointer (undo_pointer + 1)
			history.force (create {SET_NUMBER}.make (num, r, c), undo_pointer)
			sn := TRUE
			grid.force (num, r, c)
			redo_switch := true
			undo_switch := FALSE
		ensure
			element_added: grid.item (r, c) ~ num
			count_increased: number_of_elements = old number_of_elements + 1
		end

	put_num (num: INTEGER; r: INTEGER; c: INTEGER)
		require
			valid_row_in_put: r < 5 and r > 0
			valid_column_in_put: c < 5 and c > 0
			cell_not_already_filled: grid.item (r, c) ~ 0
			valid_value: num < 5 and num > 0
			value_not_exists_in_row: grid.item (r, 1) /~ num and grid.item (r, 2) /~ num and grid.item (r, 3) /~ num and grid.item (r, 4) /~ num
			value_not_exists_in_column: grid.item (1, c) /~ num and grid.item (2, c) /~ num and grid.item (3, c) /~ num and grid.item (4, c) /~ num
			value_not_exists_in_sub_grid: check_sub_grid (num, r, c)
		do
			count_redo := 0
			count_undo := 0
			pn := TRUE
			set_undo_pointer (undo_pointer + 1)
			history.force (create {PUT_NUMBER}.make (num, r, c), undo_pointer)
			grid.force (num, r, c)
			redo_switch := true
			undo_switch := FALSE
		ensure
			element_added: grid.item (r, c) ~ num
			count_increased: number_of_elements = old number_of_elements + 1
		end

feature --STRING print

	out: STRING
		do
			create Result.make_from_string ("  ")
			if error.is_empty then
				if (pn ~ TRUE) or (switch ~ TRUE) then
					result.append ("Current game is over: " + check_game_status)
				elseif game_started = FALSE then --(number_of_elements = 0) or (sn ~ TRUE) then
					result.append ("Setting up a new grid")
				end
				across
					1 |..| grid.height as x
				loop
					result.append ("%N  ")
					new_line := TRUE
					across
						1 |..| grid.width as y
					loop
						if not (y.after) and new_line = FALSE then
							result.append ("   ")
						end
						new_line := FALSE
						result.append (grid.item (x.item, y.item).out)
					end
				end
			elseif not (error.is_empty) then
				result.append ("Error: ")
				Result.append (error)
				across
					1 |..| grid.height as x
				loop
					result.append ("%N  ")
					new_line := TRUE
					across
						1 |..| grid.width as y
					loop
						if not (y.after) and new_line = FALSE then
							result.append ("   ")
						end
						new_line := FALSE
						result.append (grid.item (x.item, y.item).out)
					end
				end
			end
			sn := FALSE
			pn := FALSE
			error.make_empty
			switch := FALSE
		end

end
