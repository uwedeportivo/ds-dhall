let container/resources = ../legos/container-resources.dhall

let container =
      { Type = { resources : container/resources.Type, version : Optional Text }
      , default =
        { resources = container/resources.default, version = None Text }
      }

in  container
