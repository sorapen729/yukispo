class OriginAddressInputController < ApplicationController
  def new
  end

  def create
    if params[:origin_address][:address].present?
      session[:origin_address] = {
        address: params[:origin_address][:address],
        lat: params[:origin_address][:lat],
        lng: params[:origin_address][:lng]
      }
      redirect_to root_path, notice: '出発地が設定されました'
    else
      redirect_to origin_address_input_path, alert: '住所を入力してください'
    end
  end
end
