module Fog
  module Compute
    class CLC

      # Yes, I know this is ugly.  There is no corresponding API function to
      # retrieve these data
      IMAGES = [
        { "id" => 32, "name" => "CENTOS-5-32-TEMPLATE" },
        { "id" => 33, "name" => "CENTOS-5-64-TEMPLATE" },
        { "id" => 34, "name" => "CENTOS-6-32-TEMPLATE" },
        { "id" => 35, "name" => "CENTOS-6-64-TEMPLATE" },
        { "id" => 36, "name" => "DEBIAN-6-64-TEMPLATE" },
        { "id" => 37, "name" => "DEBIAN-7-64-TEMPLATE" },
        { "id" => -1, "name" => "PXE-TEMPLATE" },
        { "id" => 25, "name" => "RHEL-5-64-TEMPLATE" },
        { "id" => 22, "name" => "RHEL-6-64-TEMPLATE" },
        { "id" => -1, "name" => "BOSH-STEMCELL" },
        { "id" => -1, "name" => "MICRO-BOSH-STEMCELL" },
        { "id" => 29, "name" => "UBUNTU-10-32-TEMPLATE" },
        { "id" => 30, "name" => "UBUNTU-10-64-TEMPLATE" },
        { "id" => -1, "name" => "UBUNTU-10-64-LAMP-TEMPLATE" },
        { "id" => 31, "name" => "UBUNTU-12-64-TEMPLATE" },
        { "id" => -1, "name" => "UBUNTU-10-64-WF-TEMPLATE" },
        { "id" => -1, "name" => "UBUNTU-10-64-WF-TEMPLATE-V2" },
        { "id" => 15, "name" => "WIN2K3R2ENT-32" },
        { "id" => 16, "name" => "WIN2K3R2ENT-64" },
        { "id" => 17, "name" => "WIN2K3R2STD-32" },
        { "id" => 18, "name" => "WIN2K3R2STD-64" },
        { "id" => -1, "name" => "WIN2008R2DTC-64" },
        { "id" => -1, "name" => "WIN2008R2ENT-64" },
        { "id" => -1, "name" => "WIN2008R2STD-64" },
        { "id" => 27, "name" => "WIN2012DTC-64" },
        { "id" => 28, "name" => "WIN2012R2DTC-64" },
      ]

      class Real

        def list_images(options = {})
          # Yes, this is a mock.  There is no api function to expose these, and I can't expect
          # users to pluck these ids out of URIs and other responses
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "status" => "OK",
            "images" => Fog::Compute::CLC::IMAGES
          }
          response
        end

      end

      class Mock

        def list_images
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "status" => "OK",
            "images" => Fog::Compute::CLC::IMAGES
          }
          response
        end

      end
    end
  end
end
