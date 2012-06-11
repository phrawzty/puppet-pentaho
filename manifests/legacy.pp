# All the bits and pieces needed for a legacy (dirty, monolithic)
#   deployment of Pentaho in the eco2 context.
class pentaho::legacy {
    include pentaho
    include java::openjdk

    $packages = [ 'curl', 'python2.6', 'poppler-utils', 'qpdf' ]

    package { $packages:
        ensure => present
    }

    file { "${pentaho::basedir}/.kettle/kettle.properties":
        owner   => $pentaho::user,
        group   => $pentaho::group,
        mode    => '0644',
        source  => 'puppet:///files/pentaho/legacy/kettle.properties',
        require => File["${pentaho::basedir}/.kettle"]
    }

    # This could very likely be dynamic, based on a (future) define that
    #   that looks something like pentaho::repo ...
    file { "${pentaho::basedir}/.kettle/repositories.xml":
        owner   => $pentaho::user,
        group   => $pentaho::group,
        mode    => '0644',
        source  => 'puppet:///files/pentaho/legacy/repositories.xml',
        require => File["${pentaho::basedir}/.kettle"]
    }

    # TODO: Ensure that the Git repo is there, somehow.
}
