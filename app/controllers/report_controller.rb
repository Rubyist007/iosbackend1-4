class ReportController < ApplicationController
  before_action :authenticate_user!
  
  def index 
    render json: { data: Report.all }
  end

  def create
    report = current_user.reports.create(report_params)
    if report.save
      render json: { data: report }
    else
      render json: { errors: report.errors.full_messages }
    end
  end

  def show
    render json: { data: Report.find(params[:id]) }
  end

  private

    def report_params
      params.require(:report).permit(:subject, :text)
    end
end
