module Fog
  module Compute
    class CLC
      class Real

        def power_off_server( name )
          # BJF - need to build body here
          # {
          #   "Name": "<name>"
          # }
          request(
            :expects  => [200],
            :method   => 'POST',
            :path     => "REST/Server/PowerOffServer/json"
          )
        end

      end

      class Mock

        def power_off_server( name )
          response = Excon::Response.new
          response.status = 200
          server = self.data[:servers].find { |s| s['Name'] == name }
          server['PowerState'] = 'Stopped' if server
          response.body = {
            "RequestID" => Fog::Mock.random_numbers(1).to_i,
            "StatusCode" => 0,
            "Message" => "Success",
            "Success" => true,
          }
          response
        end

      end
    end
  end
end
