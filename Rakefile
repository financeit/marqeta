require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:spec)

desc "Run RuboCop"
RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ["--display-cop-names"]
end

desc "Run Sorbet type checking"
task(:srb) do |task|
  sh('srb tc')
end

task default: %i[srb spec rubocop]
