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

"""Dependencies compatibility layer for WORKSPACE and bzlmod modes."""

def _proxy_wasm_rust_sdk_deps_impl(ctx):
    """Implementation of the proxy_wasm_rust_sdk_deps repository rule."""
    
    # Detect if we're in bzlmod mode by checking if @crates repository exists
    # In bzlmod mode, dependencies come from @crates//
    # In WORKSPACE mode, dependencies come from //bazel/cargo/remote:
    
    build_content = """
# Auto-generated compatibility layer for proxy-wasm-rust-sdk dependencies
# This allows the same BUILD files to work in both WORKSPACE and bzlmod modes

package(default_visibility = ["//visibility:public"])

alias(
    name = "hashbrown",
    actual = "{hashbrown_target}",
)

alias(
    name = "log", 
    actual = "{log_target}",
)
""".format(
        hashbrown_target = "@crates//:hashbrown" if ctx.attr.bzlmod_mode else "//bazel/cargo/remote:hashbrown",
        log_target = "@crates//:log" if ctx.attr.bzlmod_mode else "//bazel/cargo/remote:log",
    )
    
    ctx.file("BUILD.bazel", build_content)

proxy_wasm_rust_sdk_deps = repository_rule(
    implementation = _proxy_wasm_rust_sdk_deps_impl,
    attrs = {
        "bzlmod_mode": attr.bool(default = False),
    },
)

def setup_proxy_wasm_rust_sdk_deps(bzlmod_mode = False):
    """Set up compatibility layer for dependencies.
    
    Args:
        bzlmod_mode: True if running in bzlmod mode, False for WORKSPACE mode
    """
    proxy_wasm_rust_sdk_deps(
        name = "proxy_wasm_rust_sdk_deps",
        bzlmod_mode = bzlmod_mode,
    )