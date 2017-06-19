# # encoding: utf-8

# Inspec test for recipe lxd_two::install

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

%w{lxd lxd-client}.each do |pkg|
  describe package(pkg) do
    it 'should be installed'

    context 'Ubuntu 16.04' do
      its('version') { should >= '2.14' }
    end
  end
end
