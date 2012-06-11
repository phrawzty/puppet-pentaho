# Used to deploy Pentaho PDI (Kettle)
define pentaho::deploy_pdi (
    $ver,
    $mirror = false,
    $target = 'data-integration',
    $source = "http://sourceforge.net/projects/pentaho/files/Data%20Integration/${ver}/pdi-ce-${ver}.tar.gz/download?"
    ) {

    include pentaho

    $pdidir = "${pentaho::basedir}/${target}"

    file { $pdidir:
        ensure  => directory,
        require => File[$pentaho::basedir]
    }

    file { "${pentaho::basedir}/pentaho":
        ensure  => link,
        target  => $pdidir,
        require => File[$pdidir]
    }

    # This is done in order to prevent accidental refreshes of the actual File
    # resource, which would trigger a re-deployment.
    exec { "ensure_perms_${name}":
        command => "/bin/chown -R ${pentaho::user}.${pentaho::user} ${pdidir}",
        unless  => "/usr/bin/stat ${pdidir} | grep Uid | grep ${pentaho::user}",
        cwd     => $pentaho::basedir,
        require => File[$pdidir]
    }

    if ( $mirror ) {
        $use_mirror = "use_mirror=${mirror}"
    } else {
        $use_mirror = ''
    }

    exec { "pdi_acquire_${name}":
        command     => "/usr/bin/wget \"${source}${use_mirror}\" -O pdi-ce-${ver}.tar.gz",
        cwd         => '/tmp',
        subscribe   => File[$pdidir],
        user        => $pentaho::user,
        refreshonly => true,
    }

    exec { "pdi_unpack_${name}":
        command     => "/bin/tar -xzf /tmp/pdi-ce-${ver}.tar.gz",
        cwd         => $pentaho::basedir,
        subscribe   => Exec["pdi_acquire_${name}"],
        user        => $pentaho::user,
        refreshonly => true
    }
}
