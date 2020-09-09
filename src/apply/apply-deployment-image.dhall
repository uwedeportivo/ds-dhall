let baseSchema = ../base/schema.dhall

let overlaySchema = ../customizations/schema.dhall

let overlayImage = ../legos/container-images.dhall

let applyImagef0
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Frontend.Deployment.sourcegraph-frontend.spec.template.spec.containers.frontend.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Frontend.Deployment.sourcegraph-frontend.containers.frontend.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Frontend.Deployment.sourcegraph-frontend.spec.template.spec.containers.frontend.image =
              finalImage

let applyImagef1
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Frontend.Deployment.sourcegraph-frontend.spec.template.spec.containers.jaeger-agent.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Frontend.Deployment.sourcegraph-frontend.containers.jaeger-agent.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Frontend.Deployment.sourcegraph-frontend.spec.template.spec.containers.jaeger-agent.image =
              finalImage

let applyAll
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let r = base

        let r = applyImagef0 r overlay

        let r = applyImagef1 r overlay

        in  r

in  applyAll
