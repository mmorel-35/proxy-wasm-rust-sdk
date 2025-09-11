# Copyright 2022 Google LLC
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

"""Module extensions for proxy-wasm-rust-sdk."""

load("//bazel:deps.bzl", "setup_proxy_wasm_rust_sdk_deps")

def _deps_impl(ctx):
    """Implementation of the deps module extension."""
    setup_proxy_wasm_rust_sdk_deps(bzlmod_mode = True)
    return ctx.extension_metadata(
        root_module_direct_deps = ["proxy_wasm_rust_sdk_deps"],
        root_module_direct_dev_deps = [],
    )

deps = module_extension(
    implementation = _deps_impl,
)