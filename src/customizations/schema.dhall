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
          }
      , default =
        { Shared =
          { namespace = None Text, imageMods = container/image.default }
        , Frontend.Deployment.sourcegraph-frontend.containers =
          { frontend = customization/container.default
          , jaeger-agent = customization/container.default
          }
        }
      }

in  schema
