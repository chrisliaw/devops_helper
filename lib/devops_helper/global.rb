
require 'singleton'
require 'tlogger'
require 'fileutils'

module DevopsHelper
  class Global
    include Singleton

    attr_accessor :logger
    attr_reader :root_store
    def initialize()
      debug = ENV['DevOpsHelper_Debug']
      debugOut = ENV['DevOpsHelper_DebugOut'] || STDOUT

      if debug.nil?
        @logger = Tlogger.new('devops_helper.log', 5, 1024*1024*10)
      else
        @logger = Tlogger.new(debugOut)
      end
      @root_store = File.join(Dir.home,".devops_helper")
      FileUtils.mkdir_p(@root_store) if not File.exist?(@root_store)
    end # initialize

  end # class Global
end # module DevopsHelper
