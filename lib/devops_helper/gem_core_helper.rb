
require 'toolrack'
require 'tty-prompt'

require_relative 'version_store'

module DevopsHelper
  module GemCoreHelper
    include Antrapol::ToolRack::ConditionUtils

    def find_gemspec(root)
       if is_empty?(root)
         raise DevopsHelper::Error, "Root path '#{root}' to find_gemspec is empty"
       else
         Dir.glob(File.join(root,"*.gemspec")).first
       end
    end

  end
end
