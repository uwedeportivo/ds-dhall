let baseType = { name : Text, registry : Text, sha256 : Text, version : Text }

let customization = ../customizations/image.dhall

let overlayMerge
    : baseType → customization.Type → Optional Text → Optional Text → Text
    = λ(base : baseType) →
      λ(overlay : customization.Type) →
      λ(overrideVersion : Optional Text) →
      λ(overrideSha256 : Optional Text) →
        let overlayedRegistry =
              merge
                { Some = λ(x : Text) → x, None = base.registry }
                overlay.registry

        let prefixedName =
              merge
                { Some = λ(x : Text) → x ++ base.name, None = base.name }
                overlay.prefix

        let prefixedAndSuffixName =
              merge
                { Some = λ(x : Text) → prefixedName ++ x, None = prefixedName }
                overlay.suffix

        let finalVersion =
              merge
                { Some = λ(x : Text) → x, None = base.version }
                overrideVersion

        let finalSha356 =
              merge
                { Some = λ(x : Text) → x, None = base.sha256 }
                overrideSha256

        let p1 = prefixedAndSuffixName ++ ":" ++ finalVersion

        let p2 =
              if    overlay.omitRegistry
              then  p1
              else  overlayedRegistry ++ "/" ++ p1

        let p3 =
              if overlay.omitSha256 then p2 else p2 ++ "@sha256:" ++ finalSha356

        in  p3

let tests =
      { t1 =
            assert
          :   overlayMerge
                { name = "foo"
                , registry = "docker.io"
                , sha256 =
                    "776606b680d7ce4a5d37451831ef2414ab10414b5e945ed5f50fe768f898d23f"
                , version = "3.19.2"
                }
                customization::{=}
                (None Text)
                (None Text)
            ≡ "docker.io/foo:3.19.2@sha256:776606b680d7ce4a5d37451831ef2414ab10414b5e945ed5f50fe768f898d23f"
      , t2 =
            assert
          :   overlayMerge
                { name = "foo"
                , registry = "docker.io"
                , sha256 =
                    "776606b680d7ce4a5d37451831ef2414ab10414b5e945ed5f50fe768f898d23f"
                , version = "3.19.2"
                }
                customization::{ registry = Some "google.io" }
                (None Text)
                (None Text)
            ≡ "google.io/foo:3.19.2@sha256:776606b680d7ce4a5d37451831ef2414ab10414b5e945ed5f50fe768f898d23f"
      , t3 =
            assert
          :   overlayMerge
                { name = "foo"
                , registry = "docker.io"
                , sha256 =
                    "776606b680d7ce4a5d37451831ef2414ab10414b5e945ed5f50fe768f898d23f"
                , version = "3.19.2"
                }
                customization::{
                , registry = Some "google.io"
                , prefix = Some "pre"
                , suffix = Some "ix"
                }
                (None Text)
                (None Text)
            ≡ "google.io/prefooix:3.19.2@sha256:776606b680d7ce4a5d37451831ef2414ab10414b5e945ed5f50fe768f898d23f"
      , t4 =
            assert
          :   overlayMerge
                { name = "foo"
                , registry = "docker.io"
                , sha256 =
                    "776606b680d7ce4a5d37451831ef2414ab10414b5e945ed5f50fe768f898d23f"
                , version = "3.19.2"
                }
                customization::{
                , registry = Some "google.io"
                , prefix = Some "pre"
                , suffix = Some "ix"
                }
                (Some "insiders")
                ( Some
                    "51b827ff2bf3f9df740cd8538840ef7fd7cb245c7b93063ef829f67ca71ea23e"
                )
            ≡ "google.io/prefooix:insiders@sha256:51b827ff2bf3f9df740cd8538840ef7fd7cb245c7b93063ef829f67ca71ea23e"
      , t5 =
            assert
          :   overlayMerge
                { name = "foo"
                , registry = "docker.io"
                , sha256 =
                    "776606b680d7ce4a5d37451831ef2414ab10414b5e945ed5f50fe768f898d23f"
                , version = "3.19.2"
                }
                customization::{
                , registry = Some "google.io"
                , prefix = Some "pre"
                , suffix = Some "ix"
                , omitRegistry = True
                }
                (None Text)
                (None Text)
            ≡ "prefooix:3.19.2@sha256:776606b680d7ce4a5d37451831ef2414ab10414b5e945ed5f50fe768f898d23f"
      , t6 =
            assert
          :   overlayMerge
                { name = "foo"
                , registry = "docker.io"
                , sha256 =
                    "776606b680d7ce4a5d37451831ef2414ab10414b5e945ed5f50fe768f898d23f"
                , version = "3.19.2"
                }
                customization::{
                , registry = Some "google.io"
                , prefix = Some "pre"
                , suffix = Some "ix"
                , omitSha256 = True
                }
                (None Text)
                (None Text)
            ≡ "google.io/prefooix:3.19.2"
      }

in  overlayMerge
