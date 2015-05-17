class SessionsController < ApplicationController
	def login
	
	end
	def loging
		if user_param == 'admin'
			login_admins login_params
		elsif user_param == 'superuser'
			login_superuser login_params
		end
	end

	def logout
		if session[:admin] or session[:superuser]
			session[:admin] = nil
			session[:superuser] = nil
			render 'logout'
		else
			redirect_to root_path
		end
	end
	private
	def on_session?
		if session[:admin] or [:superuser]
			return false
		else
			return true
		end
	end
	def login_admins(params)
		if @admin = Admin.login(params) 
			session[:admin] = @admin.id
			redirect_to @admin
		else
			flash[:notice] = 'Nombre de usuario o contraseña incorrecta'
			redirect_to '/login'
		end
	end
	def login_superuser(params)
		if @superuser = Superuser.login(params) 
			session[:superuser] = @superuser.id
			redirect_to @superuser
		else
			flash[:notice] = 'Nombre de usuario o contraseña incorrecta'
			redirect_to '/login'
		end
	end
	def user_param
		user = params.require(:login).permit(:user)
		user = user[:user]
		return user
	end
	def  login_params
		params.require(:login).permit(:email, :password)
	end	
end
