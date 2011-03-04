require 'open3'
class Turbulence
  module Scm
    class Svn 
      class << self
        def log_command(commit_range)
          `svn log --all -M -C --numstat --format="%n" #{commit_range}`
        end

        def is_repo?(directory)
          FileUtils.cd(directory) {
            Open3.popen3("svn status") do |_, _, err, _|
            return !(err.read =~ /Not a git repository/)  
            end
          }
        end
      end
    end
  end
end