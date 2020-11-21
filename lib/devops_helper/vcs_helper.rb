
require 'gvcs'
require 'git_cli'

module DevopsHelper
  module GvcsHelper

    def has_pending_changes?
      ws = Gvcs::Workspace.new(vcs,@root)
      
      mst, mf = ws.modified_files
      dst, df = ws.deleted_files

      mf.length > 0 or df.length > 0
    end

    def has_new_changes?
      ws = Gvcs::Workspace.new(vcs,@root)
      
      nst, nf = ws.new_files

      nf.length > 0 
    end

    def is_workspace?
      Gvcs::Workspace.new(vcs,@root).is_workspace?
    end

    def method_missing(mtd, *args, &block)
      ws = Gvcs::Workspace.new(vcs,@root)
      if ws.respond_to?(mtd)
        ws.send(mtd,*args,&block)
      else
        super
      end 
    end

    private
    def vcs
      if is_empty?(@vcs)
        @vcs = Gvcs::Vcs.new
      end
      @vcs
    end

  end
end
