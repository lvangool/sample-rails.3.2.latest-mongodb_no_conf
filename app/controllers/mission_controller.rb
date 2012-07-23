skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

class MissionController < ApplicationController

	def complete
		@user = User.find_for_token_authentication(params)
		@result_hash = {}

		if !@user.nil?
			@user.missions.find(params[:mission_id])
			@result_hash = {result: "success"}
		else
			@result_hash = {result: "failure"}
		end

		respond_to do |format|
			format.json { render :json => @result_hash }
		end
	end

end
