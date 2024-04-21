class Api::FeaturesController < ApplicationController
    def index
      features = Earthquake.all
  
      # Filtrar por tipo de magnitud (mag_type)
      if params[:mag_type].present?
        mag_types = params[:mag_type].split(',')
        features = features.where(mag_type: mag_types)
      end
  
      # Paginación
      per_page = params[:per_page].to_i.clamp(1, 1000) || 10
      page = params[:page].to_i.clamp(1, Float::INFINITY) || 1
      total_count = features.count
      features = features.offset((page - 1) * per_page).limit(per_page)
  
      # Construir el JSON de respuesta
      data = features.map do |feature|
        {
          id: feature.id,
          type: 'feature',
          attributes: {
            external_id: feature.external_id,
            magnitude: feature.magnitude,
            place: feature.place,
            time: feature.time,
            tsunami: feature.tsunami,
            mag_type: feature.mag_type,
            title: feature.title,
            coordinates: {
              longitude: feature.longitude,
              latitude: feature.latitude
            }
          },
          links: {
            external_url: feature.url
          }
        }
      end
  
      render json: {
        data: data,
        pagination: {
          current_page: page,
          total: total_count,
          per_page: per_page
        }
      }
    end

    def comments_count
      feature = Earthquake.find(params[:feature_id])
      comments_count = feature.comments.count
      render json: { comments_count: comments_count }
    end
  end
  