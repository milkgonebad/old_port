class QrController < ApplicationController
  
  before_filter :authenticate_user!, :ensure_admin
  
  #TODO add validation on the code to make sure we're not being hacked
  
  def index
    # look up the code
    @test = Test.find_by qr_code_number: params[:id]
    if @test.nil?
      # ok check our collection of IDs
      @qr = Qr.available.find_by qr_code_number: params[:id]
      if @qr.nil?
        flash[:error] = "This QR code is not in our system.  I can't let you proceed."
        redirect_to '/dashboard'
      end
      
      # ok valid new qr code - do we have a customer
      if session[:customer_id].nil?
        # TODO:  we should give a way to look up customers but for now tough luck
        flash[:error] = "Please select a customer to work with and scan this QR code again."
        redirect_to users_path
      end
      
      # does this customer have any unassociated tests?
      @customer = User.find(session[:customer_id])
      
      tests = @customer.tests.no_qr_code
      if tests.empty?
        # GOD YOU'RE DOING IT WRONG
        flash[:error] = "This customer doesn't have any tests available.  Please create an order then rescan this code."
        redirect_to user_orders_path(@customer)
      end
      
      # ok, we have a customer, a good qr code, and available tests
      # push all of this good stuff to the tests controller and it can do the rest
      flash[:notice] = "Associating this QR code with a new test!"
      
      # DEBUG this will probably fail:
      redirect_to edit_user_test_path(@customer, tests.first, qr_code_number: params[:id])
      
    else
      # in this case we don't need the customer number which is ok!  Go right to the test since we will start testing!
      # TODO does this set the receive status? or in progress?  I think we need some shiny buttons on the show page
      redirect_to user_test_path(@test.user_id, @test)
    end
    
    
    # if not found - check if it's one of our's
    
    # if not error and bork out
    
    # if it is, ask if want to create a new test?
    
    # look for customer, if not found redirect to customers index page - find one first - scan again
    
    # have customer and a new code - find first empty test and populate!
    
    
    
  end
  
  private
  
  def qr_params
    params.require(:id)
  end
  
end