# handles CRUD for Records
class RecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:destroy, :update]

  def index
    @records = Record.all
  end

  def create
    @record = current_user.records.build(record_params)

    if @record.save
      render json: @record
    else
      render json: @record.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @record.destroy
    head :no_content
  end

  def update
    if @record.update(record_params)
      render json: @record
    else
      render json: @record.errors, status: :unprocessable_entity
    end
  end

  private
    def set_record
      @record = Record.find(params[:id])
    end

    def record_params
      params.require(:record).permit(:title, :amount, :date, :user_id)
    end
end
