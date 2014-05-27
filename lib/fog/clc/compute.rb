require 'fog/clc/core'

module Fog
  module Compute
    class CLC < Fog::Service

      requires     :clc_api_key
      requires     :clc_password

      recognizes   :clc_api_url

      model_path   'fog/clc/models/compute'
      model        :server
      collection   :servers
      model        :image
      collection   :images

      request_path 'fog/clc/requests/compute'
      request      :list_servers
      request      :list_images
      request      :get_server_details
      request      :create_server
      request      :destroy_server
      request      :reboot_server
      request      :power_cycle_server
      request      :power_off_server
      request      :power_on_server

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :servers => []
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @clc_api_key = options[:clc_api_key]
        end

        def data
          self.class.data[@clc_api_key]
        end

        def reset_data
          self.class.data.delete(@clc_api_key)
        end

      end

      class Real

        def initialize(options={})
          @clc_cookie    = nil
          @clc_api_key   = options[:clc_api_key]
          @clc_password  = options[:clc_password]
          @clc_api_url   = options[:clc_api_url] || "https://api.tier3.com"
          @connection_options = options[:connection_options] || {:read_timeout => 360}
          @persistent = options[:persistent]  || false
          @connection    = Fog::XML::Connection.new(@clc_api_url, @persistent, @connection_options)
          login
        end

        def login
          # Let's give a login a shot
          body = {
            'APIKey' => @clc_api_key,
            'Password' => @clc_password
          }
          resp = request(
            :expects  => [200],
            :method   => 'POST',
            :path     => 'REST/Auth/Logon',
            :body     => Fog::JSON.encode(body)
          )
          @clc_cookie = resp.headers["set-cookie"]
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:headers] ||= {}
          params[:headers].merge!("Content-Type" => "application/json")
          params[:headers].merge!("Cookie" => @clc_cookie)

          response = retry_event_lock { parse @connection.request(params) }

          unless response.body.empty?
            if response.body['Success'] != true
              case response.body['Message']
              # TODO: Look for login unsuccessful, etc.
              when /No Droplets Found/
                raise Fog::Errors::NotFound.new
              else
                raise Fog::Errors::Error.new response.body.to_s
              end
            end
          end
          response
        end

        private

        def parse(response)
          return response if response.body.empty?
          response.body = Fog::JSON.decode(response.body)
          response
        end

        def retry_event_lock
          count   = 0
          response = nil
          while count < 5
            response = yield

            if response.body && response.body['error_message'] =~ /There is already a pending event for the droplet/
              count += 1
              sleep count ** 3
            else
              break
            end
          end

          response
        end

      end
    end
  end
end
