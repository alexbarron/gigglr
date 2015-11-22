class RelationshipsController < ApplicationController
	before_action :authenticate_user!

	def create
		@comedian = Comedian.find(params[:comedian_id])
		current_user.follow(@comedian)
		respond_to do |format|
			format.html { redirect_to request.referer || @comedian, notice: "You're now following #{@comedian.name}" }
			format.js
		end

	end

	def destroy
		@comedian = Relationship.find(params[:id]).comedian
		current_user.unfollow(@comedian)
		respond_to do |format|
			format.html { redirect_to request.referer || @comedian, notice: "You're no longer following #{@comedian.name}" }
			format.js
		end
	end

end