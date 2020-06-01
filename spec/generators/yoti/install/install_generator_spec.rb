require 'generator_spec'
require 'generators/yoti/install/install_generator.rb'

describe Yoti::Generators::InstallGenerator, type: :generator do
  destination File.expand_path('../../../tmp', __dir__)

  before(:all) do
    prepare_destination
    run_generator
  end

  after(:all) do
    FileUtils.rm_rf(Dir['spec/tmp'])
  end

  let(:initializer) { File.read('spec/sample-data/initializer.txt') }

  it 'creates the Yoti initializer in the right path' do
    assert_file 'config/initializers/yoti.rb', initializer
  end
end
