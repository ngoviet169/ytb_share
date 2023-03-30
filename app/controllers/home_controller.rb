class HomeController < ApplicationController
  def index
    @videos = Video.eager_load(:user).all
  end
end
