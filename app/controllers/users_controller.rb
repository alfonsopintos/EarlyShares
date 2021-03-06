class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create 
    @user = User.new user_params

    if @user.save
      session[:user_id] = @user.id
      redirect_to projects_path, notice: "User Created"
    else
      render action: 'new'
    end
  end


  private
  def user_params
    params.
    require(:user).permit(:name, :password, :password_confirmation, :email, :phone_number, :auth_token)
  end
  
end
