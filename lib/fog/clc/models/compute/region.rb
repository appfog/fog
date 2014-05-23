require 'fog/core/model'

module Fog
  module Compute
    class CLC
      class Region < Fog::Model

        identity  :id
        attribute :name

      end
    end
  end
end
