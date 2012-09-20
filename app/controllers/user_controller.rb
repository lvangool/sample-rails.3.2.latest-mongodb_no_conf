class UserController < ApplicationController

	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
	
	# Delete this block after testing
	before_filter :allow_cross_domain_access
	def allow_cross_domain_access
	  response.headers["Access-Control-Allow-Origin"] = "*"
	  response.headers["Access-Control-Allow-Methods"] = "*"
	end
	# end of block to delete after testing

	def get_token
		@user = User.where({:username => params[:username].downcase}).first
		@result_hash = {}

		if !@user.nil? && @user.valid_password?(params[:password])
			@result_hash = {status: "success", token: @user.authentication_token}
		else
			@result_hash = {status: "failure"}
		end

		respond_to do |format|
			format.json { render :json => @result_hash }
		end
	end

	def get_drawing_missions
		@user = User.find_for_token_authentication(params)
		@result_hash = {}

		if !@user.nil?
			# Should get only the drawing type of mission
			@result_hash = {
							status: "success", 
							missions: @user.missions.order_by(:date_created.desc, :completed.asc).map {|mission|
																{
																	_id: mission._id, 
																	completed: mission.completed, 
																	prompt: mission.prompt, 
																	confirmation: mission.confirmation, 
																	name: mission.name, 
																	result: (if mission.completed_drawing && mission.completed_drawing.temp_image then {temp_image: mission.completed_drawing.temp_image} elsif mission.completed_drawing then {image: mission.completed_drawing.image.get_url(384, 288)} end), 
																	template: ({image: mission.template_drawing.get_url(), thumb: mission.template_drawing.image.get_url(384, 288)} if mission.template_drawing),
																	tools: mission.tools
																} 
														}	
							}
		else
			@result_hash = {status: "failure"}
		end
		
		respond_to do |format|
			format.json { render :json => @result_hash }
		end
	end

	def get_drawings
		@user = User.find_for_token_authentication(params)
		@result_hash = {}

		if !@user.nil?
			@result_hash = {status: "success", drawings: @user.drawings.order_by(:date_created => :desc).map { |drawing| 
																												{
																												 _id: drawing._id, 
																											     full: (drawing.get_url() if drawing.image),
																											     public_id: (drawing.image['public_id'] if drawing.image),
																										    	 temp_image: (drawing.temp_image if drawing.temp_image)
																										        }
																										     }.compact 
						   }
			@result_hash[:thumbs] = Cloudinary::Uploader.generate_sprite(@user._id.to_s + "_thumbs", :width => 160, :height => 120, :crop => :scale, :prefix => "nzk_")
		else
			@result_hash = {status: "failure"}
		end
		
		respond_to do |format|
			format.json { render :json => @result_hash }
		end
	end

end