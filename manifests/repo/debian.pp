# Configure debian apt repo
#
# === Parameters
#
# [*location*]
#   Location of the apt repository
#
# [*release*]
#   Parameter Removed since obsolete
#
# [*repos*]
#   Apt repository names
#
# [*include_src*]
#   Add source source repository
#
# [*key*]
#   Public key in apt::key format
#
# [*dotdeb*]
#   Parameter Removed since obsolete
#
class php::repo::debian(
  $location     = 'http://packages.dotdeb.org',
  $release      = 'wheezy-php56',
  $repos        = 'all',
  $include_src  = false,
  $key          = {
    'id'     => '6572BBEF1B5FF28B28B706837E3F070089DF5277',
    'source' => 'http://www.dotdeb.org/dotdeb.gpg',
  },
  $dotdeb       = false,
) {

  if $caller_module_name != $module_name {
    warning('php::repo::debian is private')
  }

  include '::apt'

  create_resources(::apt::key, { 'php::repo::debian' => {
    key => $key['id'], key_source => $key['source'],
  } })

  $dotdeb_release = $::php::globals::globals_php_version ? {
    '5.4' => "${::lsbdistcodename}-php54",
    '5.5' => "${::lsbdistcodename}-php55",
    '5.6' => "${::lsbdistcodename}-php56",
    '7.0' => "${::lsbdistcodename}"
  }

  ::apt::source { "dotdeb-${dotdeb_release}":
    location    => $location,
    release     => $dotdeb_release,
    repos       => $repos,
    include  => {
      'src' => $include_src,
      'deb' => true,
    },
    require     => Apt::Key['php::repo::debian'],
  }
}
