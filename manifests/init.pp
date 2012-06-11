class pentaho (
    $env = 'default',
    $basedir = '/home/pentaho',
    $user = 'pentaho',
    $group = 'pentaho',
    $packages = false
    ) {

    include concat::setup

    if ( $packages ) {
        package { $packages: ensure => present }
    }

    # set up common dirs
    $commondirs = [ $basedir,
                    "${basedir}/.kettle",
                    "${basedir}/archive",
                    "${basedir}/JobsLogs" ]

    file { $commondirs:
        ensure  => directory,
        owner   => $user,
        group   => $group,
        mode    => '0775',
        require => User[$user]
    }

    $kettle_prop = "${basedir}/.kettle/kettle.properties"

    concat { $kettle_prop:
        owner   => $user,
        group   => $group,
        mode    => '0644',
        require => File["${basedir}/.kettle"]
    }

    concat::fragment { 'kettle_prop_header':
        target  => $kettle_prop,
        content => "# THIS FILE MANAGED BY PUPPET\n",
        order   => 10
    }

    $repo_xml = "${basedir}/.kettle/repositories.xml"

    concat { $repo_xml:
        owner   => $user,
        group   => $group,
        mode    => '0644',
        require => File["${basedir}/.kettle"]
    }

    concat::fragment { 'repo_xml_header':
        target  => $repo_xml,
        content => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!-- THIS FILE MANAGED BY PUPPET -->\n<repositories>\n",
        order   => 10
    }

    concat::fragment { 'repo_xml_footer':
        target  => $repo_xml,
        content => "</repositories>\n",
        order   => 99
    }

    $shared_xml = "${basedir}/.kettle/shared.xml"

    concat { $shared_xml:
        owner   => $user,
        group   => $group,
        mode    => '0644',
        require => File["${basedir}/.kettle"]
    }

    concat::fragment { 'shared_xml_header':
        target  => $shared_xml,
        content => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!-- THIS FILE IS MANAGED BY PUPPET -->\n<sharedobjects>\n",
        order   => 10
    }

    concat::fragment { 'shared_xml_footer':
        target  => $shared_xml,
        content => "</sharedobjects>\n",
        order   => 99
    }
}
