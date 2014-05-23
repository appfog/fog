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
                           options = {} )

          query_hash = {
            :name        => name,
            :description => description,
            :hardware_group_id => hardware_group_id,
            :server_type => server_type,
            :service_level => service_level,
            :cpu_count => cpu_count,
            :gb_memory => gb_memory,
            :template => template,
          }

          #if options[:ssh_key_ids]
            #options[:ssh_key_ids]    = options[:ssh_key_ids].join(",") if options[:ssh_key_ids].is_a? Array
            #query_hash[:ssh_key_ids] = options[:ssh_key_ids]
          #end

          #query_hash[:private_networking] = !!options[:private_networking]

          request(
            :expects  => [200],
            :method   => 'POST',
            :path     => 'REST/Server/CreateServer/json',
            :query    => query_hash
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
            "hardware_group_id"   => hardware_group_id,
            "name"                => name,
            "cpu_count"           => cpu_count,
            "gb_memory"           => gb_memory,
            "os_id"               => Fog::Mock.random_numbers(32).to_i,
            "server_type"         => server_type,
            "service_level"       => service_level,
            "ip_address"          => "127.0.0.1",
            "power_state"         => "Started",
            "is_template"         => false,
            "is_hyperscale"       => false,
            "disk_count"          => Fog::Mock.random_numbers(3).to_i,
            "total_disk_space_gb" => 1000,
            "state"               => 'Active',
            "cpu_count"           => 2,
            "gb_memory"           => 8,
            "modified_date"       => Time.now.strftime("%FT%TZ"),
            "modified_by"         => "MockMaster3000",
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
