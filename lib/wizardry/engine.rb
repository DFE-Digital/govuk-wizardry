module Wizardry
  class Engine < ::Rails::Engine
    isolate_namespace Wizardry
  end
end

Dir[Wizardry::Engine.root.join(*%w(app helpers *.rb))].each { |f| require f }
