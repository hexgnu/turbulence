class Turbulence
  module Calculators
    class Churn
      RUBY_FILE_EXTENSION = ".rb"

      class << self
        attr_accessor :scm, :compute_mean, :commit_range
        
        def for_these_files(files)
          scm.changes_by_ruby_file(commit_range).each do |filename, count|
            yield filename, count if files.include?(filename)
          end
        end
      end
    end
  end
end
