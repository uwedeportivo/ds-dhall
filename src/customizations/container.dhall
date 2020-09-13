let container/resources = ../combinators/container-resources.dhall

let vsType = { version : Text, sha256 : Text }

let container =
      { Type =
          { resources : Optional container/resources.Type
          , vs : Optional vsType
          , additionalEnv : Optional (List { name : Text, value : Text })
          }
      , default =
        { resources = None container/resources.Type
        , vs = None vsType
        , additionalEnv = None (List { name : Text, value : Text })
        }
      }

in  container
