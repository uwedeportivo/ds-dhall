{- Generated by dhallie DO NOT EDIT -}

let customization/container = ./container.dhall

let container/image = ./image.dhall

let schema =
      { Type =
            { Shared :
                { namespace : Optional Text, imageMods : container/image.Type }
            }
          ⩓ { Precise-Code-Intel :
                { Deployment :
                    { precise-code-intel-bundle-manager :
                        { containers :
                            { precise-code-intel-bundle-manager :
                                customization/container.Type
                            }
                        }
                    }
                }
            }
          ⩓ { Precise-Code-Intel :
                { Deployment :
                    { precise-code-intel-worker :
                        { containers :
                            { precise-code-intel-worker :
                                customization/container.Type
                            }
                        }
                    }
                }
            }
          ⩓ { Redis :
                { Deployment :
                    { redis-cache :
                        { containers :
                            { redis-cache : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Redis :
                { Deployment :
                    { redis-cache :
                        { containers :
                            { redis-exporter : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Redis :
                { Deployment :
                    { redis-store :
                        { containers :
                            { redis-store : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Redis :
                { Deployment :
                    { redis-store :
                        { containers :
                            { redis-exporter : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Syntect-Server :
                { Deployment :
                    { syntect-server :
                        { containers :
                            { syntect-server : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Jaeger :
                { Deployment :
                    { jaeger :
                        { containers : { jaeger : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Searcher :
                { Deployment :
                    { searcher :
                        { containers :
                            { jaeger-agent : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Searcher :
                { Deployment :
                    { searcher :
                        { containers :
                            { searcher : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Query-Runner :
                { Deployment :
                    { query-runner :
                        { containers :
                            { jaeger-agent : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Query-Runner :
                { Deployment :
                    { query-runner :
                        { containers :
                            { query-runner : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Repo-Updater :
                { Deployment :
                    { repo-updater :
                        { containers :
                            { jaeger-agent : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Repo-Updater :
                { Deployment :
                    { repo-updater :
                        { containers :
                            { repo-updater : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Github-Proxy :
                { Deployment :
                    { github-proxy :
                        { containers :
                            { github-proxy : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Github-Proxy :
                { Deployment :
                    { github-proxy :
                        { containers :
                            { jaeger-agent : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Pgsql :
                { Deployment :
                    { pgsql :
                        { containers : { pgsql : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Pgsql :
                { Deployment :
                    { pgsql :
                        { containers :
                            { pgsql-exporter : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Prometheus :
                { Deployment :
                    { prometheus :
                        { containers :
                            { prometheus : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Symbols :
                { Deployment :
                    { symbols :
                        { containers :
                            { jaeger-agent : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Symbols :
                { Deployment :
                    { symbols :
                        { containers :
                            { symbols : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Frontend :
                { Deployment :
                    { sourcegraph-frontend :
                        { containers :
                            { jaeger-agent : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Frontend :
                { Deployment :
                    { sourcegraph-frontend :
                        { containers :
                            { frontend : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Grafana :
                { StatefulSet :
                    { grafana :
                        { containers :
                            { grafana : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Gitserver :
                { StatefulSet :
                    { gitserver :
                        { containers :
                            { gitserver : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Gitserver :
                { StatefulSet :
                    { gitserver :
                        { containers :
                            { jaeger-agent : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Indexed-Search :
                { StatefulSet :
                    { indexed-search :
                        { containers :
                            { zoekt-indexserver : customization/container.Type }
                        }
                    }
                }
            }
          ⩓ { Indexed-Search :
                { StatefulSet :
                    { indexed-search :
                        { containers :
                            { zoekt-webserver : customization/container.Type }
                        }
                    }
                }
            }
      , default =
            { Shared =
              { namespace = None Text, imageMods = container/image.default }
            }
          ∧ { Precise-Code-Intel.Deployment.precise-code-intel-bundle-manager.containers.precise-code-intel-bundle-manager =
                customization/container.default
            }
          ∧ { Precise-Code-Intel.Deployment.precise-code-intel-worker.containers.precise-code-intel-worker =
                customization/container.default
            }
          ∧ { Redis.Deployment.redis-cache.containers.redis-cache =
                customization/container.default
            }
          ∧ { Redis.Deployment.redis-cache.containers.redis-exporter =
                customization/container.default
            }
          ∧ { Redis.Deployment.redis-store.containers.redis-store =
                customization/container.default
            }
          ∧ { Redis.Deployment.redis-store.containers.redis-exporter =
                customization/container.default
            }
          ∧ { Syntect-Server.Deployment.syntect-server.containers.syntect-server =
                customization/container.default
            }
          ∧ { Jaeger.Deployment.jaeger.containers.jaeger =
                customization/container.default
            }
          ∧ { Searcher.Deployment.searcher.containers.jaeger-agent =
                customization/container.default
            }
          ∧ { Searcher.Deployment.searcher.containers.searcher =
                customization/container.default
            }
          ∧ { Query-Runner.Deployment.query-runner.containers.jaeger-agent =
                customization/container.default
            }
          ∧ { Query-Runner.Deployment.query-runner.containers.query-runner =
                customization/container.default
            }
          ∧ { Repo-Updater.Deployment.repo-updater.containers.jaeger-agent =
                customization/container.default
            }
          ∧ { Repo-Updater.Deployment.repo-updater.containers.repo-updater =
                customization/container.default
            }
          ∧ { Github-Proxy.Deployment.github-proxy.containers.github-proxy =
                customization/container.default
            }
          ∧ { Github-Proxy.Deployment.github-proxy.containers.jaeger-agent =
                customization/container.default
            }
          ∧ { Pgsql.Deployment.pgsql.containers.pgsql =
                customization/container.default
            }
          ∧ { Pgsql.Deployment.pgsql.containers.pgsql-exporter =
                customization/container.default
            }
          ∧ { Prometheus.Deployment.prometheus.containers.prometheus =
                customization/container.default
            }
          ∧ { Symbols.Deployment.symbols.containers.jaeger-agent =
                customization/container.default
            }
          ∧ { Symbols.Deployment.symbols.containers.symbols =
                customization/container.default
            }
          ∧ { Frontend.Deployment.sourcegraph-frontend.containers.jaeger-agent =
                customization/container.default
            }
          ∧ { Frontend.Deployment.sourcegraph-frontend.containers.frontend =
                customization/container.default
            }
          ∧ { Grafana.StatefulSet.grafana.containers.grafana =
                customization/container.default
            }
          ∧ { Gitserver.StatefulSet.gitserver.containers.gitserver =
                customization/container.default
            }
          ∧ { Gitserver.StatefulSet.gitserver.containers.jaeger-agent =
                customization/container.default
            }
          ∧ { Indexed-Search.StatefulSet.indexed-search.containers.zoekt-indexserver =
                customization/container.default
            }
          ∧ { Indexed-Search.StatefulSet.indexed-search.containers.zoekt-webserver =
                customization/container.default
            }
      }

in  schema
