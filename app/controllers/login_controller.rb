class LoginController < ApplicationController
  def create
    user = User.find_by(email: params[:email].downcase) || register
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
    end

    redirect_to home_index_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to home_index_path
  end

  private

  def user_params
    params.permit(:email, :password)
  end

  def register
    user = User.new(user_params)

    return user if user.save!
  end
end
