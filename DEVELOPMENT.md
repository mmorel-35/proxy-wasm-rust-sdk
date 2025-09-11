# Development

## Building and Testing

This project supports both traditional WORKSPACE and modern bzlmod build modes.

### Bzlmod Mode (Default)

By default, the project uses bzlmod mode (configured in `.bazelrc`). Build with:

```sh
bazelisk build //...
```

### WORKSPACE Mode  

To use the traditional WORKSPACE mode, disable bzlmod:

```sh
bazelisk build --noenable_bzlmod //...
```

### Local Testing

GitHub Actions can be executed locally using the [`act`] tool.

All tests can be executed using:

    act

Individual tests can be executed using `-j` and `--matrix` parameters, e.g.:

    act -j bazel
    act -j stable
    act -j nightly  
    act -j examples --matrix example:http_auth_random

By default, all jobs are cached in `~/.cache/actcache`. This can be disabled
using the `--no-cache-server` parameter.

## Updating Bazel dependencies

When adding or updating Cargo dependencies, the existing Bazel `BUILD` files
must be regenerated using the [`bazelisk`] tool.

### For WORKSPACE mode:
```sh
bazelisk run --noenable_bzlmod //bazel/cargo:crates_vendor -- --repin all
```

### For bzlmod mode:
```sh
bazelisk run --enable_bzlmod //bazel/cargo:crates_vendor -- --repin all
```

## Bzlmod Migration

This project has been migrated to support both WORKSPACE and bzlmod build modes:

- **WORKSPACE mode**: Uses `rules_rust` 0.61.0 with custom patch for `out_binary` support
- **Bzlmod mode**: Uses `rules_rust` 0.63.0 which includes the `out_binary` fix natively
- **Compatibility layer**: A unified dependency layer (`@proxy_wasm_rust_sdk_deps//`) allows the same BUILD files to work in both modes
- **CI/CD**: Both modes are tested in the GitHub Actions workflow

The dependency mapping works as follows:
- **WORKSPACE**: `@proxy_wasm_rust_sdk_deps//:hashbrown` → `//bazel/cargo/remote:hashbrown`
- **Bzlmod**: `@proxy_wasm_rust_sdk_deps//:hashbrown` → `@crates//:hashbrown`


[`act`]: https://github.com/nektos/act
[`bazelisk`]: https://github.com/bazelbuild/bazelisk
