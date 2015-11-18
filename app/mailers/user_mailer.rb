class UserMailer < ApplicationMailer

	def new_show(user, comedian, show)
		@user = user
		@comedian = comedian
		@show = show

		mail to: user.email, subject: "New " + @comedian.name + " show near you on " + @show.showtime.strftime("%b %e")
	end
end
