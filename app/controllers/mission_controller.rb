class MissionController < ApplicationController

	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

	def complete
		@user = User.find_for_token_authentication(params)
		@result_hash = {}

		if !@user.nil?
			mission = @user.missions.find(params[:mission_id])
			
			if !mission.nil?
				mission.completed = true
				mission.date_completed = Time.now
				mission.save

				@result_hash = {status: "success"}
			else
				@result_hash = {status: "failure"}
			end
		else
			@result_hash = {status: "failure"}
		end

		respond_to do |format|
			format.json { render :json => @result_hash }
		end
	end

end
