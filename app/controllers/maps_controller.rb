class MapsController < ApplicationController
  def index
    @addresses = Address.all.select(:id, :address, :lat, :lng).order(created_at: :desc)
    @latest_address = @addresses.first
  end
end
