Shindo.tests('Fog::Compute[:clc] | servers collection', ['clc']) do
  service = Fog::Compute[:clc]

  options = {
    :Name => "#{clc_server_name}"
  }.merge clc_set_test_server_attributes

  public_key_path = File.join(File.dirname(__FILE__), '../../fixtures/id_rsa.pub')
  private_key_path = File.join(File.dirname(__FILE__), '../../fixtures/id_rsa')

  # Collection tests are consistently timing out on Travis wasting people's time and resources
  pending if Fog.mocking?

  collection_tests(service.servers, options, true) do
    @instance.wait_for { ready? }
  end

  # BJF: Not applicable?
  tests("#bootstrap with public/private_key_path").succeeds do
    pending if Fog.mocking?
    @server = service.servers.bootstrap({
      :public_key_path => public_key_path,
      :private_key_path => private_key_path
    }.merge(options))
    @server.destroy
  end

  # BJF: Not applicable?
  tests("#bootstrap with public/private_key").succeeds do
    pending if Fog.mocking?
    @server = service.servers.bootstrap({
      :public_key => File.read(public_key_path),
      :private_key => File.read(private_key_path)
    }.merge(options))
    @server.destroy
  end

  # BJF: Not applicable?
  tests("#bootstrap with no public/private keys") do
    raises(ArgumentError, 'raises ArgumentError') { service.servers.bootstrap(options) }
  end
end
