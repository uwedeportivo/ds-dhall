let baseSchema = ../../base/schema.dhall

let overlaySchema = ../../customizations/schema.dhall

let overlayImage = ../../legos/container-images.dhall

let applyImage
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseFrontendImage =
              base.Frontend.Deployment.sourcegraph-frontend.spec.template.spec.containers.frontend.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayFrontendVs =
              overlay.Frontend.Deployment.sourcegraph-frontend.containers.frontend.vs

        let finalFrontendImage =
              overlayImage
                baseFrontendImage
                overlaySharedImageMods
                overlayFrontendVs

        in  base
          with Frontend.Deployment.sourcegraph-frontend.spec.template.spec.containers.frontend.image =
              finalFrontendImage

in  applyImage
