
require 'toolrack'

module DevopsHelper
  module GemVersionHelper
    include Antrapol::ToolRack::ConditionUtils

    def find_gem_version_file(root)
      if is_empty?(root)
         raise DevopsHelper::Error, "Root path '#{root}' to find_version_file is empty"
      else
        Dir.glob(File.join(root,"**/version.rb"))
      end
    end

    def get_version_record(root)
      VersionStore.load(root)   
    end # find_last_version

    def prompt_version(gname,current,currentAt)

      current = "" if is_empty?(current)

      prompt = TTY::Prompt.new
      
      ops = []
      ops << increase_version(current,1)
      ops << increase_version(current,2)
      ops << increase_version(current,3)
      ops << "Custom"
      ops << "Quit"
      
      curInfo = []
      if not_empty?(current)
        curInfo << "Current version is '#{current}'"
        curInfo << "created at #{currentAt}" if not_empty?(currentAt)
      else
        curInfo << "There is not a previous version found in record."
      end
      prompt.ok curInfo.join(" ")

      begin
        sel = prompt.select("Version of this release of '#{gname}'", ops)
        if sel != "Quit"
          if sel == "Custom"
            loop do
              sel = prompt.ask("Please provide the custom version number: ") do |q|
                q.required true
              end

              pro = prompt.yes?("Proceed using version '#{sel}'?")
              break if pro
            end # loop
          end

          sel

        else
          -1
        end
      rescue TTY::Reader::InputInterrupt
        STDERR.puts "\n\nAborted"
        exit(3)
      end

    end # prompt_version

    def rewrite_gem_version_file(version_file, newVersion)
      if not_empty?(version_file) and not_empty?(version_file)
        tmpFile = File.join(File.dirname(version_file),"version.rb.tmp")
        FileUtils.mv(version_file,tmpFile)

        File.open(version_file,"w") do |f|
          File.open(tmpFile,"r").each_line do |l|
            if l =~ /VERSION/
              indx = (l =~ /=/)
              ll = "#{l[0..indx]} \"#{newVersion}\""
              f.puts ll
            else
              f.write l
            end
          end
        end
        
        FileUtils.rm tmpFile

      else
        raise DevopsHelper::Error, "Given version file '#{version_file}' does not exist"
      end
    end

    def increase_version(input, digitNo)
      input = "" if is_empty?(input)

      si = input.split(".")
      cnt = 0
      res = []
      if si.length >= digitNo
        Global.instance.logger.debug "Given length longer then digit no"

        hit = false
        si.each do |i|
          # digitNo = start at 1
          if (cnt+1) < digitNo
            res << i
          elsif cnt+1 == digitNo
            i = i.to_i
            res << (i += 1)
          else
            res << "0"
          end

          cnt += 1

        end

      else
        
        Global.instance.logger.debug "Given digit no longer then length"

        res = si
        cnt = si.length
        (0...(digitNo-si.length)-1).each do |i|
          res << "0"
        end

        res << "1"

      end

      if res.length == 1
        res << "0"
      elsif res.length == 2 and res[-1].to_i != 0
        res << "0"
      end

      res.join(".")
      
    end

  end
end
