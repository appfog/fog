
# Shortcut for Fog::Compute[:clc]
def clc_service
  Fog::Compute[:clc]
end

def clc_set_test_server_attributes
  # Hard coding numbers because requests from tests are sometimes failing.
  # TODO: Mock properly instead
  {
    :Cpu=> 2,
    :MemoryGB => 8,
    :Description  => 'Mock Test Server',
    :HardwareGroupID => 4677,
    :ServerType => 1,
    :ServiceLevel => 2,
    :Location => 'CA2',
    :Template => 'UBUNTU-12-64-TEMPLATE',
    :Network => 'vlan_674_10.56.74'
  }
end

def clc_server_name
  "123456"
end

# Create a long lived server for the tests
def clc_test_server
  puts "clc_test_server"
  server = clc_service.servers.find { |s| s.Name == clc_server_name }
  unless server
    server = clc_service.servers.create({
      :Name => clc_server_name
    }.merge(clc_set_test_server_attributes))
    server.wait_for { ready? }
  end
  server
end

# Destroy the long lived server
def clc_test_server_destroy
  server = clc_service.servers.find { |s| s.Name == clc_server_name }
  server.destroy if server
end

at_exit do
  unless Fog.mocking? || Fog.credentials[:clc_api_key].nil?
    server = clc_service.servers.find { |s| s.Name == clc_server_name }
    if server
      server.wait_for(120) do
        reload rescue nil; ready?
      end
    end
    clc_test_server_destroy
  end
end
