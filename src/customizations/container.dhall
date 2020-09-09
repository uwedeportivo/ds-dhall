let container/resources = ../legos/container-resources.dhall

let vsType = { version : Text, sha256 : Text }

let container =
      { Type = { resources : container/resources.Type, vs : Optional vsType }
      , default = { resources = container/resources.default, vs = None vsType }
      }

in  container
