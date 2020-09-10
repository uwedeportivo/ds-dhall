let baseSchema = ../base/schema.dhall

let overlaySchema = ../customizations/schema.dhall

let overlayImage = ../combinators/container-images.dhall

let applyImagef0
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Pgsql.Deployment.pgsql.spec.template.spec.containers.pgsql.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs = overlay.Pgsql.Deployment.pgsql.containers.pgsql.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Pgsql.Deployment.pgsql.spec.template.spec.containers.pgsql.image =
              finalImage

let applyImagef1
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Pgsql.Deployment.pgsql.spec.template.spec.containers.pgsql-exporter.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Pgsql.Deployment.pgsql.containers.pgsql-exporter.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Pgsql.Deployment.pgsql.spec.template.spec.containers.pgsql-exporter.image =
              finalImage

let applyImagef2
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Syntect-Server.Deployment.syntect-server.spec.template.spec.containers.syntect-server.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Syntect-Server.Deployment.syntect-server.containers.syntect-server.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Syntect-Server.Deployment.syntect-server.spec.template.spec.containers.syntect-server.image =
              finalImage

let applyImagef3
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Github-Proxy.Deployment.github-proxy.spec.template.spec.containers.github-proxy.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Github-Proxy.Deployment.github-proxy.containers.github-proxy.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Github-Proxy.Deployment.github-proxy.spec.template.spec.containers.github-proxy.image =
              finalImage

let applyImagef4
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Github-Proxy.Deployment.github-proxy.spec.template.spec.containers.jaeger-agent.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Github-Proxy.Deployment.github-proxy.containers.jaeger-agent.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Github-Proxy.Deployment.github-proxy.spec.template.spec.containers.jaeger-agent.image =
              finalImage

let applyImagef5
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Jaeger.Deployment.jaeger.spec.template.spec.containers.jaeger.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs = overlay.Jaeger.Deployment.jaeger.containers.jaeger.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Jaeger.Deployment.jaeger.spec.template.spec.containers.jaeger.image =
              finalImage

let applyImagef6
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Redis.Deployment.redis-cache.spec.template.spec.containers.redis-cache.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Redis.Deployment.redis-cache.containers.redis-cache.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Redis.Deployment.redis-cache.spec.template.spec.containers.redis-cache.image =
              finalImage

let applyImagef7
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Redis.Deployment.redis-cache.spec.template.spec.containers.redis-exporter.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Redis.Deployment.redis-cache.containers.redis-exporter.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Redis.Deployment.redis-cache.spec.template.spec.containers.redis-exporter.image =
              finalImage

let applyImagef8
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Redis.Deployment.redis-store.spec.template.spec.containers.redis-store.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Redis.Deployment.redis-store.containers.redis-store.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Redis.Deployment.redis-store.spec.template.spec.containers.redis-store.image =
              finalImage

let applyImagef9
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Redis.Deployment.redis-store.spec.template.spec.containers.redis-exporter.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Redis.Deployment.redis-store.containers.redis-exporter.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Redis.Deployment.redis-store.spec.template.spec.containers.redis-exporter.image =
              finalImage

let applyImagef10
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Prometheus.Deployment.prometheus.spec.template.spec.containers.prometheus.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Prometheus.Deployment.prometheus.containers.prometheus.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Prometheus.Deployment.prometheus.spec.template.spec.containers.prometheus.image =
              finalImage

let applyImagef11
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Repo-Updater.Deployment.repo-updater.spec.template.spec.containers.jaeger-agent.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Repo-Updater.Deployment.repo-updater.containers.jaeger-agent.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Repo-Updater.Deployment.repo-updater.spec.template.spec.containers.jaeger-agent.image =
              finalImage

let applyImagef12
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Repo-Updater.Deployment.repo-updater.spec.template.spec.containers.repo-updater.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Repo-Updater.Deployment.repo-updater.containers.repo-updater.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Repo-Updater.Deployment.repo-updater.spec.template.spec.containers.repo-updater.image =
              finalImage

let applyImagef13
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Symbols.Deployment.symbols.spec.template.spec.containers.jaeger-agent.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Symbols.Deployment.symbols.containers.jaeger-agent.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Symbols.Deployment.symbols.spec.template.spec.containers.jaeger-agent.image =
              finalImage

let applyImagef14
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Symbols.Deployment.symbols.spec.template.spec.containers.symbols.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs = overlay.Symbols.Deployment.symbols.containers.symbols.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Symbols.Deployment.symbols.spec.template.spec.containers.symbols.image =
              finalImage

let applyImagef15
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Query-Runner.Deployment.query-runner.spec.template.spec.containers.jaeger-agent.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Query-Runner.Deployment.query-runner.containers.jaeger-agent.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Query-Runner.Deployment.query-runner.spec.template.spec.containers.jaeger-agent.image =
              finalImage

let applyImagef16
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Query-Runner.Deployment.query-runner.spec.template.spec.containers.query-runner.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Query-Runner.Deployment.query-runner.containers.query-runner.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Query-Runner.Deployment.query-runner.spec.template.spec.containers.query-runner.image =
              finalImage

let applyImagef17
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Searcher.Deployment.searcher.spec.template.spec.containers.jaeger-agent.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Searcher.Deployment.searcher.containers.jaeger-agent.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Searcher.Deployment.searcher.spec.template.spec.containers.jaeger-agent.image =
              finalImage

let applyImagef18
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Searcher.Deployment.searcher.spec.template.spec.containers.searcher.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Searcher.Deployment.searcher.containers.searcher.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Searcher.Deployment.searcher.spec.template.spec.containers.searcher.image =
              finalImage

let applyImagef19
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

let applyImagef20
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

let applyImagef21
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Precise-Code-Intel.Deployment.precise-code-intel-bundle-manager.spec.template.spec.containers.precise-code-intel-bundle-manager.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Precise-Code-Intel.Deployment.precise-code-intel-bundle-manager.containers.precise-code-intel-bundle-manager.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Precise-Code-Intel.Deployment.precise-code-intel-bundle-manager.spec.template.spec.containers.precise-code-intel-bundle-manager.image =
              finalImage

let applyImagef22
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseImage =
              base.Precise-Code-Intel.Deployment.precise-code-intel-worker.spec.template.spec.containers.precise-code-intel-worker.image

        let overlaySharedImageMods = overlay.Shared.imageMods

        let overlayVs =
              overlay.Precise-Code-Intel.Deployment.precise-code-intel-worker.containers.precise-code-intel-worker.vs

        let finalImage = overlayImage baseImage overlaySharedImageMods overlayVs

        in  base
          with Precise-Code-Intel.Deployment.precise-code-intel-worker.spec.template.spec.containers.precise-code-intel-worker.image =
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

        let r = applyImagef5 r overlay

        let r = applyImagef6 r overlay

        let r = applyImagef7 r overlay

        let r = applyImagef8 r overlay

        let r = applyImagef9 r overlay

        let r = applyImagef10 r overlay

        let r = applyImagef11 r overlay

        let r = applyImagef12 r overlay

        let r = applyImagef13 r overlay

        let r = applyImagef14 r overlay

        let r = applyImagef15 r overlay

        let r = applyImagef16 r overlay

        let r = applyImagef17 r overlay

        let r = applyImagef18 r overlay

        let r = applyImagef19 r overlay

        let r = applyImagef20 r overlay

        let r = applyImagef21 r overlay

        let r = applyImagef22 r overlay

        in  r

in  applyAll
