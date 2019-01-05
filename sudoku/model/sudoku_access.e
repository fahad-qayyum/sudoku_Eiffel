note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	SUDOKU_ACCESS

feature
	m: SUDOKU
		once
			create Result.make
		end

invariant
	m = m
end




