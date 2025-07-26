![openframes-fortran](media/logo.png)
============

Modern Fortran interface to the [OpenFrames](https://github.com/ravidavi/OpenFrames) realtime interactive scientific visualization API. OpenFrames is an opensource library used by NASA's spacecraft trajectory tools [Copernicus](https://www.nasa.gov/centers/johnson/copernicus/index.html) and [GMAT](https://sourceforge.net/projects/gmat/).

### Description

This is a Fortran library that provides an interface to the C OpenFrames API. It can be considered a modern version of the old Fortran interface that is included with OpenFrames.

### Compiling

A `fpm.toml` file is provided for compiling openframes-fortran with the [Fortran Package Manager](https://github.com/fortran-lang/fpm). For example, to build:

```
fpm build --profile release
```

To use `openframes-fortran` within your fpm project, add the following to your `fpm.toml` file:
```toml
[dependencies]
openframes-fortran = { git="https://github.com/jacobwilliams/openframes-fortran.git" }
```

Note that you will also need to link with the OpenFrames and OpenSceneGraph libraries.

## Documentation

The latest API documentation for the `master` branch can be found [here](https://jacobwilliams.github.io/openframes-fortran/). This was generated from the source code using [FORD](https://github.com/Fortran-FOSS-Programmers/ford).

### See also
 * [OpenFrames](https://github.com/ravidavi/OpenFrames) [GitHub]
 * [OpenFrames Wiki](https://sourceforge.net/p/openframes/wiki/Home/) [Sourceforge]
 * [openframes-python-example](https://gitlab.com/EmergentSpaceTechnologies/openframes-python-example)
