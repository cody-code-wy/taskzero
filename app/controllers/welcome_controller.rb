class WelcomeController < ApplicationController
  skip_after_action :verify_authorized

  def index #Get /
  end
end
