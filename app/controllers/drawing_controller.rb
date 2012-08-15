class DrawingController < ApplicationController

	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
	
	# Delete this block after testing
	after_filter :set_access_control_headers

	def set_access_control_headers
		headers['Access-Control-Allow-Origin'] = '*'
	   	headers['Access-Control-Request-Method'] = '*'
	end
	# end of block to delete after testing
	
	def add_from_app
		@user = User.find_for_token_authentication(params)
		@drawing = nil

		if !@user.nil? && !params[:image].nil?
			@drawing = @user.drawings.build

			@drawing.strokes_attributes = JSON.parse(params[:curves].to_s) 
			@drawing.temp_image = params[:image]
			@drawing.add_parent(params[:base_id]) if params[:base_id]
			@drawing.upload_image()
		end

		respond_to do |format|
			if !@drawing.nil? && @drawing.save
				# Launch a job to convert the base64 into image and s3 upload.

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
