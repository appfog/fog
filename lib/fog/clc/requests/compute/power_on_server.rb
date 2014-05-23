module Fog
  module Compute
    class CLC
      class Real

        def power_on_server( name )
          # BJF: Build json here
          request(
            :expects  => [200],
            :method   => 'POST',
            :path     => "REST/Server/PowerOnServer/json"
          )
        end

      end

      class Mock

        def power_on_server( name )
          response = Excon::Response.new
          response.status = 200
          server = self.data[:servers].find { |s| s['name'] }
          server['power_state'] = 'Started' if server
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
