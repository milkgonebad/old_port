class AdministratorsController < ApplicationController
  before_action :set_administrator, only: [:show, :edit, :update, :destroy]

  def index
    @administrators = params[:all] ? User.all_administrators : User.administrators
  end

  def show
  end

  def new
    @administrator = User.new(:role => User::ROLES[:administrator], :active => true)
  end

  def edit
  end

  def create
    @administrator = Administrator.new(administrator_params)

    if @administrator.save
      redirect_to @administrator, notice: 'Administrator was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @administrator.update(administrator_params)
      redirect_to @administrator, notice: 'Administrator was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @administrator.active = false
    if @administrator.save
      redirect_to administrators_url, notice: 'Administrator was successfully deactivated.'
    else
      redirect_to administrators_url, alert: 'Administrator was no successfully deactivated.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_administrator
      @administrator = Administrator.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def administrator_params
      params.require(:administrator).permit(:first_name, :last_name, :role, :email, :password, :password_confirmation, :active)
    end
end
