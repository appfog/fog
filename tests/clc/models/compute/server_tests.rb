Shindo.tests("Fog::Compute[:clc] | server model", ['clc', 'compute']) do

  server  = clc_test_server

  tests('The server model should') do

    tests('have the action') do
      %w{
        reboot
        power_cycle
        stop
        start
        reload
      }.each do |action|
        test(action) { server.respond_to? action }
      end
    end

    tests('have attributes') do
      # BJF - why do I need this?
      model_attribute_hash = server.attributes
      attributes = [
        :id,
        :hardware_group_id,
        :name,
        :description,
        :dns_name,
        :cpu_count,
        :gb_memory,
        :disk_count,
        :total_disk_space_gb,
        :is_template,
        :is_hyperscale,
        :state,
        :server_type,
        :service_level,
        :os_id,
        :power_state,
        :maintenance_mode_flag,
        :location,
        :primary_ip_address,
        :ip_addresses,
        :custom_fields,
        :modified_by,
        :modified_date,
      ]
      tests("The server model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { server.respond_to? attribute }
        end
      end
    end

    test('#reboot') do
      server.reboot
      server.wait_for { server.power_state == 'Started' }
      server.power_state == 'Started'
    end

    test('#power_cycle') do
      server.wait_for { server.ready? }
      server.power_cycle
      server.wait_for { server.power_state == 'Started' }
      server.power_state == 'Started'
    end

    test('#stop') do
      server.stop
      server.wait_for { server.power_state == 'Stopped' }
      server.power_state == 'Stopped'
    end

    test('#start') do
      server.start
      server.wait_for { ready? }
      server.ready?
    end

    test('#update') do
      begin
        server.update
      rescue NotImplementedError => e
        true
      end
    end
  end

  # restore server state
  server.start
  server.wait_for { ready? }

end

