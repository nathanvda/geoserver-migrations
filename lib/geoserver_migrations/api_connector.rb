module GeoserverMigrations
  class APIConnector

    def initialize
      # initialise geoserver-client
      GeoserverClient.api_root = ::GEOSERVER_MIGRATIONS_CONFIG[:geoserver_base]
      GeoserverClient.api_user = ::GEOSERVER_MIGRATIONS_CONFIG[:api][:user]
      GeoserverClient.api_password = ::GEOSERVER_MIGRATIONS_CONFIG[:api][:password]

      GeoserverClient.workspace    = GEOSERVER_MIGRATIONS_CONFIG[:workspace]
      GeoserverClient.datastore    = GEOSERVER_MIGRATIONS_CONFIG[:datastore]
    end

    def execute(layer_configs, direction = :up, options={})
      layer_configs.each do |layer_name, layer_config|
        #layer_options = layer_config.options
        #
        if direction == :up
          # explicitly create style if sld given
          if !layer_config.sld.nil?
            puts " -- Create style #{layer_config.style_name}"

            GeoserverClient.create_style layer_config.style_name, sld: layer_config.sld
          end

          puts " -- Create layer #{layer_config.layer_name} [native_name = #{layer_config.feature_name}]"
          GeoserverClient.create_featuretype layer_name, native_name: layer_config.feature_name
          GeoserverClient.set_layer_style layer_name, layer_config.style_name
        else
          if !layer_config.sld.nil?
            puts " -- delete style #{layer_config.style_name}"

            GeoserverClient.delete_style layer_config.style_name
          end

          puts " -- delete layer #{layer_config.layer_name}"
          GeoserverClient.delete_featuretype layer_name
        end
      end
    end

    def test
      layers = GeoserverClient.layers
      layers["featureTypes"]["featureType"].map{|l| l["name"]}
    end

  end
end