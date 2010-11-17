module Discodactyl # :nodoc:
  KNOWN_RELS = {
    'OpenID' => 'http://specs.openid.net/auth/',
    'OpenID Provider' => 'http://specs.openid.net/auth/2.0/provider',
    'OpenID Provider' => 'openid2.provider',
    "Profile" => 'http://webfinger.net/rel/profile-page',
    "Profile data" => 'http://portablecontacts.net/spec/1.0#me',
    "Contacts" => 'http://portablecontacts.net/spec/1.0',
    "describedby" => 'describedby', # from POWDER
    "Webfinger/LRDD" => 'lrdd'
  }
end