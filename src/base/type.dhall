{ Base :
    { Service :
        { backend :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { deploy : Text
                    , group : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { clusterIP : Text
                , ports :
                    { unused :
                        { name : Text, port : Natural, targetPort : Natural }
                    }
                , selector : { group : Text }
                , type : Text
                }
            }
        }
    , StorageClass :
        { sourcegraph :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { deploy : Text, sourcegraph-resource-requires : Text }
                , name : Text
                }
            , parameters : { type : Text }
            , provisioner : Text
            }
        }
    }
, Cadvisor :
    { ClusterRole :
        { cadvisor :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , category : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , rules :
                List
                  { apiGroups : List Text
                  , resourceNames : List Text
                  , resources : List Text
                  , verbs : List Text
                  }
            }
        }
    , ClusterRoleBinding :
        { cadvisor :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , category : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , roleRef : { apiGroup : Text, kind : Text, name : Text }
            , subjects :
                { cadvisor : { kind : Text, name : Text, namespace : Text } }
            }
        }
    , DaemonSet :
        { cadvisor :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations :
                    { description : Text
                    , `seccomp.security.alpha.kubernetes.io/pod` : Text
                    }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { selector : { matchLabels : { app : Text } }
                , template :
                    { metadata :
                        { annotations :
                            { description : Text
                            , `prometheus.io/port` : Text
                            , `sourcegraph.prometheus/scrape` : Text
                            }
                        , labels : { app : Text, deploy : Text }
                        }
                    , spec :
                        { automountServiceAccountToken : Bool
                        , containers :
                            { cadvisor :
                                { args : List Text
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    { http :
                                        { containerPort : Natural
                                        , name : Text
                                        , protocol : Text
                                        }
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , volumeMounts :
                                    { disk :
                                        { mountPath : Text
                                        , name : Text
                                        , readOnly : Bool
                                        }
                                    , docker :
                                        { mountPath : Text
                                        , name : Text
                                        , readOnly : Bool
                                        }
                                    , rootfs :
                                        { mountPath : Text
                                        , name : Text
                                        , readOnly : Bool
                                        }
                                    , sys :
                                        { mountPath : Text
                                        , name : Text
                                        , readOnly : Bool
                                        }
                                    , var-run :
                                        { mountPath : Text
                                        , name : Text
                                        , readOnly : Bool
                                        }
                                    }
                                }
                            }
                        , serviceAccountName : Text
                        , terminationGracePeriodSeconds : Natural
                        , volumes :
                            { disk : { hostPath : { path : Text }, name : Text }
                            , docker :
                                { hostPath : { path : Text }, name : Text }
                            , rootfs :
                                { hostPath : { path : Text }, name : Text }
                            , sys : { hostPath : { path : Text }, name : Text }
                            , var-run :
                                { hostPath : { path : Text }, name : Text }
                            }
                        }
                    }
                }
            }
        }
    , PodSecurityPolicy :
        { cadvisor :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { allowedHostPaths : List { pathPrefix : Text }
                , fsGroup : { rule : Text }
                , runAsUser : { rule : Text }
                , seLinux : { rule : Text }
                , supplementalGroups : { rule : Text }
                , volumes : List Text
                }
            }
        }
    , ServiceAccount :
        { cadvisor :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , category : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            }
        }
    }
, Frontend :
    { Deployment :
        { sourcegraph-frontend :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { minReadySeconds : Natural
                , replicas : Natural
                , revisionHistoryLimit : Natural
                , selector : { matchLabels : { app : Text } }
                , strategy :
                    { rollingUpdate :
                        { maxSurge : Natural, maxUnavailable : Natural }
                    , type : Text
                    }
                , template :
                    { metadata : { labels : { app : Text, deploy : Text } }
                    , spec :
                        { containers :
                            { frontend :
                                { args : List Text
                                , env :
                                    { CACHE_DIR : { name : Text, value : Text }
                                    , GRAFANA_SERVER_URL :
                                        { name : Text, value : Text }
                                    , JAEGER_SERVER_URL :
                                        { name : Text, value : Text }
                                    , PGDATABASE : { name : Text, value : Text }
                                    , PGHOST : { name : Text, value : Text }
                                    , PGPORT : { name : Text, value : Text }
                                    , PGSSLMODE : { name : Text, value : Text }
                                    , PGUSER : { name : Text, value : Text }
                                    , POD_NAME :
                                        { name : Text
                                        , valueFrom :
                                            { fieldRef : { fieldPath : Text } }
                                        }
                                    , PRECISE_CODE_INTEL_BUNDLE_MANAGER_URL :
                                        { name : Text, value : Text }
                                    , PROMETHEUS_URL :
                                        { name : Text, value : Text }
                                    , SRC_GIT_SERVERS :
                                        { name : Text, value : Text }
                                    }
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , livenessProbe :
                                    { httpGet :
                                        { path : Text
                                        , port : Text
                                        , scheme : Text
                                        }
                                    , initialDelaySeconds : Natural
                                    , timeoutSeconds : Natural
                                    }
                                , name : Text
                                , ports :
                                    { http :
                                        { containerPort : Natural, name : Text }
                                    , http-internal :
                                        { containerPort : Natural, name : Text }
                                    }
                                , readinessProbe :
                                    { httpGet :
                                        { path : Text
                                        , port : Text
                                        , scheme : Text
                                        }
                                    , periodSeconds : Natural
                                    , timeoutSeconds : Natural
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                , volumeMounts :
                                    { cache-ssd :
                                        { mountPath : Text, name : Text }
                                    }
                                }
                            , jaeger-agent :
                                { args : List Text
                                , env :
                                    { POD_NAME :
                                        { name : Text
                                        , valueFrom :
                                            { fieldRef :
                                                { apiVersion : Text
                                                , fieldPath : Text
                                                }
                                            }
                                        }
                                    }
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    List
                                      { containerPort : Natural
                                      , protocol : Text
                                      }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                }
                            }
                        , securityContext : { runAsUser : Natural }
                        , serviceAccountName : Text
                        , volumes :
                            { cache-ssd : { emptyDir : {}, name : Text } }
                        }
                    }
                }
            }
        }
    , Ingress :
        { sourcegraph-frontend :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations :
                    { `kubernetes.io/ingress.class` : Text
                    , `nginx.ingress.kubernetes.io/proxy-body-size` : Text
                    }
                , labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { rules :
                    List
                      { http :
                          { paths :
                              List
                                { backend :
                                    { serviceName : Text
                                    , servicePort : Natural
                                    }
                                , path : Text
                                }
                          }
                      }
                }
            }
        }
    , Role :
        { sourcegraph-frontend :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { `app.kubernetes.io/component` : Text
                    , category : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , rules :
                List
                  { apiGroups : List Text
                  , resources : List Text
                  , verbs : List Text
                  }
            }
        }
    , RoleBinding :
        { sourcegraph-frontend :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { `app.kubernetes.io/component` : Text
                    , category : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , roleRef : { apiGroup : Text, kind : Text, name : Text }
            , subjects : { sourcegraph-frontend : { kind : Text, name : Text } }
            }
        }
    , Service :
        { sourcegraph-frontend :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations :
                    { `prometheus.io/port` : Text
                    , `sourcegraph.prometheus/scrape` : Text
                    }
                , labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { ports :
                    { http : { name : Text, port : Natural, targetPort : Text }
                    }
                , selector : { app : Text }
                , type : Text
                }
            }
        , sourcegraph-frontend-internal :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { ports :
                    { http-internal :
                        { name : Text, port : Natural, targetPort : Text }
                    }
                , selector : { app : Text }
                , type : Text
                }
            }
        }
    , ServiceAccount :
        { sourcegraph-frontend :
            { apiVersion : Text
            , imagePullSecrets : { docker-registry : { name : Text } }
            , kind : Text
            , metadata :
                { labels :
                    { `app.kubernetes.io/component` : Text
                    , category : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            }
        }
    }
, Github-Proxy :
    { Deployment :
        { github-proxy :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { minReadySeconds : Natural
                , replicas : Natural
                , revisionHistoryLimit : Natural
                , selector : { matchLabels : { app : Text } }
                , strategy :
                    { rollingUpdate :
                        { maxSurge : Natural, maxUnavailable : Natural }
                    , type : Text
                    }
                , template :
                    { metadata : { labels : { app : Text, deploy : Text } }
                    , spec :
                        { containers :
                            { github-proxy :
                                { env : Optional <>
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    { http :
                                        { containerPort : Natural, name : Text }
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                }
                            , jaeger-agent :
                                { args : List Text
                                , env :
                                    { POD_NAME :
                                        { name : Text
                                        , valueFrom :
                                            { fieldRef :
                                                { apiVersion : Text
                                                , fieldPath : Text
                                                }
                                            }
                                        }
                                    }
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    List
                                      { containerPort : Natural
                                      , protocol : Text
                                      }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                }
                            }
                        , securityContext : { runAsUser : Natural }
                        }
                    }
                }
            }
        }
    , Service :
        { github-proxy :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations :
                    { `prometheus.io/port` : Text
                    , `sourcegraph.prometheus/scrape` : Text
                    }
                , labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { ports :
                    { http : { name : Text, port : Natural, targetPort : Text }
                    }
                , selector : { app : Text }
                , type : Text
                }
            }
        }
    }
, Gitserver :
    { Service :
        { gitserver :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations :
                    { description : Text
                    , `prometheus.io/port` : Text
                    , `sourcegraph.prometheus/scrape` : Text
                    }
                , labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    , type : Text
                    }
                , name : Text
                }
            , spec :
                { clusterIP : Text
                , ports :
                    { unused :
                        { name : Text, port : Natural, targetPort : Natural }
                    }
                , selector : { app : Text, type : Text }
                , type : Text
                }
            }
        }
    , StatefulSet :
        { gitserver :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { replicas : Natural
                , revisionHistoryLimit : Natural
                , selector : { matchLabels : { app : Text } }
                , serviceName : Text
                , template :
                    { metadata :
                        { labels :
                            { app : Text
                            , deploy : Text
                            , group : Text
                            , type : Text
                            }
                        }
                    , spec :
                        { containers :
                            { gitserver :
                                { args : List Text
                                , env : Optional <>
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , livenessProbe :
                                    { initialDelaySeconds : Natural
                                    , tcpSocket : { port : Text }
                                    , timeoutSeconds : Natural
                                    }
                                , name : Text
                                , ports :
                                    { rpc :
                                        { containerPort : Natural, name : Text }
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                , volumeMounts :
                                    { repos : { mountPath : Text, name : Text }
                                    }
                                }
                            , jaeger-agent :
                                { args : List Text
                                , env :
                                    { POD_NAME :
                                        { name : Text
                                        , valueFrom :
                                            { fieldRef :
                                                { apiVersion : Text
                                                , fieldPath : Text
                                                }
                                            }
                                        }
                                    }
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    List
                                      { containerPort : Natural
                                      , protocol : Text
                                      }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                }
                            }
                        , securityContext : { runAsUser : Natural }
                        , volumes : { repos : { name : Text } }
                        }
                    }
                , updateStrategy : { type : Text }
                , volumeClaimTemplates :
                    List
                      { apiVersion : Text
                      , kind : Text
                      , metadata : { name : Text }
                      , spec :
                          { accessModes : List Text
                          , resources :
                              { requests :
                                  { cpu : Optional Text
                                  , memory : Optional Text
                                  , ephemeralStorage : Optional Text
                                  }
                              }
                          , storageClassName : Text
                          }
                      }
                }
            }
        }
    }
, Grafana :
    { ConfigMap :
        { grafana :
            { apiVersion : Text
            , data : { `datasources.yml` : Text }
            , kind : Text
            , metadata :
                { labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            }
        }
    , Service :
        { grafana :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { ports :
                    { http : { name : Text, port : Natural, targetPort : Text }
                    }
                , selector : { app : Text }
                , type : Text
                }
            }
        }
    , ServiceAccount :
        { grafana :
            { apiVersion : Text
            , imagePullSecrets : { docker-registry : { name : Text } }
            , kind : Text
            , metadata :
                { labels :
                    { `app.kubernetes.io/component` : Text
                    , category : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            }
        }
    , StatefulSet :
        { grafana :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { replicas : Natural
                , revisionHistoryLimit : Natural
                , selector : { matchLabels : { app : Text } }
                , serviceName : Text
                , template :
                    { metadata : { labels : { app : Text, deploy : Text } }
                    , spec :
                        { containers :
                            { grafana :
                                { image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    { http :
                                        { containerPort : Natural, name : Text }
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                , volumeMounts :
                                    { config : { mountPath : Text, name : Text }
                                    , grafana-data :
                                        { mountPath : Text, name : Text }
                                    }
                                }
                            }
                        , securityContext : { runAsUser : Natural }
                        , serviceAccountName : Text
                        , volumes :
                            { config :
                                { configMap :
                                    { defaultMode : Natural, name : Text }
                                , name : Text
                                }
                            }
                        }
                    }
                , updateStrategy : { type : Text }
                , volumeClaimTemplates :
                    List
                      { apiVersion : Text
                      , kind : Text
                      , metadata : { name : Text }
                      , spec :
                          { accessModes : List Text
                          , resources :
                              { requests :
                                  { cpu : Optional Text
                                  , memory : Optional Text
                                  , ephemeralStorage : Optional Text
                                  }
                              }
                          , storageClassName : Text
                          }
                      }
                }
            }
        }
    }
, Indexed-Search :
    { Service :
        { indexed-search :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations :
                    { description : Text
                    , `prometheus.io/port` : Text
                    , `sourcegraph.prometheus/scrape` : Text
                    }
                , labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { clusterIP : Text
                , ports : List { port : Natural }
                , selector : { app : Text }
                , type : Text
                }
            }
        , indexed-search-indexer :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations :
                    { description : Text
                    , `prometheus.io/port` : Text
                    , `sourcegraph.prometheus/scrape` : Text
                    }
                , labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { clusterIP : Text
                , ports : List { port : Natural, targetPort : Natural }
                , selector : { app : Text }
                , type : Text
                }
            }
        }
    , StatefulSet :
        { indexed-search :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { replicas : Natural
                , revisionHistoryLimit : Natural
                , selector : { matchLabels : { app : Text } }
                , serviceName : Text
                , template :
                    { metadata : { labels : { app : Text, deploy : Text } }
                    , spec :
                        { containers :
                            { zoekt-indexserver :
                                { env : Optional <>
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    { index-http :
                                        { containerPort : Natural, name : Text }
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                , volumeMounts :
                                    { data : { mountPath : Text, name : Text } }
                                }
                            , zoekt-webserver :
                                { env : Optional <>
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    { http :
                                        { containerPort : Natural, name : Text }
                                    }
                                , readinessProbe :
                                    { failureThreshold : Natural
                                    , httpGet :
                                        { path : Text
                                        , port : Text
                                        , scheme : Text
                                        }
                                    , periodSeconds : Natural
                                    , timeoutSeconds : Natural
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                , volumeMounts :
                                    { data : { mountPath : Text, name : Text } }
                                }
                            }
                        , securityContext : { runAsUser : Natural }
                        , volumes : { data : { name : Text } }
                        }
                    }
                , updateStrategy : { type : Text }
                , volumeClaimTemplates :
                    List
                      { apiVersion : Text
                      , kind : Text
                      , metadata : { labels : { deploy : Text }, name : Text }
                      , spec :
                          { accessModes : List Text
                          , resources :
                              { requests :
                                  { cpu : Optional Text
                                  , memory : Optional Text
                                  , ephemeralStorage : Optional Text
                                  }
                              }
                          , storageClassName : Text
                          }
                      }
                }
            }
        }
    }
, Jaeger :
    { Deployment :
        { jaeger :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , `app.kubernetes.io/name` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { replicas : Natural
                , selector :
                    { matchLabels :
                        { app : Text
                        , `app.kubernetes.io/component` : Text
                        , `app.kubernetes.io/name` : Text
                        }
                    }
                , strategy : { type : Text }
                , template :
                    { metadata :
                        { annotations :
                            { `prometheus.io/port` : Text
                            , `prometheus.io/scrape` : Text
                            }
                        , labels :
                            { app : Text
                            , `app.kubernetes.io/component` : Text
                            , `app.kubernetes.io/name` : Text
                            , deploy : Text
                            }
                        }
                    , spec :
                        { containers :
                            { jaeger :
                                { args : List Text
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    List
                                      { containerPort : Natural
                                      , protocol : Text
                                      }
                                , readinessProbe :
                                    { httpGet : { path : Text, port : Natural }
                                    , initialDelaySeconds : Natural
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                }
                            }
                        , securityContext : { runAsUser : Natural }
                        }
                    }
                }
            }
        }
    , Service :
        { jaeger-collector :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , `app.kubernetes.io/name` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { ports :
                    { jaeger-collector-grpc :
                        { name : Text
                        , port : Natural
                        , protocol : Text
                        , targetPort : Natural
                        }
                    , jaeger-collector-http :
                        { name : Text
                        , port : Natural
                        , protocol : Text
                        , targetPort : Natural
                        }
                    , jaeger-collector-tchannel :
                        { name : Text
                        , port : Natural
                        , protocol : Text
                        , targetPort : Natural
                        }
                    }
                , selector :
                    { `app.kubernetes.io/component` : Text
                    , `app.kubernetes.io/name` : Text
                    }
                , type : Text
                }
            }
        , jaeger-query :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , `app.kubernetes.io/name` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { ports :
                    { query-http :
                        { name : Text
                        , port : Natural
                        , protocol : Text
                        , targetPort : Natural
                        }
                    }
                , selector :
                    { `app.kubernetes.io/component` : Text
                    , `app.kubernetes.io/name` : Text
                    }
                , type : Text
                }
            }
        }
    }
, Pgsql :
    { ConfigMap :
        { pgsql-conf :
            { apiVersion : Text
            , data : { `postgresql.conf` : Text }
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            }
        }
    , Deployment :
        { pgsql :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { minReadySeconds : Natural
                , replicas : Natural
                , revisionHistoryLimit : Natural
                , selector : { matchLabels : { app : Text } }
                , strategy : { type : Text }
                , template :
                    { metadata :
                        { labels : { app : Text, deploy : Text, group : Text } }
                    , spec :
                        { containers :
                            { pgsql :
                                { env : Optional <>
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , livenessProbe :
                                    { exec : { command : List Text }
                                    , initialDelaySeconds : Natural
                                    }
                                , name : Text
                                , ports :
                                    { pgsql :
                                        { containerPort : Natural, name : Text }
                                    }
                                , readinessProbe :
                                    { exec : { command : List Text } }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                , volumeMounts :
                                    { disk : { mountPath : Text, name : Text }
                                    , pgsql-conf :
                                        { mountPath : Text, name : Text }
                                    }
                                }
                            , pgsql-exporter :
                                { env :
                                    { DATA_SOURCE_NAME :
                                        { name : Text, value : Text }
                                    }
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                }
                            }
                        , initContainers :
                            { correct-data-dir-permissions :
                                { command : List Text
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , securityContext : { runAsUser : Natural }
                                , volumeMounts :
                                    { disk : { mountPath : Text, name : Text } }
                                }
                            }
                        , securityContext : { runAsUser : Natural }
                        , volumes :
                            { disk :
                                { name : Text
                                , persistentVolumeClaim : { claimName : Text }
                                }
                            , pgsql-conf :
                                { configMap :
                                    { defaultMode : Natural, name : Text }
                                , name : Text
                                }
                            }
                        }
                    }
                }
            }
        }
    , PersistentVolumeClaim :
        { pgsql :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { accessModes : List Text
                , resources :
                    { requests :
                        { cpu : Optional Text
                        , memory : Optional Text
                        , ephemeralStorage : Optional Text
                        }
                    }
                , storageClassName : Text
                }
            }
        }
    , Service :
        { pgsql :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations :
                    { `prometheus.io/port` : Text
                    , `sourcegraph.prometheus/scrape` : Text
                    }
                , labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { ports :
                    { pgsql : { name : Text, port : Natural, targetPort : Text }
                    }
                , selector : { app : Text }
                , type : Text
                }
            }
        }
    }
, Precise-Code-Intel :
    { Deployment :
        { precise-code-intel-bundle-manager :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { minReadySeconds : Natural
                , replicas : Natural
                , revisionHistoryLimit : Natural
                , selector : { matchLabels : { app : Text } }
                , strategy : { type : Text }
                , template :
                    { metadata : { labels : { app : Text, deploy : Text } }
                    , spec :
                        { containers :
                            { precise-code-intel-bundle-manager :
                                { env :
                                    { POD_NAME :
                                        { name : Text
                                        , valueFrom :
                                            { fieldRef : { fieldPath : Text } }
                                        }
                                    , PRECISE_CODE_INTEL_BUNDLE_DIR :
                                        { name : Text, value : Text }
                                    }
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , livenessProbe :
                                    { httpGet :
                                        { path : Text
                                        , port : Text
                                        , scheme : Text
                                        }
                                    , initialDelaySeconds : Natural
                                    , timeoutSeconds : Natural
                                    }
                                , name : Text
                                , ports :
                                    { debug :
                                        { containerPort : Natural, name : Text }
                                    , http :
                                        { containerPort : Natural, name : Text }
                                    }
                                , readinessProbe :
                                    { httpGet :
                                        { path : Text
                                        , port : Text
                                        , scheme : Text
                                        }
                                    , periodSeconds : Natural
                                    , timeoutSeconds : Natural
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                , volumeMounts :
                                    { bundle-manager :
                                        { mountPath : Text, name : Text }
                                    }
                                }
                            }
                        , securityContext : { runAsUser : Natural }
                        , volumes :
                            { bundle-manager :
                                { name : Text
                                , persistentVolumeClaim : { claimName : Text }
                                }
                            }
                        }
                    }
                }
            }
        , precise-code-intel-worker :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { minReadySeconds : Natural
                , replicas : Natural
                , revisionHistoryLimit : Natural
                , selector : { matchLabels : { app : Text } }
                , strategy :
                    { rollingUpdate :
                        { maxSurge : Natural, maxUnavailable : Natural }
                    , type : Text
                    }
                , template :
                    { metadata : { labels : { app : Text, deploy : Text } }
                    , spec :
                        { containers :
                            { precise-code-intel-worker :
                                { env :
                                    { NUM_WORKERS :
                                        { name : Text, value : Text }
                                    , POD_NAME :
                                        { name : Text
                                        , valueFrom :
                                            { fieldRef : { fieldPath : Text } }
                                        }
                                    , PRECISE_CODE_INTEL_BUNDLE_MANAGER_URL :
                                        { name : Text, value : Text }
                                    }
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , livenessProbe :
                                    { httpGet :
                                        { path : Text
                                        , port : Text
                                        , scheme : Text
                                        }
                                    , initialDelaySeconds : Natural
                                    , timeoutSeconds : Natural
                                    }
                                , name : Text
                                , ports :
                                    { debug :
                                        { containerPort : Natural, name : Text }
                                    , http :
                                        { containerPort : Natural, name : Text }
                                    }
                                , readinessProbe :
                                    { httpGet :
                                        { path : Text
                                        , port : Text
                                        , scheme : Text
                                        }
                                    , periodSeconds : Natural
                                    , timeoutSeconds : Natural
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                }
                            }
                        , securityContext : { runAsUser : Natural }
                        }
                    }
                }
            }
        }
    , PersistentVolumeClaim :
        { bundle-manager :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { accessModes : List Text
                , resources :
                    { requests :
                        { cpu : Optional Text
                        , memory : Optional Text
                        , ephemeralStorage : Optional Text
                        }
                    }
                , storageClassName : Text
                }
            }
        }
    , Service :
        { precise-code-intel-bundle-manager :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations :
                    { `prometheus.io/port` : Text
                    , `sourcegraph.prometheus/scrape` : Text
                    }
                , labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { ports :
                    { debug : { name : Text, port : Natural, targetPort : Text }
                    , http : { name : Text, port : Natural, targetPort : Text }
                    }
                , selector : { app : Text }
                , type : Text
                }
            }
        , precise-code-intel-worker :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations :
                    { `prometheus.io/port` : Text
                    , `sourcegraph.prometheus/scrape` : Text
                    }
                , labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { ports :
                    { debug : { name : Text, port : Natural, targetPort : Text }
                    , http : { name : Text, port : Natural, targetPort : Text }
                    }
                , selector : { app : Text }
                , type : Text
                }
            }
        }
    }
, Prometheus :
    { ClusterRole :
        { prometheus :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { `app.kubernetes.io/component` : Text
                    , category : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , rules :
                List
                  { apiGroups : Optional (List Text)
                  , nonResourceURLs : Optional (List Text)
                  , resources : Optional (List Text)
                  , verbs : List Text
                  }
            }
        }
    , ClusterRoleBinding :
        { prometheus :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { `app.kubernetes.io/component` : Text
                    , category : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , roleRef : { apiGroup : Text, kind : Text, name : Text }
            , subjects :
                { prometheus : { kind : Text, name : Text, namespace : Text } }
            }
        }
    , ConfigMap :
        { prometheus :
            { apiVersion : Text
            , data : { `extra_rules.yml` : Text, `prometheus.yml` : Text }
            , kind : Text
            , metadata :
                { labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            }
        }
    , Deployment :
        { prometheus :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { minReadySeconds : Natural
                , replicas : Natural
                , revisionHistoryLimit : Natural
                , selector : { matchLabels : { app : Text } }
                , strategy : { type : Text }
                , template :
                    { metadata : { labels : { app : Text, deploy : Text } }
                    , spec :
                        { containers :
                            { prometheus :
                                { image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , livenessProbe :
                                    { httpGet : { path : Text, port : Natural }
                                    , initialDelaySeconds : Natural
                                    , timeoutSeconds : Natural
                                    }
                                , name : Text
                                , ports :
                                    { http :
                                        { containerPort : Natural, name : Text }
                                    }
                                , readinessProbe :
                                    { httpGet : { path : Text, port : Natural }
                                    , initialDelaySeconds : Natural
                                    , timeoutSeconds : Natural
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                , volumeMounts :
                                    { config : { mountPath : Text, name : Text }
                                    , data : { mountPath : Text, name : Text }
                                    }
                                }
                            }
                        , securityContext : { runAsUser : Natural }
                        , serviceAccountName : Text
                        , volumes :
                            { config :
                                { configMap :
                                    { defaultMode : Natural, name : Text }
                                , name : Text
                                }
                            , data :
                                { name : Text
                                , persistentVolumeClaim : { claimName : Text }
                                }
                            }
                        }
                    }
                }
            }
        }
    , PersistentVolumeClaim :
        { prometheus :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { accessModes : List Text
                , resources :
                    { requests :
                        { cpu : Optional Text
                        , memory : Optional Text
                        , ephemeralStorage : Optional Text
                        }
                    }
                , storageClassName : Text
                }
            }
        }
    , Service :
        { prometheus :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { ports :
                    { http : { name : Text, port : Natural, targetPort : Text }
                    }
                , selector : { app : Text }
                , type : Text
                }
            }
        }
    , ServiceAccount :
        { prometheus :
            { apiVersion : Text
            , imagePullSecrets : { docker-registry : { name : Text } }
            , kind : Text
            , metadata :
                { labels :
                    { `app.kubernetes.io/component` : Text
                    , category : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            }
        }
    }
, Query-Runner :
    { Deployment :
        { query-runner :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { minReadySeconds : Natural
                , replicas : Natural
                , revisionHistoryLimit : Natural
                , selector : { matchLabels : { app : Text } }
                , strategy :
                    { rollingUpdate :
                        { maxSurge : Natural, maxUnavailable : Natural }
                    , type : Text
                    }
                , template :
                    { metadata : { labels : { app : Text, deploy : Text } }
                    , spec :
                        { containers :
                            { jaeger-agent :
                                { args : List Text
                                , env :
                                    { POD_NAME :
                                        { name : Text
                                        , valueFrom :
                                            { fieldRef :
                                                { apiVersion : Text
                                                , fieldPath : Text
                                                }
                                            }
                                        }
                                    }
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    List
                                      { containerPort : Natural
                                      , protocol : Text
                                      }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                }
                            , query-runner :
                                { env : Optional <>
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    { http :
                                        { containerPort : Natural, name : Text }
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                }
                            }
                        , securityContext : { runAsUser : Natural }
                        }
                    }
                }
            }
        }
    , Service :
        { query-runner :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations :
                    { `prometheus.io/port` : Text
                    , `sourcegraph.prometheus/scrape` : Text
                    }
                , labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { ports :
                    { http : { name : Text, port : Natural, targetPort : Text }
                    }
                , selector : { app : Text }
                , type : Text
                }
            }
        }
    }
, Redis :
    { Deployment :
        { redis-cache :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { minReadySeconds : Natural
                , replicas : Natural
                , revisionHistoryLimit : Natural
                , selector : { matchLabels : { app : Text } }
                , strategy : { type : Text }
                , template :
                    { metadata : { labels : { app : Text, deploy : Text } }
                    , spec :
                        { containers :
                            { redis-cache :
                                { env : Optional <>
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , livenessProbe :
                                    { initialDelaySeconds : Natural
                                    , tcpSocket : { port : Text }
                                    }
                                , name : Text
                                , ports :
                                    { redis :
                                        { containerPort : Natural, name : Text }
                                    }
                                , readinessProbe :
                                    { initialDelaySeconds : Natural
                                    , tcpSocket : { port : Text }
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                , volumeMounts :
                                    { redis-data :
                                        { mountPath : Text, name : Text }
                                    }
                                }
                            , redis-exporter :
                                { image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    { redisexp :
                                        { containerPort : Natural, name : Text }
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                }
                            }
                        , securityContext : { runAsUser : Natural }
                        , volumes :
                            { redis-data :
                                { name : Text
                                , persistentVolumeClaim : { claimName : Text }
                                }
                            }
                        }
                    }
                }
            }
        , redis-store :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { minReadySeconds : Natural
                , replicas : Natural
                , revisionHistoryLimit : Natural
                , selector : { matchLabels : { app : Text } }
                , strategy : { type : Text }
                , template :
                    { metadata : { labels : { app : Text, deploy : Text } }
                    , spec :
                        { containers :
                            { redis-exporter :
                                { image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    { redisexp :
                                        { containerPort : Natural, name : Text }
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                }
                            , redis-store :
                                { env : Optional <>
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , livenessProbe :
                                    { initialDelaySeconds : Natural
                                    , tcpSocket : { port : Text }
                                    }
                                , name : Text
                                , ports :
                                    { redis :
                                        { containerPort : Natural, name : Text }
                                    }
                                , readinessProbe :
                                    { initialDelaySeconds : Natural
                                    , tcpSocket : { port : Text }
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                , volumeMounts :
                                    { redis-data :
                                        { mountPath : Text, name : Text }
                                    }
                                }
                            }
                        , securityContext : { runAsUser : Natural }
                        , volumes :
                            { redis-data :
                                { name : Text
                                , persistentVolumeClaim : { claimName : Text }
                                }
                            }
                        }
                    }
                }
            }
        }
    , PersistentVolumeClaim :
        { redis-cache :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { accessModes : List Text
                , resources :
                    { requests :
                        { cpu : Optional Text
                        , memory : Optional Text
                        , ephemeralStorage : Optional Text
                        }
                    }
                , storageClassName : Text
                }
            }
        , redis-store :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { accessModes : List Text
                , resources :
                    { requests :
                        { cpu : Optional Text
                        , memory : Optional Text
                        , ephemeralStorage : Optional Text
                        }
                    }
                , storageClassName : Text
                }
            }
        }
    , Service :
        { redis-cache :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations :
                    { `prometheus.io/port` : Text
                    , `sourcegraph.prometheus/scrape` : Text
                    }
                , labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { ports :
                    { redis : { name : Text, port : Natural, targetPort : Text }
                    }
                , selector : { app : Text }
                , type : Text
                }
            }
        , redis-store :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations :
                    { `prometheus.io/port` : Text
                    , `sourcegraph.prometheus/scrape` : Text
                    }
                , labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { ports :
                    { redis : { name : Text, port : Natural, targetPort : Text }
                    }
                , selector : { app : Text }
                , type : Text
                }
            }
        }
    }
, Repo-Updater :
    { Deployment :
        { repo-updater :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { minReadySeconds : Natural
                , replicas : Natural
                , revisionHistoryLimit : Natural
                , selector : { matchLabels : { app : Text } }
                , strategy :
                    { rollingUpdate :
                        { maxSurge : Natural, maxUnavailable : Natural }
                    , type : Text
                    }
                , template :
                    { metadata : { labels : { app : Text, deploy : Text } }
                    , spec :
                        { containers :
                            { jaeger-agent :
                                { args : List Text
                                , env :
                                    { POD_NAME :
                                        { name : Text
                                        , valueFrom :
                                            { fieldRef :
                                                { apiVersion : Text
                                                , fieldPath : Text
                                                }
                                            }
                                        }
                                    }
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    List
                                      { containerPort : Natural
                                      , protocol : Text
                                      }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                }
                            , repo-updater :
                                { env : Optional <>
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    { debug :
                                        { containerPort : Natural, name : Text }
                                    , http :
                                        { containerPort : Natural, name : Text }
                                    }
                                , readinessProbe :
                                    { failureThreshold : Natural
                                    , httpGet :
                                        { path : Text
                                        , port : Text
                                        , scheme : Text
                                        }
                                    , periodSeconds : Natural
                                    , timeoutSeconds : Natural
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                }
                            }
                        , securityContext : { runAsUser : Natural }
                        }
                    }
                }
            }
        }
    , Service :
        { repo-updater :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations :
                    { `prometheus.io/port` : Text
                    , `sourcegraph.prometheus/scrape` : Text
                    }
                , labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { ports :
                    { http : { name : Text, port : Natural, targetPort : Text }
                    }
                , selector : { app : Text }
                , type : Text
                }
            }
        }
    }
, Searcher :
    { Deployment :
        { searcher :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { minReadySeconds : Natural
                , replicas : Natural
                , revisionHistoryLimit : Natural
                , selector : { matchLabels : { app : Text } }
                , strategy :
                    { rollingUpdate :
                        { maxSurge : Natural, maxUnavailable : Natural }
                    , type : Text
                    }
                , template :
                    { metadata : { labels : { app : Text, deploy : Text } }
                    , spec :
                        { containers :
                            { jaeger-agent :
                                { args : List Text
                                , env :
                                    { POD_NAME :
                                        { name : Text
                                        , valueFrom :
                                            { fieldRef :
                                                { apiVersion : Text
                                                , fieldPath : Text
                                                }
                                            }
                                        }
                                    }
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    List
                                      { containerPort : Natural
                                      , protocol : Text
                                      }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                }
                            , searcher :
                                { env :
                                    { CACHE_DIR : { name : Text, value : Text }
                                    , POD_NAME :
                                        { name : Text
                                        , valueFrom :
                                            { fieldRef : { fieldPath : Text } }
                                        }
                                    , SEARCHER_CACHE_SIZE_MB :
                                        { name : Text, value : Text }
                                    }
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    { debug :
                                        { containerPort : Natural, name : Text }
                                    , http :
                                        { containerPort : Natural, name : Text }
                                    }
                                , readinessProbe :
                                    { failureThreshold : Natural
                                    , httpGet :
                                        { path : Text
                                        , port : Text
                                        , scheme : Text
                                        }
                                    , periodSeconds : Natural
                                    , timeoutSeconds : Natural
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                , volumeMounts :
                                    { cache-ssd :
                                        { mountPath : Text, name : Text }
                                    }
                                }
                            }
                        , securityContext : { runAsUser : Natural }
                        , volumes :
                            { cache-ssd : { emptyDir : {}, name : Text } }
                        }
                    }
                }
            }
        }
    , Service :
        { searcher :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations :
                    { `prometheus.io/port` : Text
                    , `sourcegraph.prometheus/scrape` : Text
                    }
                , labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { ports :
                    { debug : { name : Text, port : Natural, targetPort : Text }
                    , http : { name : Text, port : Natural, targetPort : Text }
                    }
                , selector : { app : Text }
                , type : Text
                }
            }
        }
    }
, Symbols :
    { Deployment :
        { symbols :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { minReadySeconds : Natural
                , replicas : Natural
                , revisionHistoryLimit : Natural
                , selector : { matchLabels : { app : Text } }
                , strategy :
                    { rollingUpdate :
                        { maxSurge : Natural, maxUnavailable : Natural }
                    , type : Text
                    }
                , template :
                    { metadata : { labels : { app : Text, deploy : Text } }
                    , spec :
                        { containers :
                            { jaeger-agent :
                                { args : List Text
                                , env :
                                    { POD_NAME :
                                        { name : Text
                                        , valueFrom :
                                            { fieldRef :
                                                { apiVersion : Text
                                                , fieldPath : Text
                                                }
                                            }
                                        }
                                    }
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , name : Text
                                , ports :
                                    List
                                      { containerPort : Natural
                                      , protocol : Text
                                      }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                }
                            , symbols :
                                { env :
                                    { CACHE_DIR : { name : Text, value : Text }
                                    , POD_NAME :
                                        { name : Text
                                        , valueFrom :
                                            { fieldRef : { fieldPath : Text } }
                                        }
                                    , SYMBOLS_CACHE_SIZE_MB :
                                        { name : Text, value : Text }
                                    }
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , livenessProbe :
                                    { httpGet :
                                        { path : Text
                                        , port : Text
                                        , scheme : Text
                                        }
                                    , initialDelaySeconds : Natural
                                    , timeoutSeconds : Natural
                                    }
                                , name : Text
                                , ports :
                                    { debug :
                                        { containerPort : Natural, name : Text }
                                    , http :
                                        { containerPort : Natural, name : Text }
                                    }
                                , readinessProbe :
                                    { httpGet :
                                        { path : Text
                                        , port : Text
                                        , scheme : Text
                                        }
                                    , periodSeconds : Natural
                                    , timeoutSeconds : Natural
                                    }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                , volumeMounts :
                                    { cache-ssd :
                                        { mountPath : Text, name : Text }
                                    }
                                }
                            }
                        , securityContext : { runAsUser : Natural }
                        , volumes :
                            { cache-ssd : { emptyDir : {}, name : Text } }
                        }
                    }
                }
            }
        }
    , Service :
        { symbols :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations :
                    { `prometheus.io/port` : Text
                    , `sourcegraph.prometheus/scrape` : Text
                    }
                , labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { ports :
                    { debug : { name : Text, port : Natural, targetPort : Text }
                    , http : { name : Text, port : Natural, targetPort : Text }
                    }
                , selector : { app : Text }
                , type : Text
                }
            }
        }
    }
, Syntect-Server :
    { Deployment :
        { syntect-server :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { annotations : { description : Text }
                , labels :
                    { `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { minReadySeconds : Natural
                , replicas : Natural
                , revisionHistoryLimit : Natural
                , selector : { matchLabels : { app : Text } }
                , strategy :
                    { rollingUpdate :
                        { maxSurge : Natural, maxUnavailable : Natural }
                    , type : Text
                    }
                , template :
                    { metadata : { labels : { app : Text, deploy : Text } }
                    , spec :
                        { containers :
                            { syntect-server :
                                { env : Optional <>
                                , image :
                                    < asText : Text
                                    | asRecord :
                                        { name : Text
                                        , registry : Text
                                        , sha256 : Text
                                        , version : Text
                                        }
                                    >
                                , livenessProbe :
                                    { httpGet :
                                        { path : Text
                                        , port : Text
                                        , scheme : Text
                                        }
                                    , initialDelaySeconds : Natural
                                    , timeoutSeconds : Natural
                                    }
                                , name : Text
                                , ports :
                                    { http :
                                        { containerPort : Natural, name : Text }
                                    }
                                , readinessProbe :
                                    { tcpSocket : { port : Text } }
                                , resources :
                                    { limits :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    , requests :
                                        { cpu : Optional Text
                                        , memory : Optional Text
                                        , ephemeralStorage : Optional Text
                                        }
                                    }
                                , terminationMessagePolicy : Text
                                }
                            }
                        , securityContext : { runAsUser : Natural }
                        }
                    }
                }
            }
        }
    , Service :
        { syntect-server :
            { apiVersion : Text
            , kind : Text
            , metadata :
                { labels :
                    { app : Text
                    , `app.kubernetes.io/component` : Text
                    , deploy : Text
                    , sourcegraph-resource-requires : Text
                    }
                , name : Text
                }
            , spec :
                { ports :
                    { http : { name : Text, port : Natural, targetPort : Text }
                    }
                , selector : { app : Text }
                , type : Text
                }
            }
        }
    }
}
