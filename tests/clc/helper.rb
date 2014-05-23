
# Shortcut for Fog::Compute[:clc]
def clc_service
  Fog::Compute[:clc]
end

def clc_set_test_server_attributes
  # Hard coding numbers because requests from tests are sometimes failing.
  # TODO: Mock properly instead
  {
    :cpu_count => 2,
    :gb_memory => 8,
    :description  => 'Mock Test Server',
    :hardware_group_id => 24601,
    :server_type => 1,
    :service_level => 2,
    :template => 'NOT-WINDOWS'
  }
end

def clc_server_name
  "clc-server-test2222"
end

# Create a long lived server for the tests
def clc_test_server
  server = clc_service.servers.find { |s| s.name == clc_server_name }
  unless server
    server = clc_service.servers.create({
      :name => clc_server_name
    }.merge(clc_set_test_server_attributes))
    server.wait_for { ready? }
  end
  server
end

# Destroy the long lived server
def clc_test_server_destroy
  server = clc_service.servers.find { |s| s.name == clc_server_name }
  server.destroy if server
end

at_exit do
  unless Fog.mocking? || Fog.credentials[:clc_api_key].nil?
    server = clc_service.servers.find { |s| s.name == clc_server_name }
    if server
      server.wait_for(120) do
        reload rescue nil; ready?
      end
    end
    clc_test_server_destroy
  end
end
