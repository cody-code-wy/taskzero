class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def show
  end

  # GET /user/new
  def new
    @user = User.new
  end

  # GET /user/edit
  def edit
  end

  # POST /user
  # POST /user.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to '/', notice: 'Thank you for signing up for Task Zero!' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user
  # PATCH/PUT /user.json
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

  # DELETE /user
  # DELETE /user.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to '/', notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      parameters = params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      if parameters[:password]== '' and parameters[:password_confirmation] == ''
        parameters.delete(:password)
        parameters.delete(:password_confirmation)
      end
      return parameters
    end
end
