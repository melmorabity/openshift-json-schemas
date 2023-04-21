# OpenShift JSON schemas

This project provides a set of JSON schemas for the most recent OpenShift versions, starting with version 4.10. These schemas are useful, for example, for validating OpenShift YAML or JSON files locally with tools like [Kubeval](https://github.com/instrumenta/kubeval) or [Kubeconform](https://github.com/yannh/kubeconform).

This project was inspired by the [OpenShift JSON schema project by Gareth Rushgrove](https://github.com/garethr/openshift-json-schema) and [this Red Hat Cloud blog article by Andrew Block](https://cloud.redhat.com/blog/validating-openshift-manifests-in-a-gitops-world).

The schemas were generated from [OpenAPI v2 specifications](openapi/), which were dumped from OpenShift instances run by [CRC](https://github.com/crc-org/crc), and then converted to JSON schemas using [openapi2jsonschema](https://github.com/instrumenta/openapi2jsonschema). A [Makefile](Makefile) automating these various steps is available.

For each OpenShift version, different "flavors" of schemas are available:

* `vX.Y`: URL-referenced schemas
* `vX.Y-standalone`: de-referenced schemas, which are more useful as standalone documents
* `vX.Y-standalone-strict`: de-referenced schemas, which are more useful as standalone documents and prohibit properties not in the schema
* `vX.Y-local`: relative references, which are useful for avoiding network dependencies.
