class UsersController < Clearance::UsersController
    before_action :require_login, except: [:new, :create]
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :require_authorization, :only => [:edit, :update, :destroy]

    def index
        @users = User.all
    end

    def show
    end

    def edit
    end

    def update
        respond_to do |format|
            if @user.update(user_params)
                format.html { redirect_to @user, notice: 'User was successfully updated.' }
                format.json { render :show, status: :ok, location: @user }
            else
                format.html { render :edit }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @user.destroy
        respond_to do |format|
            format.html { redirect_to sign_in_path, notice: 'Your account was successfully deleted.' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
        @user = User.find(params[:id])
    end

    def user_params
        params[:user].permit(:email, :password, :first_name, :last_name)
    end

    def require_authorization
      redirect_to user_path unless current_user.can_edit?(@user)
    end

end
