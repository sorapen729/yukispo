class OriginAddressInputsController < ApplicationController
  def new
  end

  def create
    @address = Address.new(address_params)
    if @address.save
      redirect_to root_path, success: "出発地が設定されました"
    else
      flash.now[:danger] = "住所を入力してください"
      render :new, status: :unprocessable_entity
    end
  end
end
