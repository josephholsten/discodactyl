module Discodactyl # :nodoc:
  KNOWN_RELS = {
    'http://microformats.org/profile/hcard' => 'hcard',
    'http://specs.openid.net/auth/' => 'OpenID',
    'http://specs.openid.net/auth/2.0/provider' => 'OpenID Provider',
    'openid2.provider' => 'OpenID Provider',
    'http://webfinger.net/rel/profile-page' => 'Profile',
    'http://portablecontacts.net/spec/1.0#me' => 'Profile data',
    'http://portablecontacts.net/spec/1.0' => 'Contacts',
    'describedby' => 'describedby', # from POWDER
    'lrdd' => 'Webfinger/LRDD',
    'http://schemas.google.com/g/2010#updates-from' => 'activities'
  }
end
