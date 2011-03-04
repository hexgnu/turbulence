require 'open3'
class Turbulence
  module Scm
    class Svn
      class << self
        def log_command(commit_range)
          churn = Hash.new(0)
          `svn log #{commit_range} --verbose`.split(/\n/).each do |line|
            filename = get_filename_from_line(line)
            if filename
              churn[filename] += 1
            end
          end
          churn
        end

        def is_repo?(directory)
          FileUtils.cd(directory) {
            Open3.popen3("svn status") do |_, _, err, _|
              return !(err.read =~ /not a working copy/)
            end
          }
        end

        private
        def get_filename_from_line(line)
          match = line.match(/\W*[A,M]\W+(\/.*)\b/)
          match ? match[1] : false
        end
      end

    end
  end
end
