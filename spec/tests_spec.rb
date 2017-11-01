require 'serverspec'
require 'docker'

# Pull in the shared drone tests from https://github.com/1and1internet/drone-tests
base_spec_dir = Pathname.new(File.join(File.dirname(__FILE__)))
Dir[base_spec_dir.join('../../drone-tests/shared/**/*.rb')].sort.each {|f| require_relative f}

RSpec.configure do |c|
  @image = Docker::Image.get(ENV['IMAGE'])
  set :backend, :docker
  set :docker_image, @image.id
  set :docker_container_create_options, {
      'User' => '100000'
  }

  describe "tests" do

    print "No tests implemented.\n"

    # include_examples 'debian-8'

  end
end
