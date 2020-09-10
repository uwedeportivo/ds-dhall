let baseSchema = ../base/schema.dhall

let overlaySchema = ../customizations/schema.dhall

let resourceCombinator = ../combinators/container-resources.dhall

let applyResourcesf0
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Indexed-Search.StatefulSet.indexed-search.spec.template.spec.containers.zoekt-indexserver.resources

        let overlayResources =
              overlay.Indexed-Search.StatefulSet.indexed-search.containers.zoekt-indexserver.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Indexed-Search.StatefulSet.indexed-search.spec.template.spec.containers.zoekt-indexserver.resources =
              finalResources

let applyResourcesf1
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Indexed-Search.StatefulSet.indexed-search.spec.template.spec.containers.zoekt-webserver.resources

        let overlayResources =
              overlay.Indexed-Search.StatefulSet.indexed-search.containers.zoekt-webserver.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Indexed-Search.StatefulSet.indexed-search.spec.template.spec.containers.zoekt-webserver.resources =
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
