let baseSchema = ./base/schema.dhall

let overlaySchema = ./customizations/schema.dhall

let apply = ./apply/apply-all.dhall

let base = baseSchema::{=}

let overlay = overlaySchema::{=}

let overlay = overlay with Shared.imageMods.registry = Some "google.io"

let r = apply base overlay

in  r
