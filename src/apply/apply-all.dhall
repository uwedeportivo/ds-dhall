let baseSchema = ../base/schema.dhall

let overlaySchema = ../customizations/schema.dhall

let applyDeploymentImage = ./apply-deployment-image.dhall

let applyAll
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let r = applyDeploymentImage base overlay in r

in  applyAll
