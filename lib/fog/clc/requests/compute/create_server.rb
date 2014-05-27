module Fog
  module Compute
    class CLC
      class Real

        #
        # FIXME: missing ssh keys support
        #
        def create_server( name,
                           description,
                           hardware_group_id,
                           server_type,
                           service_level,
                           cpu_count,
                           gb_memory,
                           template,
                           network,
                           options = {} )

          body = {
            :Alias        => name,
            :Description => description,
            :HardwareGroupID => hardware_group_id,
            :ServerType => server_type,
            :ServiceLevel => service_level,
            :Cpu => cpu_count,
            :MemoryGB => gb_memory,
            :Template => template,
            :Network => network,
          }

puts "DEBUG: " + body.inspect
          body.merge!(options)
puts "DEBUG(2): " + body.inspect

          #if options[:ssh_key_ids]
            #options[:ssh_key_ids]    = options[:ssh_key_ids].join(",") if options[:ssh_key_ids].is_a? Array
            #query_hash[:ssh_key_ids] = options[:ssh_key_ids]
          #end

          #query_hash[:private_networking] = !!options[:private_networking]

          request(
            :expects  => [200],
            :method   => 'POST',
            :path     => 'REST/Server/CreateServer/json',
            :body    => Fog::JSON.encode(body)
          )
        end

      end

      class Mock

        def create_server( name,
                           description,
                           hardware_group_id,
                           server_type,
                           service_level,
                           cpu_count,
                           gb_memory,
                           template,
                           options = {} )
          response = Excon::Response.new
          response.status = 200

          mock_data = {
            "id"                  => Fog::Mock.random_numbers(1).to_i,
            "HardwareGroupID"   => hardware_group_id,
            "Name"                => name,
            "Cpu"           => cpu_count,
            "MemoryGB"           => gb_memory,
            "OperatingSystem"               => Fog::Mock.random_numbers(32).to_i,
            "ServerType"         => server_type,
            "ServiceLevel"       => service_level,
            "IPAddress"          => "127.0.0.1",
            "PowerState"         => "Started",
            "IsTemplate"         => false,
            "IsHyperscale"       => false,
            "DiskCount"          => Fog::Mock.random_numbers(3).to_i,
            "TotalDiskSpaceGB" => 1000,
            "Status"               => 'Active',
            "ModifiedDate"       => Time.now.strftime("%FT%TZ"),
            "ModifiedBy"         => "MockMaster3000",
          }

          # BJF: Pretty sure we're not returning a droplet.  Need to figure this out.
          response.body = {
            "status"   => "OK",
            "droplet"  => mock_data
          }

          self.data[:servers] << mock_data
          response
        end

      end
    end
  end
end
