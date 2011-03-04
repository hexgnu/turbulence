require 'turbulence/scm/svn'
require 'tmpdir'
require 'fileutils'

describe Turbulence::Scm::Svn do
  describe "::is_repo?" do
    before do
      @tmp = Dir.mktmpdir(nil,'..')
      @tmp_svn_repo = Dir.mktmpdir('svn', '.')
      @tmp_svn_checkout = Dir.mktmpdir('svn-co', '.')
      `svnadmin create #{File.basename(@tmp_svn_repo)}`
      `svn co file://#{File.expand_path(@tmp_svn_repo)} #{@tmp_svn_checkout}`
    end
    
    after do
      %w[tmp tmp_svn_repo tmp_svn_checkout].each do |variable|
        FileUtils.rm_r(instance_variable_get("@#{variable}"))
      end
    end
    
    it "returns true for the working directory" do
      Turbulence::Scm::Svn.is_repo?(@tmp_svn_checkout).should == true
    end
    
    it "return false for a newly created tmp directory" do
      Turbulence::Scm::Svn.is_repo?(@tmp).should == false
    end
    
  end
end