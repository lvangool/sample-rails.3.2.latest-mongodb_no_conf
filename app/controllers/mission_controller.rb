class MissionController < ApplicationController

	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
	
	# Delete this block after testing
	before_filter :allow_cross_domain_access
	def allow_cross_domain_access
	  response.headers["Access-Control-Allow-Origin"] = "*"
	  response.headers["Access-Control-Allow-Methods"] = "*"
	end
	# end of block to delete after testing

	def complete
		@user = User.find_for_token_authentication(params)
		@result_hash = {}

		if !@user.nil?
			mission = @user.missions.find(params[:mission_id])
			mission.completed = true
			mission.date_completed = Time.now
			mission.completed_drawing = Drawing.new(temp_image: params[:image])
			mission.completed_drawing.strokes_attributes = JSON.parse(params[:curves].to_s)

			if !mission.nil? && mission.completed_drawing.save && mission.save
				Drawing.delay.process_mission(@user._id, params[:mission_id])

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
