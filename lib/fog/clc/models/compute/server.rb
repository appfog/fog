require 'fog/compute/models/server'

# TODO: Fix all of the docs

module Fog
  module Compute
    class CLC

      # A CLC Server
      #
      class Server < Fog::Compute::Server

        identity  :id
        attribute :hardware_group_id
        attribute  :name, aliases => 'alias'
        attribute :description
        attribute :dns_name
        attribute :cpu_count
        attribute :gb_memory
        attribute :disk_count
        attribute :total_disk_space_gb
        attribute :is_template
        attribute :is_hyperscale
        attribute :state, aliases => 'status'
        attribute :server_type
        attribute :service_level
        attribute :os_id
        attribute :power_state
        attribute :maintenance_mode_flag
        attribute :location
        attribute :primary_ip_address
        attribute :ip_addresses
        attribute :custom_fields
        attribute :template
        attribute :modified_by
        attribute :modified_date

        # Reboot the server (soft reboot).
        #
        # The preferred method of rebooting a server.
        def reboot
          requires :name
          service.reboot_server self.name
        end

        # Reboot the server (hard reboot).
        #
        # Powers the server off and then powers it on again.
        def power_cycle
          requires :name
          service.power_cycle_server self.name
        end

        # Shutdown the server
        #
        # Sends a shutdown signal to the operating system.
        # The server consumes resources while powered off
        # so you are still charged.
        #
        # @see https://www.clc.com/community/questions/am-i-charged-while-my-droplet-is-in-a-powered-off-state
        #def shutdown
          #requires :name
          #service.shutdown_server self.name
        #end

        # Power off the server
        #
        # Works as a power switch.
        # The server consumes resources while powered off
        # so you are still charged.
        #
        # @see https://www.clc.com/community/questions/am-i-charged-while-my-droplet-is-in-a-powered-off-state
        def stop
          requires :name
          service.power_off_server self.name
        end

        # Power on the server.
        #
        # The server consumes resources while powered on
        # so you will be charged.
        #
        # Each time a server is spun up, even if for a few seconds,
        # it is charged for an hour.
        #
        def start
          requires :name
          service.power_on_server self.name
        end

        def setup(credentials = {})
          # BJF Remove me later?
          # requires :ssh_ip_address
          #require 'net/ssh'

          #commands = [
            #%{mkdir .ssh},
            #%{passwd -l #{username}},
            #%{echo "#{Fog::JSON.encode(Fog::JSON.sanitize(attributes))}" >> ~/attributes.json}
          #]
          #if public_key
            #commands << %{echo "#{public_key}" >> ~/.ssh/authorized_keys}
          #end

          # wait for aws to be ready
          #wait_for { sshable?(credentials) }

          #Fog::SSH.new(ssh_ip_address, username, credentials).run(commands)
          true

        end

        # Creates the server (not to be called directly).
        #
        # Usually called by Fog::Collection#create
        #
        #   clc = Fog::Compute.new({
        #     :provider => 'CLC',
        #     :clc_api_key   => 'key-here',      # your API key here
        #     :clc_client_id => 'client-id-here' # your client key here
        #   })
        #   clc.servers.create :name => 'foobar',
        #                     :image_id  => image_id_here,
        #                     :cpu_count => cpu_count_here,
        #                     :gb_memory => gb_memeory_here,
        #                     :region_id => region_id_here
        #
        # @return [Boolean]
        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :name, :description, :hardware_group_id, :server_type, 
                   :service_level, :cpu_count, :gb_memory, :template

          options = {}
          # BJF: Remove me too?
          #if attributes[:ssh_key_ids]
            #options[:ssh_key_ids] = attributes[:ssh_key_ids]
          #elsif @ssh_keys
            #options[:ssh_key_ids] = @ssh_keys.map(&:id)
          #end

          #options[:private_networking] = !!attributes[:private_networking]

          data = service.create_server name,
                                       description,
                                       hardware_group_id,
                                       server_type,
                                       service_level,
                                       cpu_count,
                                       gb_memory,
                                       template,
                                       options
          # BJF: Do I have something comparable here?
          merge_attributes(data.body['droplet'])
          true
        end

        # Destroy the server, freeing up the resources.
        #
        # CLC will stop charging you for the resources
        # the server was using.
        #
        # Once the server has been destroyed, there's no way
        # to recover it so the data is irrecoverably lost.
        #
        # IMPORTANT: As of 2013/01/31, you should wait some time to
        # destroy the server after creating it. If you try to destroy
        # the server too fast, the destroy event may be lost and the
        # server will remain running and consuming resources, so
        # CLC will keep charging you.
        # Double checked this with CLC staff and confirmed
        # that it's the way it works right now.
        #
        # Double check the server has been destroyed!
        def destroy
          requires :name
          service.destroy_server name
        end

        # Checks whether the server status is 'active'.
        #
        # The server transitions from 'new' to 'active' sixty to ninety
        # seconds after creating it (time varies and may take more
        # than 90 secs).
        #
        # @return [Boolean]
        def ready?
          # BJF: Pretty sure this should be a constant
          state == 'Active'
        end

        # CLC API does not support updating server state
        def update
          msg = 'CLC servers do not support updates'
          raise NotImplementedError.new(msg)
        end

      end

    end
  end
end
