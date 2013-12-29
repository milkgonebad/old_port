class QrCodesController < ApplicationController

  def index
  end

  def import
    num_created, num_exists = Qr.import(params[:file])
    flash[:notice] = "Results of QR Code Import:  " + num_created.to_s + " created, " + num_exists.to_s + " already existed."
    render 'index'
  end

  private

  def qr_code_params
    params[:qr_code].permit(:file)
  end
  
end
