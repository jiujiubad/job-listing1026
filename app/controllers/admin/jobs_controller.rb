class Admin::JobsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_job_and_check_permission, only: [:update, :edit, :destroy]
  before_action :require_is_admin
  layout "admin"

  def index
    @jobs = Job.all
  end

  def show
    @job = Job.find(params[:id])
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to admin_jobs_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @job.update(job_params)
      redirect_to admin_jobs_path, notice: "Update Success!"
    else
      render :edit
    end
  end

  def destroy
    @job.destroy
    redirect_to admin_jobs_path, alert: "Job Deleted!"
  end

  def publish
    @job = Job.find(params[:id])
    @job.publish!
    redirect_to :back
  end

  def hide
    @job = Job.find(params[:id])
    @job.hide!
    redirect_to :back
  end

  private

  def find_job_and_check_permission
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:title, :description, :wage_upper_bound, :wage_lower_bound, :contact_email, :is_hidden)
  end
end
