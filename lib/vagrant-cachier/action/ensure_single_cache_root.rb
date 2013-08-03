module VagrantPlugins
  module Cachier
    class Action
      class EnsureSingleCacheRoot
        def initialize(app, env)
          @app = app
        end

        def call(env)
          raise 'Do our work'
          @app.call(env)
        end
      end
    end
  end
end
