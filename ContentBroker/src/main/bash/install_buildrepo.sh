#!/bin/bash

# author: Daniel M. de Oliveira

REVISION_NUMBER=`git rev-list HEAD --count`
cp -r ../installation /ci/BuildRepository/installation.$REVISION_NUMBER