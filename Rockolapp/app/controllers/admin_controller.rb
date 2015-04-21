class AdminController < ApplicationController

	def index
		@admins = Admin.all
	end

	def new
		@admin = Admin.new
	end

	def show
		puts "Session= #{session[:user]}"
		if session[:user] and session[:user] == params[:id].to_i
			@admin = Admin.find(params[:id])
		else
			redirect_to '/'
		end
		rescue ActiveRecord::RecordNotFound
			redirect_to '/404.html'
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

	def login
		if request.get?
			render 'login'
		else
			if @admin = Admin.login(login_params) 
				session[:user] = @admin.id
				redirect_to @admin
			else
				redirect_to '/login/admin'
			end
		end
	end

	def logout
		if session[:user]
			reset_session
			render 'logout'
		else
			redirect_to '/'
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
