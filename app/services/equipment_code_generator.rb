class EquipmentCodeGenerator
  def initialize(params)
    @industry = params[:industry]
    @asset_type = params[:asset_type]
    @configuration = params[:configuration]
  end

  def generate_code
    "#{industry_code}-#{config_code}"
  end

  private
  def industry_code
   " #{@industry[0].upcase}#{asset_code}"
  end


  def asset_code
    @asset_type.split(",").map { |each| each.strip[0] }.join.upcase
  end

  def config_code
    #   Abbreviate the configurations to form the code
    # EG. Day, Cav, Quad, Axel Dump => "DCQA"
    @configuration.split(",").map { |part| part.strip[0] }.join.upcase
  end
end
