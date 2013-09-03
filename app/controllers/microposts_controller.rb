class MicropostsController < ApplicationController

	before_filter :signed_in_user, only: [:create, :destroy]
	before_filter :correct_user, only: :destroy

	def create
		@micropost = current_user.microposts.build(params[:micropost])
		@micropost.in_reply_to = find_mention(@micropost)
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		redirect_to root_url
	end

	private

		def correct_user
			@micropost = current_user.microposts.find_by_id(params[:id])
			redirect_to root_url if @micropost.nil?
		end

		def find_mention(micropost)
			micropost_as_array = micropost.content.split(" ")
			if(micropost_as_array[0][0] == '@')
				return micropost_as_array[0][1..-1]
			else
				return ""
			end
		end
end