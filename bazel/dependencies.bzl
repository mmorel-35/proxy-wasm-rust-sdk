# Copyright 2020 Google LLC
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

load("@proxy_wasm_rust_sdk//bazel/cargo/remote:defs.bzl", "crate_repositories")
load("@rules_rust//crate_universe:repositories.bzl", "crate_universe_dependencies")
load("@rules_rust//rust:repositories.bzl", "rust_repositories")

def _create_crates_alias_impl(ctx):
    """Create @crates alias for WORKSPACE mode compatibility.
    
    This creates aliases that point to the vendored crates in //bazel/cargo/remote.
    The vendored approach provides better compatibility between WORKSPACE and bzlmod modes.
    """
    build_content = """
package(default_visibility = ["//visibility:public"])

alias(
    name = "hashbrown",
    actual = "@proxy_wasm_rust_sdk//bazel/cargo/remote:hashbrown",
)

alias(
    name = "log", 
    actual = "@proxy_wasm_rust_sdk//bazel/cargo/remote:log",
)
"""
    ctx.file("BUILD.bazel", build_content)

_create_crates_alias = repository_rule(
    implementation = _create_crates_alias_impl,
)

def proxy_wasm_rust_sdk_dependencies():
    """Setup dependencies for proxy-wasm-rust-sdk.
    
    Uses vendored crates for better WORKSPACE/bzlmod compatibility.
    The crates are pre-generated using crates_vendor and stored in //bazel/cargo/remote.
    """
    rust_repositories()
    crate_universe_dependencies()
    crate_repositories()
    
    # Create @crates alias for WORKSPACE mode compatibility
    # In bzlmod mode, targets can reference //bazel/cargo/remote:crate_name directly
    _create_crates_alias(name = "crates")
