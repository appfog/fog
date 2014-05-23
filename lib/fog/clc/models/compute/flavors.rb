require 'fog/core/collection'
require 'fog/clc/models/compute/flavor'

module Fog
  module Compute
    class CLC

      class Flavors < Fog::Collection
        model Fog::Compute::CLC::Flavor

        def all
          load service.list_flavors.body['sizes']
        end

        def get(id)
          all.find { |f| f.id == id }
        rescue Fog::Errors::NotFound
          nil
        end

      end

    end
  end
end
