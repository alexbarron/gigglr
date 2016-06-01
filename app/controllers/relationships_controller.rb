class RelationshipsController < ApplicationController
	before_action :authenticate_user!

	def create
		@comedian = Comedian.find(params[:comedian_id])
		current_user.follow(@comedian)
		Analytics.track(
      user_id: current_user.id,
      event: 'Followed Comedian',
      properties: { comedian: @comedian.name, comedian_id: @comedian.id })
		respond_to do |format|
			format.html { redirect_to request.referer || @comedian, notice: "You're now following #{@comedian.name}" }
			format.js
		end

	end

	def destroy
		@comedian = Relationship.find(params[:id]).comedian
		current_user.unfollow(@comedian)
    Analytics.track(
      user_id: current_user.id,
      event: 'Unfollowed Comedian',
      properties: { comedian: @comedian.name, comedian_id: @comedian.id })
		respond_to do |format|
			format.html { redirect_to request.referer || @comedian, notice: "You're no longer following #{@comedian.name}" }
			format.js
		end
	end

end