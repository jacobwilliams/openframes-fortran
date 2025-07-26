Simple scripts to build OpenFrames.

### How to use

First, run `setup_env.sh` to clone OpenFrames and build the environment. This requires that `pixi` be installed.

Then run:

```
pixi shell --manifest-path ./build/osgenv/pixi.toml

./build_openframes.sh
```

### See also

 * [pixi](https://pixi.sh/latest/) -- fast, modern, and reproducible package management tool for developers of all backgrounds.