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
      render json: { errors: report.errors.full_messages }, status: 400
    end
  end

  def destroy 
    report = Report.find(params[:id])
    report.destroy
    render json: { data: ["Record destroyed"]}, status: 200

    rescue ActiveRecord::RecordNotFound
      render json: { status: 404, errors: ["Couldn't find Report with 'id'=#{params[:id]}"] }, status: 404
  end

  def show
    render json: { data: [Report.find(params[:id])] }
  end

  private

    def report_params
      params.require(:report).permit(:subject, :text)
    end
end
