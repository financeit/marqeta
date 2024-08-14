# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:spec)

desc "Run RuboCop"
RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ["--display-cop-names"]
end

task default: %i[spec rubocop]
