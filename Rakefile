# frozen_string_literal: true

task :test do
  Dir['test/*.rb'].map { |file| load file }
end

namespace :example do
  task :test do
    Dir['test/example/*.rb'].map { |file| load file }
  end
end
