# SPDX-License-Identifier: Apache-2.0
#
# Copyright (c) 2024  Panasonic Automotive Systems, Co., Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#CURDIR := $(dir $(lastword $(MAKEFILE_LIST)))

GO?=go
GOBUILDFLAGS?=-v

###linux
GOOS?=linux

###################

###x86 32-bit (Linux is no support)
#GOARCH?=386

###x86_64 64-bit
GOARCH?=amd64

###arm 32-bit (Linux is no support)
#GOARCH?=arm

###arm64 64-bit
#GOARCH?=arm64

ifeq ($(GOOS), linux)
    ifeq ($(GOARCH), amd64)
        LIBTARGET=gcc
    else ifeq ($(GOARCH), arm64)
        LIBTARGET=aarch64-linux-gnu-gcc
    endif
endif

THIS_DIR=.
MODULES=cmd \
	internal

INSTALL_MODULES=$(patsubst %,install-%, $(MODULES))
CLEAN_MODULES=$(patsubst %,clean-%, $(MODULES))
TEST_MODULES=$(patsubst %,test-%, $(MODULES))
FMT_MODULES=$(patsubst %,fmt-%, $(MODULES))
LINT_MODULES=$(patsubst %,lint-%, $(MODULES))
DOC_MODULES=$(patsubst %,doc-%, $(MODULES))


.PHONY: all install $(INSTALL_MODULES)
all : install ulaclientlib
install : $(INSTALL_MODULES)

$(INSTALL_MODULES):
	set -e;\
	target=`echo $@ | sed -e 's/install-//'`;\
	make -C $${target} install

.PHONY: test $(TEST_MODULES)
test: $(TEST_MODULES)

$(TEST_MODULES) :
	set -e;\
	target=`echo $@ | sed -e 's/test-//'`;\
	make -C $${target} test

.PHONY: fmt $(FMT_MODULES)
fmt: $(FMT_MODULES)

$(FMT_MODULES) :
	set -e;\
	target=`echo $@ | sed -e 's/fmt-//'`;\
	make -C $${target} fmt

.PHONY: lint $(LINT_MODULES)
lint: $(LINT_MODULES)

$(LINT_MODULES):
	set -e;\
	target=`echo $@ | sed -e 's/lint-//'`;\
	make -C $${target} lint

.PHONY: doc $(DOC_MODULES)
doc: $(DOC_MODULES)

$(DOC_MODULES):
	set -e;\
	target=`echo $@ | sed -e 's/doc-//'`;\
	make -C $${target} doc

.PHONY: clean $(CLEAN_MODULES)
clean: $(CLEAN_MODULES)

$(CLEAN_MODULES):
	set -e;\
	target=`echo $@ | sed -e 's/clean-//'`;\
	make -C $${target} clean 

.PHONY: ulanodelib
ulanodelib:
	set -e;\
	make GOOS=${GOOS} GOARCH=${GOARCH} LIBTARGET=${LIBTARGET} LIBAPI=${LIBAPI} STRIPTARGET=${STRIPTARGET} -C cmd $@

.PHONY: ulaclientlib
ulaclientlib:
	set -e;\
	make GOOS=${GOOS} GOARCH=${GOARCH} LIBTARGET=${LIBTARGET} -C pkg/ula-client-lib $@

.PHONY: linuxulanodelib
linuxulanodelib:
	set -e;\
	make GOOS=${GOOS} GOARCH=${GOARCH} LIBTARGET=${LIBTARGET} -C cmd $@


