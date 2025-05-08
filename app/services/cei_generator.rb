require "digest"

class CeiGenerator
  def initialize(params)
    @industry = params[:industry]
    @asset_type = params[:asset_type]
    @configuration = params[:configuration]
    @year = params[:year]
    @make = params[:make]
    @model = params[:model]
    @usage_type = params[:usage_type]
    @usage = params[:usage].to_i
    @appraisal_date = Date.parse(params[:appraisal_date])
  end

  def generate
    # 1. Generate the Equipment Category Code
    equipment_category_code = EquipmentCodeGenerator.new(
      industry: @industry,
      asset_type: @asset_type,
      configuration: @configuration,
    ).generate_code

    # 2. Generate Year, Make and Model segment
    ymm_segment = "#{@year.to_s[-2...]}#{@make.upcase[0..1]}#{@model.to_s.upcase[0..1]}"

    # 3. Generate Usage Segment
    usage_segment = "#{@usage_type}#{@usage / 1000}"

    # 4. Transform date to julian format
    julian = to_julian(@appraisal_date)

    # 5. Generate UID
    uid = generate_uid(equipment_category_code)

    # 6. Generate CEI
    cei = "#{equipment_category_code}-#{ymm_segment}-#{usage_segment}-#{julian}-#{uid}"

    # Calculate the buffered usage
    buffered_usage = (@usage * 1.10).to_i

    { cei:, buffered_usage:, original_usage: @usage }
  end

  private

  def to_julian(date)
    year = date.strftime("%y")
    day = date.yday.to_s.rjust(3, "0")
    "#{year}#{day}"
  end

  def generate_uid(equipment_category_code)
    data = "#{equipment_category_code}-#{@year}-#{@make}-#{@model}-#{@usage_type}-#{@usage}-#{@appraisal_date}"
    Digest::SHA256.hexdigest(data)[0..5].upcase
  end
end
