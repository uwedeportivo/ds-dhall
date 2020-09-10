let customization/container = ./container.dhall

let container/image = ./image.dhall

let schema =
      { Type =
          { Shared :
              { namespace : Optional Text, imageMods : container/image.Type }
          , Frontend :
              { Deployment :
                  { sourcegraph-frontend :
                      { containers :
                          { frontend : customization/container.Type
                          , jaeger-agent : customization/container.Type
                          }
                      }
                  }
              }
          , Indexed-Search :
              { StatefulSet :
                  { indexed-search :
                      { containers :
                          { zoekt-indexserver : customization/container.Type
                          , zoekt-webserver : customization/container.Type
                          }
                      }
                  }
              }
          }
      , default =
        { Shared =
          { namespace = None Text, imageMods = container/image.default }
        , Frontend.Deployment.sourcegraph-frontend.containers =
          { frontend = customization/container.default
          , jaeger-agent = customization/container.default
          }
        , Indexed-Search.StatefulSet.indexed-search.containers =
          { zoekt-indexserver = customization/container.default
          , zoekt-webserver = customization/container.default
          }
        }
      }

in  schema
