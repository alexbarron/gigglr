class RelationshipsController < ApplicationController
	before_action :authenticate_user!

	def create
		@comedian = Comedian.find(params[:comedian_id])
		current_user.follow(@comedian)
		redirect_to @comedian, notice: "You're now following #{@comedian.name}"
	end

	def destroy
		@comedian = Relationship.find(params[:id]).comedian
		current_user.unfollow(@comedian)
		redirect_to @comedian, notice: "You're no longer following #{@comedian.name}"
	end

end