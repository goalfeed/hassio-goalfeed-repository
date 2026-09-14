# Comment for home-assistant/builder issue #255

Hey, I ran into the same error with the GitHub Action but found a workaround that actually works!

I was getting the same `jq: error: Could not open file /tmp/build_config/config.json: No such file or directory` error when using `home-assistant/builder@2025.11.0` in my GitHub Actions workflow. I tried everything - absolute paths, relative paths, verified the files exist, created build.json, pinned versions, etc. Nothing worked with the GitHub Action.

But then I tried running the builder Docker image directly instead of using the GitHub Action, and it worked perfectly! Same configuration, same target path (`/data/goalfeed`), same everything - just running it as a direct docker command.

Here's what works for me:

```yaml
- name: Build ${{ matrix.addon }} add-on
  if: steps.check.outputs.build_arch == 'true'
  run: |
    docker run --rm --privileged \
      -v /var/run/docker.sock:/var/run/docker.sock:ro \
      -v ~/.docker:/root/.docker \
      -v ${{ github.workspace }}:/data \
      ghcr.io/home-assistant/amd64-builder:2025.11.0 \
      --${{ matrix.arch }} \
      --target /data/${{ matrix.addon }} \
      --image "hassio-${{matrix.arch}}-${{matrix.addon}}" \
      --docker-hub "ghcr.io/${{ github.repository_owner }}" \
      --addon \
      ${{ env.BUILD_ARGS }}
```

The build completes successfully with this approach. I'm using `amd64-builder` for all architectures since it handles cross-compilation, and mounting the workspace at `/data` using `${{ github.workspace }}`.

The GitHub Action version with the exact same args fails every time, so there's definitely something wrong with how the GitHub Action processes the target path or mounts the repository. My config.json and build.json files are definitely there and valid - I verified them with ls and cat commands in the workflow.

Anyway, just wanted to share this workaround in case it helps anyone else stuck on this. The direct Docker approach works great as a temporary solution until the GitHub Action gets fixed.
