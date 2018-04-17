class PhotoController < ApplicationController
  def index
    @current_user = User.find(params[:id])
    @title = "#{@current_user.first_name} #{@current_user.last_name}'s page"
  end
end
