# Used to build kettle.properties
define pentaho::kprop (
    $content = false,
    $source = false,
    $order = 50
    ) {

    include pentaho

    concat::fragment { $name:
        target => $pentaho::kettle_prop,
        order  => $order
    }

    if ( $content and $source) {
        err("ERROR: kprop ${name} cannot have both source and content defined.")
    } elsif ( $content ) {
        Concat::Fragment[$name] { content => $content }
    } elsif ( $source ) {
        Concat::Fragment[$name] { source => $source }
    } else {
        err("ERROR: kprop ${name} must have either source or content defined.")
    }
}
