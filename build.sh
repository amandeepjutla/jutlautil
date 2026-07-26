#!/usr/bin/env bash
# build.sh
# Author: "Amandeep Jutla, with Claude (Opus 5)" is "claude"'s polite description of the authorship but in fact i take no responsibility for any of the below. it seems to work though
# Date: 2026-07-26
# build and publish jutlautil: sdist/wheel to PyPI, conda package to ajutla channel
#
# NB: this publishes to both indexes on every run. Bump the version in
# pyproject.toml, jutlautil/__init__.py, and recipe.yaml before running.

set -euo pipefail
cd "$(dirname "$0")"

# uv build replaces `python -m build`, so no Python environment is needed to
# build. Clearing both output dirs first keeps stale versions out of the uploads,
# which glob over whatever is left behind.
rm -rf dist output
uv build

# Upload with twine rather than `uv publish`: twine reads the token from
# ~/.pypirc, which uv does not support (it wants UV_PUBLISH_TOKEN instead).
micromamba run -n python-base twine upload dist/*

# recipe.yaml builds from the working tree, so this no longer depends on the
# PyPI upload having landed and propagated first.
rattler-build build --recipe recipe.yaml

# Upload with anaconda-client rather than `rattler-build upload`: the token from
# `anaconda login` lives in ~/Library/Application Support/binstar, which
# rattler-build does not read (it uses its own auth file / ANACONDA_API_KEY).
micromamba run -n python-base anaconda upload output/noarch/*.conda
