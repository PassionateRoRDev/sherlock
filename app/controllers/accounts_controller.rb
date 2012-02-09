class AccountsController < ApplicationController

  before_filter :authenticate_user!

  def show
    @account = current_user
  end

  def update
    @account = current_user

    if( @account.update_attributes( params[:user] ))
      notice = "Information Updated"
      redirect_to root_path
    else
      render :action => 'show'
    end
  end
end

