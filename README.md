Modern Fortran interface to OpenFrames realtime interactive scientific visualization API

### Description

This is a Fortran library that provides an interface to the C OpenFrames API. It can be considered a modern version of the old Fortran interface that is included with OpenFrames.

### Compiling

A `fmp.toml` file is provided for compiling geodesic-fortran with the [Fortran Package Manager](https://github.com/fortran-lang/fpm). For example, to build:

```
fpm build --profile release
```

To use `openframes-fortran` within your fpm project, add the following to your `fpm.toml` file:
```toml
[dependencies]
openframes-fortran = { git="https://github.com/jacobwilliams/openframes-fortran.git" }
```

Note that you will also need to link with the OpenFrames and OpenSceneGraph libraries.

### See also
 * [OpenFrames](https://github.com/ravidavi/OpenFrames)
