class MapsController < ApplicationController
  def index
    @addresses = Address.all.select(:id, :address, :lat, :lng)
  end
end
