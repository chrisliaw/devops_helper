
require 'toolrack'
include Antrapol::ToolRack::ConditionUtils

require 'devops_helper'

# include task like 'rake build'
require 'bundler/gem_tasks'
# another way to build the gem
#require 'rubygems/commands/build_command'

require 'fileutils'

desc "Some simple rake tasks to assist gem developer in releasing new version of gem"

namespace :devops do

  task :gem_release do
    
    STDOUT.puts "Managed gem release V#{DevopsHelper::VERSION}" 

    wd = Dir.getwd
    tp = TTY::Prompt.new

    vh = DevopsHelper::VcsHelper.new(wd)
    if vh.is_workspace?

      begin
        if vh.has_pending_changes? or vh.has_new_changes?
          cc = tp.yes?("There are pending changes not yet commit. Commit first? ")
          if cc
            STDOUT.puts "Commit the changes first before release"
            exit(0)
          end
        end
      rescue TTY::Reader::InputInterrupt
        STDOUT.puts "\n\nAborted"
        exit(1)
      end

    end # is_workspace?

    rh = DevopsHelper::GemReleaseHelper.new
    spec = rh.find_gemspec(wd) 

    vf = rh.find_gem_version_file(wd) 
    if vf.length > 1
      # more then one. User has to select
      svf = vf.first
    else
      svf = vf.first 
    end

    if not_empty?(spec) #and not_empty?(svf)
      
      vs = rh.get_version_record(wd) 
      gs = Gem::Specification.load(spec)
      lstVer = vs.last_version(gs.name)
      if not is_empty?(lstVer)
        targetVersion = rh.prompt_version(gs.name, lstVer[:version], lstVer[:created_at])
      else
        targetVersion = rh.prompt_version(gs.name, "", nil)
      end 

      if targetVersion == -1
        STDERR.puts "Aborted"
        exit(1)
      end

      if not_empty?(svf)
        rh.rewrite_gem_version_file(svf,targetVersion) 
        STDOUT.puts "Gem version file rewritten"

        if vh.is_workspace?
          # commit changes
          vh.add(svf)
          vh.commit("Automated commit by DevOps Helper during release process", { files: [svf] })
        end

      end

      if vh.is_workspace?
        begin
          tagSrc = tp.yes?("Tag the source code for this release? ")
          if tagSrc
            msg = tp.ask("Please provide message for this tag (optional) : ", default: "Tagged version '#{targetVersion}' by DevOps Helper")
            msg = "Automated tagging version '#{targetVersion}' by DevOps Helper" if is_empty?(msg)
            vh.create_tag(targetVersion, msg)
          end
        rescue TTY::Reader::InputInterrupt
          STDERR.puts "\n\nAborted"
          exit(1)
        end
      end
 
      res = rh.build_gem
      STDOUT.puts "Gem '#{gs.name}' built"

      vs.register_version(gs.name, targetVersion)
      vs.save(wd)
      STDOUT.puts "Version '#{targetVersion}' registered"

    elsif is_empty?(spec)
      STDERR.puts "gemspec file not found at '#{wd}'"
      exit(2)
    elsif is_empty?(svf)
      STDERR.puts "Cannot find version.rb to update GEM version"
      exit(2)
    end 

  end # gem_release

end # devops
