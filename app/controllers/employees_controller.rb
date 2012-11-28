class EmployeesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :authorize_pi!
  before_filter :resolve_employee!, :only => [:show, :edit, :update ]
  
  def index    
    @employees = current_user.employees   
  end
  
  def edit
    @employee.build_user_address unless @employee.user_address
  end
  
  def show
    @employee.build_user_address unless @employee.user_address  
    @cases = current_user.cases
  end
  
  def update       
    
    data = params[:user] || {}
    address = data[:user_address_attributes] || {}
    
    @employee.first_name = data[:first_name]
    @employee.last_name = data[:last_name]
    @employee.user_address || @employee.build_user_address
    
    @employee.user_address.phone = address[:phone]
         
    if @employee.save      
      redirect_to employee_path(@employee), :notice => 'Employee info has been updated'
    else
      flash[:alert] = 'Employee info could not be updated'
      render 'edit'
    end
  end
  
  private
  
  def resolve_employee!
    @employee = current_user.employees.find_by_id(params[:id])
    redirect_to employees_path unless @employee
  end
  
end
