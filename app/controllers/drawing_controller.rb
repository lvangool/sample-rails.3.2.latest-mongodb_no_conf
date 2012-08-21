class DrawingController < ApplicationController

	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

	# Delete this block after testing
	before_filter :allow_cross_domain_access
	def allow_cross_domain_access
	  response.headers["Access-Control-Allow-Origin"] = "*"
	  response.headers["Access-Control-Allow-Methods"] = "*"
	end
	# end of block to delete after testing

	def add_from_email
		if User.where(email: params[:email]).exists?
			@user = User.find_by(email: params[:email])
		else
			@user = User.create_from_email(params[:email])
		end

		@drawing = @user.drawings.build
		@drawing.strokes_attributes = JSON.parse(params[:curves].to_s)
		@drawing.temp_image = params[:image]

		respond_to do |format|
			if @user.save && @drawing.save
				Drawing.delay.process_drawing(@user._id, @drawing._id, params[:base_id])
				UserMailer.delay.send_drawing

				format.json { render json: { status: "success" } }
			else
				format.json { render json: { status: "failure" } }
			end
		end

	end

	def add_from_app
		@user = User.find_for_token_authentication(params)
		@drawing = nil

		if !@user.nil? && !params[:image].nil?
			@drawing = @user.drawings.build

			@drawing.strokes_attributes = JSON.parse(params[:curves].to_s)
			@drawing.temp_image = params[:image]
		end

		respond_to do |format|
			if !@drawing.nil? && @drawing.save
				Drawing.delay.process_drawing(@user._id, @drawing._id, params[:base_id])

				format.json { render json: { status: "success" } }
			else
				format.json { render json: { status: "failure" } }
			end
		end
	end

	def delete
		@user = User.find_for_token_authentication(params)
		@drawing = nil

		if !@user.nil? && !params[:id_drawing].nil?
			@drawing = @user.drawings.find(params[:id_drawing])
			@drawing.delete
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
