require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Sandbox do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ sandbox }).should.be.instance_of Command::Sandbox
      end
    end
  end
end

