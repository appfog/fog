class CLC < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::CLC
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("CLC[:compute] is not recommended, use Compute[:clc] for portability")
          Fog::Compute.new(:provider => 'CLC')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::CLC.services
    end

  end
end
