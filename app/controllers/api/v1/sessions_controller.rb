class Api::V1::SessionsController < Devise::SessionsController
  before_action :sign_in_params, only: :create
  before_action :load_user, only: :create
  before_action :valid_token, only: :destroy
  skip_before_action :verify_signed_out_user, only: :destroy

  #sign in
  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in "user", @user
      render json: {
  	  	messages: "Signed in successfully",
  	  	is_success: true,
  	  	data: @user
  	  }, status: :ok
  	else
  	  render json: {
  	  	messages: "Sign in error",
  	  	is_success: false,
  	  	data: {}
  	  }, status: :unauthorized	
    end
  end

  #sign out
  def destroy
  	sign_out @user
  	@user.generate_new_authentication_token
  	render json: {
  	  	messages: "Signed out successfully",
  	  	is_success: true,
  	  	data: {}
  	  }, status: :ok
  end

  private
  def sign_in_params
  	params.permit(:email, :password)
  end

  def load_user
  	@user = User.find_for_database_authentication(email: sign_in_params[:email])
  	if @user
  	  return @user
  	else
  	  render json: {
  	  	messages: "Can not get user",
  	  	is_success: false,
  	  	data: {}
  	  }, status: :unauthorized
  	end
  end

  def valid_token
  	@user = User.find_by authentication_token: request.headers["AUTH-TOKEN"]

  	if @user
  	  return @user
  	else
  	  render json: {
  	  	messages: "Invalid token",
  	  	is_success: false,
  	  	data: {}
  	  }, status: :forbidden
  	end
  end
end