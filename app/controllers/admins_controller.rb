class AdminsController < ApplicationController

  def new
  end

  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      sign_in @admin
      flash[:success] = "Time to fire coworkers!"
      redirect_to load_users_path
    else
      render 'new'
    end
  end

  def destroy
  end

  def load_users
  end

  def process_users
    uploaded_io = params[:upload][:fname]
    current_admin.process(uploaded_io)
  end

  def start
    current_admin.send_emails
    redirect_to results_path
  end
    
end
