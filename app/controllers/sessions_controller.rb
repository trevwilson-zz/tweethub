class SessionsController < ApplicationController

	def new
	end

	def create
		email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
		if email_regex.match(params[:session][:email_or_username].downcase)
			user = User.find_by_email(params[:session][:email_or_username].downcase)
		else
			user = User.find_by_username(params[:session][:email_or_username].downcase)
		end
		if user && user.authenticate(params[:session][:password])
			sign_in user
			redirect_back_or user
		else
			flash.now[:error] = 'Invalid email/password combination'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end

end
