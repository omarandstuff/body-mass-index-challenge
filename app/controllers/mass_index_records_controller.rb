class MassIndexRecordsController < ApplicationController
  before_action :authenticate_request

  def index
    render json: @current_user.records
  end

  def create
    record = MassIndexRecord.new record_params
    record.user = @current_user

    if record.save
      render json: record
    else
      render josn: record.errors, status: :bad_request
    end
  end

  def destroy
    record = MassIndexRecord.find_by_id params[:id]

    if record.user == @current_user && record.destroy
      render json: ''
    else
      render josn: "Can't delete", status: :bad_request
    end
  end

  private

    def record_params
      params.require(:record).permit(:body_mass_index)
    end
end
