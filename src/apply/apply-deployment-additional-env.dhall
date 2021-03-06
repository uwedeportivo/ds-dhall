{- Generated by dhallie DO NOT EDIT -}

let baseSchema = ../base/schema.dhall

let overlaySchema = ../customizations/schema.dhall

let applyAddtionalEnvf0
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Pgsql.Deployment.pgsql.spec.template.spec.containers.pgsql.additionalEnv

        let overlayAdditionalEnv =
              overlay.Pgsql.Deployment.pgsql.containers.pgsql.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Pgsql
               . Deployment
               . pgsql
               . spec
               . template
               . spec
               . containers
               . pgsql
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf1
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Pgsql.Deployment.pgsql.spec.template.spec.containers.pgsql-exporter.additionalEnv

        let overlayAdditionalEnv =
              overlay.Pgsql.Deployment.pgsql.containers.pgsql-exporter.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Pgsql
               . Deployment
               . pgsql
               . spec
               . template
               . spec
               . containers
               . pgsql-exporter
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf2
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Symbols.Deployment.symbols.spec.template.spec.containers.jaeger-agent.additionalEnv

        let overlayAdditionalEnv =
              overlay.Symbols.Deployment.symbols.containers.jaeger-agent.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Symbols
               . Deployment
               . symbols
               . spec
               . template
               . spec
               . containers
               . jaeger-agent
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf3
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Symbols.Deployment.symbols.spec.template.spec.containers.symbols.additionalEnv

        let overlayAdditionalEnv =
              overlay.Symbols.Deployment.symbols.containers.symbols.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Symbols
               . Deployment
               . symbols
               . spec
               . template
               . spec
               . containers
               . symbols
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf4
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Github-Proxy.Deployment.github-proxy.spec.template.spec.containers.github-proxy.additionalEnv

        let overlayAdditionalEnv =
              overlay.Github-Proxy.Deployment.github-proxy.containers.github-proxy.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Github-Proxy
               . Deployment
               . github-proxy
               . spec
               . template
               . spec
               . containers
               . github-proxy
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf5
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Github-Proxy.Deployment.github-proxy.spec.template.spec.containers.jaeger-agent.additionalEnv

        let overlayAdditionalEnv =
              overlay.Github-Proxy.Deployment.github-proxy.containers.jaeger-agent.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Github-Proxy
               . Deployment
               . github-proxy
               . spec
               . template
               . spec
               . containers
               . jaeger-agent
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf6
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Prometheus.Deployment.prometheus.spec.template.spec.containers.prometheus.additionalEnv

        let overlayAdditionalEnv =
              overlay.Prometheus.Deployment.prometheus.containers.prometheus.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Prometheus
               . Deployment
               . prometheus
               . spec
               . template
               . spec
               . containers
               . prometheus
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf7
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Syntect-Server.Deployment.syntect-server.spec.template.spec.containers.syntect-server.additionalEnv

        let overlayAdditionalEnv =
              overlay.Syntect-Server.Deployment.syntect-server.containers.syntect-server.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Syntect-Server
               . Deployment
               . syntect-server
               . spec
               . template
               . spec
               . containers
               . syntect-server
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf8
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Frontend.Deployment.sourcegraph-frontend.spec.template.spec.containers.frontend.additionalEnv

        let overlayAdditionalEnv =
              overlay.Frontend.Deployment.sourcegraph-frontend.containers.frontend.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Frontend
               . Deployment
               . sourcegraph-frontend
               . spec
               . template
               . spec
               . containers
               . frontend
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf9
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Frontend.Deployment.sourcegraph-frontend.spec.template.spec.containers.jaeger-agent.additionalEnv

        let overlayAdditionalEnv =
              overlay.Frontend.Deployment.sourcegraph-frontend.containers.jaeger-agent.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Frontend
               . Deployment
               . sourcegraph-frontend
               . spec
               . template
               . spec
               . containers
               . jaeger-agent
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf10
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Jaeger.Deployment.jaeger.spec.template.spec.containers.jaeger.additionalEnv

        let overlayAdditionalEnv =
              overlay.Jaeger.Deployment.jaeger.containers.jaeger.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Jaeger
               . Deployment
               . jaeger
               . spec
               . template
               . spec
               . containers
               . jaeger
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf11
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Repo-Updater.Deployment.repo-updater.spec.template.spec.containers.jaeger-agent.additionalEnv

        let overlayAdditionalEnv =
              overlay.Repo-Updater.Deployment.repo-updater.containers.jaeger-agent.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Repo-Updater
               . Deployment
               . repo-updater
               . spec
               . template
               . spec
               . containers
               . jaeger-agent
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf12
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Repo-Updater.Deployment.repo-updater.spec.template.spec.containers.repo-updater.additionalEnv

        let overlayAdditionalEnv =
              overlay.Repo-Updater.Deployment.repo-updater.containers.repo-updater.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Repo-Updater
               . Deployment
               . repo-updater
               . spec
               . template
               . spec
               . containers
               . repo-updater
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf13
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Precise-Code-Intel.Deployment.precise-code-intel-bundle-manager.spec.template.spec.containers.precise-code-intel-bundle-manager.additionalEnv

        let overlayAdditionalEnv =
              overlay.Precise-Code-Intel.Deployment.precise-code-intel-bundle-manager.containers.precise-code-intel-bundle-manager.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Precise-Code-Intel
               . Deployment
               . precise-code-intel-bundle-manager
               . spec
               . template
               . spec
               . containers
               . precise-code-intel-bundle-manager
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf14
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Precise-Code-Intel.Deployment.precise-code-intel-worker.spec.template.spec.containers.precise-code-intel-worker.additionalEnv

        let overlayAdditionalEnv =
              overlay.Precise-Code-Intel.Deployment.precise-code-intel-worker.containers.precise-code-intel-worker.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Precise-Code-Intel
               . Deployment
               . precise-code-intel-worker
               . spec
               . template
               . spec
               . containers
               . precise-code-intel-worker
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf15
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Query-Runner.Deployment.query-runner.spec.template.spec.containers.jaeger-agent.additionalEnv

        let overlayAdditionalEnv =
              overlay.Query-Runner.Deployment.query-runner.containers.jaeger-agent.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Query-Runner
               . Deployment
               . query-runner
               . spec
               . template
               . spec
               . containers
               . jaeger-agent
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf16
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Query-Runner.Deployment.query-runner.spec.template.spec.containers.query-runner.additionalEnv

        let overlayAdditionalEnv =
              overlay.Query-Runner.Deployment.query-runner.containers.query-runner.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Query-Runner
               . Deployment
               . query-runner
               . spec
               . template
               . spec
               . containers
               . query-runner
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf17
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Redis.Deployment.redis-cache.spec.template.spec.containers.redis-cache.additionalEnv

        let overlayAdditionalEnv =
              overlay.Redis.Deployment.redis-cache.containers.redis-cache.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Redis
               . Deployment
               . redis-cache
               . spec
               . template
               . spec
               . containers
               . redis-cache
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf18
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Redis.Deployment.redis-cache.spec.template.spec.containers.redis-exporter.additionalEnv

        let overlayAdditionalEnv =
              overlay.Redis.Deployment.redis-cache.containers.redis-exporter.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Redis
               . Deployment
               . redis-cache
               . spec
               . template
               . spec
               . containers
               . redis-exporter
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf19
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Redis.Deployment.redis-store.spec.template.spec.containers.redis-exporter.additionalEnv

        let overlayAdditionalEnv =
              overlay.Redis.Deployment.redis-store.containers.redis-exporter.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Redis
               . Deployment
               . redis-store
               . spec
               . template
               . spec
               . containers
               . redis-exporter
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf20
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Redis.Deployment.redis-store.spec.template.spec.containers.redis-store.additionalEnv

        let overlayAdditionalEnv =
              overlay.Redis.Deployment.redis-store.containers.redis-store.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Redis
               . Deployment
               . redis-store
               . spec
               . template
               . spec
               . containers
               . redis-store
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf21
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Searcher.Deployment.searcher.spec.template.spec.containers.jaeger-agent.additionalEnv

        let overlayAdditionalEnv =
              overlay.Searcher.Deployment.searcher.containers.jaeger-agent.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Searcher
               . Deployment
               . searcher
               . spec
               . template
               . spec
               . containers
               . jaeger-agent
               . additionalEnv
               = finalAdditionalEnv

let applyAddtionalEnvf22
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseAdditionalEnv =
              base.Searcher.Deployment.searcher.spec.template.spec.containers.searcher.additionalEnv

        let overlayAdditionalEnv =
              overlay.Searcher.Deployment.searcher.containers.searcher.additionalEnv

        let finalAdditionalEnv =
              merge
                { Some = λ(x : List { name : Text, value : Text }) → Some x
                , None = baseAdditionalEnv
                }
                overlayAdditionalEnv

        in  base
          with   Searcher
               . Deployment
               . searcher
               . spec
               . template
               . spec
               . containers
               . searcher
               . additionalEnv
               = finalAdditionalEnv

let applyAll
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let r = base

        let r = applyAddtionalEnvf0 r overlay

        let r = applyAddtionalEnvf1 r overlay

        let r = applyAddtionalEnvf2 r overlay

        let r = applyAddtionalEnvf3 r overlay

        let r = applyAddtionalEnvf4 r overlay

        let r = applyAddtionalEnvf5 r overlay

        let r = applyAddtionalEnvf6 r overlay

        let r = applyAddtionalEnvf7 r overlay

        let r = applyAddtionalEnvf8 r overlay

        let r = applyAddtionalEnvf9 r overlay

        let r = applyAddtionalEnvf10 r overlay

        let r = applyAddtionalEnvf11 r overlay

        let r = applyAddtionalEnvf12 r overlay

        let r = applyAddtionalEnvf13 r overlay

        let r = applyAddtionalEnvf14 r overlay

        let r = applyAddtionalEnvf15 r overlay

        let r = applyAddtionalEnvf16 r overlay

        let r = applyAddtionalEnvf17 r overlay

        let r = applyAddtionalEnvf18 r overlay

        let r = applyAddtionalEnvf19 r overlay

        let r = applyAddtionalEnvf20 r overlay

        let r = applyAddtionalEnvf21 r overlay

        let r = applyAddtionalEnvf22 r overlay

        in  r

in  applyAll
