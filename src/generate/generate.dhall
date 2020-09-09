let baseSchema = ../base/schema.dhall

let overlaySchema = ../customizations/schema.dhall

let generatedType = ./type.dhall

let containerImages/overlayMerge = ../legos/container-images.dhall

let generate
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let r = baseSchema::{=} in r

in  generate
