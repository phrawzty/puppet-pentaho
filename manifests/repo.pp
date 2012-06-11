# Only supports (simple)git-based file repos.
# $config is a hash of the config elements (as from extlookup, for example).
define pentaho::repo (
    $config,
    $source,
    $basedir = "${pentaho::basedir}",
    $order = 50
    ) {

    include simplegit
    include pentaho

    simplegit::repo { $name:
        basedir => $basedir,
        source  => $source,
        user    => $pentaho::user
    }

    file { "${basedir}/${name}":
        owner   => $pentaho::user,
        group   => $pentaho::group,
        mode    => '0664',
        recurse => true,
        require => Simplegit::Repo[$name]
    }

    # NOTE: The xml-simple gem is required for this template.
    concat::fragment { "pentaho_repo_${name}":
        target  => $pentaho::repo_xml,
        content => template('pentaho/repo_xml.erb'),
        order   => $order
    }
}
