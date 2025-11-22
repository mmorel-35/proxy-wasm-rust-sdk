# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Bzlmod module extensions"""

load("@proxy_wasm_rust_sdk//bazel/cargo/remote:defs.bzl", "crate_repositories")

def _crates_vendor_impl(module_ctx):
    # This should contain the subset of WORKSPACE.bazel that defines
    # repositories.
    direct_deps = []

    direct_deps.extend(crate_repositories())

    # is_dev_dep is ignored here. It's not relevant for internal_deps, as dev
    # dependencies are only relevant for module extensions that can be used
    # by other MODULES.
    return module_ctx.extension_metadata(
        root_module_direct_deps = [repo.repo for repo in direct_deps],
        root_module_direct_dev_deps = [],
    )

crates_vendor = module_extension(
    doc = "Dependencies for the rules_rust examples.",
    implementation = _crates_vendor_impl,
)
