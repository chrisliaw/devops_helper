

# include task like 'rake build'
require 'bundler/gem_tasks'
# another way to build the gem
#require 'rubygems/commands/build_command'

module DevopsHelper
  module GemRakeHelper

    def build_gem
      t = find_build_task        
      raise DevopsHelper::Error, "Cannot find the build task. Please ensure the GEM is configured properly" if is_empty?(t)
      execute_build_task(t)
    end

    private
    def find_build_task
      task = nil
      Rake::Task.tasks.each do |t|
        if t.name == "build"
          task = t
          break
        end
      end
      task
    end

    def execute_build_task(task)
      task.execute if not_empty?(task) and task.is_a?(Rake::Task)
    end

  end
end
