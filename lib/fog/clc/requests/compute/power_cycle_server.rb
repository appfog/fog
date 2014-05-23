module Fog
  module Compute
    class CLC
      class Real

        def power_cycle_server( name )
            self.power_off_server name
            self.power_on_server name
        end

      end

      class Mock

        def power_cycle_server( name )
            self.power_off_server name
            self.power_on_server name
        end

      end
    end
  end
end
