note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PUT_NUMBER
inherit
	ETF_PUT_NUMBER_INTERFACE
		redefine put_number end
create
	make
feature --Attributes

--	value_before : INTEGER
--	get_row : INTEGER
--	get_column : INTEGER

feature -- execute
	put_number(num: INTEGER_64 ; row: INTEGER_64 ; col: INTEGER_64)
    	do
			-- perform some update on the model state
			if (model.game_started = false ) then
				model.set_error ("Game not yet started")
			elseif not (row.to_integer_32 < 5 and row.to_integer_32 > 0 ) then
				model.set_error ("Invalid row number")
			elseif not (col.to_integer_32 < 5 and col.to_integer_32 > 0 ) then
				model.set_error ("Invalid column number")
			elseif not(model.grid.item (row.to_integer_32, col.to_integer_32) ~ 0) then
				model.set_error ("Cell already filled")
			elseif not(num.to_integer_32 < 5 and num.to_integer_32 > 0) then
				model.set_error ("Invalid value to put in cell")
			elseif not (model.grid.item(row.to_integer_32,1)/~ num.to_integer_32 and model.grid.item(row.to_integer_32,2)/~ num.to_integer_32 and model.grid.item(row.to_integer_32,3)/~ num.to_integer_32 and model.grid.item(row.to_integer_32,4)/~ num.to_integer_32) then
				model.set_error ("Number already exists in row")
			elseif not(model.grid.item(1,col.to_integer_32)/~ num.to_integer_32 and model.grid.item(2,col.to_integer_32)/~ num.to_integer_32 and model.grid.item(3,col.to_integer_32)/~ num.to_integer_32 and model.grid.item(4,col.to_integer_32)/~ num.to_integer_32) then
				model.set_error ("Number already exists in column")
			elseif not (model.check_sub_grid(num.to_integer_32,row.to_integer_32,col.to_integer_32)) then
				model.set_error ("Number already exists in subgrid")
			else
				model.put_num(num.to_integer_32, row.to_integer_32, col.to_integer_32)
			end
				etf_cmd_container.on_change.notify ([Current])
    	end
--feature --undo
--	undo
--		do

--		end
end
