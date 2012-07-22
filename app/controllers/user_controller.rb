class UserController < ApplicationController

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
			@result_hash = {status: "success", drawings: @user.drawings}
		else
			@result_hash = {status: "failure"}
		end
		
		respond_to do |format|
			format.json { render :json => @result_hash }
		end
	end

end