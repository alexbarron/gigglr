class RelationshipsController < ApplicationController
	before_action :authenticate_user!
	
	def create
		@user = User.find(params[:relationship][:user_id])
		if @user == current_user || current_user.admin?
	    	@comedian = Comedian.find(params[:relationship][:comedian_id])
			@user.follow(@comedian)
			redirect_to @comedian, notice: "You're now following #{@comedian.name}"
		else
			redirect_to root_url, notice: "That's not yours!"
		end
	end

	def destroy
		@user = Relationship.find(params[:id]).user
		if @user == current_user || current_user.admin?
	    	@comedian = Relationship.find(params[:id]).comedian
			@user.unfollow(@comedian)
			redirect_to @comedian, notice: "You're no longer following #{@comedian.name}"
		else
			redirect_to root_url, notice: "That's not yours!"
		end
	end

end