require "devops_helper/version"

require "devops_helper/gem_core_helper"
require "devops_helper/gem_version_helper"
require "devops_helper/gem_rake_helper"
require "devops_helper/vcs_helper"

module DevopsHelper
  class Error < StandardError; end
  # Your code goes here...

  class GemReleaseHelper
    include GemCoreHelper
    include GemVersionHelper
    include GemRakeHelper
  end

  class VcsHelper
    include GvcsHelper
    
    def initialize(root, opts = { })
      @logger = opts[:logger] || Global.instance.logger
      @root = root
    end
  end

end

spec = Gem::Specification.find_by_name "devops_helper"
rf = "#{spec.gem_dir}/lib/Rakefile"
load rf


