require "bundler/gem_tasks"
require "rake/testtask"

require "devops_helper"

#spec = Gem::Specification.find_by_name "devops_helper"
#rf = "#{spec.gem_dir}/lib/Rakefile"
#load rf

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :default => :test
