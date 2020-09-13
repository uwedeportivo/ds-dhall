{- Generated by dhallie DO NOT EDIT -}

let baseSchema = ../base/schema.dhall

let overlaySchema = ../customizations/schema.dhall

let applyNamespacef0
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Syntect-Server.Deployment.syntect-server.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Syntect-Server.Deployment.syntect-server.metadata.namespace
               = finalNamespace

let applyNamespacef1
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Syntect-Server.Service.syntect-server.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Syntect-Server.Service.syntect-server.metadata.namespace
               = finalNamespace

let applyNamespacef2
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Gitserver.Service.gitserver.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Gitserver.Service.gitserver.metadata.namespace = finalNamespace

let applyNamespacef3
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Gitserver.StatefulSet.gitserver.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Gitserver.StatefulSet.gitserver.metadata.namespace
               = finalNamespace

let applyNamespacef4
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Indexed-Search.Service.indexed-search.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Indexed-Search.Service.indexed-search.metadata.namespace
               = finalNamespace

let applyNamespacef5
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Indexed-Search.Service.indexed-search-indexer.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Indexed-Search.Service.indexed-search-indexer.metadata.namespace
               = finalNamespace

let applyNamespacef6
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Indexed-Search.StatefulSet.indexed-search.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Indexed-Search.StatefulSet.indexed-search.metadata.namespace
               = finalNamespace

let applyNamespacef7
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Precise-Code-Intel.PersistentVolumeClaim.bundle-manager.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with   Precise-Code-Intel
               . PersistentVolumeClaim
               . bundle-manager
               . metadata
               . namespace
               = finalNamespace

let applyNamespacef8
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Precise-Code-Intel.Service.precise-code-intel-bundle-manager.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with   Precise-Code-Intel
               . Service
               . precise-code-intel-bundle-manager
               . metadata
               . namespace
               = finalNamespace

let applyNamespacef9
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Precise-Code-Intel.Service.precise-code-intel-worker.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with   Precise-Code-Intel
               . Service
               . precise-code-intel-worker
               . metadata
               . namespace
               = finalNamespace

let applyNamespacef10
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Precise-Code-Intel.Deployment.precise-code-intel-bundle-manager.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with   Precise-Code-Intel
               . Deployment
               . precise-code-intel-bundle-manager
               . metadata
               . namespace
               = finalNamespace

let applyNamespacef11
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Precise-Code-Intel.Deployment.precise-code-intel-worker.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with   Precise-Code-Intel
               . Deployment
               . precise-code-intel-worker
               . metadata
               . namespace
               = finalNamespace

let applyNamespacef12
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Redis.Deployment.redis-cache.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Redis.Deployment.redis-cache.metadata.namespace = finalNamespace

let applyNamespacef13
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Redis.Deployment.redis-store.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Redis.Deployment.redis-store.metadata.namespace = finalNamespace

let applyNamespacef14
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Redis.PersistentVolumeClaim.redis-cache.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Redis.PersistentVolumeClaim.redis-cache.metadata.namespace
               = finalNamespace

let applyNamespacef15
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Redis.PersistentVolumeClaim.redis-store.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Redis.PersistentVolumeClaim.redis-store.metadata.namespace
               = finalNamespace

let applyNamespacef16
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Redis.Service.redis-cache.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Redis.Service.redis-cache.metadata.namespace = finalNamespace

let applyNamespacef17
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Redis.Service.redis-store.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Redis.Service.redis-store.metadata.namespace = finalNamespace

let applyNamespacef18
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Base.Service.backend.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Base.Service.backend.metadata.namespace = finalNamespace

let applyNamespacef19
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Base.StorageClass.sourcegraph.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Base.StorageClass.sourcegraph.metadata.namespace = finalNamespace

let applyNamespacef20
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Grafana.ServiceAccount.grafana.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Grafana.ServiceAccount.grafana.metadata.namespace
               = finalNamespace

let applyNamespacef21
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Grafana.StatefulSet.grafana.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Grafana.StatefulSet.grafana.metadata.namespace = finalNamespace

let applyNamespacef22
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Grafana.ConfigMap.grafana.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Grafana.ConfigMap.grafana.metadata.namespace = finalNamespace

let applyNamespacef23
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Grafana.Service.grafana.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Grafana.Service.grafana.metadata.namespace = finalNamespace

let applyNamespacef24
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Jaeger.Deployment.jaeger.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Jaeger.Deployment.jaeger.metadata.namespace = finalNamespace

let applyNamespacef25
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Jaeger.Service.jaeger-collector.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Jaeger.Service.jaeger-collector.metadata.namespace
               = finalNamespace

let applyNamespacef26
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Jaeger.Service.jaeger-query.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Jaeger.Service.jaeger-query.metadata.namespace = finalNamespace

let applyNamespacef27
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Query-Runner.Deployment.query-runner.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Query-Runner.Deployment.query-runner.metadata.namespace
               = finalNamespace

let applyNamespacef28
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Query-Runner.Service.query-runner.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Query-Runner.Service.query-runner.metadata.namespace
               = finalNamespace

let applyNamespacef29
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Repo-Updater.Deployment.repo-updater.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Repo-Updater.Deployment.repo-updater.metadata.namespace
               = finalNamespace

let applyNamespacef30
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Repo-Updater.Service.repo-updater.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Repo-Updater.Service.repo-updater.metadata.namespace
               = finalNamespace

let applyNamespacef31
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Searcher.Deployment.searcher.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Searcher.Deployment.searcher.metadata.namespace = finalNamespace

let applyNamespacef32
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Searcher.Service.searcher.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Searcher.Service.searcher.metadata.namespace = finalNamespace

let applyNamespacef33
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Prometheus.ClusterRole.prometheus.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Prometheus.ClusterRole.prometheus.metadata.namespace
               = finalNamespace

let applyNamespacef34
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Prometheus.ClusterRoleBinding.prometheus.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Prometheus.ClusterRoleBinding.prometheus.metadata.namespace
               = finalNamespace

let applyNamespacef35
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Prometheus.ConfigMap.prometheus.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Prometheus.ConfigMap.prometheus.metadata.namespace
               = finalNamespace

let applyNamespacef36
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Prometheus.Deployment.prometheus.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Prometheus.Deployment.prometheus.metadata.namespace
               = finalNamespace

let applyNamespacef37
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Prometheus.PersistentVolumeClaim.prometheus.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Prometheus.PersistentVolumeClaim.prometheus.metadata.namespace
               = finalNamespace

let applyNamespacef38
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Prometheus.Service.prometheus.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Prometheus.Service.prometheus.metadata.namespace = finalNamespace

let applyNamespacef39
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Prometheus.ServiceAccount.prometheus.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Prometheus.ServiceAccount.prometheus.metadata.namespace
               = finalNamespace

let applyNamespacef40
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Symbols.Deployment.symbols.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Symbols.Deployment.symbols.metadata.namespace = finalNamespace

let applyNamespacef41
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Symbols.Service.symbols.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Symbols.Service.symbols.metadata.namespace = finalNamespace

let applyNamespacef42
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Cadvisor.ServiceAccount.cadvisor.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Cadvisor.ServiceAccount.cadvisor.metadata.namespace
               = finalNamespace

let applyNamespacef43
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Cadvisor.ClusterRole.cadvisor.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Cadvisor.ClusterRole.cadvisor.metadata.namespace = finalNamespace

let applyNamespacef44
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Cadvisor.ClusterRoleBinding.cadvisor.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Cadvisor.ClusterRoleBinding.cadvisor.metadata.namespace
               = finalNamespace

let applyNamespacef45
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Cadvisor.DaemonSet.cadvisor.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Cadvisor.DaemonSet.cadvisor.metadata.namespace = finalNamespace

let applyNamespacef46
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Cadvisor.PodSecurityPolicy.cadvisor.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Cadvisor.PodSecurityPolicy.cadvisor.metadata.namespace
               = finalNamespace

let applyNamespacef47
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Frontend.RoleBinding.sourcegraph-frontend.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Frontend.RoleBinding.sourcegraph-frontend.metadata.namespace
               = finalNamespace

let applyNamespacef48
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Frontend.Service.sourcegraph-frontend.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Frontend.Service.sourcegraph-frontend.metadata.namespace
               = finalNamespace

let applyNamespacef49
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Frontend.Service.sourcegraph-frontend-internal.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Frontend.Service.sourcegraph-frontend-internal.metadata.namespace
               = finalNamespace

let applyNamespacef50
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Frontend.ServiceAccount.sourcegraph-frontend.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Frontend.ServiceAccount.sourcegraph-frontend.metadata.namespace
               = finalNamespace

let applyNamespacef51
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Frontend.Deployment.sourcegraph-frontend.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Frontend.Deployment.sourcegraph-frontend.metadata.namespace
               = finalNamespace

let applyNamespacef52
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Frontend.Ingress.sourcegraph-frontend.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Frontend.Ingress.sourcegraph-frontend.metadata.namespace
               = finalNamespace

let applyNamespacef53
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Frontend.Role.sourcegraph-frontend.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Frontend.Role.sourcegraph-frontend.metadata.namespace
               = finalNamespace

let applyNamespacef54
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Github-Proxy.Deployment.github-proxy.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Github-Proxy.Deployment.github-proxy.metadata.namespace
               = finalNamespace

let applyNamespacef55
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Github-Proxy.Service.github-proxy.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Github-Proxy.Service.github-proxy.metadata.namespace
               = finalNamespace

let applyNamespacef56
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Pgsql.ConfigMap.pgsql-conf.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Pgsql.ConfigMap.pgsql-conf.metadata.namespace = finalNamespace

let applyNamespacef57
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Pgsql.Deployment.pgsql.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Pgsql.Deployment.pgsql.metadata.namespace = finalNamespace

let applyNamespacef58
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace =
              base.Pgsql.PersistentVolumeClaim.pgsql.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Pgsql.PersistentVolumeClaim.pgsql.metadata.namespace
               = finalNamespace

let applyNamespacef59
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let baseNamespace = base.Pgsql.Service.pgsql.metadata.namespace

        let overlayNamespace = overlay.Shared.namespace

        let finalNamespace =
              merge
                { Some = λ(x : Text) → Some x, None = baseNamespace }
                overlayNamespace

        in  base
          with Pgsql.Service.pgsql.metadata.namespace = finalNamespace

let applyAll
    : baseSchema.Type → overlaySchema.Type → baseSchema.Type
    = λ(base : baseSchema.Type) →
      λ(overlay : overlaySchema.Type) →
        let r = base

        let r = applyNamespacef0 r overlay

        let r = applyNamespacef1 r overlay

        let r = applyNamespacef2 r overlay

        let r = applyNamespacef3 r overlay

        let r = applyNamespacef4 r overlay

        let r = applyNamespacef5 r overlay

        let r = applyNamespacef6 r overlay

        let r = applyNamespacef7 r overlay

        let r = applyNamespacef8 r overlay

        let r = applyNamespacef9 r overlay

        let r = applyNamespacef10 r overlay

        let r = applyNamespacef11 r overlay

        let r = applyNamespacef12 r overlay

        let r = applyNamespacef13 r overlay

        let r = applyNamespacef14 r overlay

        let r = applyNamespacef15 r overlay

        let r = applyNamespacef16 r overlay

        let r = applyNamespacef17 r overlay

        let r = applyNamespacef18 r overlay

        let r = applyNamespacef19 r overlay

        let r = applyNamespacef20 r overlay

        let r = applyNamespacef21 r overlay

        let r = applyNamespacef22 r overlay

        let r = applyNamespacef23 r overlay

        let r = applyNamespacef24 r overlay

        let r = applyNamespacef25 r overlay

        let r = applyNamespacef26 r overlay

        let r = applyNamespacef27 r overlay

        let r = applyNamespacef28 r overlay

        let r = applyNamespacef29 r overlay

        let r = applyNamespacef30 r overlay

        let r = applyNamespacef31 r overlay

        let r = applyNamespacef32 r overlay

        let r = applyNamespacef33 r overlay

        let r = applyNamespacef34 r overlay

        let r = applyNamespacef35 r overlay

        let r = applyNamespacef36 r overlay

        let r = applyNamespacef37 r overlay

        let r = applyNamespacef38 r overlay

        let r = applyNamespacef39 r overlay

        let r = applyNamespacef40 r overlay

        let r = applyNamespacef41 r overlay

        let r = applyNamespacef42 r overlay

        let r = applyNamespacef43 r overlay

        let r = applyNamespacef44 r overlay

        let r = applyNamespacef45 r overlay

        let r = applyNamespacef46 r overlay

        let r = applyNamespacef47 r overlay

        let r = applyNamespacef48 r overlay

        let r = applyNamespacef49 r overlay

        let r = applyNamespacef50 r overlay

        let r = applyNamespacef51 r overlay

        let r = applyNamespacef52 r overlay

        let r = applyNamespacef53 r overlay

        let r = applyNamespacef54 r overlay

        let r = applyNamespacef55 r overlay

        let r = applyNamespacef56 r overlay

        let r = applyNamespacef57 r overlay

        let r = applyNamespacef58 r overlay

        let r = applyNamespacef59 r overlay

        in  r

in  applyAll