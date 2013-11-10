class UsersController < ApplicationController
  before_filter :authenticate_user!, :ensure_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.customers
  end

  def show
  end

  def new
    @user = User.new(:active => true, :country => 'United States')
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    
    # generate a password here or invite the user?
    
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new', alert:  @user.errors.inspect }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :address1, :address2, :city, :state, :country, :role)
    end
  
    def ensure_admin
      unless current_user.admin?
        flash[:error] = 'You are not authorized to edit users.'
        redirect_to root_path
      end 
    end

end
