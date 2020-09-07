{ Frontend =
  { Deployment.sourcegraph-frontend =
    { apiVersion = "apps/v1"
    , kind = "Deployment"
    , metadata =
      { annotations.description =
          "Serves the frontend of Sourcegraph via HTTP(S)."
      , labels =
        { `app.kubernetes.io/component` = "frontend"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "sourcegraph-frontend"
      }
    , spec =
      { minReadySeconds = 10
      , replicas = 1
      , revisionHistoryLimit = 10
      , selector.matchLabels.app = "sourcegraph-frontend"
      , strategy =
        { rollingUpdate = { maxSurge = 2, maxUnavailable = 0 }
        , type = "RollingUpdate"
        }
      , template =
        { metadata.labels =
          { app = "sourcegraph-frontend", deploy = "sourcegraph" }
        , spec =
          { containers =
            { frontend =
              { args = [ "serve" ]
              , env =
                { CACHE_DIR =
                  { name = "CACHE_DIR", value = "/mnt/cache/\$(POD_NAME)" }
                , GRAFANA_SERVER_URL =
                  { name = "GRAFANA_SERVER_URL"
                  , value = "http://grafana:30070"
                  }
                , JAEGER_SERVER_URL =
                  { name = "JAEGER_SERVER_URL"
                  , value = "http://jaeger-query:16686"
                  }
                , PGDATABASE = { name = "PGDATABASE", value = "sg" }
                , PGHOST = { name = "PGHOST", value = "pgsql" }
                , PGPORT = { name = "PGPORT", value = "5432" }
                , PGSSLMODE = { name = "PGSSLMODE", value = "disable" }
                , PGUSER = { name = "PGUSER", value = "sg" }
                , POD_NAME =
                  { name = "POD_NAME"
                  , valueFrom.fieldRef.fieldPath = "metadata.name"
                  }
                , PRECISE_CODE_INTEL_BUNDLE_MANAGER_URL =
                  { name = "PRECISE_CODE_INTEL_BUNDLE_MANAGER_URL"
                  , value = "http://precise-code-intel-bundle-manager:3187"
                  }
                , PROMETHEUS_URL =
                  { name = "PROMETHEUS_URL", value = "http://prometheus:30090" }
                , SRC_GIT_SERVERS =
                  { name = "SRC_GIT_SERVERS"
                  , value = "gitserver-0.gitserver:3178"
                  }
                }
              , image =
                { name = "sourcegraph/frontend"
                , registry = "index.docker.io"
                , sha256 =
                    "776606b680d7ce4a5d37451831ef2414ab10414b5e945ed5f50fe768f898d23f"
                , version = "3.19.2"
                }
              , livenessProbe =
                { httpGet =
                  { path = "/healthz", port = "http", scheme = "HTTP" }
                , initialDelaySeconds = 300
                , timeoutSeconds = 5
                }
              , name = "frontend"
              , ports =
                { http = { containerPort = 3080, name = "http" }
                , http-internal =
                  { containerPort = 3090, name = "http-internal" }
                }
              , readinessProbe =
                { httpGet =
                  { path = "/healthz", port = "http", scheme = "HTTP" }
                , periodSeconds = 5
                , timeoutSeconds = 5
                }
              , resources =
                { limits =
                  { cpu = Some "2"
                  , ephemeralStorage = None Text
                  , memory = Some "4G"
                  }
                , requests =
                  { cpu = Some "2"
                  , ephemeralStorage = None Text
                  , memory = Some "2G"
                  }
                }
              , terminationMessagePolicy = "FallbackToLogsOnError"
              , volumeMounts.cache-ssd =
                { mountPath = "/mnt/cache", name = "cache-ssd" }
              }
            , jaeger-agent =
              { args =
                [ "--reporter.grpc.host-port=jaeger-collector:14250"
                , "--reporter.type=grpc"
                ]
              , env.POD_NAME =
                { name = "POD_NAME"
                , valueFrom.fieldRef =
                  { apiVersion = "v1", fieldPath = "metadata.name" }
                }
              , image =
                { name = "sourcegraph/jaeger-agent"
                , registry = "index.docker.io"
                , sha256 =
                    "e757094c04559780dba1ded3475ee5f0e4e5330aa6bbc8a7398e7277b0e450fe"
                , version = "3.19.2"
                }
              , name = "jaeger-agent"
              , ports =
                [ { containerPort = 5775, protocol = "UDP" }
                , { containerPort = 5778, protocol = "TCP" }
                , { containerPort = 6831, protocol = "UDP" }
                , { containerPort = 6832, protocol = "UDP" }
                ]
              , resources =
                { limits =
                  { cpu = Some "1"
                  , ephemeralStorage = None Text
                  , memory = Some "500M"
                  }
                , requests =
                  { cpu = Some "100m"
                  , ephemeralStorage = None Text
                  , memory = Some "100M"
                  }
                }
              }
            }
          , securityContext.runAsUser = 0
          , serviceAccountName = "sourcegraph-frontend"
          , volumes.cache-ssd = { emptyDir = {=}, name = "cache-ssd" }
          }
        }
      }
    }
  , Ingress.sourcegraph-frontend =
    { apiVersion = "networking.k8s.io/v1beta1"
    , kind = "Ingress"
    , metadata =
      { annotations =
        { `kubernetes.io/ingress.class` = "nginx"
        , `nginx.ingress.kubernetes.io/proxy-body-size` = "150m"
        }
      , labels =
        { app = "sourcegraph-frontend"
        , `app.kubernetes.io/component` = "frontend"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "sourcegraph-frontend"
      }
    , spec.rules =
      [ { http.paths =
          [ { backend =
              { serviceName = "sourcegraph-frontend", servicePort = 30080 }
            , path = "/"
            }
          ]
        }
      ]
    }
  , Role.sourcegraph-frontend =
    { apiVersion = "rbac.authorization.k8s.io/v1"
    , kind = "Role"
    , metadata =
      { labels =
        { `app.kubernetes.io/component` = "frontend"
        , category = "rbac"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "cluster-admin"
        }
      , name = "sourcegraph-frontend"
      }
    , rules =
      [ { apiGroups = [ "" ]
        , resources = [ "endpoints", "services" ]
        , verbs = [ "get", "list", "watch" ]
        }
      ]
    }
  , RoleBinding.sourcegraph-frontend =
    { apiVersion = "rbac.authorization.k8s.io/v1"
    , kind = "RoleBinding"
    , metadata =
      { labels =
        { `app.kubernetes.io/component` = "frontend"
        , category = "rbac"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "cluster-admin"
        }
      , name = "sourcegraph-frontend"
      }
    , roleRef = { apiGroup = "", kind = "Role", name = "sourcegraph-frontend" }
    , subjects.sourcegraph-frontend =
      { kind = "ServiceAccount", name = "sourcegraph-frontend" }
    }
  , Service =
    { sourcegraph-frontend =
      { apiVersion = "v1"
      , kind = "Service"
      , metadata =
        { annotations =
          { `prometheus.io/port` = "6060"
          , `sourcegraph.prometheus/scrape` = "true"
          }
        , labels =
          { app = "sourcegraph-frontend"
          , `app.kubernetes.io/component` = "frontend"
          , deploy = "sourcegraph"
          , sourcegraph-resource-requires = "no-cluster-admin"
          }
        , name = "sourcegraph-frontend"
        }
      , spec =
        { ports.http = { name = "http", port = 30080, targetPort = "http" }
        , selector.app = "sourcegraph-frontend"
        , type = "ClusterIP"
        }
      }
    , sourcegraph-frontend-internal =
      { apiVersion = "v1"
      , kind = "Service"
      , metadata =
        { labels =
          { app = "sourcegraph-frontend"
          , `app.kubernetes.io/component` = "frontend"
          , deploy = "sourcegraph"
          , sourcegraph-resource-requires = "no-cluster-admin"
          }
        , name = "sourcegraph-frontend-internal"
        }
      , spec =
        { ports.http-internal =
          { name = "http-internal", port = 80, targetPort = "http-internal" }
        , selector.app = "sourcegraph-frontend"
        , type = "ClusterIP"
        }
      }
    }
  , ServiceAccount.sourcegraph-frontend =
    { apiVersion = "v1"
    , imagePullSecrets.docker-registry.name = "docker-registry"
    , kind = "ServiceAccount"
    , metadata =
      { labels =
        { `app.kubernetes.io/component` = "frontend"
        , category = "rbac"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "sourcegraph-frontend"
      }
    }
  }
, Indexed-Search =
  { Service =
    { indexed-search =
      { apiVersion = "v1"
      , kind = "Service"
      , metadata =
        { annotations =
          { description =
              "Headless service that provides a stable network identity for the indexed-search stateful set."
          , `prometheus.io/port` = "6070"
          , `sourcegraph.prometheus/scrape` = "true"
          }
        , labels =
          { app = "indexed-search"
          , `app.kubernetes.io/component` = "indexed-search"
          , deploy = "sourcegraph"
          , sourcegraph-resource-requires = "no-cluster-admin"
          }
        , name = "indexed-search"
        }
      , spec =
        { clusterIP = "None"
        , ports = [ { port = 6070 } ]
        , selector.app = "indexed-search"
        , type = "ClusterIP"
        }
      }
    , indexed-search-indexer =
      { apiVersion = "v1"
      , kind = "Service"
      , metadata =
        { annotations =
          { description =
              "Headless service that provides a stable network identity for the indexed-search stateful set."
          , `prometheus.io/port` = "6072"
          , `sourcegraph.prometheus/scrape` = "true"
          }
        , labels =
          { app = "indexed-search-indexer"
          , `app.kubernetes.io/component` = "indexed-search"
          , deploy = "sourcegraph"
          , sourcegraph-resource-requires = "no-cluster-admin"
          }
        , name = "indexed-search-indexer"
        }
      , spec =
        { clusterIP = "None"
        , ports = [ { port = 6072, targetPort = 6072 } ]
        , selector.app = "indexed-search"
        , type = "ClusterIP"
        }
      }
    }
  , StatefulSet.indexed-search =
    { apiVersion = "apps/v1"
    , kind = "StatefulSet"
    , metadata =
      { annotations.description = "Backend for indexed text search operations."
      , labels =
        { `app.kubernetes.io/component` = "indexed-search"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "indexed-search"
      }
    , spec =
      { replicas = 1
      , revisionHistoryLimit = 10
      , selector.matchLabels.app = "indexed-search"
      , serviceName = "indexed-search"
      , template =
        { metadata.labels = { app = "indexed-search", deploy = "sourcegraph" }
        , spec =
          { containers =
            { zoekt-indexserver =
              { env = None <>
              , image =
                { name = "sourcegraph/search-indexer"
                , registry = "index.docker.io"
                , sha256 =
                    "7ddeb4d06a89e086506f08d9a114186260c7fa6c242e59be8c28b505d506047a"
                , version = "3.19.2"
                }
              , name = "zoekt-indexserver"
              , ports.index-http = { containerPort = 6072, name = "index-http" }
              , resources =
                { limits =
                  { cpu = Some "8"
                  , ephemeralStorage = None Text
                  , memory = Some "8G"
                  }
                , requests =
                  { cpu = Some "4"
                  , ephemeralStorage = None Text
                  , memory = Some "4G"
                  }
                }
              , terminationMessagePolicy = "FallbackToLogsOnError"
              , volumeMounts.data = { mountPath = "/data", name = "data" }
              }
            , zoekt-webserver =
              { env = None <>
              , image =
                { name = "sourcegraph/indexed-searcher"
                , registry = "index.docker.io"
                , sha256 =
                    "d2e87635cf48c4c5d744962540751022013359bc00a9fb8e1ec2464cc6a0a2b8"
                , version = "3.19.2"
                }
              , name = "zoekt-webserver"
              , ports.http = { containerPort = 6070, name = "http" }
              , readinessProbe =
                { failureThreshold = 3
                , httpGet =
                  { path = "/healthz", port = "http", scheme = "HTTP" }
                , periodSeconds = 5
                , timeoutSeconds = 5
                }
              , resources =
                { limits =
                  { cpu = Some "2"
                  , ephemeralStorage = None Text
                  , memory = Some "4G"
                  }
                , requests =
                  { cpu = Some "500m"
                  , ephemeralStorage = None Text
                  , memory = Some "2G"
                  }
                }
              , terminationMessagePolicy = "FallbackToLogsOnError"
              , volumeMounts.data = { mountPath = "/data", name = "data" }
              }
            }
          , securityContext.runAsUser = 0
          , volumes.data.name = "data"
          }
        }
      , updateStrategy.type = "RollingUpdate"
      , volumeClaimTemplates =
        [ { apiVersion = "apps/v1"
          , kind = "PersistentVolumeClaim"
          , metadata = { labels.deploy = "sourcegraph", name = "data" }
          , spec =
            { accessModes = [ "ReadWriteOnce" ]
            , resources.requests =
              { cpu = None Text
              , ephemeralStorage = None Text
              , memory = None Text
              }
            , storageClassName = "sourcegraph"
            }
          }
        ]
      }
    }
  }
}