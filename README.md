solution for the assignment in https://github.com/sourcegraph/sourcegraph/issues/13335

base is created from 

https://github.com/sourcegraph/ds-to-dhall/pull/18

with 

```shell script
ds-to-dhall -d /Users/uwe/Desktop/ds-to-dhall-out/record.dhall \
    -t /Users/uwe/Desktop/ds-to-dhall-out/type.dhall \
    -s /Users/uwe/Desktop/ds-to-dhall-out/schema.dhall \
    --strengthenSchema /Users/uwe/Desktop/base
```

from a base in https://github.com/sourcegraph/deploy-sourcegraph with https://github.com/sourcegraph/deploy-sourcegraph/pull/844


