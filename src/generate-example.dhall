let baseSchema = ./base/schema.dhall

let overlaySchema = ./customizations/schema.dhall

let resourceCombinator = ./combinators/container-resources.dhall

let applyAll = ./apply/apply-all.dhall

let base = baseSchema::{=}

let overlay = overlaySchema::{=}

let overlay = overlay with Shared.imageMods.registry = Some "google.io"

let overlay = overlay with Shared.namespace = Some "ns-sourcegraph"

let overlay =
      overlay
      with Symbols.Deployment.symbols.containers.jaeger-agent.resources
           = Some resourceCombinator::{
        , limits = resourceCombinator.Configuration::{ cpu = Some "500m" }
        }

let overlay =
      overlay
      with Gitserver.StatefulSet.gitserver.containers.gitserver.resources
           = Some resourceCombinator::{
        , limits = resourceCombinator.Configuration::{ cpu = Some "500m" }
        }

let r = applyAll base overlay

in  r
