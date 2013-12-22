class TestsController < ApplicationController
  before_filter :authenticate_user!, :ensure_admin
  before_action :set_test, only: [:show, :edit, :update, :destroy]
  before_action :set_customer

  def index
    # filter by user or by order... at least for now
    filter = params[:order_id] ? {order_id: params[:order_id]} : {user: @customer}
    @tests = Test.where(filter)
  end

  def show
  end

  def edit
  end

  def update
  
    puts "params are " << test_params.inspect

    respond_to do |format|
      if @test.update(test_params)
        format.html { redirect_to user_test_path(@customer, @test), notice: 'Test was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  #FIXME not sure if we'll ever destroy a test...  Perhaps super admin chicken can do it?
  def destroy 
    if @test.destroy
      redirect_to user_tests, notice: 'Test was successfully destroyed.'
    else
      redirect_to user_tests, alert: 'Test was not successfully destroyed.'
    end
  end

  private
    def set_test
      @test = Test.find(params[:id])
    end
    
    def set_customer
      @customer = User.find(params[:user_id].to_i)
      session[:customer_id] = @customer.id
    end

    def test_params
      params.require(:test).permit(:status, :strain, :notes, :qr_code_number, :sample_type, :cdb, :cbn, :thc, :thcv, :cbg, :cbc, :thca, :plate)
    end

end