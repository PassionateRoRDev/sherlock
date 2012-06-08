class DashboardController < ApplicationController

  before_filter :authenticate_admin!
  
end
