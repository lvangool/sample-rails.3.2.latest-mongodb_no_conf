class DrawingController < ApplicationController

	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
	
	def add_from_app
		@user = User.find_for_token_authentication(params)
		@drawing = nil

		if !@user.nil? && !params[:image].nil?
			@drawing = Drawing.new({:curves => params[:curves]})
			@drawing.user = @user
			@drawing.from_base64(params[:image])
			# @drawing.add_parent(params[:parent_id]) if params[:parent_id]
		end

		respond_to do |format|
			if !@drawing.nil? && @drawing.save
				format.json { render json: { status: "success", data: @drawing } }
			else
				format.json { render json: { status: "failure" } }
			end
		end
	end

	def delete
		@user = User.find_for_token_authentication(params)

		if !@user.nil? && !params[:id_drawing].nil?
			@drawing = @user.drawings.find(params[:id_drawing])
		end

		respond_to do |format|
			if !@drawing.nil? && @drawing.save
				format.json { render json: { status: "success" } }
			else
				format.json { render json: { status: "failure" } }
			end
		end

	end

end
