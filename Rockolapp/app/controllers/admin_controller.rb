class AdminController < ApplicationController

	def index
		@admins = Admin.all
	end

	def new
		@admin = Admin.new
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
	def login
		if request.get?
			render 'login'
		else
			puts login_params
			@admin = Admin.find_by_email!(login_params)
			if @admin.login(login_params)
				redirect_to '/admins'
			else
				redirecto_to '/login'
			end
		end
	end
	private
		def admin_params
			params.require(:admin).permit(:email, :password, :name)
		end
		def  login_params
			params.require(:login).permit(:email, :password)
		end
end
