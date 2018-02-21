# Fake messages, services and hadndlers for tests.

require 'google/protobuf'
require_relative '../lib/twirp'

# Protobuf messages.
# An example of the result of the protoc ruby code generator.
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "example.Size" do
    optional :inches, :int32, 1
  end
  add_message "example.Hat" do
    optional :inches, :int32, 1
    optional :color, :string, 2
  end
  add_message "example.Empty" do
  end
end

module Example
  Size = Google::Protobuf::DescriptorPool.generated_pool.lookup("example.Size").msgclass
  Hat = Google::Protobuf::DescriptorPool.generated_pool.lookup("example.Hat").msgclass
  Empty = Google::Protobuf::DescriptorPool.generated_pool.lookup("example.Empty").msgclass
end

# Twirp Service.
# An example of the result of the protoc twirp_ruby plugin code generator.
module Example
  class Haberdasher < Twirp::Service
    package "example"
    service "Haberdasher"

    rpc "MakeHat", Size, Hat, handler_method: :make_hat
  end
end

# Example service handler.
# This would be provided by the developer as implementation for the service.
class HaberdasherHandler
  def make_hat(size)
    if size.inches < 0
      return Twirp::Error.new(:invalid_argument, "I can't make a hat that small!", argument: "inches")
    end
    {
      inches: size.inches,
      color: "white",
    }
  end
end

# Twirp Service with no package and no rpc methods.
class EmptyService < Twirp::Service
end