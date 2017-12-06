class ReportController < ApplicationController
  before_action :authenticate_user!
  
  def index 
    render json: { data: Report.all }
  end

  def create
    report = current_user.reports.create(report_params)
    if report.save
      render json: { data: [report] }
    else
      render_errors_422(report.errors.full_messages)
    end
  end

  def destroy 
    report = Report.find(params[:id])
    report.destroy
    render json: { data: [{ status: "Record destroyed" }] }, status: 200

  rescue ActiveRecord::RecordNotFound
    not_find_by_id("Report", params[:id])
  end

  def show
    render json: { data: [Report.find(params[:id])] }
  rescue ActiveRecord::RecordNotFound
    not_find_by_id("Report", params[:id])
  end

  private

    def report_params
      params.require(:report).permit(:subject, :text)
    end
end
