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

"""Compatibility layer for dependencies in both WORKSPACE and bzlmod modes."""

def _proxy_wasm_rust_sdk_deps_impl(repository_ctx):
    """Creates a repository that maps dependencies for WORKSPACE mode."""
    
    # This is only used in WORKSPACE mode
    # In bzlmod mode, users should use @crates directly or we create a module extension
    
    build_content = """
# Compatibility layer for dependencies in WORKSPACE mode
# Maps to //bazel/cargo/remote

alias(
    name = "hashbrown",
    actual = "@proxy_wasm_rust_sdk//bazel/cargo/remote:hashbrown",
    visibility = ["//visibility:public"],
)

alias(
    name = "log",
    actual = "@proxy_wasm_rust_sdk//bazel/cargo/remote:log",
    visibility = ["//visibility:public"],
)
"""
    
    repository_ctx.file("BUILD.bazel", build_content)

proxy_wasm_rust_sdk_deps = repository_rule(
    implementation = _proxy_wasm_rust_sdk_deps_impl,
    doc = "Creates a compatibility layer repository for dependencies in WORKSPACE mode.",
)

def _proxy_wasm_rust_sdk_deps_bzlmod_impl(repository_ctx):
    """Creates a repository that maps dependencies for bzlmod mode."""
    
    # This is only used in bzlmod mode
    # Maps to @crates
    
    build_content = """
# Compatibility layer for dependencies in bzlmod mode
# Maps to @crates

alias(
    name = "hashbrown",
    actual = "@crates//:hashbrown",
    visibility = ["//visibility:public"],
)

alias(
    name = "log",
    actual = "@crates//:log",
    visibility = ["//visibility:public"],
)
"""
    
    repository_ctx.file("BUILD.bazel", build_content)

_proxy_wasm_rust_sdk_deps_bzlmod = repository_rule(
    implementation = _proxy_wasm_rust_sdk_deps_bzlmod_impl,
    doc = "Creates a compatibility layer repository for dependencies in bzlmod mode.",
)

def _proxy_wasm_deps_ext_impl(module_ctx):
    """Module extension to create the compatibility layer in bzlmod mode."""
    _proxy_wasm_rust_sdk_deps_bzlmod(name = "proxy_wasm_rust_sdk_deps")
    return module_ctx.extension_metadata(
        root_module_direct_deps = "all",
        root_module_direct_dev_deps = [],
    )

proxy_wasm_deps_ext = module_extension(
    implementation = _proxy_wasm_deps_ext_impl,
    doc = "Module extension for creating the proxy_wasm_rust_sdk_deps compatibility layer.",
)

