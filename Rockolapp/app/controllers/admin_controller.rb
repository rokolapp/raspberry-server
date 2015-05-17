class AdminController < ApplicationController
	def index
		@admins = Admin.all if is_logged?
	end
	
	def show
		@admin = Admin.find(params[:id]) if is_user? params[:id].to_i
		rescue ActiveRecord::RecordNotFound
			render template: 'errors/no_record'
	end

	def new	
		@admin = Admin.new if is_logged?
	end

	def create 
		@admin = Admin.new(admin_params)

		if session[:superuser] and @admin.save
			redirect_to admin_index_path
		else
			render 'new'
		end
	end

	def edit
		@admin = Admin.find(params[:id]) if is_logged? and is_user? params[:id].to_i
		rescue ActiveRecord::RecordNotFound
			render template: 'errors/no_record'
	end

	def update
		@admin = Admin.find(params[:id]) if is_user? params[:id].to_i
		if session[:admin] or session[:superuser] and @admin.update(admin_params)
		redirect_to @admin
		else
			render 'edit'
		end		
		rescue ActiveRecord::RecordNotFound
			render 'errors/no_record'	
	end

	def destroy
		@admin = Admin.find(params[:id]) if is_user? params[:id].to_i

		if session[:admin] or session[:superuser] and @admin.destroy
			redirect_to 'index'
		else
			render 'errors/fatal_error'
		end
		rescue ActiveRecord::RecordNotFound
			render 'errors/no_record'		
	end
	private
	def admin_params
		params.require(:admin).permit(:name, :email, :password)
	end

	def is_user?(id)
		if session[:superuser]
			return true;
		elsif session[:admin] and session[:admin].to_i == id
			return true;
		else
			return nil;
		end
	end

	def is_logged?
		if session[:admin] or session[:superuser]
			return true
		else
			render template: 'errors/no_aut'
		end
	end

	def render_no_aut
		@resource = 'Admin'
		render template: 'errors/no_aut'
	end
end
