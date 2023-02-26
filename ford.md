project: openframes-fortran
project_dir: ./src
output_dir: ./doc
media_dir: ./media
project_github: https://github.com/jacobwilliams/openframes-fortran
summary: Modern Fortran interface to OpenFrames realtime interactive scientific visualization API
author: Jacob Williams
github: https://github.com/jacobwilliams
predocmark_alt: >
predocmark: <
docmark_alt:
docmark: !
display: public
source: true
graph: false
search: true
preprocessor: gfortran -E
extra_mods: iso_fortran_env:https://gcc.gnu.org/onlinedocs/gfortran/ISO_005fFORTRAN_005fENV.html
            iso_c_binding:https://gcc.gnu.org/onlinedocs/gfortran/ISO_005fC_005fBINDING.html#ISO_005fC_005fBINDING
exclude: openframes_c_interface.f90
         openframes_fortran_helpers.f90

{!README.md!}