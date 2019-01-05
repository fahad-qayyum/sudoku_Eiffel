note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_UNDO
inherit
	ETF_UNDO_INTERFACE
		redefine undo end
create
	make
--feature --Attributes
--	requested : detachable ETF_COMMAND
feature -- command
	undo
    	do
			-- perform some update on the model state
--			model.default_update
			if not(model.redo_switch ~ TRUE) or not (model.undo_pointer >= 1)then
				model.set_error ("Nothing to undo")
			else
				model.undo
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
