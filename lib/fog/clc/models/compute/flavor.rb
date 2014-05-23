require 'fog/core/model'

module Fog
  module Compute
    class CLC
      class Flavor < Fog::Model

        identity  :id
        attribute :name

      end
    end
  end
end
