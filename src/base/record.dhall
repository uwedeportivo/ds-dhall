{ Base =
  { Service.backend =
    { apiVersion = "v1"
    , kind = "Service"
    , metadata =
      { annotations.description =
          "Dummy service that prevents backend pods from being scheduled on the same node if possible."
      , labels =
        { deploy = "sourcegraph"
        , group = "backend"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "backend"
      , namespace = None Text
      }
    , spec =
      { clusterIP = "None"
      , ports.unused = { name = "unused", port = 10811, targetPort = 10811 }
      , selector.group = "backend"
      , type = "ClusterIP"
      }
    }
  , StorageClass.sourcegraph =
    { apiVersion = "storage.k8s.io/v1"
    , kind = "StorageClass"
    , metadata =
      { labels =
        { deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin-storage"
        }
      , name = "sourcegraph"
      , namespace = None Text
      }
    , parameters.type = "pd-ssd"
    , provisioner = "kubernetes.io/gce-pd"
    }
  }
, Cadvisor =
  { ClusterRole.cadvisor =
    { apiVersion = "rbac.authorization.k8s.io/v1"
    , kind = "ClusterRole"
    , metadata =
      { labels =
        { app = "cadvisor"
        , `app.kubernetes.io/component` = "cadvisor"
        , category = "rbac"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "cluster-admin"
        }
      , name = "cadvisor"
      , namespace = None Text
      }
    , rules =
      [ { apiGroups = [ "policy" ]
        , resourceNames = [ "cadvisor" ]
        , resources = [ "podsecuritypolicies" ]
        , verbs = [ "use" ]
        }
      ]
    }
  , ClusterRoleBinding.cadvisor =
    { apiVersion = "rbac.authorization.k8s.io/v1"
    , kind = "ClusterRoleBinding"
    , metadata =
      { labels =
        { app = "cadvisor"
        , `app.kubernetes.io/component` = "cadvisor"
        , category = "rbac"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "cluster-admin"
        }
      , name = "cadvisor"
      , namespace = None Text
      }
    , roleRef =
      { apiGroup = "rbac.authorization.k8s.io"
      , kind = "ClusterRole"
      , name = "cadvisor"
      }
    , subjects.cadvisor =
      { kind = "ServiceAccount", name = "cadvisor", namespace = "default" }
    }
  , DaemonSet.cadvisor =
    { apiVersion = "apps/v1"
    , kind = "DaemonSet"
    , metadata =
      { annotations =
        { description = "DaemonSet to ensure all nodes run a cAdvisor pod."
        , `seccomp.security.alpha.kubernetes.io/pod` = "docker/default"
        }
      , labels =
        { `app.kubernetes.io/component` = "cadvisor"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "cluster-admin"
        }
      , name = "cadvisor"
      , namespace = None Text
      }
    , spec =
      { selector.matchLabels.app = "cadvisor"
      , template =
        { metadata =
          { annotations =
            { description = "Collects and exports container metrics."
            , `prometheus.io/port` = "48080"
            , `sourcegraph.prometheus/scrape` = "true"
            }
          , labels = { app = "cadvisor", deploy = "sourcegraph" }
          , namespace = None Text
          }
        , spec =
          { automountServiceAccountToken = False
          , containers.cadvisor =
            { args =
              [ "--store_container_labels=false"
              , "--whitelisted_container_labels=io.kubernetes.container.name,io.kubernetes.pod.name,io.kubernetes.pod.namespace,io.kubernetes.pod.uid"
              ]
            , image =
                < asRecord :
                    { name : Text
                    , registry : Text
                    , sha256 : Text
                    , version : Text
                    }
                | asText : Text
                >.asRecord
                  { name = "sourcegraph/cadvisor"
                  , registry = "index.docker.io"
                  , sha256 =
                      "76276b4b464154d0329c7d960fdfcb2c627784a0e809243cc53d3e5dea6f19c8"
                  , version = "3.19.2"
                  }
            , name = "cadvisor"
            , ports.http =
              { containerPort = 48080, name = "http", protocol = "TCP" }
            , resources =
              { limits =
                { cpu = Some "300m"
                , ephemeralStorage = None Text
                , memory = Some "2000Mi"
                }
              , requests =
                { cpu = Some "150m"
                , ephemeralStorage = None Text
                , memory = Some "200Mi"
                }
              }
            , volumeMounts =
              { disk =
                { mountPath = "/dev/disk", name = "disk", readOnly = True }
              , docker =
                { mountPath = "/var/lib/docker"
                , name = "docker"
                , readOnly = True
                }
              , rootfs =
                { mountPath = "/rootfs", name = "rootfs", readOnly = True }
              , sys = { mountPath = "/sys", name = "sys", readOnly = True }
              , var-run =
                { mountPath = "/var/run", name = "var-run", readOnly = True }
              }
            }
          , serviceAccountName = "cadvisor"
          , terminationGracePeriodSeconds = 30
          , volumes =
            { disk = { hostPath.path = "/dev/disk", name = "disk" }
            , docker = { hostPath.path = "/var/lib/docker", name = "docker" }
            , rootfs = { hostPath.path = "/", name = "rootfs" }
            , sys = { hostPath.path = "/sys", name = "sys" }
            , var-run = { hostPath.path = "/var/run", name = "var-run" }
            }
          }
        }
      }
    }
  , PodSecurityPolicy.cadvisor =
    { apiVersion = "policy/v1beta1"
    , kind = "PodSecurityPolicy"
    , metadata =
      { labels =
        { app = "cadvisor"
        , `app.kubernetes.io/component` = "cadvisor"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "cluster-admin"
        }
      , name = "cadvisor"
      , namespace = None Text
      }
    , spec =
      { allowedHostPaths =
        [ { pathPrefix = "/" }
        , { pathPrefix = "/var/run" }
        , { pathPrefix = "/sys" }
        , { pathPrefix = "/var/lib/docker" }
        , { pathPrefix = "/dev/disk" }
        ]
      , fsGroup.rule = "RunAsAny"
      , runAsUser.rule = "RunAsAny"
      , seLinux.rule = "RunAsAny"
      , supplementalGroups.rule = "RunAsAny"
      , volumes = [ "*" ]
      }
    }
  , ServiceAccount.cadvisor =
    { apiVersion = "v1"
    , kind = "ServiceAccount"
    , metadata =
      { labels =
        { app = "cadvisor"
        , `app.kubernetes.io/component` = "cadvisor"
        , category = "rbac"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "cluster-admin"
        }
      , name = "cadvisor"
      , namespace = None Text
      }
    }
  }
, Frontend =
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
      , namespace = None Text
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
        { metadata =
          { labels = { app = "sourcegraph-frontend", deploy = "sourcegraph" }
          , namespace = None Text
          }
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
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
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
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
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
      , namespace = None Text
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
      , namespace = None Text
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
      , namespace = None Text
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
        , namespace = None Text
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
        , namespace = None Text
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
      , namespace = None Text
      }
    }
  }
, Github-Proxy =
  { Deployment.github-proxy =
    { apiVersion = "apps/v1"
    , kind = "Deployment"
    , metadata =
      { annotations.description = "Rate-limiting proxy for the GitHub API."
      , labels =
        { `app.kubernetes.io/component` = "github-proxy"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "github-proxy"
      , namespace = None Text
      }
    , spec =
      { minReadySeconds = 10
      , replicas = 1
      , revisionHistoryLimit = 10
      , selector.matchLabels.app = "github-proxy"
      , strategy =
        { rollingUpdate = { maxSurge = 1, maxUnavailable = 0 }
        , type = "RollingUpdate"
        }
      , template =
        { metadata =
          { labels = { app = "github-proxy", deploy = "sourcegraph" }
          , namespace = None Text
          }
        , spec =
          { containers =
            { github-proxy =
              { env = None <>
              , image =
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
                    { name = "sourcegraph/github-proxy"
                    , registry = "index.docker.io"
                    , sha256 =
                        "bf435dd750c46840e2b45696577e0d94aac7a0afedf43428c2073a85c429843c"
                    , version = "3.19.2"
                    }
              , name = "github-proxy"
              , ports.http = { containerPort = 3180, name = "http" }
              , resources =
                { limits =
                  { cpu = Some "1"
                  , ephemeralStorage = None Text
                  , memory = Some "1G"
                  }
                , requests =
                  { cpu = Some "100m"
                  , ephemeralStorage = None Text
                  , memory = Some "250M"
                  }
                }
              , terminationMessagePolicy = "FallbackToLogsOnError"
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
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
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
          }
        }
      }
    }
  , Service.github-proxy =
    { apiVersion = "v1"
    , kind = "Service"
    , metadata =
      { annotations =
        { `prometheus.io/port` = "6060"
        , `sourcegraph.prometheus/scrape` = "true"
        }
      , labels =
        { app = "github-proxy"
        , `app.kubernetes.io/component` = "github-proxy"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "github-proxy"
      , namespace = None Text
      }
    , spec =
      { ports.http = { name = "http", port = 80, targetPort = "http" }
      , selector.app = "github-proxy"
      , type = "ClusterIP"
      }
    }
  }
, Gitserver =
  { Service.gitserver =
    { apiVersion = "v1"
    , kind = "Service"
    , metadata =
      { annotations =
        { description =
            "Headless service that provides a stable network identity for the gitserver stateful set."
        , `prometheus.io/port` = "6060"
        , `sourcegraph.prometheus/scrape` = "true"
        }
      , labels =
        { app = "gitserver"
        , `app.kubernetes.io/component` = "gitserver"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        , type = "gitserver"
        }
      , name = "gitserver"
      , namespace = None Text
      }
    , spec =
      { clusterIP = "None"
      , ports.unused = { name = "unused", port = 10811, targetPort = 10811 }
      , selector = { app = "gitserver", type = "gitserver" }
      , type = "ClusterIP"
      }
    }
  , StatefulSet.gitserver =
    { apiVersion = "apps/v1"
    , kind = "StatefulSet"
    , metadata =
      { annotations.description =
          "Stores clones of repositories to perform Git operations."
      , labels =
        { `app.kubernetes.io/component` = "gitserver"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "gitserver"
      , namespace = None Text
      }
    , spec =
      { replicas = 1
      , revisionHistoryLimit = 10
      , selector.matchLabels.app = "gitserver"
      , serviceName = "gitserver"
      , template =
        { metadata =
          { labels =
            { app = "gitserver"
            , deploy = "sourcegraph"
            , group = "backend"
            , type = "gitserver"
            }
          , namespace = None Text
          }
        , spec =
          { containers =
            { gitserver =
              { args = [ "run" ]
              , env = None <>
              , image =
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
                    { name = "sourcegraph/gitserver"
                    , registry = "index.docker.io"
                    , sha256 =
                        "51b827ff2bf3f9df740cd8538840ef7fd7cb245c7b93063ef829f67ca71ea23e"
                    , version = "3.19.2"
                    }
              , livenessProbe =
                { initialDelaySeconds = 5
                , tcpSocket.port = "rpc"
                , timeoutSeconds = 5
                }
              , name = "gitserver"
              , ports.rpc = { containerPort = 3178, name = "rpc" }
              , resources =
                { limits =
                  { cpu = Some "4"
                  , ephemeralStorage = None Text
                  , memory = Some "8G"
                  }
                , requests =
                  { cpu = Some "4"
                  , ephemeralStorage = None Text
                  , memory = Some "8G"
                  }
                }
              , terminationMessagePolicy = "FallbackToLogsOnError"
              , volumeMounts.repos =
                { mountPath = "/data/repos", name = "repos" }
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
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
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
          , volumes.repos.name = "repos"
          }
        }
      , updateStrategy.type = "RollingUpdate"
      , volumeClaimTemplates =
        [ { apiVersion = "apps/v1"
          , kind = "PersistentVolumeClaim"
          , metadata = { name = "repos", namespace = None Text }
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
, Grafana =
  { ConfigMap.grafana =
    { apiVersion = "v1"
    , data.`datasources.yml` =
        ''
        apiVersion: 1

        datasources:
          - name: Prometheus
            type: prometheus
            access: proxy
            url: http://prometheus:30090
            isDefault: true
            editable: false
          - name: Jaeger
            type: Jaeger
            access: proxy
            url: http://jaeger-query:16686/-/debug/jaeger
        ''
    , kind = "ConfigMap"
    , metadata =
      { labels =
        { `app.kubernetes.io/component` = "grafana"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "grafana"
      , namespace = None Text
      }
    }
  , Service.grafana =
    { apiVersion = "v1"
    , kind = "Service"
    , metadata =
      { labels =
        { app = "grafana"
        , `app.kubernetes.io/component` = "grafana"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "grafana"
      , namespace = None Text
      }
    , spec =
      { ports.http = { name = "http", port = 30070, targetPort = "http" }
      , selector.app = "grafana"
      , type = "ClusterIP"
      }
    }
  , ServiceAccount.grafana =
    { apiVersion = "v1"
    , imagePullSecrets.docker-registry.name = "docker-registry"
    , kind = "ServiceAccount"
    , metadata =
      { labels =
        { `app.kubernetes.io/component` = "grafana"
        , category = "rbac"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "grafana"
      , namespace = None Text
      }
    }
  , StatefulSet.grafana =
    { apiVersion = "apps/v1"
    , kind = "StatefulSet"
    , metadata =
      { annotations.description = "Metrics/monitoring dashboards and alerts."
      , labels =
        { `app.kubernetes.io/component` = "grafana"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "grafana"
      , namespace = None Text
      }
    , spec =
      { replicas = 1
      , revisionHistoryLimit = 10
      , selector.matchLabels.app = "grafana"
      , serviceName = "grafana"
      , template =
        { metadata =
          { labels = { app = "grafana", deploy = "sourcegraph" }
          , namespace = None Text
          }
        , spec =
          { containers.grafana =
            { image =
                < asRecord :
                    { name : Text
                    , registry : Text
                    , sha256 : Text
                    , version : Text
                    }
                | asText : Text
                >.asRecord
                  { name = "sourcegraph/grafana"
                  , registry = "index.docker.io"
                  , sha256 =
                      "0f363ceecf8d206b16afa16716365949c882016a040c3b04a0041252ff8dbb11"
                  , version = "3.19.2"
                  }
            , name = "grafana"
            , ports.http = { containerPort = 3370, name = "http" }
            , resources =
              { limits =
                { cpu = Some "1"
                , ephemeralStorage = None Text
                , memory = Some "512Mi"
                }
              , requests =
                { cpu = Some "100m"
                , ephemeralStorage = None Text
                , memory = Some "512Mi"
                }
              }
            , terminationMessagePolicy = "FallbackToLogsOnError"
            , volumeMounts =
              { config =
                { mountPath = "/sg_config_grafana/provisioning/datasources"
                , name = "config"
                }
              , grafana-data =
                { mountPath = "/var/lib/grafana", name = "grafana-data" }
              }
            }
          , securityContext.runAsUser = 0
          , serviceAccountName = "grafana"
          , volumes.config =
            { configMap = { defaultMode = 511, name = "grafana" }
            , name = "config"
            }
          }
        }
      , updateStrategy.type = "RollingUpdate"
      , volumeClaimTemplates =
        [ { apiVersion = "apps/v1"
          , kind = "PersistentVolumeClaim"
          , metadata = { name = "grafana-data", namespace = None Text }
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
        , namespace = None Text
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
        , namespace = None Text
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
      , namespace = None Text
      }
    , spec =
      { replicas = 1
      , revisionHistoryLimit = 10
      , selector.matchLabels.app = "indexed-search"
      , serviceName = "indexed-search"
      , template =
        { metadata =
          { labels = { app = "indexed-search", deploy = "sourcegraph" }
          , namespace = None Text
          }
        , spec =
          { containers =
            { zoekt-indexserver =
              { env = None <>
              , image =
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
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
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
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
          , metadata =
            { labels.deploy = "sourcegraph"
            , name = "data"
            , namespace = None Text
            }
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
, Jaeger =
  { Deployment.jaeger =
    { apiVersion = "apps/v1"
    , kind = "Deployment"
    , metadata =
      { labels =
        { app = "jaeger"
        , `app.kubernetes.io/component` = "jaeger"
        , `app.kubernetes.io/name` = "jaeger"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "jaeger"
      , namespace = None Text
      }
    , spec =
      { replicas = 1
      , selector.matchLabels =
        { app = "jaeger"
        , `app.kubernetes.io/component` = "all-in-one"
        , `app.kubernetes.io/name` = "jaeger"
        }
      , strategy.type = "Recreate"
      , template =
        { metadata =
          { annotations =
            { `prometheus.io/port` = "16686", `prometheus.io/scrape` = "true" }
          , labels =
            { app = "jaeger"
            , `app.kubernetes.io/component` = "all-in-one"
            , `app.kubernetes.io/name` = "jaeger"
            , deploy = "sourcegraph"
            }
          , namespace = None Text
          }
        , spec =
          { containers.jaeger =
            { args = [ "--memory.max-traces=20000" ]
            , image =
                < asRecord :
                    { name : Text
                    , registry : Text
                    , sha256 : Text
                    , version : Text
                    }
                | asText : Text
                >.asRecord
                  { name = "sourcegraph/jaeger-all-in-one"
                  , registry = "index.docker.io"
                  , sha256 =
                      "fe04ae824252cb7bfb7047242d5f5da3a8491681b4007213c5d989d761f226ca"
                  , version = "3.19.2"
                  }
            , name = "jaeger"
            , ports =
              [ { containerPort = 5775, protocol = "UDP" }
              , { containerPort = 6831, protocol = "UDP" }
              , { containerPort = 6832, protocol = "UDP" }
              , { containerPort = 5778, protocol = "TCP" }
              , { containerPort = 16686, protocol = "TCP" }
              , { containerPort = 14250, protocol = "TCP" }
              ]
            , readinessProbe =
              { httpGet = { path = "/", port = 14269 }
              , initialDelaySeconds = 5
              }
            , resources =
              { limits =
                { cpu = Some "1"
                , ephemeralStorage = None Text
                , memory = Some "1G"
                }
              , requests =
                { cpu = Some "500m"
                , ephemeralStorage = None Text
                , memory = Some "500M"
                }
              }
            }
          , securityContext.runAsUser = 0
          }
        }
      }
    }
  , Service =
    { jaeger-collector =
      { apiVersion = "v1"
      , kind = "Service"
      , metadata =
        { labels =
          { app = "jaeger"
          , `app.kubernetes.io/component` = "jaeger"
          , `app.kubernetes.io/name` = "jaeger"
          , deploy = "sourcegraph"
          , sourcegraph-resource-requires = "no-cluster-admin"
          }
        , name = "jaeger-collector"
        , namespace = None Text
        }
      , spec =
        { ports =
          { jaeger-collector-grpc =
            { name = "jaeger-collector-grpc"
            , port = 14250
            , protocol = "TCP"
            , targetPort = 14250
            }
          , jaeger-collector-http =
            { name = "jaeger-collector-http"
            , port = 14268
            , protocol = "TCP"
            , targetPort = 14268
            }
          , jaeger-collector-tchannel =
            { name = "jaeger-collector-tchannel"
            , port = 14267
            , protocol = "TCP"
            , targetPort = 14267
            }
          }
        , selector =
          { `app.kubernetes.io/component` = "all-in-one"
          , `app.kubernetes.io/name` = "jaeger"
          }
        , type = "ClusterIP"
        }
      }
    , jaeger-query =
      { apiVersion = "v1"
      , kind = "Service"
      , metadata =
        { labels =
          { app = "jaeger"
          , `app.kubernetes.io/component` = "jaeger"
          , `app.kubernetes.io/name` = "jaeger"
          , deploy = "sourcegraph"
          , sourcegraph-resource-requires = "no-cluster-admin"
          }
        , name = "jaeger-query"
        , namespace = None Text
        }
      , spec =
        { ports.query-http =
          { name = "query-http"
          , port = 16686
          , protocol = "TCP"
          , targetPort = 16686
          }
        , selector =
          { `app.kubernetes.io/component` = "all-in-one"
          , `app.kubernetes.io/name` = "jaeger"
          }
        , type = "ClusterIP"
        }
      }
    }
  }
, Pgsql =
  { ConfigMap.pgsql-conf =
    { apiVersion = "v1"
    , data.`postgresql.conf` =
        ''
        # -----------------------------
        # PostgreSQL configuration file
        # -----------------------------
        #
        # This file consists of lines of the form:
        #
        #   name = value
        #
        # (The "=" is optional.)  Whitespace may be used.  Comments are introduced with
        # "#" anywhere on a line.  The complete list of parameter names and allowed
        # values can be found in the PostgreSQL documentation.
        #
        # The commented-out settings shown in this file represent the default values.
        # Re-commenting a setting is NOT sufficient to revert it to the default value;
        # you need to reload the server.
        #
        # This file is read on server startup and when the server receives a SIGHUP
        # signal.  If you edit the file on a running system, you have to SIGHUP the
        # server for the changes to take effect, run "pg_ctl reload", or execute
        # "SELECT pg_reload_conf()".  Some parameters, which are marked below,
        # require a server shutdown and restart to take effect.
        #
        # Any parameter can also be given as a command-line option to the server, e.g.,
        # "postgres -c log_connections=on".  Some parameters can be changed at run time
        # with the "SET" SQL command.
        #
        # Memory units:  kB = kilobytes        Time units:  ms  = milliseconds
        #                MB = megabytes                     s   = seconds
        #                GB = gigabytes                     min = minutes
        #                TB = terabytes                     h   = hours
        #                                                   d   = days


        #------------------------------------------------------------------------------
        # FILE LOCATIONS
        #------------------------------------------------------------------------------

        # The default values of these variables are driven from the -D command-line
        # option or PGDATA environment variable, represented here as ConfigDir.

        #data_directory = 'ConfigDir'		# use data in another directory
        					# (change requires restart)
        #hba_file = 'ConfigDir/pg_hba.conf'	# host-based authentication file
        					# (change requires restart)
        #ident_file = 'ConfigDir/pg_ident.conf'	# ident configuration file
        					# (change requires restart)

        # If external_pid_file is not explicitly set, no extra PID file is written.
        #external_pid_file = '''			# write an extra PID file
        					# (change requires restart)


        #------------------------------------------------------------------------------
        # CONNECTIONS AND AUTHENTICATION
        #------------------------------------------------------------------------------

        # - Connection Settings -

        listen_addresses = '*'
        					# comma-separated list of addresses;
        					# defaults to 'localhost'; use '*' for all
        					# (change requires restart)
        #port = 5432				# (change requires restart)
        max_connections = 100			# (change requires restart)
        #superuser_reserved_connections = 3	# (change requires restart)
        #unix_socket_directories = '/var/run/postgresql'	# comma-separated list of directories
        					# (change requires restart)
        #unix_socket_group = '''			# (change requires restart)
        #unix_socket_permissions = 0777		# begin with 0 to use octal notation
        					# (change requires restart)
        #bonjour = off				# advertise server via Bonjour
        					# (change requires restart)
        #bonjour_name = '''			# defaults to the computer name
        					# (change requires restart)

        # - TCP Keepalives -
        # see "man 7 tcp" for details

        #tcp_keepalives_idle = 0		# TCP_KEEPIDLE, in seconds;
        					# 0 selects the system default
        #tcp_keepalives_interval = 0		# TCP_KEEPINTVL, in seconds;
        					# 0 selects the system default
        #tcp_keepalives_count = 0		# TCP_KEEPCNT;
        					# 0 selects the system default

        # - Authentication -

        #authentication_timeout = 1min		# 1s-600s
        #password_encryption = md5		# md5 or scram-sha-256
        #db_user_namespace = off

        # GSSAPI using Kerberos
        #krb_server_keyfile = '''
        #krb_caseins_users = off

        # - SSL -

        #ssl = off
        #ssl_ca_file = '''
        #ssl_cert_file = 'server.crt'
        #ssl_crl_file = '''
        #ssl_key_file = 'server.key'
        #ssl_ciphers = 'HIGH:MEDIUM:+3DES:!aNULL' # allowed SSL ciphers
        #ssl_prefer_server_ciphers = on
        #ssl_ecdh_curve = 'prime256v1'
        #ssl_dh_params_file = '''
        #ssl_passphrase_command = '''
        #ssl_passphrase_command_supports_reload = off


        #------------------------------------------------------------------------------
        # RESOURCE USAGE (except WAL)
        #------------------------------------------------------------------------------

        # - Memory -

        shared_buffers = 128MB			# min 128kB
        					# (change requires restart)
        #huge_pages = try			# on, off, or try
        					# (change requires restart)
        #temp_buffers = 8MB			# min 800kB
        #max_prepared_transactions = 0		# zero disables the feature
        					# (change requires restart)
        # Caution: it is not advisable to set max_prepared_transactions nonzero unless
        # you actively intend to use prepared transactions.
        #work_mem = 4MB				# min 64kB
        #maintenance_work_mem = 64MB		# min 1MB
        #autovacuum_work_mem = -1		# min 1MB, or -1 to use maintenance_work_mem
        #max_stack_depth = 2MB			# min 100kB
        dynamic_shared_memory_type = posix	# the default is the first option
        					# supported by the operating system:
        					#   posix
        					#   sysv
        					#   windows
        					#   mmap
        					# use none to disable dynamic shared memory
        					# (change requires restart)

        # - Disk -

        #temp_file_limit = -1			# limits per-process temp file space
        					# in kB, or -1 for no limit

        # - Kernel Resources -

        #max_files_per_process = 1000		# min 25
        					# (change requires restart)

        # - Cost-Based Vacuum Delay -

        #vacuum_cost_delay = 0			# 0-100 milliseconds
        #vacuum_cost_page_hit = 1		# 0-10000 credits
        #vacuum_cost_page_miss = 10		# 0-10000 credits
        #vacuum_cost_page_dirty = 20		# 0-10000 credits
        #vacuum_cost_limit = 200		# 1-10000 credits

        # - Background Writer -

        #bgwriter_delay = 200ms			# 10-10000ms between rounds
        #bgwriter_lru_maxpages = 100		# max buffers written/round, 0 disables
        #bgwriter_lru_multiplier = 2.0		# 0-10.0 multiplier on buffers scanned/round
        #bgwriter_flush_after = 512kB		# measured in pages, 0 disables

        # - Asynchronous Behavior -

        #effective_io_concurrency = 1		# 1-1000; 0 disables prefetching
        #max_worker_processes = 8		# (change requires restart)
        #max_parallel_maintenance_workers = 2	# taken from max_parallel_workers
        #max_parallel_workers_per_gather = 2	# taken from max_parallel_workers
        #parallel_leader_participation = on
        #max_parallel_workers = 8		# maximum number of max_worker_processes that
        					# can be used in parallel operations
        #old_snapshot_threshold = -1		# 1min-60d; -1 disables; 0 is immediate
        					# (change requires restart)
        #backend_flush_after = 0		# measured in pages, 0 disables


        #------------------------------------------------------------------------------
        # WRITE-AHEAD LOG
        #------------------------------------------------------------------------------

        # - Settings -

        #wal_level = replica			# minimal, replica, or logical
        					# (change requires restart)
        #fsync = on				# flush data to disk for crash safety
        					# (turning this off can cause
        					# unrecoverable data corruption)
        #synchronous_commit = on		# synchronization level;
        					# off, local, remote_write, remote_apply, or on
        #wal_sync_method = fsync		# the default is the first option
        					# supported by the operating system:
        					#   open_datasync
        					#   fdatasync (default on Linux)
        					#   fsync
        					#   fsync_writethrough
        					#   open_sync
        #full_page_writes = on			# recover from partial page writes
        #wal_compression = off			# enable compression of full-page writes
        #wal_log_hints = off			# also do full page writes of non-critical updates
        					# (change requires restart)
        #wal_buffers = -1			# min 32kB, -1 sets based on shared_buffers
        					# (change requires restart)
        #wal_writer_delay = 200ms		# 1-10000 milliseconds
        #wal_writer_flush_after = 1MB		# measured in pages, 0 disables

        #commit_delay = 0			# range 0-100000, in microseconds
        #commit_siblings = 5			# range 1-1000

        # - Checkpoints -

        #checkpoint_timeout = 5min		# range 30s-1d
        max_wal_size = 1GB
        min_wal_size = 80MB
        #checkpoint_completion_target = 0.5	# checkpoint target duration, 0.0 - 1.0
        #checkpoint_flush_after = 256kB		# measured in pages, 0 disables
        #checkpoint_warning = 30s		# 0 disables

        # - Archiving -

        #archive_mode = off		# enables archiving; off, on, or always
        				# (change requires restart)
        #archive_command = '''		# command to use to archive a logfile segment
        				# placeholders: %p = path of file to archive
        				#               %f = file name only
        				# e.g. 'test ! -f /mnt/server/archivedir/%f && cp %p /mnt/server/archivedir/%f'
        #archive_timeout = 0		# force a logfile segment switch after this
        				# number of seconds; 0 disables


        #------------------------------------------------------------------------------
        # REPLICATION
        #------------------------------------------------------------------------------

        # - Sending Servers -

        # Set these on the master and on any standby that will send replication data.

        #max_wal_senders = 10		# max number of walsender processes
        				# (change requires restart)
        #wal_keep_segments = 0		# in logfile segments; 0 disables
        #wal_sender_timeout = 60s	# in milliseconds; 0 disables

        #max_replication_slots = 10	# max number of replication slots
        				# (change requires restart)
        #track_commit_timestamp = off	# collect timestamp of transaction commit
        				# (change requires restart)

        # - Master Server -

        # These settings are ignored on a standby server.

        #synchronous_standby_names = '''	# standby servers that provide sync rep
        				# method to choose sync standbys, number of sync standbys,
        				# and comma-separated list of application_name
        				# from standby(s); '*' = all
        #vacuum_defer_cleanup_age = 0	# number of xacts by which cleanup is delayed

        # - Standby Servers -

        # These settings are ignored on a master server.

        #hot_standby = on			# "off" disallows queries during recovery
        					# (change requires restart)
        #max_standby_archive_delay = 30s	# max delay before canceling queries
        					# when reading WAL from archive;
        					# -1 allows indefinite delay
        #max_standby_streaming_delay = 30s	# max delay before canceling queries
        					# when reading streaming WAL;
        					# -1 allows indefinite delay
        #wal_receiver_status_interval = 10s	# send replies at least this often
        					# 0 disables
        #hot_standby_feedback = off		# send info from standby to prevent
        					# query conflicts
        #wal_receiver_timeout = 60s		# time that receiver waits for
        					# communication from master
        					# in milliseconds; 0 disables
        #wal_retrieve_retry_interval = 5s	# time to wait before retrying to
        					# retrieve WAL after a failed attempt

        # - Subscribers -

        # These settings are ignored on a publisher.

        #max_logical_replication_workers = 4	# taken from max_worker_processes
        					# (change requires restart)
        #max_sync_workers_per_subscription = 2	# taken from max_logical_replication_workers


        #------------------------------------------------------------------------------
        # QUERY TUNING
        #------------------------------------------------------------------------------

        # - Planner Method Configuration -

        #enable_bitmapscan = on
        #enable_hashagg = on
        #enable_hashjoin = on
        #enable_indexscan = on
        #enable_indexonlyscan = on
        #enable_material = on
        #enable_mergejoin = on
        #enable_nestloop = on
        #enable_parallel_append = on
        #enable_seqscan = on
        #enable_sort = on
        #enable_tidscan = on
        #enable_partitionwise_join = off
        #enable_partitionwise_aggregate = off
        #enable_parallel_hash = on
        #enable_partition_pruning = on

        # - Planner Cost Constants -

        #seq_page_cost = 1.0			# measured on an arbitrary scale
        #random_page_cost = 4.0			# same scale as above
        #cpu_tuple_cost = 0.01			# same scale as above
        #cpu_index_tuple_cost = 0.005		# same scale as above
        #cpu_operator_cost = 0.0025		# same scale as above
        #parallel_tuple_cost = 0.1		# same scale as above
        #parallel_setup_cost = 1000.0	# same scale as above

        #jit_above_cost = 100000		# perform JIT compilation if available
        					# and query more expensive than this;
        					# -1 disables
        #jit_inline_above_cost = 500000		# inline small functions if query is
        					# more expensive than this; -1 disables
        #jit_optimize_above_cost = 500000	# use expensive JIT optimizations if
        					# query is more expensive than this;
        					# -1 disables

        #min_parallel_table_scan_size = 8MB
        #min_parallel_index_scan_size = 512kB
        #effective_cache_size = 4GB

        # - Genetic Query Optimizer -

        #geqo = on
        #geqo_threshold = 12
        #geqo_effort = 5			# range 1-10
        #geqo_pool_size = 0			# selects default based on effort
        #geqo_generations = 0			# selects default based on effort
        #geqo_selection_bias = 2.0		# range 1.5-2.0
        #geqo_seed = 0.0			# range 0.0-1.0

        # - Other Planner Options -

        #default_statistics_target = 100	# range 1-10000
        #constraint_exclusion = partition	# on, off, or partition
        #cursor_tuple_fraction = 0.1		# range 0.0-1.0
        #from_collapse_limit = 8
        #join_collapse_limit = 8		# 1 disables collapsing of explicit
        					# JOIN clauses
        #force_parallel_mode = off
        #jit = off				# allow JIT compilation


        #------------------------------------------------------------------------------
        # REPORTING AND LOGGING
        #------------------------------------------------------------------------------

        # - Where to Log -

        #log_destination = 'stderr'		# Valid values are combinations of
        					# stderr, csvlog, syslog, and eventlog,
        					# depending on platform.  csvlog
        					# requires logging_collector to be on.

        # This is used when logging to stderr:
        #logging_collector = off		# Enable capturing of stderr and csvlog
        					# into log files. Required to be on for
        					# csvlogs.
        					# (change requires restart)

        # These are only used if logging_collector is on:
        #log_directory = 'log'			# directory where log files are written,
        					# can be absolute or relative to PGDATA
        #log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'	# log file name pattern,
        					# can include strftime() escapes
        #log_file_mode = 0600			# creation mode for log files,
        					# begin with 0 to use octal notation
        #log_truncate_on_rotation = off		# If on, an existing log file with the
        					# same name as the new log file will be
        					# truncated rather than appended to.
        					# But such truncation only occurs on
        					# time-driven rotation, not on restarts
        					# or size-driven rotation.  Default is
        					# off, meaning append to existing files
        					# in all cases.
        #log_rotation_age = 1d			# Automatic rotation of logfiles will
        					# happen after that time.  0 disables.
        #log_rotation_size = 10MB		# Automatic rotation of logfiles will
        					# happen after that much log output.
        					# 0 disables.

        # These are relevant when logging to syslog:
        #syslog_facility = 'LOCAL0'
        #syslog_ident = 'postgres'
        #syslog_sequence_numbers = on
        #syslog_split_messages = on

        # This is only relevant when logging to eventlog (win32):
        # (change requires restart)
        #event_source = 'PostgreSQL'

        # - When to Log -

        #log_min_messages = warning		# values in order of decreasing detail:
        					#   debug5
        					#   debug4
        					#   debug3
        					#   debug2
        					#   debug1
        					#   info
        					#   notice
        					#   warning
        					#   error
        					#   log
        					#   fatal
        					#   panic

        #log_min_error_statement = error	# values in order of decreasing detail:
        					#   debug5
        					#   debug4
        					#   debug3
        					#   debug2
        					#   debug1
        					#   info
        					#   notice
        					#   warning
        					#   error
        					#   log
        					#   fatal
        					#   panic (effectively off)

        #log_min_duration_statement = -1	# -1 is disabled, 0 logs all statements
        					# and their durations, > 0 logs only
        					# statements running at least this number
        					# of milliseconds


        # - What to Log -

        #debug_print_parse = off
        #debug_print_rewritten = off
        #debug_print_plan = off
        #debug_pretty_print = on
        #log_checkpoints = off
        #log_connections = off
        #log_disconnections = off
        #log_duration = off
        #log_error_verbosity = default		# terse, default, or verbose messages
        #log_hostname = off
        #log_line_prefix = '%m [%p] '		# special values:
        					#   %a = application name
        					#   %u = user name
        					#   %d = database name
        					#   %r = remote host and port
        					#   %h = remote host
        					#   %p = process ID
        					#   %t = timestamp without milliseconds
        					#   %m = timestamp with milliseconds
        					#   %n = timestamp with milliseconds (as a Unix epoch)
        					#   %i = command tag
        					#   %e = SQL state
        					#   %c = session ID
        					#   %l = session line number
        					#   %s = session start timestamp
        					#   %v = virtual transaction ID
        					#   %x = transaction ID (0 if none)
        					#   %q = stop here in non-session
        					#        processes
        					#   %% = '%'
        					# e.g. '<%u%%%d> '
        #log_lock_waits = off			# log lock waits >= deadlock_timeout
        #log_statement = 'none'			# none, ddl, mod, all
        #log_replication_commands = off
        #log_temp_files = -1			# log temporary files equal or larger
        					# than the specified size in kilobytes;
        					# -1 disables, 0 logs all temp files
        log_timezone = 'Etc/UTC'

        #------------------------------------------------------------------------------
        # PROCESS TITLE
        #------------------------------------------------------------------------------

        #cluster_name = '''			# added to process titles if nonempty
        					# (change requires restart)
        #update_process_title = on


        #------------------------------------------------------------------------------
        # STATISTICS
        #------------------------------------------------------------------------------

        # - Query and Index Statistics Collector -

        #track_activities = on
        #track_counts = on
        #track_io_timing = off
        #track_functions = none			# none, pl, all
        #track_activity_query_size = 1024	# (change requires restart)
        #stats_temp_directory = 'pg_stat_tmp'


        # - Monitoring -

        #log_parser_stats = off
        #log_planner_stats = off
        #log_executor_stats = off
        #log_statement_stats = off


        #------------------------------------------------------------------------------
        # AUTOVACUUM
        #------------------------------------------------------------------------------

        #autovacuum = on			# Enable autovacuum subprocess?  'on'
        					# requires track_counts to also be on.
        #log_autovacuum_min_duration = -1	# -1 disables, 0 logs all actions and
        					# their durations, > 0 logs only
        					# actions running at least this number
        					# of milliseconds.
        #autovacuum_max_workers = 3		# max number of autovacuum subprocesses
        					# (change requires restart)
        #autovacuum_naptime = 1min		# time between autovacuum runs
        #autovacuum_vacuum_threshold = 50	# min number of row updates before
        					# vacuum
        #autovacuum_analyze_threshold = 50	# min number of row updates before
        					# analyze
        #autovacuum_vacuum_scale_factor = 0.2	# fraction of table size before vacuum
        #autovacuum_analyze_scale_factor = 0.1	# fraction of table size before analyze
        #autovacuum_freeze_max_age = 200000000	# maximum XID age before forced vacuum
        					# (change requires restart)
        #autovacuum_multixact_freeze_max_age = 400000000	# maximum multixact age
        					# before forced vacuum
        					# (change requires restart)
        #autovacuum_vacuum_cost_delay = 20ms	# default vacuum cost delay for
        					# autovacuum, in milliseconds;
        					# -1 means use vacuum_cost_delay
        #autovacuum_vacuum_cost_limit = -1	# default vacuum cost limit for
        					# autovacuum, -1 means use
        					# vacuum_cost_limit


        #------------------------------------------------------------------------------
        # CLIENT CONNECTION DEFAULTS
        #------------------------------------------------------------------------------

        # - Statement Behavior -

        #client_min_messages = notice		# values in order of decreasing detail:
        					#   debug5
        					#   debug4
        					#   debug3
        					#   debug2
        					#   debug1
        					#   log
        					#   notice
        					#   warning
        					#   error
        #search_path = '"$user", public'	# schema names
        #row_security = on
        #default_tablespace = '''		# a tablespace name, ''' uses the default
        #temp_tablespaces = '''			# a list of tablespace names, ''' uses
        					# only default tablespace
        #check_function_bodies = on
        #default_transaction_isolation = 'read committed'
        #default_transaction_read_only = off
        #default_transaction_deferrable = off
        #session_replication_role = 'origin'
        #statement_timeout = 0			# in milliseconds, 0 is disabled
        #lock_timeout = 0			# in milliseconds, 0 is disabled
        #idle_in_transaction_session_timeout = 0	# in milliseconds, 0 is disabled
        #vacuum_freeze_min_age = 50000000
        #vacuum_freeze_table_age = 150000000
        #vacuum_multixact_freeze_min_age = 5000000
        #vacuum_multixact_freeze_table_age = 150000000
        #vacuum_cleanup_index_scale_factor = 0.1	# fraction of total number of tuples
        						# before index cleanup, 0 always performs
        						# index cleanup
        #bytea_output = 'hex'			# hex, escape
        #xmlbinary = 'base64'
        #xmloption = 'content'
        #gin_fuzzy_search_limit = 0
        #gin_pending_list_limit = 4MB

        # - Locale and Formatting -

        datestyle = 'iso, mdy'
        #intervalstyle = 'postgres'
        timezone = 'Etc/UTC'
        #timezone_abbreviations = 'Default'     # Select the set of available time zone
        					# abbreviations.  Currently, there are
        					#   Default
        					#   Australia (historical usage)
        					#   India
        					# You can create your own file in
        					# share/timezonesets/.
        #extra_float_digits = 0			# min -15, max 3
        #client_encoding = sql_ascii		# actually, defaults to database
        					# encoding

        # These settings are initialized by initdb, but they can be changed.
        lc_messages = 'en_US.utf8'			# locale for system error message
        					# strings
        lc_monetary = 'en_US.utf8'			# locale for monetary formatting
        lc_numeric = 'en_US.utf8'			# locale for number formatting
        lc_time = 'en_US.utf8'				# locale for time formatting

        # default configuration for text search
        default_text_search_config = 'pg_catalog.english'

        # - Shared Library Preloading -

        #shared_preload_libraries = '''	# (change requires restart)
        #local_preload_libraries = '''
        #session_preload_libraries = '''
        #jit_provider = 'llvmjit'		# JIT library to use

        # - Other Defaults -

        #dynamic_library_path = '$libdir'


        #------------------------------------------------------------------------------
        # LOCK MANAGEMENT
        #------------------------------------------------------------------------------

        #deadlock_timeout = 1s
        #max_locks_per_transaction = 64		# min 10
        					# (change requires restart)
        #max_pred_locks_per_transaction = 64	# min 10
        					# (change requires restart)
        #max_pred_locks_per_relation = -2	# negative values mean
        					# (max_pred_locks_per_transaction
        					#  / -max_pred_locks_per_relation) - 1
        #max_pred_locks_per_page = 2            # min 0


        #------------------------------------------------------------------------------
        # VERSION AND PLATFORM COMPATIBILITY
        #------------------------------------------------------------------------------

        # - Previous PostgreSQL Versions -

        #array_nulls = on
        #backslash_quote = safe_encoding	# on, off, or safe_encoding
        #default_with_oids = off
        #escape_string_warning = on
        #lo_compat_privileges = off
        #operator_precedence_warning = off
        #quote_all_identifiers = off
        #standard_conforming_strings = on
        #synchronize_seqscans = on

        # - Other Platforms and Clients -

        #transform_null_equals = off


        #------------------------------------------------------------------------------
        # ERROR HANDLING
        #------------------------------------------------------------------------------

        #exit_on_error = off			# terminate session on any error?
        #restart_after_crash = on		# reinitialize after backend crash?
        #data_sync_retry = off			# retry or panic on failure to fsync
        					# data?
        					# (change requires restart)


        #------------------------------------------------------------------------------
        # CONFIG FILE INCLUDES
        #------------------------------------------------------------------------------

        # These options allow settings to be loaded from files other than the
        # default postgresql.conf.

        #include_dir = '''			# include files ending in '.conf' from
        					# a directory, e.g., 'conf.d'
        #include_if_exists = '''			# include file only if it exists
        #include = '''				# include file


        #------------------------------------------------------------------------------
        # CUSTOMIZED OPTIONS
        #------------------------------------------------------------------------------

        # Add settings for extensions here
        ''
    , kind = "ConfigMap"
    , metadata =
      { annotations.description = "Configuration for PostgreSQL"
      , labels =
        { `app.kubernetes.io/component` = "pgsql"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "pgsql-conf"
      , namespace = None Text
      }
    }
  , Deployment.pgsql =
    { apiVersion = "apps/v1"
    , kind = "Deployment"
    , metadata =
      { annotations.description = "Postgres database for various data."
      , labels =
        { `app.kubernetes.io/component` = "pgsql"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "pgsql"
      , namespace = None Text
      }
    , spec =
      { minReadySeconds = 10
      , replicas = 1
      , revisionHistoryLimit = 10
      , selector.matchLabels.app = "pgsql"
      , strategy.type = "Recreate"
      , template =
        { metadata =
          { labels =
            { app = "pgsql", deploy = "sourcegraph", group = "backend" }
          , namespace = None Text
          }
        , spec =
          { containers =
            { pgsql =
              { env = None <>
              , image =
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
                    { name = "sourcegraph/postgres-11.4"
                    , registry = "index.docker.io"
                    , sha256 =
                        "63090799b34b3115a387d96fe2227a37999d432b774a1d9b7966b8c5d81b56ad"
                    , version = "3.19.2"
                    }
              , livenessProbe =
                { exec.command = [ "/liveness.sh" ], initialDelaySeconds = 15 }
              , name = "pgsql"
              , ports.pgsql = { containerPort = 5432, name = "pgsql" }
              , readinessProbe.exec.command = [ "/ready.sh" ]
              , resources =
                { limits =
                  { cpu = Some "4"
                  , ephemeralStorage = None Text
                  , memory = Some "2Gi"
                  }
                , requests =
                  { cpu = Some "4"
                  , ephemeralStorage = None Text
                  , memory = Some "2Gi"
                  }
                }
              , terminationMessagePolicy = "FallbackToLogsOnError"
              , volumeMounts =
                { disk = { mountPath = "/data", name = "disk" }
                , pgsql-conf = { mountPath = "/conf", name = "pgsql-conf" }
                }
              }
            , pgsql-exporter =
              { env.DATA_SOURCE_NAME =
                { name = "DATA_SOURCE_NAME"
                , value = "postgres://sg:@localhost:5432/?sslmode=disable"
                }
              , image =
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
                    { name = "postgres_exporter"
                    , registry = "wrouesnel"
                    , sha256 =
                        "785c919627c06f540d515aac88b7966f352403f73e931e70dc2cbf783146a98b"
                    , version = "v0.7.0"
                    }
              , name = "pgsql-exporter"
              , resources =
                { limits =
                  { cpu = Some "10m"
                  , ephemeralStorage = None Text
                  , memory = Some "50Mi"
                  }
                , requests =
                  { cpu = Some "10m"
                  , ephemeralStorage = None Text
                  , memory = Some "50Mi"
                  }
                }
              , terminationMessagePolicy = "FallbackToLogsOnError"
              }
            }
          , initContainers.correct-data-dir-permissions =
            { command =
              [ "sh"
              , "-c"
              , "if [ -d /data/pgdata-11 ]; then chmod 750 /data/pgdata-11; fi"
              ]
            , image =
                < asRecord :
                    { name : Text
                    , registry : Text
                    , sha256 : Text
                    , version : Text
                    }
                | asText : Text
                >.asRecord
                  { name = "alpine"
                  , registry = "sourcegraph"
                  , sha256 =
                      "4d05cd5669726fc38823e92320659a6d1ef7879e62268adec5df658a0bacf65c"
                  , version = "3.10"
                  }
            , name = "correct-data-dir-permissions"
            , securityContext.runAsUser = 0
            , volumeMounts.disk = { mountPath = "/data", name = "disk" }
            }
          , securityContext.runAsUser = 0
          , volumes =
            { disk =
              { name = "disk", persistentVolumeClaim.claimName = "pgsql" }
            , pgsql-conf =
              { configMap = { defaultMode = 511, name = "pgsql-conf" }
              , name = "pgsql-conf"
              }
            }
          }
        }
      }
    }
  , PersistentVolumeClaim.pgsql =
    { apiVersion = "v1"
    , kind = "PersistentVolumeClaim"
    , metadata =
      { labels =
        { `app.kubernetes.io/component` = "pgsql"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "pgsql"
      , namespace = None Text
      }
    , spec =
      { accessModes = [ "ReadWriteOnce" ]
      , resources.requests =
        { cpu = None Text, ephemeralStorage = None Text, memory = None Text }
      , storageClassName = "sourcegraph"
      }
    }
  , Service.pgsql =
    { apiVersion = "v1"
    , kind = "Service"
    , metadata =
      { annotations =
        { `prometheus.io/port` = "9187"
        , `sourcegraph.prometheus/scrape` = "true"
        }
      , labels =
        { app = "pgsql"
        , `app.kubernetes.io/component` = "pgsql"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "pgsql"
      , namespace = None Text
      }
    , spec =
      { ports.pgsql = { name = "pgsql", port = 5432, targetPort = "pgsql" }
      , selector.app = "pgsql"
      , type = "ClusterIP"
      }
    }
  }
, Precise-Code-Intel =
  { Deployment =
    { precise-code-intel-bundle-manager =
      { apiVersion = "apps/v1"
      , kind = "Deployment"
      , metadata =
        { annotations.description =
            "Stores and manages precise code intelligence bundles."
        , labels =
          { `app.kubernetes.io/component` = "precise-code-intel"
          , deploy = "sourcegraph"
          , sourcegraph-resource-requires = "no-cluster-admin"
          }
        , name = "precise-code-intel-bundle-manager"
        , namespace = None Text
        }
      , spec =
        { minReadySeconds = 10
        , replicas = 1
        , revisionHistoryLimit = 10
        , selector.matchLabels.app = "precise-code-intel-bundle-manager"
        , strategy.type = "Recreate"
        , template =
          { metadata =
            { labels =
              { app = "precise-code-intel-bundle-manager"
              , deploy = "sourcegraph"
              }
            , namespace = None Text
            }
          , spec =
            { containers.precise-code-intel-bundle-manager =
              { env =
                { POD_NAME =
                  { name = "POD_NAME"
                  , valueFrom.fieldRef.fieldPath = "metadata.name"
                  }
                , PRECISE_CODE_INTEL_BUNDLE_DIR =
                  { name = "PRECISE_CODE_INTEL_BUNDLE_DIR"
                  , value = "/lsif-storage"
                  }
                }
              , image =
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
                    { name = "sourcegraph/precise-code-intel-bundle-manager"
                    , registry = "index.docker.io"
                    , sha256 =
                        "104b10b85cd508e31cc71271a7a5153d7248d2ef28a8f08756875d863492e363"
                    , version = "3.19.2"
                    }
              , livenessProbe =
                { httpGet =
                  { path = "/healthz", port = "http", scheme = "HTTP" }
                , initialDelaySeconds = 60
                , timeoutSeconds = 5
                }
              , name = "precise-code-intel-bundle-manager"
              , ports =
                { debug = { containerPort = 6060, name = "debug" }
                , http = { containerPort = 3187, name = "http" }
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
                  , memory = Some "2G"
                  }
                , requests =
                  { cpu = Some "500m"
                  , ephemeralStorage = None Text
                  , memory = Some "500M"
                  }
                }
              , terminationMessagePolicy = "FallbackToLogsOnError"
              , volumeMounts.bundle-manager =
                { mountPath = "/lsif-storage", name = "bundle-manager" }
              }
            , securityContext.runAsUser = 0
            , volumes.bundle-manager =
              { name = "bundle-manager"
              , persistentVolumeClaim.claimName = "bundle-manager"
              }
            }
          }
        }
      }
    , precise-code-intel-worker =
      { apiVersion = "apps/v1"
      , kind = "Deployment"
      , metadata =
        { annotations.description =
            "Handles conversion of uploaded precise code intelligence bundles."
        , labels =
          { `app.kubernetes.io/component` = "precise-code-intel"
          , deploy = "sourcegraph"
          , sourcegraph-resource-requires = "no-cluster-admin"
          }
        , name = "precise-code-intel-worker"
        , namespace = None Text
        }
      , spec =
        { minReadySeconds = 10
        , replicas = 1
        , revisionHistoryLimit = 10
        , selector.matchLabels.app = "precise-code-intel-worker"
        , strategy =
          { rollingUpdate = { maxSurge = 1, maxUnavailable = 1 }
          , type = "RollingUpdate"
          }
        , template =
          { metadata =
            { labels =
              { app = "precise-code-intel-worker", deploy = "sourcegraph" }
            , namespace = None Text
            }
          , spec =
            { containers.precise-code-intel-worker =
              { env =
                { NUM_WORKERS = { name = "NUM_WORKERS", value = "4" }
                , POD_NAME =
                  { name = "POD_NAME"
                  , valueFrom.fieldRef.fieldPath = "metadata.name"
                  }
                , PRECISE_CODE_INTEL_BUNDLE_MANAGER_URL =
                  { name = "PRECISE_CODE_INTEL_BUNDLE_MANAGER_URL"
                  , value = "http://precise-code-intel-bundle-manager:3187"
                  }
                }
              , image =
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
                    { name = "sourcegraph/precise-code-intel-worker"
                    , registry = "index.docker.io"
                    , sha256 =
                        "a1f5e4589cf09995d67cca1156749a371d24d8af9f1171808df1d39d6b6f1df6"
                    , version = "3.19.2"
                    }
              , livenessProbe =
                { httpGet =
                  { path = "/healthz", port = "http", scheme = "HTTP" }
                , initialDelaySeconds = 60
                , timeoutSeconds = 5
                }
              , name = "precise-code-intel-worker"
              , ports =
                { debug = { containerPort = 6060, name = "debug" }
                , http = { containerPort = 3188, name = "http" }
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
                  { cpu = Some "500m"
                  , ephemeralStorage = None Text
                  , memory = Some "2G"
                  }
                }
              , terminationMessagePolicy = "FallbackToLogsOnError"
              }
            , securityContext.runAsUser = 0
            }
          }
        }
      }
    }
  , PersistentVolumeClaim.bundle-manager =
    { apiVersion = "v1"
    , kind = "PersistentVolumeClaim"
    , metadata =
      { labels =
        { `app.kubernetes.io/component` = "precise-code-intel"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "bundle-manager"
      , namespace = None Text
      }
    , spec =
      { accessModes = [ "ReadWriteOnce" ]
      , resources.requests =
        { cpu = None Text, ephemeralStorage = None Text, memory = None Text }
      , storageClassName = "sourcegraph"
      }
    }
  , Service =
    { precise-code-intel-bundle-manager =
      { apiVersion = "v1"
      , kind = "Service"
      , metadata =
        { annotations =
          { `prometheus.io/port` = "6060"
          , `sourcegraph.prometheus/scrape` = "true"
          }
        , labels =
          { app = "precise-code-intel-bundle-manager"
          , `app.kubernetes.io/component` = "precise-code-intel"
          , deploy = "sourcegraph"
          , sourcegraph-resource-requires = "no-cluster-admin"
          }
        , name = "precise-code-intel-bundle-manager"
        , namespace = None Text
        }
      , spec =
        { ports =
          { debug = { name = "debug", port = 6060, targetPort = "debug" }
          , http = { name = "http", port = 3187, targetPort = "http" }
          }
        , selector.app = "precise-code-intel-bundle-manager"
        , type = "ClusterIP"
        }
      }
    , precise-code-intel-worker =
      { apiVersion = "v1"
      , kind = "Service"
      , metadata =
        { annotations =
          { `prometheus.io/port` = "6060"
          , `sourcegraph.prometheus/scrape` = "true"
          }
        , labels =
          { app = "precise-code-intel-worker"
          , `app.kubernetes.io/component` = "precise-code-intel"
          , deploy = "sourcegraph"
          , sourcegraph-resource-requires = "no-cluster-admin"
          }
        , name = "precise-code-intel-worker"
        , namespace = None Text
        }
      , spec =
        { ports =
          { debug = { name = "debug", port = 6060, targetPort = "debug" }
          , http = { name = "http", port = 3188, targetPort = "http" }
          }
        , selector.app = "precise-code-intel-worker"
        , type = "ClusterIP"
        }
      }
    }
  }
, Prometheus =
  { ClusterRole.prometheus =
    { apiVersion = "rbac.authorization.k8s.io/v1"
    , kind = "ClusterRole"
    , metadata =
      { labels =
        { `app.kubernetes.io/component` = "prometheus"
        , category = "rbac"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "cluster-admin"
        }
      , name = "prometheus"
      , namespace = None Text
      }
    , rules =
      [ { apiGroups = Some [ "" ]
        , nonResourceURLs = None (List Text)
        , resources = Some
          [ "endpoints"
          , "namespaces"
          , "nodes"
          , "nodes/metrics"
          , "nodes/proxy"
          , "pods"
          , "services"
          ]
        , verbs = [ "get", "list", "watch" ]
        }
      , { apiGroups = Some [ "" ]
        , nonResourceURLs = None (List Text)
        , resources = Some [ "configmaps" ]
        , verbs = [ "get" ]
        }
      , { apiGroups = None (List Text)
        , nonResourceURLs = Some [ "/metrics" ]
        , resources = None (List Text)
        , verbs = [ "get" ]
        }
      ]
    }
  , ClusterRoleBinding.prometheus =
    { apiVersion = "rbac.authorization.k8s.io/v1"
    , kind = "ClusterRoleBinding"
    , metadata =
      { labels =
        { `app.kubernetes.io/component` = "prometheus"
        , category = "rbac"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "cluster-admin"
        }
      , name = "prometheus"
      , namespace = None Text
      }
    , roleRef = { apiGroup = "", kind = "ClusterRole", name = "prometheus" }
    , subjects.prometheus =
      { kind = "ServiceAccount", name = "prometheus", namespace = "default" }
    }
  , ConfigMap.prometheus =
    { apiVersion = "v1"
    , data =
      { `extra_rules.yml` = ""
      , `prometheus.yml` =
          ''
          global:
            scrape_interval:     30s
            evaluation_interval: 30s

          alerting:
            alertmanagers:
              # Bundled Alertmanager, started by prom-wrapper
              - static_configs:
                  - targets: ['127.0.0.1:9093']
                path_prefix: /alertmanager
              # Uncomment the following to have alerts delivered to additional Alertmanagers discovered
              # in the cluster. This configuration is not required if you use Sourcegraph's built-in alerting:
              # https://docs.sourcegraph.com/admin/observability/alerting
              # - kubernetes_sd_configs:
              #  - role: endpoints
              #  relabel_configs:
              #    - source_labels: [__meta_kubernetes_service_name]
              #      regex: alertmanager
              #      action: keep

          rule_files:
            - '*_rules.yml'
            - "/sg_config_prometheus/*_rules.yml"
            - "/sg_prometheus_add_ons/*_rules.yml"

          # A scrape configuration for running Prometheus on a Kubernetes cluster.
          # This uses separate scrape configs for cluster components (i.e. API server, node)
          # and services to allow each to use different authentication configs.
          #
          # Kubernetes labels will be added as Prometheus labels on metrics via the
          # `labelmap` relabeling action.

          # Scrape config for API servers.
          #
          # Kubernetes exposes API servers as endpoints to the default/kubernetes
          # service so this uses `endpoints` role and uses relabelling to only keep
          # the endpoints associated with the default/kubernetes service using the
          # default named port `https`. This works for single API server deployments as
          # well as HA API server deployments.
          scrape_configs:
          - job_name: 'kubernetes-apiservers'

            kubernetes_sd_configs:
            - role: endpoints

            # Default to scraping over https. If required, just disable this or change to
            # `http`.
            scheme: https

            # This TLS & bearer token file config is used to connect to the actual scrape
            # endpoints for cluster components. This is separate to discovery auth
            # configuration because discovery & scraping are two separate concerns in
            # Prometheus. The discovery auth config is automatic if Prometheus runs inside
            # the cluster. Otherwise, more config options have to be provided within the
            # <kubernetes_sd_config>.
            tls_config:
              ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
              # If your node certificates are self-signed or use a different CA to the
              # master CA, then disable certificate verification below. Note that
              # certificate verification is an integral part of a secure infrastructure
              # so this should only be disabled in a controlled environment. You can
              # disable certificate verification by uncommenting the line below.
              #
              # insecure_skip_verify: true
            bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

            # Keep only the default/kubernetes service endpoints for the https port. This
            # will add targets for each API server which Kubernetes adds an endpoint to
            # the default/kubernetes service.
            relabel_configs:
            - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
              action: keep
              regex: default;kubernetes;https

          - job_name: 'kubernetes-nodes'

            # Default to scraping over https. If required, just disable this or change to
            # `http`.
            scheme: https

            # This TLS & bearer token file config is used to connect to the actual scrape
            # endpoints for cluster components. This is separate to discovery auth
            # configuration because discovery & scraping are two separate concerns in
            # Prometheus. The discovery auth config is automatic if Prometheus runs inside
            # the cluster. Otherwise, more config options have to be provided within the
            # <kubernetes_sd_config>.
            tls_config:
              ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
              # If your node certificates are self-signed or use a different CA to the
              # master CA, then disable certificate verification below. Note that
              # certificate verification is an integral part of a secure infrastructure
              # so this should only be disabled in a controlled environment. You can
              # disable certificate verification by uncommenting the line below.
              #
              insecure_skip_verify: true
            bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

            kubernetes_sd_configs:
            - role: node

            relabel_configs:
            - action: labelmap
              regex: __meta_kubernetes_node_label_(.+)
            - target_label: __address__
              replacement: kubernetes.default.svc:443
            - source_labels: [__meta_kubernetes_node_name]
              regex: (.+)
              target_label: __metrics_path__
              replacement: /api/v1/nodes/''${1}/proxy/metrics

          # Scrape config for service endpoints.
          #
          # The relabeling allows the actual service scrape endpoint to be configured
          # via the following annotations:
          #
          # * `prometheus.io/scrape`: Only scrape services that have a value of `true`
          # * `prometheus.io/scheme`: If the metrics endpoint is secured then you will need
          # to set this to `https` & most likely set the `tls_config` of the scrape config.
          # * `prometheus.io/path`: If the metrics path is not `/metrics` override this.
          # * `prometheus.io/port`: If the metrics are exposed on a different port to the
          # service then set this appropriately.
          - job_name: 'kubernetes-service-endpoints'

            kubernetes_sd_configs:
            - role: endpoints

            relabel_configs:
            - source_labels: [__meta_kubernetes_service_annotation_sourcegraph_prometheus_scrape]
              action: keep
              regex: true
            - source_labels: [__meta_kubernetes_pod_container_name]
              action: drop
              regex: jaeger-agent
            - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scheme]
              action: replace
              target_label: __scheme__
              regex: (https?)
            - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_path]
              action: replace
              target_label: __metrics_path__
              regex: (.+)
            - source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
              action: replace
              target_label: __address__
              regex: (.+)(?::\d+);(\d+)
              replacement: $1:$2
            - action: labelmap
              regex: __meta_kubernetes_service_label_(.+)
            - source_labels: [__meta_kubernetes_namespace]
              action: replace
              # Sourcegraph specific customization. We want a more convenient to type label.
              # target_label: kubernetes_namespace
              target_label: ns
            - source_labels: [__meta_kubernetes_service_name]
              action: replace
              target_label: kubernetes_name
            # Sourcegraph specific customization. We want a nicer name for job
            - source_labels: [app]
              action: replace
              target_label: job
            # Sourcegraph specific customization. We want a nicer name for instance
            - source_labels: [__meta_kubernetes_pod_name]
              action: replace
              target_label: instance

          # Example scrape config for probing services via the Blackbox Exporter.
          #
          # The relabeling allows the actual service scrape endpoint to be configured
          # via the following annotations:
          #
          # * `prometheus.io/probe`: Only probe services that have a value of `true`
          - job_name: 'kubernetes-services'

            metrics_path: /probe
            params:
              module: [http_2xx]

            kubernetes_sd_configs:
            - role: service

            relabel_configs:
            - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_probe]
              action: keep
              regex: true
            - source_labels: [__address__]
              target_label: __param_target
            - target_label: __address__
              replacement: blackbox
            - source_labels: [__param_target]
              target_label: instance
            - action: labelmap
              regex: __meta_kubernetes_service_label_(.+)
            - source_labels: [__meta_kubernetes_service_namespace]
              # Sourcegraph specific customization. We want a more convenient to type label.
              # target_label: kubernetes_namespace
              target_label: ns
            - source_labels: [__meta_kubernetes_service_name]
              target_label: kubernetes_name

          # Example scrape config for pods
          #
          # The relabeling allows the actual pod scrape endpoint to be configured via the
          # following annotations:
          #
          # * `prometheus.io/scrape`: Only scrape pods that have a value of `true`
          # * `prometheus.io/path`: If the metrics path is not `/metrics` override this.
          # * `prometheus.io/port`: Scrape the pod on the indicated port instead of the default of `9102`.
          - job_name: 'kubernetes-pods'

            kubernetes_sd_configs:
            - role: pod

            relabel_configs:
            - source_labels: [__meta_kubernetes_pod_annotation_sourcegraph_prometheus_scrape]
              action: keep
              regex: true
            - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
              action: replace
              target_label: __metrics_path__
              regex: (.+)
            - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
              action: replace
              regex: (.+):(?:\d+);(\d+)
              replacement: ''${1}:''${2}
              target_label: __address__
            - action: labelmap
              regex: __meta_kubernetes_pod_label_(.+)
            - source_labels: [__meta_kubernetes_namespace]
              action: replace
              # Sourcegraph specific customization. We want a more convenient to type label.
              # target_label: kubernetes_namespace
              target_label: ns
            - source_labels: [__meta_kubernetes_pod_name]
              action: replace
              target_label: kubernetes_pod_name

          # Scrape prometheus itself for metrics.
          - job_name: 'builtin-prometheus'
            static_configs:
              - targets: ['127.0.0.1:9092']
                labels:
                  app: prometheus
          - job_name: 'builtin-alertmanager'
            metrics_path: /alertmanager/metrics
            static_configs:
              - targets: ['127.0.0.1:9093']
                labels:
                  app: alertmanager
          ''
      }
    , kind = "ConfigMap"
    , metadata =
      { labels =
        { `app.kubernetes.io/component` = "prometheus"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "prometheus"
      , namespace = None Text
      }
    }
  , Deployment.prometheus =
    { apiVersion = "apps/v1"
    , kind = "Deployment"
    , metadata =
      { annotations.description =
          "Collects metrics and aggregates them into graphs."
      , labels =
        { `app.kubernetes.io/component` = "prometheus"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "prometheus"
      , namespace = None Text
      }
    , spec =
      { minReadySeconds = 10
      , replicas = 1
      , revisionHistoryLimit = 10
      , selector.matchLabels.app = "prometheus"
      , strategy.type = "Recreate"
      , template =
        { metadata =
          { labels = { app = "prometheus", deploy = "sourcegraph" }
          , namespace = None Text
          }
        , spec =
          { containers.prometheus =
            { image =
                < asRecord :
                    { name : Text
                    , registry : Text
                    , sha256 : Text
                    , version : Text
                    }
                | asText : Text
                >.asRecord
                  { name = "sourcegraph/prometheus"
                  , registry = "index.docker.io"
                  , sha256 =
                      "be6b68a89bdf4b4b60ed61a1545179b20f91db8ba11e60869aaa00720b7c0e7b"
                  , version = "3.19.2"
                  }
            , livenessProbe =
              { httpGet = { path = "/-/healthy", port = 9090 }
              , initialDelaySeconds = 30
              , timeoutSeconds = 30
              }
            , name = "prometheus"
            , ports.http = { containerPort = 9090, name = "http" }
            , readinessProbe =
              { httpGet = { path = "/-/ready", port = 9090 }
              , initialDelaySeconds = 30
              , timeoutSeconds = 30
              }
            , resources =
              { limits =
                { cpu = Some "2"
                , ephemeralStorage = None Text
                , memory = Some "3G"
                }
              , requests =
                { cpu = Some "500m"
                , ephemeralStorage = None Text
                , memory = Some "3G"
                }
              }
            , terminationMessagePolicy = "FallbackToLogsOnError"
            , volumeMounts =
              { config =
                { mountPath = "/sg_prometheus_add_ons", name = "config" }
              , data = { mountPath = "/prometheus", name = "data" }
              }
            }
          , securityContext.runAsUser = 0
          , serviceAccountName = "prometheus"
          , volumes =
            { config =
              { configMap = { defaultMode = 511, name = "prometheus" }
              , name = "config"
              }
            , data =
              { name = "data", persistentVolumeClaim.claimName = "prometheus" }
            }
          }
        }
      }
    }
  , PersistentVolumeClaim.prometheus =
    { apiVersion = "v1"
    , kind = "PersistentVolumeClaim"
    , metadata =
      { labels =
        { `app.kubernetes.io/component` = "prometheus"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "prometheus"
      , namespace = None Text
      }
    , spec =
      { accessModes = [ "ReadWriteOnce" ]
      , resources.requests =
        { cpu = None Text, ephemeralStorage = None Text, memory = None Text }
      , storageClassName = "sourcegraph"
      }
    }
  , Service.prometheus =
    { apiVersion = "v1"
    , kind = "Service"
    , metadata =
      { labels =
        { app = "prometheus"
        , `app.kubernetes.io/component` = "prometheus"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "prometheus"
      , namespace = None Text
      }
    , spec =
      { ports.http = { name = "http", port = 30090, targetPort = "http" }
      , selector.app = "prometheus"
      , type = "ClusterIP"
      }
    }
  , ServiceAccount.prometheus =
    { apiVersion = "v1"
    , imagePullSecrets.docker-registry.name = "docker-registry"
    , kind = "ServiceAccount"
    , metadata =
      { labels =
        { `app.kubernetes.io/component` = "prometheus"
        , category = "rbac"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "prometheus"
      , namespace = None Text
      }
    }
  }
, Query-Runner =
  { Deployment.query-runner =
    { apiVersion = "apps/v1"
    , kind = "Deployment"
    , metadata =
      { annotations.description =
          "Saved search query runner / notification service."
      , labels =
        { `app.kubernetes.io/component` = "query-runner"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "query-runner"
      , namespace = None Text
      }
    , spec =
      { minReadySeconds = 10
      , replicas = 1
      , revisionHistoryLimit = 10
      , selector.matchLabels.app = "query-runner"
      , strategy =
        { rollingUpdate = { maxSurge = 1, maxUnavailable = 0 }
        , type = "RollingUpdate"
        }
      , template =
        { metadata =
          { labels = { app = "query-runner", deploy = "sourcegraph" }
          , namespace = None Text
          }
        , spec =
          { containers =
            { jaeger-agent =
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
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
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
            , query-runner =
              { env = None <>
              , image =
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
                    { name = "sourcegraph/query-runner"
                    , registry = "index.docker.io"
                    , sha256 =
                        "bdf87a86c751774dc7940ed3f4bd0a508e24e06630b1b8874d1dc43b1263969f"
                    , version = "3.19.2"
                    }
              , name = "query-runner"
              , ports.http = { containerPort = 3183, name = "http" }
              , resources =
                { limits =
                  { cpu = Some "1"
                  , ephemeralStorage = None Text
                  , memory = Some "1G"
                  }
                , requests =
                  { cpu = Some "500m"
                  , ephemeralStorage = None Text
                  , memory = Some "1G"
                  }
                }
              , terminationMessagePolicy = "FallbackToLogsOnError"
              }
            }
          , securityContext.runAsUser = 0
          }
        }
      }
    }
  , Service.query-runner =
    { apiVersion = "v1"
    , kind = "Service"
    , metadata =
      { annotations =
        { `prometheus.io/port` = "6060"
        , `sourcegraph.prometheus/scrape` = "true"
        }
      , labels =
        { app = "query-runner"
        , `app.kubernetes.io/component` = "query-runner"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "query-runner"
      , namespace = None Text
      }
    , spec =
      { ports.http = { name = "http", port = 80, targetPort = "http" }
      , selector.app = "query-runner"
      , type = "ClusterIP"
      }
    }
  }
, Redis =
  { Deployment =
    { redis-cache =
      { apiVersion = "apps/v1"
      , kind = "Deployment"
      , metadata =
        { annotations.description = "Redis for storing short-lived caches."
        , labels =
          { `app.kubernetes.io/component` = "redis"
          , deploy = "sourcegraph"
          , sourcegraph-resource-requires = "no-cluster-admin"
          }
        , name = "redis-cache"
        , namespace = None Text
        }
      , spec =
        { minReadySeconds = 10
        , replicas = 1
        , revisionHistoryLimit = 10
        , selector.matchLabels.app = "redis-cache"
        , strategy.type = "Recreate"
        , template =
          { metadata =
            { labels = { app = "redis-cache", deploy = "sourcegraph" }
            , namespace = None Text
            }
          , spec =
            { containers =
              { redis-cache =
                { env = None <>
                , image =
                    < asRecord :
                        { name : Text
                        , registry : Text
                        , sha256 : Text
                        , version : Text
                        }
                    | asText : Text
                    >.asRecord
                      { name = "sourcegraph/redis-cache"
                      , registry = "index.docker.io"
                      , sha256 =
                          "7820219195ab3e8fdae5875cd690fed1b2a01fd1063bd94210c0e9d529c38e56"
                      , version = "3.19.2"
                      }
                , livenessProbe =
                  { initialDelaySeconds = 30, tcpSocket.port = "redis" }
                , name = "redis-cache"
                , ports.redis = { containerPort = 6379, name = "redis" }
                , readinessProbe =
                  { initialDelaySeconds = 5, tcpSocket.port = "redis" }
                , resources =
                  { limits =
                    { cpu = Some "1"
                    , ephemeralStorage = None Text
                    , memory = Some "6Gi"
                    }
                  , requests =
                    { cpu = Some "1"
                    , ephemeralStorage = None Text
                    , memory = Some "6Gi"
                    }
                  }
                , terminationMessagePolicy = "FallbackToLogsOnError"
                , volumeMounts.redis-data =
                  { mountPath = "/redis-data", name = "redis-data" }
                }
              , redis-exporter =
                { image =
                    < asRecord :
                        { name : Text
                        , registry : Text
                        , sha256 : Text
                        , version : Text
                        }
                    | asText : Text
                    >.asRecord
                      { name = "sourcegraph/redis_exporter"
                      , registry = "index.docker.io"
                      , sha256 =
                          "282d59b2692cca68da128a4e28d368ced3d17945cd1d273d3ee7ba719d77b753"
                      , version = "18-02-07_bb60087_v0.15.0"
                      }
                , name = "redis-exporter"
                , ports.redisexp = { containerPort = 9121, name = "redisexp" }
                , resources =
                  { limits =
                    { cpu = Some "10m"
                    , ephemeralStorage = None Text
                    , memory = Some "100Mi"
                    }
                  , requests =
                    { cpu = Some "10m"
                    , ephemeralStorage = None Text
                    , memory = Some "100Mi"
                    }
                  }
                , terminationMessagePolicy = "FallbackToLogsOnError"
                }
              }
            , securityContext.runAsUser = 0
            , volumes.redis-data =
              { name = "redis-data"
              , persistentVolumeClaim.claimName = "redis-cache"
              }
            }
          }
        }
      }
    , redis-store =
      { apiVersion = "apps/v1"
      , kind = "Deployment"
      , metadata =
        { annotations.description =
            "Redis for storing semi-persistent data like user sessions."
        , labels =
          { `app.kubernetes.io/component` = "redis"
          , deploy = "sourcegraph"
          , sourcegraph-resource-requires = "no-cluster-admin"
          }
        , name = "redis-store"
        , namespace = None Text
        }
      , spec =
        { minReadySeconds = 10
        , replicas = 1
        , revisionHistoryLimit = 10
        , selector.matchLabels.app = "redis-store"
        , strategy.type = "Recreate"
        , template =
          { metadata =
            { labels = { app = "redis-store", deploy = "sourcegraph" }
            , namespace = None Text
            }
          , spec =
            { containers =
              { redis-exporter =
                { image =
                    < asRecord :
                        { name : Text
                        , registry : Text
                        , sha256 : Text
                        , version : Text
                        }
                    | asText : Text
                    >.asRecord
                      { name = "sourcegraph/redis_exporter"
                      , registry = "index.docker.io"
                      , sha256 =
                          "282d59b2692cca68da128a4e28d368ced3d17945cd1d273d3ee7ba719d77b753"
                      , version = "18-02-07_bb60087_v0.15.0"
                      }
                , name = "redis-exporter"
                , ports.redisexp = { containerPort = 9121, name = "redisexp" }
                , resources =
                  { limits =
                    { cpu = Some "10m"
                    , ephemeralStorage = None Text
                    , memory = Some "100Mi"
                    }
                  , requests =
                    { cpu = Some "10m"
                    , ephemeralStorage = None Text
                    , memory = Some "100Mi"
                    }
                  }
                , terminationMessagePolicy = "FallbackToLogsOnError"
                }
              , redis-store =
                { env = None <>
                , image =
                    < asRecord :
                        { name : Text
                        , registry : Text
                        , sha256 : Text
                        , version : Text
                        }
                    | asText : Text
                    >.asRecord
                      { name = "sourcegraph/redis-store"
                      , registry = "index.docker.io"
                      , sha256 =
                          "e8467a8279832207559bdfbc4a89b68916ecd5b44ab5cf7620c995461c005168"
                      , version = "3.19.2"
                      }
                , livenessProbe =
                  { initialDelaySeconds = 30, tcpSocket.port = "redis" }
                , name = "redis-store"
                , ports.redis = { containerPort = 6379, name = "redis" }
                , readinessProbe =
                  { initialDelaySeconds = 5, tcpSocket.port = "redis" }
                , resources =
                  { limits =
                    { cpu = Some "1"
                    , ephemeralStorage = None Text
                    , memory = Some "6Gi"
                    }
                  , requests =
                    { cpu = Some "1"
                    , ephemeralStorage = None Text
                    , memory = Some "6Gi"
                    }
                  }
                , terminationMessagePolicy = "FallbackToLogsOnError"
                , volumeMounts.redis-data =
                  { mountPath = "/redis-data", name = "redis-data" }
                }
              }
            , securityContext.runAsUser = 0
            , volumes.redis-data =
              { name = "redis-data"
              , persistentVolumeClaim.claimName = "redis-store"
              }
            }
          }
        }
      }
    }
  , PersistentVolumeClaim =
    { redis-cache =
      { apiVersion = "v1"
      , kind = "PersistentVolumeClaim"
      , metadata =
        { labels =
          { `app.kubernetes.io/component` = "redis"
          , deploy = "sourcegraph"
          , sourcegraph-resource-requires = "no-cluster-admin"
          }
        , name = "redis-cache"
        , namespace = None Text
        }
      , spec =
        { accessModes = [ "ReadWriteOnce" ]
        , resources.requests =
          { cpu = None Text, ephemeralStorage = None Text, memory = None Text }
        , storageClassName = "sourcegraph"
        }
      }
    , redis-store =
      { apiVersion = "v1"
      , kind = "PersistentVolumeClaim"
      , metadata =
        { labels =
          { `app.kubernetes.io/component` = "redis"
          , deploy = "sourcegraph"
          , sourcegraph-resource-requires = "no-cluster-admin"
          }
        , name = "redis-store"
        , namespace = None Text
        }
      , spec =
        { accessModes = [ "ReadWriteOnce" ]
        , resources.requests =
          { cpu = None Text, ephemeralStorage = None Text, memory = None Text }
        , storageClassName = "sourcegraph"
        }
      }
    }
  , Service =
    { redis-cache =
      { apiVersion = "v1"
      , kind = "Service"
      , metadata =
        { annotations =
          { `prometheus.io/port` = "9121"
          , `sourcegraph.prometheus/scrape` = "true"
          }
        , labels =
          { app = "redis-cache"
          , `app.kubernetes.io/component` = "redis"
          , deploy = "sourcegraph"
          , sourcegraph-resource-requires = "no-cluster-admin"
          }
        , name = "redis-cache"
        , namespace = None Text
        }
      , spec =
        { ports.redis = { name = "redis", port = 6379, targetPort = "redis" }
        , selector.app = "redis-cache"
        , type = "ClusterIP"
        }
      }
    , redis-store =
      { apiVersion = "v1"
      , kind = "Service"
      , metadata =
        { annotations =
          { `prometheus.io/port` = "9121"
          , `sourcegraph.prometheus/scrape` = "true"
          }
        , labels =
          { app = "redis-store"
          , `app.kubernetes.io/component` = "redis"
          , deploy = "sourcegraph"
          , sourcegraph-resource-requires = "no-cluster-admin"
          }
        , name = "redis-store"
        , namespace = None Text
        }
      , spec =
        { ports.redis = { name = "redis", port = 6379, targetPort = "redis" }
        , selector.app = "redis-store"
        , type = "ClusterIP"
        }
      }
    }
  }
, Repo-Updater =
  { Deployment.repo-updater =
    { apiVersion = "apps/v1"
    , kind = "Deployment"
    , metadata =
      { annotations.description =
          "Handles repository metadata (not Git data) lookups and updates from external code hosts and other similar services."
      , labels =
        { `app.kubernetes.io/component` = "repo-updater"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "repo-updater"
      , namespace = None Text
      }
    , spec =
      { minReadySeconds = 10
      , replicas = 1
      , revisionHistoryLimit = 10
      , selector.matchLabels.app = "repo-updater"
      , strategy =
        { rollingUpdate = { maxSurge = 1, maxUnavailable = 0 }
        , type = "RollingUpdate"
        }
      , template =
        { metadata =
          { labels = { app = "repo-updater", deploy = "sourcegraph" }
          , namespace = None Text
          }
        , spec =
          { containers =
            { jaeger-agent =
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
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
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
            , repo-updater =
              { env = None <>
              , image =
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
                    { name = "sourcegraph/repo-updater"
                    , registry = "index.docker.io"
                    , sha256 =
                        "c135cd1efd3731c3cc0cc03f205147917110240650888e538fdbe325a552caff"
                    , version = "3.19.2"
                    }
              , name = "repo-updater"
              , ports =
                { debug = { containerPort = 6060, name = "debug" }
                , http = { containerPort = 3182, name = "http" }
                }
              , readinessProbe =
                { failureThreshold = 3
                , httpGet =
                  { path = "/healthz", port = "http", scheme = "HTTP" }
                , periodSeconds = 1
                , timeoutSeconds = 5
                }
              , resources =
                { limits =
                  { cpu = Some "1"
                  , ephemeralStorage = None Text
                  , memory = Some "2Gi"
                  }
                , requests =
                  { cpu = Some "1"
                  , ephemeralStorage = None Text
                  , memory = Some "500Mi"
                  }
                }
              , terminationMessagePolicy = "FallbackToLogsOnError"
              }
            }
          , securityContext.runAsUser = 0
          }
        }
      }
    }
  , Service.repo-updater =
    { apiVersion = "v1"
    , kind = "Service"
    , metadata =
      { annotations =
        { `prometheus.io/port` = "6060"
        , `sourcegraph.prometheus/scrape` = "true"
        }
      , labels =
        { app = "repo-updater"
        , `app.kubernetes.io/component` = "repo-updater"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "repo-updater"
      , namespace = None Text
      }
    , spec =
      { ports.http = { name = "http", port = 3182, targetPort = "http" }
      , selector.app = "repo-updater"
      , type = "ClusterIP"
      }
    }
  }
, Searcher =
  { Deployment.searcher =
    { apiVersion = "apps/v1"
    , kind = "Deployment"
    , metadata =
      { annotations.description = "Backend for text search operations."
      , labels =
        { `app.kubernetes.io/component` = "searcher"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "searcher"
      , namespace = None Text
      }
    , spec =
      { minReadySeconds = 10
      , replicas = 1
      , revisionHistoryLimit = 10
      , selector.matchLabels.app = "searcher"
      , strategy =
        { rollingUpdate = { maxSurge = 1, maxUnavailable = 1 }
        , type = "RollingUpdate"
        }
      , template =
        { metadata =
          { labels = { app = "searcher", deploy = "sourcegraph" }
          , namespace = None Text
          }
        , spec =
          { containers =
            { jaeger-agent =
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
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
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
            , searcher =
              { env =
                { CACHE_DIR =
                  { name = "CACHE_DIR", value = "/mnt/cache/\$(POD_NAME)" }
                , POD_NAME =
                  { name = "POD_NAME"
                  , valueFrom.fieldRef.fieldPath = "metadata.name"
                  }
                , SEARCHER_CACHE_SIZE_MB =
                  { name = "SEARCHER_CACHE_SIZE_MB", value = "100000" }
                }
              , image =
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
                    { name = "sourcegraph/searcher"
                    , registry = "index.docker.io"
                    , sha256 =
                        "96c83aa499031c3811cac30f2c0637f00873125b465708495e018d7e2cca680a"
                    , version = "3.19.2"
                    }
              , name = "searcher"
              , ports =
                { debug = { containerPort = 6060, name = "debug" }
                , http = { containerPort = 3181, name = "http" }
                }
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
                  , memory = Some "2G"
                  }
                , requests =
                  { cpu = Some "500m"
                  , ephemeralStorage = None Text
                  , memory = Some "500M"
                  }
                }
              , terminationMessagePolicy = "FallbackToLogsOnError"
              , volumeMounts.cache-ssd =
                { mountPath = "/mnt/cache", name = "cache-ssd" }
              }
            }
          , securityContext.runAsUser = 0
          , volumes.cache-ssd = { emptyDir = {=}, name = "cache-ssd" }
          }
        }
      }
    }
  , Service.searcher =
    { apiVersion = "v1"
    , kind = "Service"
    , metadata =
      { annotations =
        { `prometheus.io/port` = "6060"
        , `sourcegraph.prometheus/scrape` = "true"
        }
      , labels =
        { app = "searcher"
        , `app.kubernetes.io/component` = "searcher"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "searcher"
      , namespace = None Text
      }
    , spec =
      { ports =
        { debug = { name = "debug", port = 6060, targetPort = "debug" }
        , http = { name = "http", port = 3181, targetPort = "http" }
        }
      , selector.app = "searcher"
      , type = "ClusterIP"
      }
    }
  }
, Symbols =
  { Deployment.symbols =
    { apiVersion = "apps/v1"
    , kind = "Deployment"
    , metadata =
      { annotations.description = "Backend for symbols operations."
      , labels =
        { `app.kubernetes.io/component` = "symbols"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "symbols"
      , namespace = None Text
      }
    , spec =
      { minReadySeconds = 10
      , replicas = 1
      , revisionHistoryLimit = 10
      , selector.matchLabels.app = "symbols"
      , strategy =
        { rollingUpdate = { maxSurge = 1, maxUnavailable = 1 }
        , type = "RollingUpdate"
        }
      , template =
        { metadata =
          { labels = { app = "symbols", deploy = "sourcegraph" }
          , namespace = None Text
          }
        , spec =
          { containers =
            { jaeger-agent =
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
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
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
            , symbols =
              { env =
                { CACHE_DIR =
                  { name = "CACHE_DIR", value = "/mnt/cache/\$(POD_NAME)" }
                , POD_NAME =
                  { name = "POD_NAME"
                  , valueFrom.fieldRef.fieldPath = "metadata.name"
                  }
                , SYMBOLS_CACHE_SIZE_MB =
                  { name = "SYMBOLS_CACHE_SIZE_MB", value = "100000" }
                }
              , image =
                  < asRecord :
                      { name : Text
                      , registry : Text
                      , sha256 : Text
                      , version : Text
                      }
                  | asText : Text
                  >.asRecord
                    { name = "sourcegraph/symbols"
                    , registry = "index.docker.io"
                    , sha256 =
                        "4254ec07804e84ab8b9b63fca906122c8501e3678978b818fe20dc3ec0344efd"
                    , version = "3.19.2"
                    }
              , livenessProbe =
                { httpGet =
                  { path = "/healthz", port = "http", scheme = "HTTP" }
                , initialDelaySeconds = 60
                , timeoutSeconds = 5
                }
              , name = "symbols"
              , ports =
                { debug = { containerPort = 6060, name = "debug" }
                , http = { containerPort = 3184, name = "http" }
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
                  , memory = Some "2G"
                  }
                , requests =
                  { cpu = Some "500m"
                  , ephemeralStorage = None Text
                  , memory = Some "500M"
                  }
                }
              , terminationMessagePolicy = "FallbackToLogsOnError"
              , volumeMounts.cache-ssd =
                { mountPath = "/mnt/cache", name = "cache-ssd" }
              }
            }
          , securityContext.runAsUser = 0
          , volumes.cache-ssd = { emptyDir = {=}, name = "cache-ssd" }
          }
        }
      }
    }
  , Service.symbols =
    { apiVersion = "v1"
    , kind = "Service"
    , metadata =
      { annotations =
        { `prometheus.io/port` = "6060"
        , `sourcegraph.prometheus/scrape` = "true"
        }
      , labels =
        { app = "symbols"
        , `app.kubernetes.io/component` = "symbols"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "symbols"
      , namespace = None Text
      }
    , spec =
      { ports =
        { debug = { name = "debug", port = 6060, targetPort = "debug" }
        , http = { name = "http", port = 3184, targetPort = "http" }
        }
      , selector.app = "symbols"
      , type = "ClusterIP"
      }
    }
  }
, Syntect-Server =
  { Deployment.syntect-server =
    { apiVersion = "apps/v1"
    , kind = "Deployment"
    , metadata =
      { annotations.description = "Backend for syntax highlighting operations."
      , labels =
        { `app.kubernetes.io/component` = "syntect-server"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "syntect-server"
      , namespace = None Text
      }
    , spec =
      { minReadySeconds = 10
      , replicas = 1
      , revisionHistoryLimit = 10
      , selector.matchLabels.app = "syntect-server"
      , strategy =
        { rollingUpdate = { maxSurge = 1, maxUnavailable = 0 }
        , type = "RollingUpdate"
        }
      , template =
        { metadata =
          { labels = { app = "syntect-server", deploy = "sourcegraph" }
          , namespace = None Text
          }
        , spec =
          { containers.syntect-server =
            { env = None <>
            , image =
                < asRecord :
                    { name : Text
                    , registry : Text
                    , sha256 : Text
                    , version : Text
                    }
                | asText : Text
                >.asRecord
                  { name = "sourcegraph/syntax-highlighter"
                  , registry = "index.docker.io"
                  , sha256 =
                      "625c556f5cf456144e51e3fe55e6312398b7714994165b4f605711e6f7d862a0"
                  , version = "3.19.2"
                  }
            , livenessProbe =
              { httpGet = { path = "/health", port = "http", scheme = "HTTP" }
              , initialDelaySeconds = 5
              , timeoutSeconds = 5
              }
            , name = "syntect-server"
            , ports.http = { containerPort = 9238, name = "http" }
            , readinessProbe.tcpSocket.port = "http"
            , resources =
              { limits =
                { cpu = Some "4"
                , ephemeralStorage = None Text
                , memory = Some "6G"
                }
              , requests =
                { cpu = Some "250m"
                , ephemeralStorage = None Text
                , memory = Some "2G"
                }
              }
            , terminationMessagePolicy = "FallbackToLogsOnError"
            }
          , securityContext.runAsUser = 0
          }
        }
      }
    }
  , Service.syntect-server =
    { apiVersion = "v1"
    , kind = "Service"
    , metadata =
      { labels =
        { app = "syntect-server"
        , `app.kubernetes.io/component` = "syntect-server"
        , deploy = "sourcegraph"
        , sourcegraph-resource-requires = "no-cluster-admin"
        }
      , name = "syntect-server"
      , namespace = None Text
      }
    , spec =
      { ports.http = { name = "http", port = 9238, targetPort = "http" }
      , selector.app = "syntect-server"
      , type = "ClusterIP"
      }
    }
  }
}
