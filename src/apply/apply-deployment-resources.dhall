let baseSchema = ../base/schema.dhall

let overlaySchema = ../customizations/schema.dhall

let resourceCombinator = ../combinators/container-resources.dhall

let applyResourcesf0
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Pgsql.Deployment.pgsql.spec.template.spec.containers.pgsql.resources

        let overlayResources =
              overlay.Pgsql.Deployment.pgsql.containers.pgsql.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Pgsql.Deployment.pgsql.spec.template.spec.containers.pgsql.resources =
              finalResources

let applyResourcesf1
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Pgsql.Deployment.pgsql.spec.template.spec.containers.pgsql-exporter.resources

        let overlayResources =
              overlay.Pgsql.Deployment.pgsql.containers.pgsql-exporter.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Pgsql.Deployment.pgsql.spec.template.spec.containers.pgsql-exporter.resources =
              finalResources

let applyResourcesf2
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Syntect-Server.Deployment.syntect-server.spec.template.spec.containers.syntect-server.resources

        let overlayResources =
              overlay.Syntect-Server.Deployment.syntect-server.containers.syntect-server.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Syntect-Server.Deployment.syntect-server.spec.template.spec.containers.syntect-server.resources =
              finalResources

let applyResourcesf3
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Github-Proxy.Deployment.github-proxy.spec.template.spec.containers.github-proxy.resources

        let overlayResources =
              overlay.Github-Proxy.Deployment.github-proxy.containers.github-proxy.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Github-Proxy.Deployment.github-proxy.spec.template.spec.containers.github-proxy.resources =
              finalResources

let applyResourcesf4
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Github-Proxy.Deployment.github-proxy.spec.template.spec.containers.jaeger-agent.resources

        let overlayResources =
              overlay.Github-Proxy.Deployment.github-proxy.containers.jaeger-agent.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Github-Proxy.Deployment.github-proxy.spec.template.spec.containers.jaeger-agent.resources =
              finalResources

let applyResourcesf5
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Jaeger.Deployment.jaeger.spec.template.spec.containers.jaeger.resources

        let overlayResources =
              overlay.Jaeger.Deployment.jaeger.containers.jaeger.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Jaeger.Deployment.jaeger.spec.template.spec.containers.jaeger.resources =
              finalResources

let applyResourcesf6
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Redis.Deployment.redis-cache.spec.template.spec.containers.redis-cache.resources

        let overlayResources =
              overlay.Redis.Deployment.redis-cache.containers.redis-cache.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Redis.Deployment.redis-cache.spec.template.spec.containers.redis-cache.resources =
              finalResources

let applyResourcesf7
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Redis.Deployment.redis-cache.spec.template.spec.containers.redis-exporter.resources

        let overlayResources =
              overlay.Redis.Deployment.redis-cache.containers.redis-exporter.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Redis.Deployment.redis-cache.spec.template.spec.containers.redis-exporter.resources =
              finalResources

let applyResourcesf8
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Redis.Deployment.redis-store.spec.template.spec.containers.redis-store.resources

        let overlayResources =
              overlay.Redis.Deployment.redis-store.containers.redis-store.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Redis.Deployment.redis-store.spec.template.spec.containers.redis-store.resources =
              finalResources

let applyResourcesf9
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Redis.Deployment.redis-store.spec.template.spec.containers.redis-exporter.resources

        let overlayResources =
              overlay.Redis.Deployment.redis-store.containers.redis-exporter.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Redis.Deployment.redis-store.spec.template.spec.containers.redis-exporter.resources =
              finalResources

let applyResourcesf10
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Prometheus.Deployment.prometheus.spec.template.spec.containers.prometheus.resources

        let overlayResources =
              overlay.Prometheus.Deployment.prometheus.containers.prometheus.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Prometheus.Deployment.prometheus.spec.template.spec.containers.prometheus.resources =
              finalResources

let applyResourcesf11
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Repo-Updater.Deployment.repo-updater.spec.template.spec.containers.jaeger-agent.resources

        let overlayResources =
              overlay.Repo-Updater.Deployment.repo-updater.containers.jaeger-agent.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Repo-Updater.Deployment.repo-updater.spec.template.spec.containers.jaeger-agent.resources =
              finalResources

let applyResourcesf12
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Repo-Updater.Deployment.repo-updater.spec.template.spec.containers.repo-updater.resources

        let overlayResources =
              overlay.Repo-Updater.Deployment.repo-updater.containers.repo-updater.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Repo-Updater.Deployment.repo-updater.spec.template.spec.containers.repo-updater.resources =
              finalResources

let applyResourcesf13
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Symbols.Deployment.symbols.spec.template.spec.containers.jaeger-agent.resources

        let overlayResources =
              overlay.Symbols.Deployment.symbols.containers.jaeger-agent.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Symbols.Deployment.symbols.spec.template.spec.containers.jaeger-agent.resources =
              finalResources

let applyResourcesf14
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Symbols.Deployment.symbols.spec.template.spec.containers.symbols.resources

        let overlayResources =
              overlay.Symbols.Deployment.symbols.containers.symbols.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Symbols.Deployment.symbols.spec.template.spec.containers.symbols.resources =
              finalResources

let applyResourcesf15
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Query-Runner.Deployment.query-runner.spec.template.spec.containers.jaeger-agent.resources

        let overlayResources =
              overlay.Query-Runner.Deployment.query-runner.containers.jaeger-agent.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Query-Runner.Deployment.query-runner.spec.template.spec.containers.jaeger-agent.resources =
              finalResources

let applyResourcesf16
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Query-Runner.Deployment.query-runner.spec.template.spec.containers.query-runner.resources

        let overlayResources =
              overlay.Query-Runner.Deployment.query-runner.containers.query-runner.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Query-Runner.Deployment.query-runner.spec.template.spec.containers.query-runner.resources =
              finalResources

let applyResourcesf17
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Searcher.Deployment.searcher.spec.template.spec.containers.jaeger-agent.resources

        let overlayResources =
              overlay.Searcher.Deployment.searcher.containers.jaeger-agent.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Searcher.Deployment.searcher.spec.template.spec.containers.jaeger-agent.resources =
              finalResources

let applyResourcesf18
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Searcher.Deployment.searcher.spec.template.spec.containers.searcher.resources

        let overlayResources =
              overlay.Searcher.Deployment.searcher.containers.searcher.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Searcher.Deployment.searcher.spec.template.spec.containers.searcher.resources =
              finalResources

let applyResourcesf19
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

let applyResourcesf20
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

let applyResourcesf21
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Precise-Code-Intel.Deployment.precise-code-intel-bundle-manager.spec.template.spec.containers.precise-code-intel-bundle-manager.resources

        let overlayResources =
              overlay.Precise-Code-Intel.Deployment.precise-code-intel-bundle-manager.containers.precise-code-intel-bundle-manager.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Precise-Code-Intel.Deployment.precise-code-intel-bundle-manager.spec.template.spec.containers.precise-code-intel-bundle-manager.resources =
              finalResources

let applyResourcesf22
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseResources =
              base.Precise-Code-Intel.Deployment.precise-code-intel-worker.spec.template.spec.containers.precise-code-intel-worker.resources

        let overlayResources =
              overlay.Precise-Code-Intel.Deployment.precise-code-intel-worker.containers.precise-code-intel-worker.resources

        let finalResources =
              resourceCombinator.overlayMerge baseResources overlayResources

        in  base
          with Precise-Code-Intel.Deployment.precise-code-intel-worker.spec.template.spec.containers.precise-code-intel-worker.resources =
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

        let r = applyResourcesf5 r overlay

        let r = applyResourcesf6 r overlay

        let r = applyResourcesf7 r overlay

        let r = applyResourcesf8 r overlay

        let r = applyResourcesf9 r overlay

        let r = applyResourcesf10 r overlay

        let r = applyResourcesf11 r overlay

        let r = applyResourcesf12 r overlay

        let r = applyResourcesf13 r overlay

        let r = applyResourcesf14 r overlay

        let r = applyResourcesf15 r overlay

        let r = applyResourcesf16 r overlay

        let r = applyResourcesf17 r overlay

        let r = applyResourcesf18 r overlay

        let r = applyResourcesf19 r overlay

        let r = applyResourcesf20 r overlay

        let r = applyResourcesf21 r overlay

        let r = applyResourcesf22 r overlay

        in  r

in  applyAll
