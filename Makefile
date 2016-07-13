#
# Compiles the C* sphinx docs, copy them in the website directory and build the website.
# This needs to know where the C* sources are, so it should be called with
#    CASSANDRA_DIR="<source to Cassandra's git sources>" make
#
# By default, this makefile builds the website (calls jekyll build), but for local testing, the "serve"
# target does 2 things:
#   1) it doesn't regenerate the sphinx docs, unless those don't exist (because you did a make clean for instance)
#   2) it calls 'jekyll serve'
#

CASSANDRA_DOC_DIR="$(CASSANDRA_DIR)/doc"
DOC_DIR="doc"

HAS_DOC=$(shell [ -d $(DOC_DIR) ] && echo 0 || echo 1)

.check-env:
ifndef CASSANDRA_DIR
	$(error You should set the CASSANDRA_DIR environment variable to the git source dir, checkout on the proper branch)
endif

all: add-doc
	@jekyll build

clean:
	@rm -rf $(DOC_DIR)
	@jekyll clean

ifeq ($(HAS_DOC), 0)
serve:
else
serve: add-doc
endif
	@jekyll serve

add-doc: .check-env
	@cd $(CASSANDRA_DOC_DIR); make website
	@if [ -d $(DOC_DIR) ]; then rm -rf $(DOC_DIR); fi
	@cp -r $(CASSANDRA_DOC_DIR)/build/html $(DOC_DIR)
