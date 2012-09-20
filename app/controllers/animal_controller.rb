class AnimalController < ApplicationController
	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

	# Delete this block after testing
	before_filter :allow_cross_domain_access
	def allow_cross_domain_access
	  response.headers["Access-Control-Allow-Origin"] = "*"
	  response.headers["Access-Control-Allow-Methods"] = "*"
	end
	# end of block to delete after testing

	def add
		@animal = Animal.new(JSON.parse(params['animal'].to_s))

		respond_to do |format|
			if @animal.save
				format.json { render json: { status: "success" } }
			else
				format.json { render json: { status: "failure" } }
			end
		end
	end

	def get
		@animal = Animal.find(params[:id])

		respond_to do |format|
			if @animal
				format.json { render json: { status: "success", data: @animal.to_json } }
			else
				format.json { render json: { status: "failure" } }
			end
		end
	end

end
