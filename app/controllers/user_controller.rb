class UserController < ApplicationController

	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
	
	# Delete this block after testing
	after_filter :set_access_control_headers

	def set_access_control_headers
		headers['Access-Control-Allow-Origin'] = '*'
	   	headers['Access-Control-Request-Method'] = '*'
	end
	# end of block to delete after testing

	def get_token
		@user = User.where({:username => params[:username]}).first
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
							missions: @user.missions.map {|mission| {
																	_id: mission._id, 
																	completed: mission.completed, 
																	prompt: mission.prompt, 
																	confirmation: mission.confirmation, 
																	name: mission.name, 
																	result: ({image: mission.result_drawing.image.url(format: 'png', _id: mission.result_drawing._id)} if mission.result_drawing), 
																	template: ({image: mission.template_drawing.image.url(format: 'png', _id: mission.template_drawing._id)} if mission.template_drawing)
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
			@result_hash = {status: "success", drawings: @user.drawings.order_by(:date_created => :desc).map { |drawing| {:_id => drawing._id, 
																														  :full=> drawing.image.url(:format => 'png'), 
																														  :thumb => drawing.image.thumb('160x120#').url(:format => 'png')} }.compact }
		else
			@result_hash = {status: "failure"}
		end
		
		respond_to do |format|
			format.json { render :json => @result_hash }
		end
	end

end