class Feature < ApplicationRecord
    def self.filter_by_params(params)
      features = Feature.all
  
      # Filtrar por mag_type
      if params[:filters].present? && params[:filters][:mag_type].present?
        features = features.where(mag_type: params[:filters][:mag_type])
      end
  
      # Paginación
      page = params[:page].to_i || 1
      per_page = params[:per_page].to_i || 25
      features = features.page(page).per(per_page)
  
      features
    end
  end
  