let baseSchema = ../../base/schema.dhall

let overlaySchema = ../../customizations/schema.dhall

let applyAll
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let r = base let r = ./apply-image.dhall base overlay in r

in  applyAll
