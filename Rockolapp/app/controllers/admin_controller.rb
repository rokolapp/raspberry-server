class AdminController < ApplicationController

	def index
		@admins = Admin.all
	end

	def new
	end

	def show
		@admin = Admin.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			redirect_to '/'
	end

	def create 
		@admin = Admin.new(admin_params)

		if @admin.save
			redirect_to @admin
		else
			render 'new'
		end
	end

	def edit
		@admin = Admin.find(params[:id])
	end

	def update 
		@admin = Admin.find(params[:id])
		if @admin.update(admin_params)
			redirect_to @admin
		else
			render 'edit'
		end
	end

	def destroy
		@admin = Admin.find(params[:id])
		if @admin.destroy
			redirect_to 'index'
		else
			render 'index'
		end
	end

	def shout
		redirect_to '/'
		Admin.shout
	end

	private
		def admin_params
			params.require(:admin).permit(:email, :password, :name)
		end
end
