
require_relative "global"

require 'yaml'

module DevopsHelper

  class VersionStore

    VERSTORE_NAME = ".version_history.yml"
    attr_accessor :history

    def initialize(history = { }, opts = { })
      @history = history
      @root = opts[:root]
      @logger = opts[:logger] || Global.instance.logger
    end

    def register_version(gname, version)
      raise DevopsHelper::Error, "Gem name cannot be empty" if is_empty?(gname)
      raise DevopsHelper::Error, "Version cannot be empty" if is_empty?(version)

      # todo validate version is in form 'x.y.z' and not 'vx.y.z' or 'version x.y.z'
      nm = gname.strip
      @history[nm] = [] if not @history.keys.include?(nm)
      verInfo = { }
      verInfo[:version] = version
      verInfo[:created_at] = Time.now
      @history[nm] << verInfo
      @history[nm]
    end # register_version

    def last_version(gname)
      if not_empty?(gname)
        rec = @history[gname.strip]
        rec.last if not_empty?(rec) 
      else
        raise DevopsHelper::Error, "Gem name is empty"
      end
    end # last_version


    def save(root = @root)
      File.open(File.join(root,VERSTORE_NAME),"w") do |f|
        f.write YAML.dump(@history)
      end   
    end

    def self.load(root)
      path = File.join(root,VERSTORE_NAME)
      if File.exist?(path)
        hist = YAML.load(File.read(path))
        VersionStore.new(hist, { root: root })
      else
        VersionStore.new
      end
    end # load

  end # class VersionStore

end
