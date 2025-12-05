# BCR Publishing Templates

This directory contains templates used by the [Publish to BCR](https://github.com/bazel-contrib/publish-to-bcr) GitHub Action to automatically publish new versions of proxy-wasm-rust-sdk to the [Bazel Central Registry (BCR)](https://github.com/bazelbuild/bazel-central-registry).

## Files

- **metadata.template.json**: Contains repository metadata including homepage, maintainers, and repository location
- **source.template.json**: Template for generating the source.json file that tells BCR where to download release archives
- **presubmit.yml**: Defines build and test tasks that BCR will run to verify each published version

## How it works

When a new tag matching the pattern `v*.*.*` is created:
1. The GitHub Actions workflow triggers the Publish to BCR action
2. The workflow uses these templates to generate a BCR entry
3. A pull request is automatically created against the Bazel Central Registry
4. Once merged, the new version becomes available to Bazel users via bzlmod

## Template Variables

The following variables are automatically substituted:
- `{OWNER}`: Repository owner (proxy-wasm)
- `{REPO}`: Repository name (proxy-wasm-rust-sdk)
- `{VERSION}`: Version number extracted from the tag (e.g., `0.2.5` from `v0.2.5`)
- `{TAG}`: Full tag name (e.g., `v0.2.5`)

## More Information

- [Publish to BCR documentation](https://github.com/bazel-contrib/publish-to-bcr)
- [BCR documentation](https://bazel.build/external/registry)
