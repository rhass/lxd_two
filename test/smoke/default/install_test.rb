# # encoding: utf-8

# Inspec test for recipe lxd_two::install

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

%w{lxd lxd-client}.each do |pkg|
  describe package(pkg) do
    it { should be_installed }

    context 'on Ubuntu 16.04' do
      its('version') do
        should >= '2.14' if os[:release].to_f >= 16.04
      end
    end
  end
end
