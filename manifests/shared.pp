# Used to build shared.xml
define pentaho::shared (
    $config,
    $order = 50,
    $snippet = false,
    $snippet_src = 'files/pentaho/shared_snippets',
    $basedir = "${pentaho::basedir}",
    ) {

    include pentaho

    concat::fragment { "pentaho_shared_${name}":
        target  => $pentaho::shared_xml,
        content => template('pentaho/shared_xml.erb'),
        order   => $order
    }
}
