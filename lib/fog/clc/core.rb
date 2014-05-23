require 'fog/core'
require 'fog/json'

module Fog
  module CLC
    extend Fog::Provider
    service(:compute, 'Compute')
  end
end

