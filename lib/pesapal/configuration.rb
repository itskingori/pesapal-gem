module Pesapal

  # Returns our config hash, or if empty, returns an empty hash
  def config
    @@config ||= {}
  end

  # Sets our config class variable, which we expect to be a hash
  def config=(hash)
    @@config = hash
  end

  # Allows us to use instance methods on a Module e.g. Pesapal.config
  module_function :config, :config=
end
