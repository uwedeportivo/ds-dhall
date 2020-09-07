let container/resources = ../legos/container-resources.dhall

let container/image = ./image.dhall

let container =
      { Type =
          { resources : container/resources.Type, image : container/image.Type }
      , default =
        { resources = container/resources.default
        , image = container/image.default
        }
      }

in  container
