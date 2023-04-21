# Based on:
# - https://github.com/garethr/openshift-json-schema
# - https://cloud.redhat.com/blog/validating-openshift-manifests-in-a-gitops-world

VERSION ?= $(shell oc version -o json | jq -r 'if .openshiftVersion then "v" + .openshiftVersion | split(".")[:2] | join(".") else "master" end')
OPENAPI_SPEC_FILE = openapi/openshift-openapi-spec-$(VERSION).json
PREFIX = https://raw.githubusercontent.com/melmorabity/openshift-json-schemas/main/$(VERSION)/_definitions.json

export VENV_DIR = $(PWD)/.venv

define generate_schema =
$(VERSION)$(if $(1),-$(1))/_definitions.json: $(OPENAPI_SPEC_FILE) venv
	. $(VENV_DIR)/bin/activate && \
	openapi2jsonschema -o $$(dir $$@) --expanded --kubernetes $(2) $$< && \
	openapi2jsonschema -o $$(dir $$@) --kubernetes $(2) $$<

SCHEMA_DEFINITIONS += $(VERSION)$(if $(1),-$(1))/_definitions.json
SCHEMA_DIRS += $(VERSION)$(if $(1),-$(1))
endef

all: build_schemas

$(VENV_DIR)/bin/python:
	python3 -m venv $(VENV_DIR)
	. $(VENV_DIR)/bin/activate && pip install openapi2jsonschema

venv: $(VENV_DIR)/bin/python

$(OPENAPI_SPEC_FILE):
	mkdir -p $(dir $(OPENAPI_SPEC_FILE))
	oc get --raw /openapi/v2 >$@

$(eval $(call generate_schema,,--prefix $(PREFIX)))

$(eval $(call generate_schema,standalone,--stand-alone))

$(eval $(call generate_schema,standalone-strict,--stand-alone --strict))

$(eval $(call generate_schema,local,))

build_schemas: $(SCHEMA_DEFINITIONS)

test: lint

lint:
	pre-commit run --all

clean:
	$(RM) -r $(SCHEMA_DIRS)

mrproper: clean
	$(RM) $(OPENAPI_SPEC_FILE)
	$(RM) -r $(VENV_DIR)

.PHONY: all venv build_schemas test lint clean mrproper
