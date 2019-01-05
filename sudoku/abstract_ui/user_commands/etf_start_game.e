note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_START_GAME
inherit
	ETF_START_GAME_INTERFACE
		redefine start_game end
create
	make
feature -- command
	start_game
    	do
			-- perform some update on the model state
			if (model.game_started) then
				model.set_error ("Game already started")
			end
			model.start_g
			etf_cmd_container.on_change.notify ([Current])
    	end

end
