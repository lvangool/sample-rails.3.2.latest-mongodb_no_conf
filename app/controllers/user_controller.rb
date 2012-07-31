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

	def get_missions
		@user = User.find_for_token_authentication(params)
		@result_hash = {}

		if !@user.nil?
			@result_hash = {status: "success", missions: @user.missions}
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
			@result_hash = {status: "success", drawings: @user.drawings.order_by(:date_created => :desc).map { |drawing| {:full=> drawing.image.png.url, :thumb => drawing.image.thumb('160x120#', :png).url} }.compact }
		else
			@result_hash = {status: "failure"}
		end
		
		respond_to do |format|
			format.json { render :json => @result_hash }
		end
	end

end