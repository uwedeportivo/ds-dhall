let baseSchema = ../base/schema.dhall

let overlaySchema = ../customizations/schema.dhall

let resourceCombinator = ../combinators/container-resources.dhall

let applyResourcesf0
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Frontend.Deployment.sourcegraph-frontend.spec.template.spec.containers.jaeger-agent.resources

        let overlayResources =
              overlay.Frontend.Deployment.sourcegraph-frontend.containers.jaeger-agent.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Frontend.Deployment.sourcegraph-frontend.spec.template.spec.containers.jaeger-agent.resources =
              finalResources

let applyResourcesf1
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Frontend.Deployment.sourcegraph-frontend.spec.template.spec.containers.frontend.resources

        let overlayResources =
              overlay.Frontend.Deployment.sourcegraph-frontend.containers.frontend.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Frontend.Deployment.sourcegraph-frontend.spec.template.spec.containers.frontend.resources =
              finalResources

let applyAll
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let r = base

        let r = applyResourcesf0 r overlay

        let r = applyResourcesf1 r overlay

        in  r

in  applyAll
