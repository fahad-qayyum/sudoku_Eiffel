note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REDO
inherit
	ETF_REDO_INTERFACE
		redefine redo end
create
	make
feature -- command
	redo
    	do
			-- perform some update on the model state
--			if  not (model.redo_switch ~ TRUE) or not (model.undo_pointer/~ model.redo_pointer and model.redo_pointer <= model.history.upper) then
--			if  not (model.undo_pointer/~ model.redo_pointer and model.redo_pointer <= model.history.upper) then
			if  (model.undo_pointer ~ model.history.count) or not (model.redo_switch = TRUE) or (model.undo_switch = FALSE) or not (model.count_redo < model.count_undo)then
				model.set_error ("Nothing to redo")
			else
				model.redo
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
