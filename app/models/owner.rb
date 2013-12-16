class Owner 

	def name
		name = 'Foobar kardigan'
	end


	def birthdate
		birthdate = Date.new(1990, 12, 2)
	end


	def countdown
		today = Date.today
		birthday = Date.new(today.year, birthdate.month,birthdate.day)
		if birthday > today
			 countdown = (birth - today).to_i
		else
			countdown = (birthday.next_year - today).to_i
		end
	end


end