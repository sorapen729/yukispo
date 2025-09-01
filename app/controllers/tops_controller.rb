class TopsController < ApplicationController
  def index
    @tags = defined?(Tag) ? Tag.order(:name).limit(12) : []
    @featured_resorts = defined?(SkiResort) ? SkiResort.order(created_at: :desc).limit(6) : []
  end
end
