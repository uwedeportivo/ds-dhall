let customization/container = ./container.dhall

let schema =
      { Type =
          { Frontend :
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
      , default.Frontend.Deployment.sourcegraph-frontend.containers =
        { frontend = customization/container.default
        , jaeger-agent = customization/container.default
        }
      }

in  schema
