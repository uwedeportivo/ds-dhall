let baseSchema = ../base/schema.dhall

let overlaySchema = ../customizations/schema.dhall

let resourceCombinator = ../combinators/container-resources.dhall

let applyResourcesf0
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Grafana.StatefulSet.grafana.spec.template.spec.containers.grafana.resources

        let overlayResources =
              overlay.Grafana.StatefulSet.grafana.containers.grafana.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Grafana.StatefulSet.grafana.spec.template.spec.containers.grafana.resources =
              finalResources

let applyResourcesf1
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

let applyResourcesf2
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

let applyResourcesf3
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Gitserver.StatefulSet.gitserver.spec.template.spec.containers.gitserver.resources

        let overlayResources =
              overlay.Gitserver.StatefulSet.gitserver.containers.gitserver.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Gitserver.StatefulSet.gitserver.spec.template.spec.containers.gitserver.resources =
              finalResources

let applyResourcesf4
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Gitserver.StatefulSet.gitserver.spec.template.spec.containers.jaeger-agent.resources

        let overlayResources =
              overlay.Gitserver.StatefulSet.gitserver.containers.jaeger-agent.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Gitserver.StatefulSet.gitserver.spec.template.spec.containers.jaeger-agent.resources =
              finalResources

let applyAll
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let r = base

        let r = applyResourcesf0 r overlay

        let r = applyResourcesf1 r overlay

        let r = applyResourcesf2 r overlay

        let r = applyResourcesf3 r overlay

        let r = applyResourcesf4 r overlay

        in  r

in  applyAll
