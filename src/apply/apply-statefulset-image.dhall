let baseSchema = ../base/schema.dhall

let overlaySchema = ../customizations/schema.dhall

let overlayImage = ../combinators/container-images.dhall

let applyImagef0
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Grafana.StatefulSet.grafana.spec.template.spec.containers.grafana.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Grafana.StatefulSet.grafana.containers.grafana.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Grafana.StatefulSet.grafana.spec.template.spec.containers.grafana.image =
              finalImage

let applyImagef1
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Indexed-Search.StatefulSet.indexed-search.spec.template.spec.containers.zoekt-indexserver.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Indexed-Search.StatefulSet.indexed-search.containers.zoekt-indexserver.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Indexed-Search.StatefulSet.indexed-search.spec.template.spec.containers.zoekt-indexserver.image =
              finalImage

let applyImagef2
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Indexed-Search.StatefulSet.indexed-search.spec.template.spec.containers.zoekt-webserver.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Indexed-Search.StatefulSet.indexed-search.containers.zoekt-webserver.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Indexed-Search.StatefulSet.indexed-search.spec.template.spec.containers.zoekt-webserver.image =
              finalImage

let applyImagef3
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Gitserver.StatefulSet.gitserver.spec.template.spec.containers.gitserver.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Gitserver.StatefulSet.gitserver.containers.gitserver.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Gitserver.StatefulSet.gitserver.spec.template.spec.containers.gitserver.image =
              finalImage

let applyImagef4
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Gitserver.StatefulSet.gitserver.spec.template.spec.containers.jaeger-agent.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Gitserver.StatefulSet.gitserver.containers.jaeger-agent.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Gitserver.StatefulSet.gitserver.spec.template.spec.containers.jaeger-agent.image =
              finalImage

let applyAll
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let r = base

        let r = applyImagef0 r overlay

        let r = applyImagef1 r overlay

        let r = applyImagef2 r overlay

        let r = applyImagef3 r overlay

        let r = applyImagef4 r overlay

        in  r

in  applyAll
