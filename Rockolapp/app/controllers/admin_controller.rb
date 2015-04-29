class AdminController < ApplicationController

	def index
		if is_logged?
			@admins = Admin.all
		else
			render 'no_aut'
		end
	end

	def new
		@admin = Admin.new
	end

	def show
		if is_user? params[:id].to_i
			@admin = Admin.find(params[:id])
		else
			render 'no_aut'
		end
		rescue ActiveRecord::RecordNotFound
			render 'no_record'
	end

	def create 
		@admin = Admin.new(admin_params)

		if @admin.save
			redirect_to login_path
		else
			render 'new'
		end
	end

	def edit
		if is_logged? and is_user? params[:id].to_i
			@admin = Admin.find(params[:id])
		else
			redirect_to 'no_aut'
		end
		rescue ActiveRecord::RecordNotFound
			render 'no_record'
	end

	def update
		if is_logged? and is_user? params[:id].to_i
			@admin = Admin.find(params[:id])
			if @admin.update(admin_params)
			redirect_to @admin
			else
				render 'edit'
			end		
		else
			render 'no_aut'
		end
	end

	def destroy
		if is_logged? and is_user? params[:id].to_i
			@admin = Admin.find(params[:id])
			if @admin.destroy
				redirect_to 'index'
			else
				redirect_to 'no_aut'
			end
		end
		rescue ActiveRecord::RecordNotFound
			render 'no_record'		
	end
	private
		def admin_params
			params.require(:admin).permit(:name, :email, :password)
		end
		def is_user?(id)
			puts "EL NUMERO CHIDO ES: #{session[:admin]}"
			if session[:superuser]
				return true;
			elsif session[:admin] and session[:admin].to_i == id
				return true;
			else
				return nil;
			end
		end
		def is_logged?
			session[:admin] or session[:superuser]
		end
end
