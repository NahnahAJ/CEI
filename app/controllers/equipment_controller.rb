class EquipmentController < ApplicationController
  def create
    generator = CeiGenerator.new(equipment_params)
    result = generator.generate

    equipment = Equipment.create!(
      year: equipment_params[:year],
      make: equipment_params[:make],
      model: equipment_params[:model],
      usage_type: equipment_params[:usage_type],
      usage: equipment_params[:usage],
      appraisal_date: equipment_params[:appraisal_date],
      cei: result[:cei],
      usage_buffered: result[:buffered_usage],
      uid: result[:uid]
    )

    render json: { cei: equipment.cei }, status: :created
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def equipment_params
    params.require(:equipment).permit(:industry, :asset_type, :configuration, :year, :make, :model, :usage_type, :usage, :appraisal_date)
  end
end
