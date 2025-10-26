class Dashboard::ProfilesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if changing_password?
      if @user.update_with_password(user_params_with_password)
        redirect_to edit_dashboard_profile_path, notice: "Perfil atualizado com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      if @user.update(user_params_without_password)
        redirect_to edit_dashboard_profile_path, notice: "Perfil atualizado com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  private

  def changing_password?
    params[:user][:password].present?
  end

  def user_params_with_password
    params.require(:user).permit(:name, :email, :current_password, :password, :password_confirmation)
  end

  def user_params_without_password
    params.require(:user).permit(:name, :email)
  end
end
