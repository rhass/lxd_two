default['lxd']['preseed_file'] = '/etc/lxd_preseed.yml'

default['lxd']['preseed'].tap do |preseed|
  preseed['config'].tap do |config|
    config['core.https_address'] = '0.0.0.0'
    config['core.trust_password'] = 'changeme'
    config['images.auto_update_interval'] = 6
  end
end
