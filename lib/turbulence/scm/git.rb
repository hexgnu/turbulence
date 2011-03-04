require 'open3'
class Turbulence
  module Scm
    class Git 
      class << self
        def changes_by_ruby_file(commit_range)
          ruby_files_changed_in_scm(commit_range).group_by(&:first).map do |filename, stats|
            churn = stats[0..-2].map(&:last).inject(0){|n, i| n + i}
            if Turbulence::Calculators::Churn.compute_mean && stats.size > 1
              churn /= (stats.size-1)
            end
            [filename, churn]
          end
        end

        def ruby_files_changed_in_scm(commit_range)
          counted_line_changes_by_file_by_commit(commit_range).select do |filename, _|
            filename.end_with?(Turbulence::Calculators::Churn::RUBY_FILE_EXTENSION) && File.exist?(filename)
          end
        end
        
        def counted_line_changes_by_file_by_commit(commit_range)
          scm_log_file_lines(commit_range).map do |line|
            adds, deletes, filename = line.split(/\t/)
            [filename, adds.to_i + deletes.to_i]
          end
        end

        def scm_log_file_lines(commit_range)
          log_command(commit_range).each_line.reject{|line| line == "\n"}.map(&:chomp)
        end
        
        def log_command(commit_range)
          `git log --all -M -C --numstat --format="%n" #{commit_range}`
        end

        def is_repo?(directory)
          FileUtils.cd(directory) {
            Open3.popen3("git status") do |_, _, err, _|
            return !(err.read =~ /Not a git repository/)  
            end
          }
        end
      end
    end
  end
end
