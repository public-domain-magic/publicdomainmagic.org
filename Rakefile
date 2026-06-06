# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

require "rdoc/task"
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = ENV["RDOC_OUTPUT"] || "tmp/rdoc"
  rdoc.rdoc_files.include("app/**/*.rb", "lib/**/*.rb", "config/application.rb")
end

Rails.application.load_tasks

task default: %w[lint:fix test lint steep]
