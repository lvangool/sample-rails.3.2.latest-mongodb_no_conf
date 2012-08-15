class MissionController < ApplicationController

	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
	
	# Delete this block after testing
	after_filter :set_access_control_headers

	def set_access_control_headers
		headers['Access-Control-Allow-Origin'] = '*'
	   	headers['Access-Control-Request-Method'] = '*'
	end
	# end of block to delete after testing

	def complete
		@user = User.find_for_token_authentication(params)
		@result_hash = {}

		if !@user.nil?
			mission = @user.missions.find(params[:mission_id])
			
			if !mission.nil?
				mission.complete(params[:curves], params[:image])
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
