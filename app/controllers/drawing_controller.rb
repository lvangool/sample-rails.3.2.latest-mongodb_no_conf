skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

class DrawingController < ApplicationController

	def add_from_base64
		@user = User.find_for_token_authentication(params)
		@drawing = nil

		if !@user.nil?
			@drawing = Drawing.new
			@drawing.from_base64(params[:image], @user)
		end

		respond_to do |format|
			if !@drawing.nil? && @drawing.save
				format.json { render json: { status: "success", data: @drawing } }
			else
				format.json { render json: { status: "failure" } }
			end
		end
	end

end
