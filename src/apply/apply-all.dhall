let baseSchema = ../base/schema.dhall

let overlaySchema = ../customizations/schema.dhall

let applyDeploymentImage = ./apply-deployment-image.dhall

let applyStatefulSetImage = ./apply-statefulset-image.dhall

let applyDeploymentResources = ./apply-deployment-resources.dhall

let applyStatefulSetResources = ./apply-statefulset-resources.dhall


let applyAll
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let r = base

        let r = applyDeploymentImage r overlay

        let r = applyStatefulSetImage r overlay

        let r = applyDeploymentResources r overlay

        let r = applyStatefulSetResources r overlay

        in  r

in  applyAll
