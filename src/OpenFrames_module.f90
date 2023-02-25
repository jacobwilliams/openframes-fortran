!****************************************************************************************************
!>
!  Modern Fortran interface module to the OpenFrames C interface.
!
!### Author
!  * Jacob Williams, 9/9/2018 : based on the original OpenFrames
!                               module by Ravishankar Mathur. These
!                               modifications are released under the
!                               same license (Apache 2.0).
!
!### Original license
!
!```
!   Copyright 2018 Ravishankar Mathur
!
!   Licensed under the Apache License, Version 2.0 (the "License")
!   you may not use this file except in compliance with the License.
!   You may obtain a copy of the License at
!
!       http://www.apache.org/licenses/LICENSE-2.0
!
!   Unless required by applicable law or agreed to in writing, software
!   distributed under the License is distributed on an "AS IS" BASIS,
!   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!   See the License for the specific language governing permissions and
!   limitations under the License.
!```
!
!### Notes
!  Note that lines starting with "!DEC$" are compiler directives for
!  the Visual Fortran family of compilers, and should not be messed with.

! note: look at using c_ptr for strings ...

    module openframes

    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env

    implicit none

    private

    ! constants used to tell an artist where to get data for a point.
    integer(c_int), parameter, public :: of_zero = 0
    integer(c_int), parameter, public :: of_time = 1
    integer(c_int), parameter, public :: of_posopt = 2
    integer(c_int), parameter, public :: of_attitude = 3

    ! constants used to tell an artist what part of the data to use
    ! when plotting a point.
    integer(c_int), parameter, public :: of_x = 0 !! x position or quaternion 1 element
    integer(c_int), parameter, public :: of_y = 1 !! y position or quaternion 2 element
    integer(c_int), parameter, public :: of_z = 2 !! z position or quaternion 3 element
    integer(c_int), parameter, public :: of_w = 3 !! quaternion 4 element (angle)

    ! constants used to tell a markerartist which markers to draw.
    integer(c_int), parameter, public :: ofma_start = 1 !! draw start marker
    integer(c_int), parameter, public :: ofma_intermediate = 2 !! draw intermediate markers
    integer(c_int), parameter, public :: ofma_end = 4   !! draw end marker

    ! constants used to tell a markerartist which intermediate markers to draw
    integer(c_int), parameter, public :: ofma_time = 1 ! !time increments
    integer(c_int), parameter, public :: ofma_distance = 2 !! distance increments
    integer(c_int), parameter, public :: ofma_data = 3 !! data point increments

    ! constants that determine how a frame following a trajectory handles when
    ! the current time is out of the trajectory's data bounds
    integer(c_int), parameter, public :: offollow_loop = 0
    integer(c_int), parameter, public :: offollow_limit = 1

    ! constants that specify whether a frame follows a trajectory's position,
    ! attitude, or both
    integer(c_int), parameter, public :: offollow_position = 1
    integer(c_int), parameter, public :: offollow_attitude = 2

    ! constants that specify which axes to use
    integer(c_int), parameter, public :: of_noaxes = 0 !! don't use any axes
    integer(c_int), parameter, public :: of_xaxis = 1 !! use x axis
    integer(c_int), parameter, public :: of_yaxis = 2 !! use y axis
    integer(c_int), parameter, public :: of_zaxis = 4 !! use z axis

    ! constants that specify relative view base reference frame
    integer(c_int), parameter, public :: ofview_absolute = 0 !! global reference frame
    integer(c_int), parameter, public :: ofview_relative = 1 !! body-fixed frame

    ! constants that specify relative view rotation between frames
    integer(c_int), parameter, public :: ofview_direct = 0 !! direct rotation
    integer(c_int), parameter, public :: ofview_azel = 1 !! azimuth-elevation rotation

    interface to_c
        !! convert fortran variables to C variables.
        module procedure :: fortran_str_to_c,&
                            fortran_logical_to_c,&
                            fortran_int_to_c,&
                            fortran_int16_to_c,&
                            fortran_double_to_c,&
                            fortran_float_to_c
    end interface to_c
    private :: to_c

    interface to_f
        !! convert C variables to fortran variables
        module procedure :: c_int_to_fortran,&
                            c_shortint_to_fortran,&
                            c_double_to_fortran,&
                            c_float_to_fortran,&
                            c_logical_to_fortran
    end interface to_f
    private :: to_f

    abstract interface

        ! Interfaces for the procedure inputs to some of the routines.

        subroutine keypresscallback(winid,row,col,key) bind(c)
        import
        implicit none
        integer(c_int),intent(in) :: winid
        integer(c_int),intent(in) :: row
        integer(c_int),intent(in) :: col
        integer(c_int),intent(in) :: key
        end subroutine keypresscallback

        subroutine mousemotioncallback(winid,row,col,x,y) bind(c)
        import
        implicit none
        integer(c_int),intent(in) :: winid
        integer(c_int),intent(in) :: row
        integer(c_int),intent(in) :: col
        real(c_float),intent(in)  :: x
        real(c_float),intent(in)  :: y
        end subroutine mousemotioncallback

        subroutine buttonpresscallback(winid,row,col,x,y,button) bind(c)
        import
        implicit none
        integer(c_int),intent(in) :: winid
        integer(c_int),intent(in) :: row
        integer(c_int),intent(in) :: col
        real(c_float),intent(in)  :: x
        real(c_float),intent(in)  :: y
        integer(c_int),intent(in) :: button
        end subroutine buttonpresscallback

        subroutine buttonreleasecallback(winid,row,col,x,y,button) bind(c)
        import
        implicit none
        integer(c_int),intent(in) :: winid
        integer(c_int),intent(in) :: row
        integer(c_int),intent(in) :: col
        real(c_float),intent(in)  :: x
        real(c_float),intent(in)  :: y
        integer(c_int),intent(in) :: button
        end subroutine buttonreleasecallback

        subroutine swapbuffersfunction(winid) bind(c)
        import
        implicit none
        integer(c_int),intent(in) :: winid
        end subroutine swapbuffersfunction

        subroutine makecurrentfunction(winid,success) bind(c)
        import
        implicit none
        integer(c_int),intent(in) :: winid
        logical(c_bool),intent(out) :: success
        end subroutine makecurrentfunction

        subroutine updatecontextfunction(winid,success) bind(c)
        import
        implicit none
        integer(c_int),intent(in) :: winid
        logical(c_bool),intent(out) :: success
        end subroutine updatecontextfunction

    end interface

    interface

        ! note that we are renaming them here with "_c" for use
        ! in the routines below, but the c routines we actually
        ! call are unchanged.

        ! the interfaces here need to match what is declared
        ! in the c routines.

        subroutine of_initialize_c() bind(c,name='of_initialize')
        !DEC$ ATTRIBUTES DLLIMPORT :: of_initialize
        import
        implicit none
        end subroutine of_initialize_c

        subroutine of_cleanup_c()  bind(c,name='of_cleanup')
        !DEC$ ATTRIBUTES DLLIMPORT :: of_cleanup
        import
        implicit none
        end subroutine of_cleanup_c

        subroutine of_getreturnedvalue_c(val) bind(c,name='of_getreturnedvalue')
        !DEC$ ATTRIBUTES DLLIMPORT :: of_getreturnedvalue
        import
        implicit none
        integer(c_int), intent(out) :: val
        end subroutine of_getreturnedvalue_c

        subroutine of_adddatafilepath_c(newpath)
        !dec$ attributes dllimport,c,reference :: of_adddatafilepath
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: newpath
        end subroutine of_adddatafilepath_c

        subroutine ofwin_activate_c(id) bind(c,name='ofwin_activate')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_activate
        import
        implicit none
        integer(c_int), intent(in) :: id
        end subroutine ofwin_activate_c

        subroutine ofwin_createproxy_c(x, y, width, height, nrow, ncol, embedded, id, usevr) &
            bind(c,name='ofwin_createproxy')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_createproxy
        import
        implicit none
        integer(c_int), intent(in) :: x, y, width, height, nrow, ncol, id
        logical(c_bool), intent(in) :: embedded, usevr
        end subroutine ofwin_createproxy_c

        subroutine ofwin_setwindowname_c(winname) bind(c,name='ofwin_setwindowname')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setwindowname
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: winname
        end subroutine ofwin_setwindowname_c

        subroutine ofwin_setgridsize_c(nrow, ncol) bind(c,name='ofwin_setgridsize')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setgridsize
        import
        implicit none
        integer(c_int), intent(in) :: nrow, ncol
        end subroutine ofwin_setgridsize_c

        subroutine ofwin_setkeypresscallback_c(fcn) bind(c,name='ofwin_setkeypresscallback')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setkeypresscallback
        import
        implicit none
        procedure(keypresscallback) :: fcn
        end subroutine ofwin_setkeypresscallback_c

        subroutine ofwin_setmousemotioncallback_c(fcn) bind(c,name='ofwin_setmousemotioncallback')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setmousemotioncallback
        import
        implicit none
        procedure(mousemotioncallback) :: fcn
        end subroutine ofwin_setmousemotioncallback_c

        subroutine ofwin_setbuttonpresscallback_c(fcn) bind(c,name='ofwin_setbuttonpresscallback')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setbuttonpresscallback
        import
        implicit none
        procedure(buttonpresscallback) :: fcn
        end subroutine ofwin_setbuttonpresscallback_c

        subroutine ofwin_setbuttonreleasecallback_c(fcn) bind(c,name='ofwin_setbuttonreleasecallback')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setbuttonreleasecallback
        import
        implicit none
        procedure(buttonreleasecallback) :: fcn
        end subroutine ofwin_setbuttonreleasecallback_c

        subroutine ofwin_start_c() bind(c,name='ofwin_start')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_start
        import
        implicit none
        end subroutine ofwin_start_c

        subroutine ofwin_stop_c() bind(c,name='ofwin_stop')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_stop
        import
        implicit none
        end subroutine ofwin_stop_c

        subroutine ofwin_waitforstop_c() bind(c,name='ofwin_waitforstop')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_waitforstop
        import
        implicit none
        end subroutine ofwin_waitforstop_c

        subroutine ofwin_pauseanimation_c(pause) bind(c,name='ofwin_pauseanimation')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_pauseanimation
        import
        implicit none
        logical(c_bool),intent(in) :: pause
        end subroutine ofwin_pauseanimation_c

        subroutine ofwin_isrunning_c(state) bind(c,name='ofwin_isrunning')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_isrunning
        import
        implicit none
        integer(c_int), intent(out) :: state
        end subroutine ofwin_isrunning_c

        subroutine ofwin_setscene_c(row, col) bind(c,name='ofwin_setscene')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setscene
        import
        implicit none
        integer(c_int), intent(in) :: row, col
        end subroutine ofwin_setscene_c

        subroutine ofwin_settime_c(time) bind(c,name='ofwin_settime')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_settime
        import
        implicit none
        real(c_double), intent(in) :: time
        end subroutine ofwin_settime_c

        subroutine ofwin_gettime_c(time) bind(c,name='ofwin_gettime')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_gettime
        import
        implicit none
        real(c_double), intent(out) :: time
        end subroutine ofwin_gettime_c

        subroutine ofwin_pausetime_c(pause) bind(c,name='ofwin_pausetime')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_pausetime
        import
        implicit none
        logical(c_bool), intent(in) :: pause
        end subroutine ofwin_pausetime_c

        subroutine ofwin_istimepaused_c(ispaused) bind(c,name='ofwin_istimepaused')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_istimepaused
        import
        implicit none
        logical(c_bool), intent(out) :: ispaused
        end subroutine ofwin_istimepaused_c

        subroutine ofwin_settimescale_c(tscale) bind(c,name='ofwin_settimescale')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_settimescale
        import
        implicit none
        real(c_double), intent(in) :: tscale
        end subroutine ofwin_settimescale_c

        subroutine ofwin_gettimescale_c(tscale) bind(c,name='ofwin_gettimescale')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_gettimescale
        import
        implicit none
        real(c_double), intent(out) :: tscale
        end subroutine ofwin_gettimescale_c

        subroutine ofwin_setlightambient_c(row, col, r, g, b) bind(c,name='ofwin_setlightambient')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setlightambient
        import
        implicit none
        integer(c_int), intent(in) :: row, col
        real(c_float), intent(in) :: r, g, b
        end subroutine ofwin_setlightambient_c

        subroutine ofwin_setlightdiffuse_c(row, col, r, g, b) bind(c,name='ofwin_setlightdiffuse')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setlightdiffuse
        import
        implicit none
        integer(c_int), intent(in) :: row, col
        real(c_float), intent(in) :: r, g, b
        end subroutine ofwin_setlightdiffuse_c

        subroutine ofwin_setlightspecular_c(row, col, r, g, b) bind(c,name='ofwin_setlightspecular')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setlightspecular
        import
        implicit none
        integer(c_int), intent(in) :: row, col
        real(c_float), intent(in) :: r, g, b
        end subroutine ofwin_setlightspecular_c

        subroutine ofwin_setlightposition_c(row, col, x, y, z, w) bind(c,name='ofwin_setlightposition')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setlightposition
        import
        implicit none
        integer(c_int), intent(in) :: row, col
        real(c_float), intent(in) :: x, y, z, w
        end subroutine ofwin_setlightposition_c

        subroutine ofwin_setstereo_c(row, col, enable, eyeseparation, width, height, distance) &
            bind(c,name='ofwin_setstereo')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setstereo
        import
        implicit none
        integer(c_int), intent(in) :: row, col
        logical(c_bool), intent(in) :: enable
        real(c_float), intent(in) :: eyeseparation, width, height, distance
        end subroutine ofwin_setstereo_c

        subroutine ofwin_setbackgroundcolor_c(row, col, r, g, b) bind(c,name='ofwin_setbackgroundcolor')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setbackgroundcolor
        import
        implicit none
        integer(c_int), intent(in) :: row, col
        real(c_float), intent(in) :: r, g, b
        end subroutine ofwin_setbackgroundcolor_c

        subroutine ofwin_setbackgroundtexture_c(row, col, fname) bind(c,name='ofwin_setbackgroundtexture')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setbackgroundtexture
        import
        implicit none
        integer(c_int), intent(in) :: row, col
        character(kind=c_char,len=1), dimension(*), intent(in) :: fname
        end subroutine ofwin_setbackgroundtexture_c

        subroutine ofwin_setbackgroundstardata_c(row, col, minmag, maxmag, fname) &
            bind(c,name='ofwin_setbackgroundstardata')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setbackgroundstardata
        import
        implicit none
        integer(c_int), intent(in) :: row, col
        real(c_float), intent(in) :: minmag, maxmag
        character(kind=c_char,len=1), dimension(*), intent(in) :: fname
        end subroutine ofwin_setbackgroundstardata_c

        subroutine ofwin_enablehudtext_c(row, col, enable) bind(c,name='ofwin_enablehudtext')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_enablehudtext
        import
        implicit none
        integer(c_int), intent(in) :: row, col
        logical(c_bool), intent(in) :: enable
        end subroutine ofwin_enablehudtext_c

        subroutine ofwin_sethudtextfont_c(row, col, fname) bind(c,name='ofwin_sethudtextfont')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_sethudtextfont
        import
        implicit none
        integer(c_int), intent(in) :: row, col
        character(kind=c_char,len=1), dimension(*), intent(in) :: fname
        end subroutine ofwin_sethudtextfont_c

        subroutine ofwin_sethudtextparameters_c(row, col, r, g, b, charsize) &
            bind(c,name='ofwin_sethudtextparameters')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_sethudtextparameters
        import
        implicit none
        integer(c_int), intent(in) :: row, col
        real(c_float), intent(in) :: r, g, b, charsize
        end subroutine ofwin_sethudtextparameters_c

        subroutine ofwin_sethudtextposition_c(row, col, x, y, alignment) bind(c,name='ofwin_sethudtextposition')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_sethudtextposition
        import
        implicit none
        integer(c_int), intent(in) :: row, col, alignment
        real(c_float), intent(in) :: x, y
        end subroutine ofwin_sethudtextposition_c

        subroutine ofwin_sethudtext_c(row, col, text) bind(c,name='ofwin_sethudtext')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_sethudtext
        import
        implicit none
        integer(c_int), intent(in) :: row, col
        character(kind=c_char,len=1), dimension(*), intent(in) :: text
        end subroutine ofwin_sethudtext_c

        subroutine ofwin_setdesiredframerate_c(fps) bind(c,name='ofwin_setdesiredframerate')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setdesiredframerate
        import
        implicit none
        real(c_double), intent(in) :: fps
        end subroutine ofwin_setdesiredframerate_c

        subroutine ofwin_addview_c(row, col) bind(c,name='ofwin_addview')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_addview
        import
        implicit none
        integer(c_int), intent(in) :: row, col
        end subroutine ofwin_addview_c

        subroutine ofwin_removeview_c(row, col) bind(c,name='ofwin_removeview')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_removeview
        import
        implicit none
        integer(c_int), intent(in) :: row, col
        end subroutine ofwin_removeview_c

        subroutine ofwin_removeallviews_c(row, col) bind(c,name='ofwin_removeallviews')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_removeallviews
        import
        implicit none
        integer(c_int), intent(in) :: row, col
        end subroutine ofwin_removeallviews_c

        subroutine ofwin_selectview_c(row, col) bind(c,name='ofwin_selectview')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_selectview
        import
        implicit none
        integer(c_int), intent(in) :: row, col
        end subroutine ofwin_selectview_c

        subroutine ofwin_setswapbuffersfunction_c(fcn) bind(c,name='ofwin_setswapbuffersfunction')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setswapbuffersfunction
        import
        implicit none
        procedure(swapbuffersfunction) :: fcn
        end subroutine ofwin_setswapbuffersfunction_c

        subroutine ofwin_setmakecurrentfunction_c(fcn) bind(c,name='ofwin_setmakecurrentfunction')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setmakecurrentfunction
        import
        implicit none
        procedure(makecurrentfunction) :: fcn
        end subroutine ofwin_setmakecurrentfunction_c

        subroutine ofwin_setupdatecontextfunction_c(fcn) bind(c,name='ofwin_setupdatecontextfunction')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setupdatecontextfunction
        import
        implicit none
        procedure(updatecontextfunction) :: fcn
        end subroutine ofwin_setupdatecontextfunction_c

        subroutine ofwin_resizewindow_c(x, y, width, height) bind(c,name='ofwin_resizewindow')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_resizewindow
        import
        implicit none
        integer(c_int), intent(in) :: x, y, width, height
        end subroutine ofwin_resizewindow_c

        subroutine ofwin_keypress_c(key) bind(c,name='ofwin_keypress')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_keypress
        import
        implicit none
        integer(c_int), intent(in) :: key
        end subroutine ofwin_keypress_c

        subroutine ofwin_keyrelease_c(key) bind(c,name='ofwin_keyrelease')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_keyrelease
        import
        implicit none
        integer(c_int), intent(in) :: key
        end subroutine ofwin_keyrelease_c

        subroutine ofwin_buttonpress_c(x, y, button) bind(c,name='ofwin_buttonpress')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_buttonpress
        import
        implicit none
        real(c_float), intent(in) :: x, y
        integer(c_int), intent(in) :: button
        end subroutine ofwin_buttonpress_c

        subroutine ofwin_buttonrelease_c(x, y, button) bind(c,name='ofwin_buttonrelease')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_buttonrelease
        import
        implicit none
        real(c_float), intent(in) :: x, y
        integer(c_int), intent(in) :: button
        end subroutine ofwin_buttonrelease_c

        subroutine ofwin_mousemotion_c(x, y) bind(c,name='ofwin_mousemotion')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_mousemotion
        import
        implicit none
        real(c_float), intent(in) :: x, y
        end subroutine ofwin_mousemotion_c

        subroutine ofwin_capturewindow_c() bind(c,name='ofwin_capturewindow')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_capturewindow
        import
        implicit none
        end subroutine ofwin_capturewindow_c

        subroutine ofwin_setwindowcapturefile_c(fname,fext) bind(c,name='ofwin_setwindowcapturefile')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setwindowcapturefile
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: fname
        character(kind=c_char,len=1), dimension(*), intent(in) :: fext
        end subroutine ofwin_setwindowcapturefile_c

        subroutine ofwin_setwindowcapturekey_c(key) bind(c,name='ofwin_setwindowcapturekey')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_setwindowcapturekey
        import
        implicit none
        integer(c_int), intent(in) :: key
        end subroutine ofwin_setwindowcapturekey_c

        subroutine offm_activate_c(id) bind(c,name='offm_activate')
        !DEC$ ATTRIBUTES DLLIMPORT :: offm_activate
        import
        implicit none
        integer(c_int), intent(in) :: id
        end subroutine offm_activate_c

        subroutine offm_create_c(id) bind(c,name='offm_create')
        !DEC$ ATTRIBUTES DLLIMPORT :: offm_create
        import
        implicit none
        integer(c_int), intent(in) :: id
        end subroutine offm_create_c

        subroutine offm_setframe_c() bind(c,name='offm_setframe')
        !DEC$ ATTRIBUTES DLLIMPORT :: offm_setframe
        import
        implicit none
        end subroutine offm_setframe_c

        subroutine offm_lock_c() bind(c,name='offm_lock')
        !DEC$ ATTRIBUTES DLLIMPORT :: offm_lock
        import
        implicit none
        end subroutine offm_lock_c

        subroutine offm_unlock_c() bind(c,name='offm_unlock')
        !DEC$ ATTRIBUTES DLLIMPORT :: offm_unlock
        import
        implicit none
        end subroutine offm_unlock_c

        subroutine offrame_activate_c(name) bind(c,name='offrame_activate')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_activate
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine offrame_activate_c

        subroutine offrame_create_c(name) bind(c,name='offrame_create')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_create
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine offrame_create_c

        subroutine offrame_setcolor_c(r, g, b, a) bind(c,name='offrame_setcolor')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_setcolor
        import
        implicit none
        real(c_float), intent(in) :: r, g, b, a
        end subroutine offrame_setcolor_c

        subroutine offrame_addchild_c(name) bind(c,name='offrame_addchild')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_addchild
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine offrame_addchild_c

        subroutine offrame_removechild_c(name) bind(c,name='offrame_removechild')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_removechild
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine offrame_removechild_c

        subroutine offrame_removeallchildren_c() bind(c,name='offrame_removeallchildren')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_removeallchildren
        import
        implicit none
        end subroutine offrame_removeallchildren_c

        subroutine offrame_getnumchildren_c(numchildren) bind(c,name='offrame_getnumchildren')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_getnumchildren
        import
        implicit none
        integer(c_int), intent(out) :: numchildren
        end subroutine offrame_getnumchildren_c

        subroutine offrame_setposition_c(x, y, z) bind(c,name='offrame_setposition')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_setposition
        import
        implicit none
        real(c_double), intent(in) :: x, y, z
        end subroutine offrame_setposition_c

        subroutine offrame_getposition_c(x, y, z) bind(c,name='offrame_getposition')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_getposition
        import
        implicit none
        real(c_double), intent(out) :: x, y, z
        end subroutine offrame_getposition_c

        subroutine offrame_setattitude_c(x, y, z, angle) bind(c,name='offrame_setattitude')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_setattitude
        import
        implicit none
        real(c_double), intent(in) :: x, y, z, angle
        end subroutine offrame_setattitude_c

        subroutine offrame_getattitude_c(x, y, z, angle) bind(c,name='offrame_getattitude')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_getattitude
        import
        implicit none
        real(c_double), intent(out) :: x, y, z, angle
        end subroutine offrame_getattitude_c

        subroutine offrame_showaxes_c(axes) bind(c,name='offrame_showaxes')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_showaxes
        import
        implicit none
        integer(c_int), intent(in) :: axes
        end subroutine offrame_showaxes_c

        subroutine offrame_shownamelabel_c(namelabel) bind(c,name='offrame_shownamelabel')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_shownamelabel
        import
        implicit none
        logical(c_bool), intent(in) :: namelabel
        end subroutine offrame_shownamelabel_c

        subroutine offrame_showaxeslabels_c(labels) bind(c,name='offrame_showaxeslabels')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_showaxeslabels
        import
        implicit none
        integer(c_int), intent(in) :: labels
        end subroutine offrame_showaxeslabels_c

        subroutine offrame_setnamelabel_c(name) bind(c,name='offrame_setnamelabel')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_setnamelabel
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine offrame_setnamelabel_c

        subroutine offrame_setaxeslabels_c(xlabel, ylabel, zlabel) bind(c,name='offrame_setaxeslabels')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_setaxeslabels
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: xlabel, ylabel, zlabel
        end subroutine offrame_setaxeslabels_c

        subroutine offrame_movexaxis_c(pos, length, headratio, bodyradius, headradius) &
            bind(c,name='offrame_movexaxis')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_movexaxis
        import
        implicit none
        real(c_double), intent(in) :: pos(3), length, headratio, bodyradius, headradius
        end subroutine offrame_movexaxis_c

        subroutine offrame_moveyaxis_c(pos, length, headratio, bodyradius, headradius) &
            bind(c,name='offrame_moveyaxis')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_moveyaxis
        import
        implicit none
        real(c_double), intent(in) :: pos(3), length, headratio, bodyradius, headradius
        end subroutine offrame_moveyaxis_c

        subroutine offrame_movezaxis_c(pos, length, headratio, bodyradius, headradius) &
            bind(c,name='offrame_movezaxis')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_movezaxis
        import
        implicit none
        real(c_double), intent(in) :: pos(3), length, headratio, bodyradius, headradius
        end subroutine offrame_movezaxis_c

        subroutine offrame_setlightsourceenabled_c(enabled) bind(c,name='offrame_setlightsourceenabled')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_setlightsourceenabled
        import
        implicit none
        logical(c_bool), intent(in) :: enabled
        end subroutine offrame_setlightsourceenabled_c

        subroutine offrame_getlightsourceenabled_c(enabled) bind(c,name='offrame_getlightsourceenabled')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_getlightsourceenabled
        import
        implicit none
        logical(c_bool), intent(out) :: enabled
        end subroutine offrame_getlightsourceenabled_c

        subroutine offrame_setlightambient_c(r, g, b) bind(c,name='offrame_setlightambient')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_setlightambient
        import
        implicit none
        real(c_float), intent(in) :: r, g, b
        end subroutine offrame_setlightambient_c

        subroutine offrame_setlightdiffuse_c(r, g, b) bind(c,name='offrame_setlightdiffuse')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_setlightdiffuse
        import
        implicit none
        real(c_float), intent(in) :: r, g, b
        end subroutine offrame_setlightdiffuse_c

        subroutine offrame_setlightspecular_c(r, g, b) bind(c,name='offrame_setlightspecular')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_setlightspecular
        import
        implicit none
        real(c_float), intent(in) :: r, g, b
        end subroutine offrame_setlightspecular_c

        subroutine offrame_followtrajectory_c(name) bind(c,name='offrame_followtrajectory')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_followtrajectory
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine offrame_followtrajectory_c

        subroutine offrame_followtype_c(data, mode) bind(c,name='offrame_followtype')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_followtype
        import
        implicit none
        integer(c_int), intent(in) :: data, mode
        end subroutine offrame_followtype_c

        subroutine offrame_followposition_c(src, element, opt, scale) bind(c,name='offrame_followposition')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_followposition
        import
        implicit none
        integer(c_int), intent(in) :: src(3), element(3), opt(3)
        real(c_double), intent(in) :: scale(3)
        end subroutine offrame_followposition_c

        subroutine offrame_printframestring_c() bind(c,name='offrame_printframestring')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_printframestring
        import
        implicit none
        end subroutine offrame_printframestring_c

        subroutine ofsphere_create_c(name) bind(c,name='ofsphere_create')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsphere_create
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine ofsphere_create_c

        subroutine ofsphere_setradius_c(radius) bind(c,name='ofsphere_setradius')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsphere_setradius
        import
        implicit none
        real(c_double), intent(in) :: radius
        end subroutine ofsphere_setradius_c

        subroutine ofsphere_settexturemap_c(fname) bind(c,name='ofsphere_settexturemap')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsphere_settexturemap
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: fname
        end subroutine ofsphere_settexturemap_c

        subroutine ofsphere_setnighttexturemap_c(fname) bind(c,name='ofsphere_setnighttexturemap')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsphere_setnighttexturemap
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: fname
        end subroutine ofsphere_setnighttexturemap_c

        subroutine ofsphere_setautolod_c(lod) bind(c,name='ofsphere_setautolod')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsphere_setautolod
        import
        implicit none
        logical(c_bool), intent(in) :: lod
        end subroutine ofsphere_setautolod_c

        subroutine ofsphere_setsphereposition_c(x, y, z) bind(c,name='ofsphere_setsphereposition')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsphere_setsphereposition
        import
        implicit none
        real(c_double), intent(in) :: x, y, z
        end subroutine ofsphere_setsphereposition_c

        subroutine ofsphere_setsphereattitude_c(rx, ry, rz, angle) bind(c,name='ofsphere_setsphereattitude')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsphere_setsphereattitude
        import
        implicit none
        real(c_double), intent(in) :: rx, ry, rz, angle
        end subroutine ofsphere_setsphereattitude_c

        subroutine ofsphere_setspherescale_c(sx, sy, sz) bind(c,name='ofsphere_setspherescale')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsphere_setspherescale
        import
        implicit none
        real(c_double), intent(in) :: sx, sy, sz
        end subroutine ofsphere_setspherescale_c

        subroutine ofsphere_setmaterialambient_c(r, g, b) bind(c,name='ofsphere_setmaterialambient')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsphere_setmaterialambient
        import
        implicit none
        real(c_float), intent(in) :: r, g, b
        end subroutine ofsphere_setmaterialambient_c

        subroutine ofsphere_setmaterialdiffuse_c(r, g, b) bind(c,name='ofsphere_setmaterialdiffuse')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsphere_setmaterialdiffuse
        import
        implicit none
        real(c_float), intent(in) :: r, g, b
        end subroutine ofsphere_setmaterialdiffuse_c

        subroutine ofsphere_setmaterialspecular_c(r, g, b) bind(c,name='ofsphere_setmaterialspecular')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsphere_setmaterialspecular
        import
        implicit none
        real(c_float), intent(in) :: r, g, b
        end subroutine ofsphere_setmaterialspecular_c

        subroutine ofsphere_setmaterialemission_c(r, g, b) bind(c,name='ofsphere_setmaterialemission')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsphere_setmaterialemission
        import
        implicit none
        real(c_float), intent(in) :: r, g, b
        end subroutine ofsphere_setmaterialemission_c

        subroutine ofsphere_setmaterialshininess_c(shininess) bind(c,name='ofsphere_setmaterialshininess')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsphere_setmaterialshininess
        import
        implicit none
        real(c_float), intent(in) :: shininess
        end subroutine ofsphere_setmaterialshininess_c

        subroutine ofmodel_create_c(name) bind(c,name='ofmodel_create')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmodel_create
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine ofmodel_create_c

        subroutine ofmodel_setmodel_c(fname) bind(c,name='ofmodel_setmodel')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmodel_setmodel
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: fname
        end subroutine ofmodel_setmodel_c

        subroutine ofmodel_setmodelposition_c(x, y, z) bind(c,name='ofmodel_setmodelposition')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmodel_setmodelposition
        import
        implicit none
        real(c_double), intent(in) :: x, y, z
        end subroutine ofmodel_setmodelposition_c

        subroutine ofmodel_getmodelposition_c(x, y, z) bind(c,name='ofmodel_getmodelposition')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmodel_getmodelposition
        import
        implicit none
        real(c_double), intent(out) :: x, y, z
        end subroutine ofmodel_getmodelposition_c

        subroutine ofmodel_setmodelscale_c(x, y, z) bind(c,name='ofmodel_setmodelscale')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmodel_setmodelscale
        import
        implicit none
        real(c_double), intent(in) :: x, y, z
        end subroutine ofmodel_setmodelscale_c

        subroutine ofmodel_getmodelscale_c(x, y, z) bind(c,name='ofmodel_getmodelscale')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmodel_getmodelscale
        import
        implicit none
        real(c_double), intent(out) :: x, y, z
        end subroutine ofmodel_getmodelscale_c

        subroutine ofmodel_setmodelpivot_c(x, y, z) bind(c,name='ofmodel_setmodelpivot')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmodel_setmodelpivot
        import
        implicit none
        real(c_double), intent(in) :: x, y, z
        end subroutine ofmodel_setmodelpivot_c

        subroutine ofmodel_getmodelpivot_c(x, y, z) bind(c,name='ofmodel_getmodelpivot')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmodel_getmodelpivot
        import
        implicit none
        real(c_double), intent(out) :: x, y, z
        end subroutine ofmodel_getmodelpivot_c

        subroutine ofmodel_getmodelsize_c(size) bind(c,name='ofmodel_getmodelsize')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmodel_getmodelsize
        import
        implicit none
        real(c_double), intent(out) :: size
        end subroutine ofmodel_getmodelsize_c

        subroutine ofdrawtraj_create_c(name) bind(c,name='ofdrawtraj_create')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofdrawtraj_create
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine ofdrawtraj_create_c

        subroutine ofdrawtraj_addartist_c(name) bind(c,name='ofdrawtraj_addartist')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofdrawtraj_addartist
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine ofdrawtraj_addartist_c

        subroutine ofdrawtraj_removeartist_c(name) bind(c,name='ofdrawtraj_removeartist')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofdrawtraj_removeartist
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine ofdrawtraj_removeartist_c

        subroutine ofdrawtraj_removeallartists_c() bind(c,name='ofdrawtraj_removeallartists')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofdrawtraj_removeallartists
        import
        implicit none
        end subroutine ofdrawtraj_removeallartists_c

        subroutine ofcoordaxes_create_c(name) bind(c,name='ofcoordaxes_create')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofcoordaxes_create
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine ofcoordaxes_create_c

        subroutine ofcoordaxes_setaxislength_c(len) bind(c,name='ofcoordaxes_setaxislength')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofcoordaxes_setaxislength
        import
        implicit none
        real(c_double), intent(in) :: len
        end subroutine ofcoordaxes_setaxislength_c

        subroutine ofcoordaxes_setdrawaxes_c(axes) bind(c,name='ofcoordaxes_setdrawaxes')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofcoordaxes_setdrawaxes
        import
        implicit none
        integer(c_int), intent(in) :: axes
        end subroutine ofcoordaxes_setdrawaxes_c

        subroutine ofcoordaxes_settickspacing_c(major, minor) bind(c,name='ofcoordaxes_settickspacing')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofcoordaxes_settickspacing
        import
        implicit none
        real(c_double), intent(in) :: major, minor
        end subroutine ofcoordaxes_settickspacing_c

        subroutine ofcoordaxes_setticksize_c(major, minor) bind(c,name='ofcoordaxes_setticksize')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofcoordaxes_setticksize
        import
        implicit none
        integer(c_int), intent(in) :: major, minor
        end subroutine ofcoordaxes_setticksize_c

        subroutine ofcoordaxes_settickimage_c(fname) bind(c,name='ofcoordaxes_settickimage')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofcoordaxes_settickimage
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: fname
        end subroutine ofcoordaxes_settickimage_c

        subroutine ofcoordaxes_settickshader_c(fname) bind(c,name='ofcoordaxes_settickshader')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofcoordaxes_settickshader
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: fname
        end subroutine ofcoordaxes_settickshader_c

        subroutine oflatlongrid_create_c(name) bind(c,name='oflatlongrid_create')
        !DEC$ ATTRIBUTES DLLIMPORT :: oflatlongrid_create
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine oflatlongrid_create_c

        subroutine oflatlongrid_setparameters_c(radiusx, radiusy, radiusz, latspace, lonspace) &
            bind(c,name='oflatlongrid_setparameters')
        !DEC$ ATTRIBUTES DLLIMPORT :: oflatlongrid_setparameters
        import
        implicit none
        real(c_double), intent(in) :: radiusx, radiusy, radiusz, latspace, lonspace
        end subroutine oflatlongrid_setparameters_c

        subroutine ofradialplane_create_c(name) bind(c,name='ofradialplane_create')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofradialplane_create
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine ofradialplane_create_c

        subroutine ofradialplane_setparameters_c(radius, radspace, lonspace) bind(c,name='ofradialplane_setparameters')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofradialplane_setparameters
        import
        implicit none
        real(c_double), intent(in) :: radius, radspace, lonspace
        end subroutine ofradialplane_setparameters_c

        subroutine ofradialplane_setplanecolor_c(r, g, b, a) bind(c,name='ofradialplane_setplanecolor')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofradialplane_setplanecolor
        import
        implicit none
        real(c_float), intent(in) :: r, g, b, a
        end subroutine ofradialplane_setplanecolor_c

        subroutine ofradialplane_setlinecolor_c(r, g, b, a) bind(c,name='ofradialplane_setlinecolor')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofradialplane_setlinecolor
        import
        implicit none
        real(c_float), intent(in) :: r, g, b, a
        end subroutine ofradialplane_setlinecolor_c

        subroutine oftraj_activate_c(name) bind(c,name='oftraj_activate')
        !DEC$ ATTRIBUTES DLLIMPORT :: oftraj_activate
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine oftraj_activate_c

        subroutine oftraj_create_c(name, dof, numopt) bind(c,name='oftraj_create')
        !DEC$ ATTRIBUTES DLLIMPORT :: oftraj_create
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        integer(c_int), intent(in) :: dof, numopt
        end subroutine oftraj_create_c

        subroutine oftraj_setnumoptionals_c(nopt) bind(c,name='oftraj_setnumoptionals')
        !DEC$ ATTRIBUTES DLLIMPORT :: oftraj_setnumoptionals
        import
        implicit none
        integer(c_int), intent(in) :: nopt
        end subroutine oftraj_setnumoptionals_c

        subroutine oftraj_setdof_c(dof) bind(c,name='oftraj_setdof')
        !DEC$ ATTRIBUTES DLLIMPORT :: oftraj_setdof
        import
        implicit none
        integer(c_int), intent(in) :: dof
        end subroutine oftraj_setdof_c

        subroutine oftraj_addtime_c(t) bind(c,name='oftraj_addtime')
        !DEC$ ATTRIBUTES DLLIMPORT :: oftraj_addtime
        import
        implicit none
        real(c_double), intent(in) :: t
        end subroutine oftraj_addtime_c

        subroutine oftraj_addposition_c(x, y, z) bind(c,name='oftraj_addposition')
        !DEC$ ATTRIBUTES DLLIMPORT :: oftraj_addposition
        import
        implicit none
        real(c_double), intent(in) :: x, y, z
        end subroutine oftraj_addposition_c

        subroutine oftraj_addpositionvec_c(pos) bind(c,name='oftraj_addpositionvec')
        !DEC$ ATTRIBUTES DLLIMPORT :: oftraj_addpositionvec
        import
        implicit none
        real(c_double), dimension(*), intent(in) :: pos
        end subroutine oftraj_addpositionvec_c

        subroutine oftraj_addattitude_c(x, y, z, w) bind(c,name='oftraj_addattitude')
        !DEC$ ATTRIBUTES DLLIMPORT :: oftraj_addattitude
        import
        implicit none
        real(c_double), intent(in) :: x, y, z, w
        end subroutine oftraj_addattitude_c

        subroutine oftraj_addattitudevec_c(att) bind(c,name='oftraj_addattitudevec')
        !DEC$ ATTRIBUTES DLLIMPORT :: oftraj_addattitudevec
        import
        implicit none
        real(c_double), dimension(4), intent(in) :: att
        end subroutine oftraj_addattitudevec_c

        subroutine oftraj_setoptional_c(index, x, y, z) bind(c,name='oftraj_setoptional')
        !DEC$ ATTRIBUTES DLLIMPORT :: oftraj_setoptional
        import
        implicit none
        integer(c_int), intent(in) :: index
        real(c_double), intent(in) :: x, y, z
        end subroutine oftraj_setoptional_c

        subroutine oftraj_setoptionalvec_c(index, opt) bind(c,name='oftraj_setoptionalvec')
        !DEC$ ATTRIBUTES DLLIMPORT :: oftraj_setoptionalvec
        import
        implicit none
        integer(c_int), intent(in) :: index
        real(c_double), dimension(*), intent(in) :: opt
        end subroutine oftraj_setoptionalvec_c

        subroutine oftraj_clear_c() bind(c,name='oftraj_clear')
        !DEC$ ATTRIBUTES DLLIMPORT :: oftraj_clear
        import
        implicit none
        end subroutine oftraj_clear_c

        subroutine oftraj_informartists_c() bind(c,name='oftraj_informartists')
        !DEC$ ATTRIBUTES DLLIMPORT :: oftraj_informartists
        import
        implicit none
        end subroutine oftraj_informartists_c

        subroutine oftraj_autoinformartists_c(autoinform) bind(c,name='oftraj_autoinformartists')
        !DEC$ ATTRIBUTES DLLIMPORT :: oftraj_autoinformartists
        import
        implicit none
        logical(c_bool), intent(in) :: autoinform
        end subroutine oftraj_autoinformartists_c

        subroutine oftrajartist_activate_c(name) bind(c,name='oftrajartist_activate')
        !DEC$ ATTRIBUTES DLLIMPORT :: oftrajartist_activate
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine oftrajartist_activate_c

        subroutine oftrajartist_settrajectory_c() bind(c,name='oftrajartist_settrajectory')
        !DEC$ ATTRIBUTES DLLIMPORT :: oftrajartist_settrajectory
        import
        implicit none
        end subroutine oftrajartist_settrajectory_c

        subroutine ofcurveartist_create_c(name) bind(c,name='ofcurveartist_create')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofcurveartist_create
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine ofcurveartist_create_c

        subroutine ofcurveartist_setxdata_c(src, element, opt, scale) bind(c,name='ofcurveartist_setxdata')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofcurveartist_setxdata
        import
        implicit none
        integer(c_int), intent(in) :: src, element, opt
        real(c_double), intent(in) :: scale
        end subroutine ofcurveartist_setxdata_c

        subroutine ofcurveartist_setydata_c(src, element, opt, scale) bind(c,name='ofcurveartist_setydata')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofcurveartist_setydata
        import
        implicit none
        integer(c_int), intent(in) :: src, element, opt
        real(c_double), intent(in) :: scale
        end subroutine ofcurveartist_setydata_c

        subroutine ofcurveartist_setzdata_c(src, element, opt, scale) bind(c,name='ofcurveartist_setzdata')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofcurveartist_setzdata
        import
        implicit none
        integer(c_int), intent(in) :: src, element, opt
        real(c_double), intent(in) :: scale
        end subroutine ofcurveartist_setzdata_c

        subroutine ofcurveartist_setcolor_c(r, g, b) bind(c,name='ofcurveartist_setcolor')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofcurveartist_setcolor
        import
        implicit none
        real(c_float), intent(in) :: r, g, b
        end subroutine ofcurveartist_setcolor_c

        subroutine ofcurveartist_setwidth_c(width) bind(c,name='ofcurveartist_setwidth')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofcurveartist_setwidth
        import
        implicit none
        real(c_float), intent(in) :: width
        end subroutine ofcurveartist_setwidth_c

        subroutine ofcurveartist_setpattern_c(factor, pattern) bind(c,name='ofcurveartist_setpattern')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofcurveartist_setpattern
        import
        implicit none
        integer(c_int), intent(in) :: factor
        integer(c_short), intent(in) :: pattern
        end subroutine ofcurveartist_setpattern_c

        subroutine ofsegmentartist_create_c(name) bind(c,name='ofsegmentartist_create')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsegmentartist_create
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine ofsegmentartist_create_c

        subroutine ofsegmentartist_setstartxdata_c(src, element, opt, scale) bind(c,name='ofsegmentartist_setstartxdata')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsegmentartist_setstartxdata
        import
        implicit none
        integer(c_int), intent(in) :: src, element, opt
        real(c_double), intent(in) :: scale
        end subroutine ofsegmentartist_setstartxdata_c

        subroutine ofsegmentartist_setstartydata_c(src, element, opt, scale) bind(c,name='ofsegmentartist_setstartydata')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsegmentartist_setstartydata
        import
        implicit none
        integer(c_int), intent(in) :: src, element, opt
        real(c_double), intent(in) :: scale
        end subroutine ofsegmentartist_setstartydata_c

        subroutine ofsegmentartist_setstartzdata_c(src, element, opt, scale) bind(c,name='ofsegmentartist_setstartzdata')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsegmentartist_setstartzdata
        import
        implicit none
        integer(c_int), intent(in) :: src, element, opt
        real(c_double), intent(in) :: scale
        end subroutine ofsegmentartist_setstartzdata_c

        subroutine ofsegmentartist_setendxdata_c(src, element, opt, scale) bind(c,name='ofsegmentartist_setendxdata')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsegmentartist_setendxdata
        import
        implicit none
        integer(c_int), intent(in) :: src, element, opt
        real(c_double), intent(in) :: scale
        end subroutine ofsegmentartist_setendxdata_c

        subroutine ofsegmentartist_setendydata_c(src, element, opt, scale) bind(c,name='ofsegmentartist_setendydata')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsegmentartist_setendydata
        import
        implicit none
        integer(c_int), intent(in) :: src, element, opt
        real(c_double), intent(in) :: scale
        end subroutine ofsegmentartist_setendydata_c

        subroutine ofsegmentartist_setendzdata_c(src, element, opt, scale) bind(c,name='ofsegmentartist_setendzdata')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsegmentartist_setendzdata
        import
        implicit none
        integer(c_int), intent(in) :: src, element, opt
        real(c_double), intent(in) :: scale
        end subroutine ofsegmentartist_setendzdata_c

        subroutine ofsegmentartist_setstride_c(stride) bind(c,name='ofsegmentartist_setstride')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsegmentartist_setstride
        import
        implicit none
        integer(c_int), intent(in) :: stride
        end subroutine ofsegmentartist_setstride_c

        subroutine ofsegmentartist_setcolor_c(r, g, b) bind(c,name='ofsegmentartist_setcolor')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsegmentartist_setcolor
        import
        implicit none
        real(c_float), intent(in) :: r, g, b
        end subroutine ofsegmentartist_setcolor_c

        subroutine ofsegmentartist_setwidth_c(width) bind(c,name='ofsegmentartist_setwidth')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsegmentartist_setwidth
        import
        implicit none
        real(c_float), intent(in) :: width
        end subroutine ofsegmentartist_setwidth_c

        subroutine ofsegmentartist_setpattern_c(factor, pattern) bind(c,name='ofsegmentartist_setpattern')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofsegmentartist_setpattern
        import
        implicit none
        integer(c_int), intent(in) :: factor
        integer(c_short), intent(in) :: pattern
        end subroutine ofsegmentartist_setpattern_c

        subroutine ofmarkerartist_create_c(name) bind(c,name='ofmarkerartist_create')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmarkerartist_create
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine ofmarkerartist_create_c

        subroutine ofmarkerartist_setxdata_c(src, element, opt, scale) bind(c,name='ofmarkerartist_setxdata')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmarkerartist_setxdata
        import
        implicit none
        integer(c_int), intent(in) :: src, element, opt
        real(c_double), intent(in) :: scale
        end subroutine ofmarkerartist_setxdata_c

        subroutine ofmarkerartist_setydata_c(src, element, opt, scale) bind(c,name='ofmarkerartist_setydata')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmarkerartist_setydata
        import
        implicit none
        integer(c_int), intent(in) :: src, element, opt
        real(c_double), intent(in) :: scale
        end subroutine ofmarkerartist_setydata_c

        subroutine ofmarkerartist_setzdata_c(src, element, opt, scale) bind(c,name='ofmarkerartist_setzdata')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmarkerartist_setzdata
        import
        implicit none
        integer(c_int), intent(in) :: src, element, opt
        real(c_double), intent(in) :: scale
        end subroutine ofmarkerartist_setzdata_c

        subroutine ofmarkerartist_setmarkers_c(markers) bind(c,name='ofmarkerartist_setmarkers')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmarkerartist_setmarkers
        import
        implicit none
        integer(c_int), intent(in) :: markers
        end subroutine ofmarkerartist_setmarkers_c

        subroutine ofmarkerartist_setmarkercolor_c(markers, r, g, b) bind(c,name='ofmarkerartist_setmarkercolor')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmarkerartist_setmarkercolor
        import
        implicit none
        integer(c_int), intent(in) :: markers
        real(c_float), intent(in) :: r, g, b
        end subroutine ofmarkerartist_setmarkercolor_c

        subroutine ofmarkerartist_setmarkerimage_c(fname) bind(c,name='ofmarkerartist_setmarkerimage')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmarkerartist_setmarkerimage
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: fname
        end subroutine ofmarkerartist_setmarkerimage_c

        subroutine ofmarkerartist_setmarkershader_c(fname) bind(c,name='ofmarkerartist_setmarkershader')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmarkerartist_setmarkershader
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: fname
        end subroutine ofmarkerartist_setmarkershader_c

        subroutine ofmarkerartist_setintermediatetype_c(type) bind(c,name='ofmarkerartist_setintermediatetype')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmarkerartist_setintermediatetype
        import
        implicit none
        integer(c_int), intent(in) :: type
        end subroutine ofmarkerartist_setintermediatetype_c

        subroutine ofmarkerartist_setintermediatespacing_c(spacing) bind(c,name='ofmarkerartist_setintermediatespacing')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmarkerartist_setintermediatespacing
        import
        implicit none
        real(c_double), intent(in) :: spacing
        end subroutine ofmarkerartist_setintermediatespacing_c

        subroutine ofmarkerartist_setintermediatedirection_c(direction) bind(c,name='ofmarkerartist_setintermediatedirection')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmarkerartist_setintermediatedirection
        import
        implicit none
        integer(c_int), intent(in) :: direction
        end subroutine ofmarkerartist_setintermediatedirection_c

        subroutine ofmarkerartist_setmarkersize_c(size) bind(c,name='ofmarkerartist_setmarkersize')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmarkerartist_setmarkersize
        import
        implicit none
        integer(c_int), intent(in) :: size
        end subroutine ofmarkerartist_setmarkersize_c

        subroutine ofmarkerartist_setautoattenuate_c(autoattenuate) bind(c,name='ofmarkerartist_setautoattenuate')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofmarkerartist_setautoattenuate
        import
        implicit none
        logical(c_bool), intent(in) :: autoattenuate
        end subroutine ofmarkerartist_setautoattenuate_c

        subroutine ofview_activate_c(name) bind(c,name='ofview_activate')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofview_activate
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine ofview_activate_c

        subroutine ofview_create_c(name) bind(c,name='ofview_create')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofview_create
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: name
        end subroutine ofview_create_c

        subroutine ofview_setorthographic_c(left, right, bottom, top) bind(c,name='ofview_setorthographic')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofview_setorthographic
        import
        implicit none
        real(c_double), intent(in) :: left, right, bottom, top
        end subroutine ofview_setorthographic_c

        subroutine ofview_setperspective_c(fov, ratio) bind(c,name='ofview_setperspective')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofview_setperspective
        import
        implicit none
        real(c_double), intent(in) :: fov, ratio
        end subroutine ofview_setperspective_c

        subroutine ofview_setviewframe_c(root, frame) bind(c,name='ofview_setviewframe')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofview_setviewframe
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: root, frame
        end subroutine ofview_setviewframe_c

        subroutine ofview_setviewbetweenframes_c(root, srcframe, dstframe, frametype, rotationtype) &
            bind(c,name='ofview_setviewbetweenframes')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofview_setviewbetweenframes
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: root, srcframe, dstframe
        integer(c_int), intent(in) :: frametype, rotationtype
        end subroutine ofview_setviewbetweenframes_c

        subroutine ofview_setdefaultviewdistance_c(distance) bind(c,name='ofview_setdefaultviewdistance')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofview_setdefaultviewdistance
        import
        implicit none
        real(c_double), intent(in) :: distance
        end subroutine ofview_setdefaultviewdistance_c

        subroutine ofview_gettrackball_c(eye, center, up) bind(c,name='ofview_gettrackball')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofview_gettrackball
        import
        implicit none
        real(c_double), intent(out) :: eye(3), center(3), up(3)
        end subroutine ofview_gettrackball_c

        subroutine ofview_settrackball_c(eye, center, up) bind(c,name='ofview_settrackball')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofview_settrackball
        import
        implicit none
        real(c_double), intent(in) :: eye(3), center(3), up(3)
        end subroutine ofview_settrackball_c

        subroutine ofview_isvalid_c(valid) bind(c,name='ofview_isvalid')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofview_isvalid
        import
        implicit none
        logical(c_bool), intent(out) :: valid
        end subroutine ofview_isvalid_c

        subroutine ofview_reset_c() bind(c,name='ofview_reset')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofview_reset
        import
        implicit none
        end subroutine ofview_reset_c

    end interface

    public :: of_initialize
    public :: of_cleanup
    public :: of_getreturnedvalue
    public :: of_adddatafilepath
    public :: ofwin_activate
    public :: ofwin_createproxy
    public :: ofwin_setwindowname
    public :: ofwin_setgridsize
    public :: ofwin_setkeypresscallback
    public :: ofwin_setmousemotioncallback
    public :: ofwin_setbuttonpresscallback
    public :: ofwin_setbuttonreleasecallback
    public :: ofwin_start
    public :: ofwin_stop
    public :: ofwin_waitforstop
    public :: ofwin_pauseanimation
    public :: ofwin_isrunning
    public :: ofwin_setscene
    public :: ofwin_settime
    public :: ofwin_gettime
    public :: ofwin_pausetime
    public :: ofwin_istimepaused
    public :: ofwin_settimescale
    public :: ofwin_gettimescale
    public :: ofwin_setlightambient
    public :: ofwin_setlightdiffuse
    public :: ofwin_setlightspecular
    public :: ofwin_setlightposition
    public :: ofwin_setstereo
    public :: ofwin_setbackgroundcolor
    public :: ofwin_setbackgroundtexture
    public :: ofwin_setbackgroundstardata
    public :: ofwin_enablehudtext
    public :: ofwin_sethudtextfont
    public :: ofwin_sethudtextparameters
    public :: ofwin_sethudtextposition
    public :: ofwin_sethudtext
    public :: ofwin_setdesiredframerate
    public :: ofwin_addview
    public :: ofwin_removeview
    public :: ofwin_removeallviews
    public :: ofwin_selectview
    public :: ofwin_setswapbuffersfunction
    public :: ofwin_setmakecurrentfunction
    public :: ofwin_setupdatecontextfunction
    public :: ofwin_resizewindow
    public :: ofwin_keypress
    public :: ofwin_keyrelease
    public :: ofwin_buttonpress
    public :: ofwin_buttonrelease
    public :: ofwin_mousemotion
    public :: ofwin_capturewindow
    public :: ofwin_setwindowcapturefile
    public :: ofwin_setwindowcapturekey
    public :: offm_activate
    public :: offm_create
    public :: offm_setframe
    public :: offm_lock
    public :: offm_unlock
    public :: offrame_activate
    public :: offrame_create
    public :: offrame_setcolor
    public :: offrame_addchild
    public :: offrame_removechild
    public :: offrame_removeallchildren
    public :: offrame_getnumchildren
    public :: offrame_setposition
    public :: offrame_getposition
    public :: offrame_setattitude
    public :: offrame_getattitude
    public :: offrame_showaxes
    public :: offrame_shownamelabel
    public :: offrame_showaxeslabels
    public :: offrame_setnamelabel
    public :: offrame_setaxeslabels
    public :: offrame_movexaxis
    public :: offrame_moveyaxis
    public :: offrame_movezaxis
    public :: offrame_setlightsourceenabled
    public :: offrame_getlightsourceenabled
    public :: offrame_setlightambient
    public :: offrame_setlightdiffuse
    public :: offrame_setlightspecular
    public :: offrame_followtrajectory
    public :: offrame_followtype
    public :: offrame_followposition
    public :: offrame_printframestring
    public :: ofsphere_create
    public :: ofsphere_setradius
    public :: ofsphere_settexturemap
    public :: ofsphere_setnighttexturemap
    public :: ofsphere_setautolod
    public :: ofsphere_setsphereposition
    public :: ofsphere_setsphereattitude
    public :: ofsphere_setspherescale
    public :: ofsphere_setmaterialambient
    public :: ofsphere_setmaterialdiffuse
    public :: ofsphere_setmaterialspecular
    public :: ofsphere_setmaterialemission
    public :: ofsphere_setmaterialshininess
    public :: ofmodel_create
    public :: ofmodel_setmodel
    public :: ofmodel_setmodelposition
    public :: ofmodel_getmodelposition
    public :: ofmodel_setmodelscale
    public :: ofmodel_getmodelscale
    public :: ofmodel_setmodelpivot
    public :: ofmodel_getmodelpivot
    public :: ofmodel_getmodelsize
    public :: ofdrawtraj_create
    public :: ofdrawtraj_addartist
    public :: ofdrawtraj_removeartist
    public :: ofdrawtraj_removeallartists
    public :: ofcoordaxes_create
    public :: ofcoordaxes_setaxislength
    public :: ofcoordaxes_setdrawaxes
    public :: ofcoordaxes_settickspacing
    public :: ofcoordaxes_setticksize
    public :: ofcoordaxes_settickimage
    public :: ofcoordaxes_settickshader
    public :: oflatlongrid_create
    public :: oflatlongrid_setparameters
    public :: ofradialplane_create
    public :: ofradialplane_setparameters
    public :: ofradialplane_setplanecolor
    public :: ofradialplane_setlinecolor
    public :: oftraj_activate
    public :: oftraj_create
    public :: oftraj_setnumoptionals
    public :: oftraj_setdof
    public :: oftraj_addtime
    public :: oftraj_addposition
    public :: oftraj_addpositionvec
    public :: oftraj_addattitude
    public :: oftraj_addattitudevec
    public :: oftraj_setoptional
    public :: oftraj_setoptionalvec
    public :: oftraj_clear
    public :: oftraj_informartists
    public :: oftraj_autoinformartists
    public :: oftrajartist_activate
    public :: oftrajartist_settrajectory
    public :: ofcurveartist_create
    public :: ofcurveartist_setxdata
    public :: ofcurveartist_setydata
    public :: ofcurveartist_setzdata
    public :: ofcurveartist_setcolor
    public :: ofcurveartist_setwidth
    public :: ofcurveartist_setpattern
    public :: ofsegmentartist_create
    public :: ofsegmentartist_setstartxdata
    public :: ofsegmentartist_setstartydata
    public :: ofsegmentartist_setstartzdata
    public :: ofsegmentartist_setendxdata
    public :: ofsegmentartist_setendydata
    public :: ofsegmentartist_setendzdata
    public :: ofsegmentartist_setstride
    public :: ofsegmentartist_setcolor
    public :: ofsegmentartist_setwidth
    public :: ofsegmentartist_setpattern
    public :: ofmarkerartist_create
    public :: ofmarkerartist_setxdata
    public :: ofmarkerartist_setydata
    public :: ofmarkerartist_setzdata
    public :: ofmarkerartist_setmarkers
    public :: ofmarkerartist_setmarkercolor
    public :: ofmarkerartist_setmarkerimage
    public :: ofmarkerartist_setmarkershader
    public :: ofmarkerartist_setintermediatetype
    public :: ofmarkerartist_setintermediatespacing
    public :: ofmarkerartist_setintermediatedirection
    public :: ofmarkerartist_setmarkersize
    public :: ofmarkerartist_setautoattenuate
    public :: ofview_activate
    public :: ofview_create
    public :: ofview_setorthographic
    public :: ofview_setperspective
    public :: ofview_setviewframe
    public :: ofview_setviewbetweenframes
    public :: ofview_setdefaultviewdistance
    public :: ofview_gettrackball
    public :: ofview_settrackball
    public :: ofview_isvalid
    public :: ofview_reset

    contains
!****************************************************************************************************

    subroutine of_initialize()
    !! sets up all internal openframes fortran/c interface variables
    !! must be called before other openframes calls
    call of_initialize_c()
    end subroutine of_initialize

    subroutine of_cleanup()
    !! cleans up all internal openframes fortran/c interface variables
    !! must be called when done using openframes
    !! afterwards, the only way to continue using openframes is to
    !! first make another call to of_initialize()
    call of_cleanup_c()
    end subroutine of_cleanup

    subroutine of_getreturnedvalue(val)
    !! retrieve the result of the last function call
    integer(int32), intent(out) :: val
    integer(c_int) :: cval
    call of_getreturnedvalue_c(cval)
    val = to_f(cval)
    end subroutine of_getreturnedvalue

    subroutine of_adddatafilepath(newpath)
    !! add a path to the start of the osg search path list
    character(len=*), intent(in) :: newpath
    call of_adddatafilepath_c(to_c(newpath))
    end subroutine of_adddatafilepath

    subroutine ofwin_activate(id)
    integer(int32), intent(in) :: id
    call ofwin_activate_c(to_c(id))
    end subroutine ofwin_activate

    subroutine ofwin_createproxy(x, y, width, height, nrow, ncol, embedded, id, usevr)
    integer(int32), intent(in) :: x
    integer(int32), intent(in) :: y
    integer(int32), intent(in) :: width
    integer(int32), intent(in) :: height
    integer(int32), intent(in) :: nrow
    integer(int32), intent(in) :: ncol
    integer(int32), intent(in) :: id
    logical, intent(in) :: embedded
    logical, intent(in) :: usevr
    call ofwin_createproxy_c(to_c(x), to_c(y), to_c(width), to_c(height), to_c(nrow), &
                             to_c(ncol), to_c(embedded), to_c(id), to_c(usevr))
    end subroutine ofwin_createproxy

    subroutine ofwin_setwindowname(winname)
    character(len=*), intent(in) :: winname
    call ofwin_setwindowname_c(to_c(winname))
    end subroutine ofwin_setwindowname

    subroutine ofwin_setgridsize(nrow, ncol)
    integer(int32), intent(in) :: nrow
    integer(int32), intent(in) :: ncol
    call ofwin_setgridsize_c(to_c(nrow), to_c(ncol))
    end subroutine ofwin_setgridsize

    subroutine ofwin_setkeypresscallback(fcn)
    procedure(keypresscallback) :: fcn
    call ofwin_setkeypresscallback_c(fcn)
    end subroutine ofwin_setkeypresscallback

    subroutine ofwin_setmousemotioncallback(fcn)
    procedure(mousemotioncallback) :: fcn
    call ofwin_setmousemotioncallback_c(fcn)
    end subroutine ofwin_setmousemotioncallback

    subroutine ofwin_setbuttonpresscallback(fcn)
    procedure(buttonpresscallback) :: fcn
    call ofwin_setbuttonpresscallback_c(fcn)
    end subroutine ofwin_setbuttonpresscallback

    subroutine ofwin_setbuttonreleasecallback(fcn)
    procedure(buttonreleasecallback) :: fcn
    call ofwin_setbuttonreleasecallback_c(fcn)
    end subroutine ofwin_setbuttonreleasecallback

    subroutine ofwin_start()
    call ofwin_start_c()
    end subroutine ofwin_start

    subroutine ofwin_stop()
    call ofwin_stop_c()
    end subroutine ofwin_stop

    subroutine ofwin_waitforstop()
    call ofwin_waitforstop_c()
    end subroutine ofwin_waitforstop

    subroutine ofwin_pauseanimation(pause)
    implicit none
    logical,intent(in) :: pause
    call ofwin_pauseanimation_c(to_c(pause))
    end subroutine ofwin_pauseanimation

    subroutine ofwin_isrunning(state)
    integer(int32), intent(out) :: state
    integer(c_int) :: cstate
    call ofwin_isrunning_c(cstate)
    state = to_f(cstate)
    end subroutine ofwin_isrunning

    subroutine ofwin_setscene(row, col)
    integer(int32), intent(in) :: row
    integer(int32), intent(in) :: col
    call ofwin_setscene_c(to_c(row), &
                          to_c(col))
    end subroutine ofwin_setscene

    subroutine ofwin_settime(time)
    real(real64), intent(in) :: time
    call ofwin_settime_c(to_c(time))
    end subroutine ofwin_settime

    subroutine ofwin_gettime(time)
    real(real64), intent(out) :: time
    real(c_double) :: ctime
    call ofwin_gettime_c(ctime)
    time = to_f(ctime)
    end subroutine ofwin_gettime

    subroutine ofwin_pausetime(pause)
    logical, intent(in) :: pause
    call ofwin_pausetime_c(to_c(pause))
    end subroutine ofwin_pausetime

    subroutine ofwin_istimepaused(ispaused)
    logical, intent(out) :: ispaused
    logical(c_bool) :: cispaused
    call ofwin_istimepaused_c(cispaused)
    ispaused = to_f(cispaused)
    end subroutine ofwin_istimepaused

    subroutine ofwin_settimescale(tscale)
    real(real64), intent(in) :: tscale
    call ofwin_settimescale_c(to_c(tscale))
    end subroutine ofwin_settimescale

    subroutine ofwin_gettimescale(tscale)
    real(real64), intent(out) :: tscale
    real(c_double) :: ctscale
    call ofwin_gettimescale_c(ctscale)
    tscale = to_f(ctscale)
    end subroutine ofwin_gettimescale

    subroutine ofwin_setlightambient(row, col, r, g, b)
    integer(int32), intent(in) :: row
    integer(int32), intent(in) :: col
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    call ofwin_setlightambient_c(to_c(row), to_c(col), to_c(r), to_c(g), to_c(b))
    end subroutine ofwin_setlightambient

    subroutine ofwin_setlightdiffuse(row, col, r, g, b)
    integer(int32), intent(in) :: row
    integer(int32), intent(in) :: col
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    call ofwin_setlightdiffuse_c(to_c(row), to_c(col), to_c(r), to_c(g), to_c(b))
    end subroutine ofwin_setlightdiffuse

    subroutine ofwin_setlightspecular(row, col, r, g, b)
    integer(int32), intent(in) :: row
    integer(int32), intent(in) :: col
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    call ofwin_setlightspecular_c(to_c(row), to_c(col), to_c(r), to_c(g), to_c(b))
    end subroutine ofwin_setlightspecular

    subroutine ofwin_setlightposition(row, col, x, y, z, w)
    integer(int32), intent(in) :: row
    integer(int32), intent(in) :: col
    real(real32), intent(in) :: x
    real(real32), intent(in) :: y
    real(real32), intent(in) :: z
    real(real32), intent(in) :: w
    call ofwin_setlightposition_c(to_c(row), to_c(col), to_c(x), to_c(y), to_c(z), to_c(w))
    end subroutine ofwin_setlightposition

    subroutine ofwin_setstereo(row, col, enable, eyeseparation, width, height, distance)
    integer(int32), intent(in) :: row
    integer(int32), intent(in) :: col
    logical, intent(in) :: enable
    real(real32), intent(in) :: eyeseparation
    real(real32), intent(in) :: width
    real(real32), intent(in) :: height
    real(real32), intent(in) :: distance
    call ofwin_setstereo_c(to_c(row), to_c(col), to_c(enable), to_c(eyeseparation), to_c(width), to_c(height), to_c(distance))
    end subroutine ofwin_setstereo

    subroutine ofwin_setbackgroundcolor(row, col, r, g, b)
    integer(int32), intent(in) :: row
    integer(int32), intent(in) :: col
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    call ofwin_setbackgroundcolor_c(to_c(row), to_c(col), to_c(r), to_c(g), to_c(b))
    end subroutine ofwin_setbackgroundcolor

    subroutine ofwin_setbackgroundtexture(row, col, fname)
    integer(int32), intent(in) :: row
    integer(int32), intent(in) :: col
    character(len=*), intent(in) :: fname
    call ofwin_setbackgroundtexture_c(to_c(row), to_c(col), to_c(fname))
    end subroutine ofwin_setbackgroundtexture

    subroutine ofwin_setbackgroundstardata(row, col, minmag, maxmag, fname)
    integer(int32), intent(in) :: row
    integer(int32), intent(in) :: col
    real(real32), intent(in) :: minmag
    real(real32), intent(in) :: maxmag
    character(len=*), intent(in) :: fname
    call ofwin_setbackgroundstardata_c(to_c(row), to_c(col), to_c(minmag), to_c(maxmag), to_c(fname))
    end subroutine ofwin_setbackgroundstardata

    subroutine ofwin_enablehudtext(row, col, enable)
    integer(int32), intent(in) :: row
    integer(int32), intent(in) :: col
    logical, intent(in) :: enable
    call ofwin_enablehudtext_c(to_c(row), to_c(col), to_c(enable))
    end subroutine ofwin_enablehudtext

    subroutine ofwin_sethudtextfont(row, col, fname)
    integer(int32), intent(in) :: row
    integer(int32), intent(in) :: col
    character(len=*), intent(in) :: fname
    call ofwin_sethudtextfont_c(to_c(row), to_c(col), to_c(fname))
    end subroutine ofwin_sethudtextfont

    subroutine ofwin_sethudtextparameters(row, col, r, g, b, charsize)
    integer(int32), intent(in) :: row, col
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    real(real32), intent(in) :: charsize
    call ofwin_sethudtextparameters_c(to_c(row), to_c(col), to_c(r), to_c(g), to_c(b), to_c(charsize))
    end subroutine ofwin_sethudtextparameters

    subroutine ofwin_sethudtextposition(row, col, x, y, alignment)
    integer(int32), intent(in) :: row
    integer(int32), intent(in) :: col
    integer(int32), intent(in) :: alignment
    real(real32), intent(in) :: x
    real(real32), intent(in) :: y
    call ofwin_sethudtextposition_c(to_c(row), to_c(col), to_c(x), to_c(y), to_c(alignment))
    end subroutine ofwin_sethudtextposition

    subroutine ofwin_sethudtext(row, col, text)
    integer(int32), intent(in) :: row
    integer(int32), intent(in) :: col
    character(len=*), intent(in) :: text
    call ofwin_sethudtext_c(to_c(row), to_c(col), to_c(text))
    end subroutine ofwin_sethudtext

    subroutine ofwin_setdesiredframerate(fps)
    real(real64), intent(in) :: fps
    call ofwin_setdesiredframerate_c(to_c(fps))
    end subroutine ofwin_setdesiredframerate

    subroutine ofwin_addview(row, col)
    integer(int32), intent(in) :: row
    integer(int32), intent(in) :: col
    call ofwin_addview_c(to_c(row), to_c(col))
    end subroutine ofwin_addview

    subroutine ofwin_removeview(row, col)
    integer(int32), intent(in) :: row
    integer(int32), intent(in) :: col
    call ofwin_removeview_c(to_c(row), to_c(col))
    end subroutine ofwin_removeview

    subroutine ofwin_removeallviews(row, col)
    integer(int32), intent(in) :: row
    integer(int32), intent(in) :: col
    call ofwin_removeallviews_c(to_c(row), to_c(col))
    end subroutine ofwin_removeallviews

    subroutine ofwin_selectview(row, col)
    integer(int32), intent(in) :: row
    integer(int32), intent(in) :: col
    call ofwin_selectview_c(to_c(row), to_c(col))
    end subroutine ofwin_selectview

    subroutine ofwin_setswapbuffersfunction(fcn)
    procedure(swapbuffersfunction) :: fcn
    call ofwin_setswapbuffersfunction_c(fcn)
    end subroutine ofwin_setswapbuffersfunction

    subroutine ofwin_setmakecurrentfunction(fcn)
    procedure(makecurrentfunction) :: fcn
    call ofwin_setmakecurrentfunction_c(fcn)
    end subroutine ofwin_setmakecurrentfunction

    subroutine ofwin_setupdatecontextfunction(fcn)
    procedure(updatecontextfunction) :: fcn
    call ofwin_setupdatecontextfunction_c(fcn)
    end subroutine ofwin_setupdatecontextfunction

    subroutine ofwin_resizewindow(x, y, width, height)
    integer(int32), intent(in) :: x
    integer(int32), intent(in) :: y
    integer(int32), intent(in) :: width
    integer(int32), intent(in) :: height
    call ofwin_resizewindow_c(to_c(x), to_c(y), to_c(width), to_c(height))
    end subroutine ofwin_resizewindow

    subroutine ofwin_keypress(key)
    integer(int32), intent(in) :: key
    call ofwin_keypress_c(to_c(key))
    end subroutine ofwin_keypress

    subroutine ofwin_keyrelease(key)
    integer(int32), intent(in) :: key
    call ofwin_keyrelease_c(to_c(key))
    end subroutine ofwin_keyrelease

    subroutine ofwin_buttonpress(x, y, button)
    real(real32), intent(in) :: x
    real(real32), intent(in) :: y
    integer(int32), intent(in) :: button
    call ofwin_buttonpress_c(to_c(x), to_c(y), to_c(button))
    end subroutine ofwin_buttonpress

    subroutine ofwin_buttonrelease(x, y, button)
    real(real32), intent(in) :: x
    real(real32), intent(in) :: y
    integer(int32), intent(in) :: button
    call ofwin_buttonrelease_c(to_c(x), to_c(y), to_c(button))
    end subroutine ofwin_buttonrelease

    subroutine ofwin_mousemotion(x, y)
    real(real32), intent(in) :: x
    real(real32), intent(in) :: y
    call ofwin_mousemotion_c(to_c(x), to_c(y))
    end subroutine ofwin_mousemotion

    subroutine ofwin_capturewindow()
    call ofwin_capturewindow_c()
    end subroutine ofwin_capturewindow

    subroutine ofwin_setwindowcapturefile(fname, fext)
    character(len=*), intent(in) :: fname
    character(len=*), intent(in) :: fext
    call ofwin_setwindowcapturefile_c(to_c(fname), to_c(fext))
    end subroutine ofwin_setwindowcapturefile

    subroutine ofwin_setwindowcapturekey(key)
    integer(int32), intent(in) :: key
    call ofwin_setwindowcapturekey_c(to_c(key))
    end subroutine ofwin_setwindowcapturekey

    ! FrameManager functions

    subroutine offm_activate(id)
    integer(int32), intent(in) :: id
    call offm_activate_c(to_c(id))
    end subroutine offm_activate

    subroutine offm_create(id)
    integer(int32), intent(in) :: id
    call offm_create_c(to_c(id))
    end subroutine offm_create

    subroutine offm_setframe()
    call offm_setframe_c()
    end subroutine offm_setframe

    subroutine offm_lock()
    call offm_lock_c()
    end subroutine offm_lock

    subroutine offm_unlock()
    call offm_unlock_c()
    end subroutine offm_unlock

    ! ReferenceFrame functions

    subroutine offrame_activate(name)
    character(len=*), intent(in) :: name
    call offrame_activate_c(to_c(name))
    end subroutine offrame_activate

    subroutine offrame_create(name)
    character(len=*), intent(in) :: name
    call offrame_create_c(to_c(name))
    end subroutine offrame_create

    subroutine offrame_setcolor(r, g, b, a)
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    real(real32), intent(in) :: a
    call offrame_setcolor_c(to_c(r), to_c(g), to_c(b), to_c(a))
    end subroutine offrame_setcolor

    subroutine offrame_addchild(name)
    character(len=*), intent(in) :: name
    call offrame_addchild_c(to_c(name))
    end subroutine offrame_addchild

    subroutine offrame_removechild(name)
    character(len=*), intent(in) :: name
    call offrame_removechild_c(to_c(name))
    end subroutine offrame_removechild

    subroutine offrame_removeallchildren()
    call offrame_removeallchildren_c()
    end subroutine offrame_removeallchildren

    subroutine offrame_getnumchildren(numchildren)
    integer(int32), intent(out) :: numchildren
    integer(c_int) :: cnumchildren
    call offrame_getnumchildren_c(cnumchildren)
    numchildren = to_f(numchildren)
    end subroutine offrame_getnumchildren

    subroutine offrame_setposition(x, y, z)
    real(real64), intent(in) :: x
    real(real64), intent(in) :: y
    real(real64), intent(in) :: z
    call offrame_setposition_c(to_c(x), to_c(y), to_c(z))
    end subroutine offrame_setposition

    subroutine offrame_getposition(x, y, z)
    real(real64), intent(out) :: x
    real(real64), intent(out) :: y
    real(real64), intent(out) :: z
    real(c_double) :: cx, cy, cz
    call offrame_getposition_c(cx, cy, cz)
    x = to_f(cx)
    y = to_f(cy)
    z = to_f(cz)
    end subroutine offrame_getposition

    subroutine offrame_setattitude(x, y, z, angle)
    real(real64), intent(in) :: x
    real(real64), intent(in) :: y
    real(real64), intent(in) :: z
    real(real64), intent(in) :: angle
    call offrame_setattitude_c(to_c(x), to_c(y), to_c(z), to_c(angle))
    end subroutine offrame_setattitude

    subroutine offrame_getattitude(x, y, z, angle)
    real(real64), intent(out) :: x
    real(real64), intent(out) :: y
    real(real64), intent(out) :: z
    real(real64), intent(out) :: angle
    real(c_double) :: cx, cy, cz, cangle
    call offrame_getattitude_c(cx, cy, cz, cangle)
    x = to_f(cx)
    y = to_f(cy)
    z = to_f(cz)
    angle = to_f(cangle)
    end subroutine offrame_getattitude

    subroutine offrame_showaxes(axes)
    integer(int32), intent(in) :: axes
    call offrame_showaxes_c(to_c(axes))
    end subroutine offrame_showaxes

    subroutine offrame_shownamelabel(namelabel)
    logical, intent(in) :: namelabel
    call offrame_shownamelabel_c(to_c(namelabel))
    end subroutine offrame_shownamelabel

    subroutine offrame_showaxeslabels(labels)
    integer(int32), intent(in) :: labels
    call offrame_showaxeslabels_c(to_c(labels))
    end subroutine offrame_showaxeslabels

    subroutine offrame_setnamelabel(name)
    character(len=*), intent(in) :: name
    call offrame_setnamelabel_c(to_c(name))
    end subroutine offrame_setnamelabel

    subroutine offrame_setaxeslabels(xlabel, ylabel, zlabel)
    character(len=*), intent(in) :: xlabel
    character(len=*), intent(in) :: ylabel
    character(len=*), intent(in) :: zlabel
    call offrame_setaxeslabels_c(to_c(xlabel), to_c(ylabel), to_c(zlabel))
    end subroutine offrame_setaxeslabels

    subroutine offrame_movexaxis(pos, length, headratio, bodyradius, headradius)
    real(real64), dimension(3), intent(in) :: pos
    real(real64), intent(in) :: length
    real(real64), intent(in) :: headratio
    real(real64), intent(in) :: bodyradius
    real(real64), intent(in) :: headradius
    call offrame_movexaxis_c(to_c(pos), to_c(length), to_c(headratio), to_c(bodyradius), to_c(headradius))
    end subroutine offrame_movexaxis

    subroutine offrame_moveyaxis(pos, length, headratio, bodyradius, headradius)
    real(real64), dimension(3), intent(in) :: pos
    real(real64), intent(in) :: length
    real(real64), intent(in) :: headratio
    real(real64), intent(in) :: bodyradius
    real(real64), intent(in) :: headradius
    call offrame_moveyaxis_c(to_c(pos), to_c(length), to_c(headratio), to_c(bodyradius), to_c(headradius))
    end subroutine offrame_moveyaxis

    subroutine offrame_movezaxis(pos, length, headratio, bodyradius, headradius)
    real(real64), dimension(3), intent(in) :: pos
    real(real64), intent(in) :: length
    real(real64), intent(in) :: headratio
    real(real64), intent(in) :: bodyradius
    real(real64), intent(in) :: headradius
    call offrame_movezaxis_c(to_c(pos), to_c(length), to_c(headratio), to_c(bodyradius), to_c(headradius))
    end subroutine offrame_movezaxis

    subroutine offrame_setlightsourceenabled(enabled)
    logical, intent(in) :: enabled
    call offrame_setlightsourceenabled_c(to_c(enabled))
    end subroutine offrame_setlightsourceenabled

    subroutine offrame_getlightsourceenabled(enabled)
    logical, intent(out) :: enabled
    logical(c_bool) :: cenabled
    call offrame_getlightsourceenabled_c(cenabled)
    enabled = to_f(cenabled)
    end subroutine offrame_getlightsourceenabled

    subroutine offrame_setlightambient(r, g, b)
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    call offrame_setlightambient_c(to_c(r), to_c(g), to_c(b))
    end subroutine offrame_setlightambient

    subroutine offrame_setlightdiffuse(r, g, b)
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    call offrame_setlightdiffuse_c(to_c(r), to_c(g), to_c(b))
    end subroutine offrame_setlightdiffuse

    subroutine offrame_setlightspecular(r, g, b)
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    call offrame_setlightspecular_c(to_c(r), to_c(g), to_c(b))
    end subroutine offrame_setlightspecular

    subroutine offrame_followtrajectory(name)
    character(len=*), intent(in) :: name
    call offrame_followtrajectory_c(to_c(name))
    end subroutine offrame_followtrajectory

    subroutine offrame_followtype(data, mode)
    integer(int32), intent(in) :: data
    integer(int32), intent(in) :: mode
    call offrame_followtype_c(to_c(data), to_c(mode))
    end subroutine offrame_followtype

    subroutine offrame_followposition(src, element, opt, scale)
    integer(int32), dimension(3), intent(in) :: src
    integer(int32), dimension(3), intent(in) :: element
    integer(int32), dimension(3), intent(in) :: opt
    real(real64), dimension(3), intent(in) :: scale
    call offrame_followposition_c(to_c(src), to_c(element), to_c(opt), to_c(scale))
    end subroutine offrame_followposition

    subroutine offrame_printframestring()
    call offrame_printframestring_c()
    end subroutine offrame_printframestring

    ! Sphere functions
    ! A Sphere is a type of ReferenceFrame, so all the above ReferenceFrame
    ! functions also apply to a Sphere.  In addition, to operate on a Sphere
    ! you must first set it as the currently active ReferenceFrame by using
    ! offrame_activate() (just like for any other ReferenceFrame).

    subroutine ofsphere_create(name)
    character(len=*), intent(in) :: name
    call ofsphere_create_c(to_c(name))
    end subroutine ofsphere_create

    subroutine ofsphere_setradius(radius)
    real(real64), intent(in) :: radius
    call ofsphere_setradius_c(to_c(radius))
    end subroutine ofsphere_setradius

    subroutine ofsphere_settexturemap(fname)
    character(len=*), intent(in) :: fname
    call ofsphere_settexturemap_c(to_c(fname))
    end subroutine ofsphere_settexturemap

    subroutine ofsphere_setnighttexturemap(fname)
    character(len=*), intent(in) :: fname
    call ofsphere_setnighttexturemap_c(to_c(fname))
    end subroutine ofsphere_setnighttexturemap

    subroutine ofsphere_setautolod(lod)
    logical, intent(in) :: lod
    call ofsphere_setautolod_c(to_c(lod))
    end subroutine ofsphere_setautolod

    subroutine ofsphere_setsphereposition(x, y, z)
    real(real64), intent(in) :: x
    real(real64), intent(in) :: y
    real(real64), intent(in) :: z
    call ofsphere_setsphereposition_c(to_c(x), to_c(y), to_c(z))
    end subroutine ofsphere_setsphereposition

    subroutine ofsphere_setsphereattitude(rx, ry, rz, angle)
    real(real64), intent(in) :: rx
    real(real64), intent(in) :: ry
    real(real64), intent(in) :: rz
    real(real64), intent(in) :: angle
    call ofsphere_setsphereattitude_c(to_c(rx), to_c(ry), to_c(rz), to_c(angle))
    end subroutine ofsphere_setsphereattitude

    subroutine ofsphere_setspherescale(sx, sy, sz)
    real(real64), intent(in) :: sx
    real(real64), intent(in) :: sy
    real(real64), intent(in) :: sz
    call ofsphere_setspherescale_c(to_c(sx), to_c(sy), to_c(sz))
    end subroutine ofsphere_setspherescale

    subroutine ofsphere_setmaterialambient(r, g, b)
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    call ofsphere_setmaterialambient_c(to_c(r), to_c(g), to_c(b))
    end subroutine ofsphere_setmaterialambient

    subroutine ofsphere_setmaterialdiffuse(r, g, b)
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    call ofsphere_setmaterialdiffuse_c(to_c(r), to_c(g), to_c(b))
    end subroutine ofsphere_setmaterialdiffuse

    subroutine ofsphere_setmaterialspecular(r, g, b)
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    call ofsphere_setmaterialspecular_c(to_c(r), to_c(g), to_c(b))
    end subroutine ofsphere_setmaterialspecular

    subroutine ofsphere_setmaterialemission(r, g, b)
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    call ofsphere_setmaterialemission_c(to_c(r), to_c(g), to_c(b))
    end subroutine ofsphere_setmaterialemission

    subroutine ofsphere_setmaterialshininess(shininess)
    real(real32), intent(in) :: shininess
    call ofsphere_setmaterialshininess_c(to_c(shininess))
    end subroutine ofsphere_setmaterialshininess

    ! Model Functions
    ! A Model is a type of ReferenceFrame, so all the above ReferenceFrame
    ! functions also apply to it.  In addition, to operate on a Model
    ! you must first set it as the currently active ReferenceFrame by using
    ! offrame_activate() (just like for any other ReferenceFrame).

    subroutine ofmodel_create(name)
    character(len=*), intent(in) :: name
    call ofmodel_create_c(to_c(name))
    end subroutine ofmodel_create

    subroutine ofmodel_setmodel(fname)
    character(len=*), intent(in) :: fname
    call ofmodel_setmodel_c(to_c(fname))
    end subroutine ofmodel_setmodel

    subroutine ofmodel_setmodelposition(x, y, z)
    real(real64), intent(in) :: x
    real(real64), intent(in) :: y
    real(real64), intent(in) :: z
    call ofmodel_setmodelposition_c(to_c(x), to_c(y), to_c(z))
    end subroutine ofmodel_setmodelposition

    subroutine ofmodel_getmodelposition(x, y, z)
    real(real64), intent(out) :: x
    real(real64), intent(out) :: y
    real(real64), intent(out) :: z
    real(c_double) :: cx, cy, cz
    call ofmodel_getmodelposition_c(cx, cy, cz)
    x = to_f(cx)
    y = to_f(cy)
    z = to_f(cz)
    end subroutine ofmodel_getmodelposition

    subroutine ofmodel_setmodelscale(x, y, z)
    real(real64), intent(in) :: x
    real(real64), intent(in) :: y
    real(real64), intent(in) :: z
    call ofmodel_setmodelscale_c(to_c(x), to_c(y), to_c(z))
    end subroutine ofmodel_setmodelscale

    subroutine ofmodel_getmodelscale(x, y, z)
    real(real64), intent(out) :: x
    real(real64), intent(out) :: y
    real(real64), intent(out) :: z
    real(c_double) :: cx, cy, cz
    call ofmodel_getmodelscale_c(cx, cy, cz)
    x = to_f(cx)
    y = to_f(cy)
    z = to_f(cz)
    end subroutine ofmodel_getmodelscale

    subroutine ofmodel_setmodelpivot(x, y, z)
    real(real64), intent(in) :: x
    real(real64), intent(in) :: y
    real(real64), intent(in) :: z
    call ofmodel_setmodelpivot_c(to_c(x), to_c(y), to_c(z))
    end subroutine ofmodel_setmodelpivot

    subroutine ofmodel_getmodelpivot(x, y, z)
    real(real64), intent(out) :: x
    real(real64), intent(out) :: y
    real(real64), intent(out) :: z
    real(c_double) :: cx, cy, cz
    call ofmodel_getmodelpivot_c(cx, cy, cz)
    x = to_f(cx)
    y = to_f(cy)
    z = to_f(cz)
    end subroutine ofmodel_getmodelpivot

    subroutine ofmodel_getmodelsize(size)
    real(real64), intent(out) :: size
    real(c_double) :: csize
    call ofmodel_getmodelsize_c(csize)
    size = to_f(csize)
    end subroutine ofmodel_getmodelsize

    ! DrawableTrajectory functions
    ! A DrawableTrajectory allows a TrajectoryArtist to do its drawing.
    ! A DrawableTrajectory is a type of ReferenceFrame, so all the above ReferenceFrame
    ! functions also apply to it.  In addition, to operate on a DrawableTrajectory
    ! you must first set it as the currently active ReferenceFrame by using
    ! offrame_activate() (just like for any other ReferenceFrame).

    subroutine ofdrawtraj_create(name)
    character(len=*), intent(in) :: name
    call ofdrawtraj_create_c(to_c(name))
    end subroutine ofdrawtraj_create

    subroutine ofdrawtraj_addartist(name)
    character(len=*), intent(in) :: name
    call ofdrawtraj_addartist_c(to_c(name))
    end subroutine ofdrawtraj_addartist

    subroutine ofdrawtraj_removeartist(name)
    character(len=*), intent(in) :: name
    call ofdrawtraj_removeartist_c(to_c(name))
    end subroutine ofdrawtraj_removeartist

    subroutine ofdrawtraj_removeallartists()
    call ofdrawtraj_removeallartists_c()
    end subroutine ofdrawtraj_removeallartists

    ! CoordinateAxes functions

    subroutine ofcoordaxes_create(name)
    character(len=*), intent(in) :: name
    call ofcoordaxes_create_c(to_c(name))
    end subroutine ofcoordaxes_create

    subroutine ofcoordaxes_setaxislength(len)
    real(real64), intent(in) :: len
    call ofcoordaxes_setaxislength_c(to_c(len))
    end subroutine ofcoordaxes_setaxislength

    subroutine ofcoordaxes_setdrawaxes(axes)
    integer(int32), intent(in) :: axes
    call ofcoordaxes_setdrawaxes_c(to_c(axes))
    end subroutine ofcoordaxes_setdrawaxes

    subroutine ofcoordaxes_settickspacing(major, minor)
    real(real64), intent(in) :: major
    real(real64), intent(in) :: minor
    call ofcoordaxes_settickspacing_c(to_c(major), to_c(minor))
    end subroutine ofcoordaxes_settickspacing

    subroutine ofcoordaxes_setticksize(major, minor)
    integer(int32), intent(in) :: major
    integer(int32), intent(in) :: minor
    call ofcoordaxes_setticksize_c(to_c(major), to_c(minor))
    end subroutine ofcoordaxes_setticksize

    subroutine ofcoordaxes_settickimage(fname)
    character(len=*), intent(in) :: fname
    call ofcoordaxes_settickimage_c(to_c(fname))
    end subroutine ofcoordaxes_settickimage

    subroutine ofcoordaxes_settickshader(fname)
    character(len=*), intent(in) :: fname
    call ofcoordaxes_settickshader_c(to_c(fname))
    end subroutine ofcoordaxes_settickshader

    ! LatLonGrid functions

    subroutine oflatlongrid_create(name)
    character(len=*), intent(in) :: name
    call oflatlongrid_create_c(to_c(name))
    end subroutine oflatlongrid_create

    subroutine oflatlongrid_setparameters(radiusx, radiusy, radiusz, latspace, lonspace)
    real(real64), intent(in) :: radiusx
    real(real64), intent(in) :: radiusy
    real(real64), intent(in) :: radiusz
    real(real64), intent(in) :: latspace
    real(real64), intent(in) :: lonspace
    call oflatlongrid_setparameters_c(to_c(radiusx), to_c(radiusy), to_c(radiusz), to_c(latspace), to_c(lonspace))
    end subroutine oflatlongrid_setparameters

    ! RadialPlane functions

    subroutine ofradialplane_create(name)
    character(len=*), intent(in) :: name
    call ofradialplane_create_c(to_c(name))
    end subroutine ofradialplane_create

    subroutine ofradialplane_setparameters(radius, radspace, lonspace)
    real(real64), intent(in) :: radius
    real(real64), intent(in) :: radspace
    real(real64), intent(in) :: lonspace
    call ofradialplane_setparameters_c(to_c(radius), to_c(radspace), to_c(lonspace))
    end subroutine ofradialplane_setparameters

    subroutine ofradialplane_setplanecolor(r, g, b, a)
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    real(real32), intent(in) :: a
    call ofradialplane_setplanecolor_c(to_c(r), to_c(g), to_c(b), to_c(a))
    end subroutine ofradialplane_setplanecolor

    subroutine ofradialplane_setlinecolor(r, g, b, a)
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    real(real32), intent(in) :: a
    call ofradialplane_setlinecolor_c(to_c(r), to_c(g), to_c(b), to_c(a))
    end subroutine ofradialplane_setlinecolor

    ! Trajectory functions

    subroutine oftraj_activate(name)
    character(len=*), intent(in) :: name
    call oftraj_activate_c(to_c(name))
    end subroutine oftraj_activate

    subroutine oftraj_create(name, dof, numopt)
    character(len=*), intent(in) :: name
    integer(int32), intent(in) :: dof
    integer(int32), intent(in) :: numopt
    call oftraj_create_c(to_c(name), to_c(dof), to_c(numopt))
    end subroutine oftraj_create

    subroutine oftraj_setnumoptionals(nopt)
    integer(int32), intent(in) :: nopt
    call oftraj_setnumoptionals_c(to_c(nopt))
    end subroutine oftraj_setnumoptionals

    subroutine oftraj_setdof(dof)
    integer(int32), intent(in) :: dof
    call oftraj_setdof_c(to_c(dof))
    end subroutine oftraj_setdof

    subroutine oftraj_addtime(t)
    real(real64), intent(in) :: t
    call oftraj_addtime_c(to_c(t))
    end subroutine oftraj_addtime

    subroutine oftraj_addposition(x, y, z)
    real(real64), intent(in) :: x
    real(real64), intent(in) :: y
    real(real64), intent(in) :: z
    call oftraj_addposition_c(to_c(x), to_c(y), to_c(z))
    end subroutine oftraj_addposition

    subroutine oftraj_addpositionvec(pos)
    real(real64), dimension(:), intent(in) :: pos                   ! JW - check this !!! interface has (*)
    call oftraj_addpositionvec_c(to_c(pos))
    end subroutine oftraj_addpositionvec

    subroutine oftraj_addattitude(x, y, z, w)
    real(real64), intent(in) :: x
    real(real64), intent(in) :: y
    real(real64), intent(in) :: z
    real(real64), intent(in) :: w
    call oftraj_addattitude_c(to_c(x), to_c(y), to_c(z), to_c(w))
    end subroutine oftraj_addattitude

    subroutine oftraj_addattitudevec(att)
    real(real64), dimension(4), intent(in) :: att
    call oftraj_addattitudevec_c(to_c(att))
    end subroutine oftraj_addattitudevec

    subroutine oftraj_setoptional(index, x, y, z)
    integer(int32), intent(in) :: index
    real(real64), intent(in) :: x
    real(real64), intent(in) :: y
    real(real64), intent(in) :: z
    call oftraj_setoptional_c(to_c(index), to_c(x), to_c(y), to_c(z))
    end subroutine oftraj_setoptional

    subroutine oftraj_setoptionalvec(index, opt)
    integer(int32), intent(in) :: index
    real(real64), dimension(:), intent(in) :: opt                   ! JW - check this !!! interface has (*)
    call oftraj_setoptionalvec_c(to_c(index), to_c(opt))
    end subroutine oftraj_setoptionalvec

    subroutine oftraj_clear()
    call oftraj_clear_c()
    end subroutine oftraj_clear

    subroutine oftraj_informartists()
    call oftraj_informartists_c()
    end subroutine oftraj_informartists

    subroutine oftraj_autoinformartists(autoinform)
    logical, intent(in) :: autoinform
    call oftraj_autoinformartists_c(to_c(autoinform))
    end subroutine oftraj_autoinformartists

    ! TrajectoryArtist functions
    ! A TrajectoryArtist graphically interprets the data contained in a
    ! Trajectory.  Since it is not a ReferenceFrame, it must be attached
    ! to a DrawableTrajectory before it can be added to a scene.  Note that
    ! you cannot create a TrajectoryArtist by itself.  You must create one
    ! of its derived types (eg CurveArtist etc...).

    subroutine oftrajartist_activate(name)
    character(len=*), intent(in) :: name
    call oftrajartist_activate_c(to_c(name))
    end subroutine oftrajartist_activate

    subroutine oftrajartist_settrajectory()
    call oftrajartist_settrajectory_c()
    end subroutine oftrajartist_settrajectory

    ! CurveArtist functions

    subroutine ofcurveartist_create(name)
    character(len=*), intent(in) :: name
    call ofcurveartist_create_c(to_c(name))
    end subroutine ofcurveartist_create

    subroutine ofcurveartist_setxdata(src, element, opt, scale)
    integer(int32), intent(in) :: src
    integer(int32), intent(in) :: element
    integer(int32), intent(in) :: opt
    real(real64), intent(in) :: scale
    call ofcurveartist_setxdata_c(to_c(src), to_c(element), to_c(opt), to_c(scale))
    end subroutine ofcurveartist_setxdata

    subroutine ofcurveartist_setydata(src, element, opt, scale)
    integer(int32), intent(in) :: src
    integer(int32), intent(in) :: element
    integer(int32), intent(in) :: opt
    real(real64), intent(in) :: scale
    call ofcurveartist_setydata_c(to_c(src), to_c(element), to_c(opt), to_c(scale))
    end subroutine ofcurveartist_setydata

    subroutine ofcurveartist_setzdata(src, element, opt, scale)
    integer(int32), intent(in) :: src
    integer(int32), intent(in) :: element
    integer(int32), intent(in) :: opt
    real(real64), intent(in) :: scale
    call ofcurveartist_setzdata_c(to_c(src), to_c(element), to_c(opt), to_c(scale))
    end subroutine ofcurveartist_setzdata

    subroutine ofcurveartist_setcolor(r, g, b)
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    call ofcurveartist_setcolor_c(to_c(r), to_c(g), to_c(b))
    end subroutine ofcurveartist_setcolor

    subroutine ofcurveartist_setwidth(width)
    real(real32), intent(in) :: width
    call ofcurveartist_setwidth_c(to_c(width))
    end subroutine ofcurveartist_setwidth

    subroutine ofcurveartist_setpattern(factor, pattern)
    integer(int32), intent(in) :: factor
    integer(int16), intent(in) :: pattern
    call ofcurveartist_setpattern_c(to_c(factor), to_c(pattern))
    end subroutine ofcurveartist_setpattern

    ! SegmentArtist functions

    subroutine ofsegmentartist_create(name)
    character(len=*), intent(in) :: name
    call ofsegmentartist_create_c(to_c(name))
    end subroutine ofsegmentartist_create

    subroutine ofsegmentartist_setstartxdata(src, element, opt, scale)
    integer(int32), intent(in) :: src
    integer(int32), intent(in) :: element
    integer(int32), intent(in) :: opt
    real(real64), intent(in) :: scale
    call ofsegmentartist_setstartxdata_c(to_c(src), to_c(element), to_c(opt), to_c(scale))
    end subroutine ofsegmentartist_setstartxdata

    subroutine ofsegmentartist_setstartydata(src, element, opt, scale)
    integer(int32), intent(in) :: src
    integer(int32), intent(in) :: element
    integer(int32), intent(in) :: opt
    real(real64), intent(in) :: scale
    call ofsegmentartist_setstartydata_c(to_c(src), to_c(element), to_c(opt), to_c(scale))
    end subroutine ofsegmentartist_setstartydata

    subroutine ofsegmentartist_setstartzdata(src, element, opt, scale)
    integer(int32), intent(in) :: src
    integer(int32), intent(in) :: element
    integer(int32), intent(in) :: opt
    real(real64), intent(in) :: scale
    call ofsegmentartist_setstartzdata_c(to_c(src), to_c(element), to_c(opt), to_c(scale))
    end subroutine ofsegmentartist_setstartzdata

    subroutine ofsegmentartist_setendxdata(src, element, opt, scale)
    integer(int32), intent(in) :: src
    integer(int32), intent(in) :: element
    integer(int32), intent(in) :: opt
    real(real64), intent(in) :: scale
    call ofsegmentartist_setendxdata_c(to_c(src), to_c(element), to_c(opt), to_c(scale))
    end subroutine ofsegmentartist_setendxdata

    subroutine ofsegmentartist_setendydata(src, element, opt, scale)
    integer(int32), intent(in) :: src
    integer(int32), intent(in) :: element
    integer(int32), intent(in) :: opt
    real(real64), intent(in) :: scale
    call ofsegmentartist_setendydata_c(to_c(src), to_c(element), to_c(opt), to_c(scale))
    end subroutine ofsegmentartist_setendydata

    subroutine ofsegmentartist_setendzdata(src, element, opt, scale)
    integer(int32), intent(in) :: src
    integer(int32), intent(in) :: element
    integer(int32), intent(in) :: opt
    real(real64), intent(in) :: scale
    call ofsegmentartist_setendzdata_c(to_c(src), to_c(element), to_c(opt), to_c(scale))
    end subroutine ofsegmentartist_setendzdata

    subroutine ofsegmentartist_setstride(stride)
    integer(int32), intent(in) :: stride
    call ofsegmentartist_setstride_c(to_c(stride))
    end subroutine ofsegmentartist_setstride

    subroutine ofsegmentartist_setcolor(r, g, b)
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    call ofsegmentartist_setcolor_c(to_c(r), to_c(g), to_c(b))
    end subroutine ofsegmentartist_setcolor

    subroutine ofsegmentartist_setwidth(width)
    real(real32), intent(in) :: width
    call ofsegmentartist_setwidth_c(to_c(width))
    end subroutine ofsegmentartist_setwidth

    subroutine ofsegmentartist_setpattern(factor, pattern)
    integer(int32), intent(in) :: factor
    integer(int16), intent(in) :: pattern
    call ofsegmentartist_setpattern_c(to_c(factor), to_c(pattern))
    end subroutine ofsegmentartist_setpattern

    ! MarkerArtist functions

    subroutine ofmarkerartist_create(name)
    character(len=*), intent(in) :: name
    call ofmarkerartist_create_c(to_c(name))
    end subroutine ofmarkerartist_create

    subroutine ofmarkerartist_setxdata(src, element, opt, scale)
    integer(int32), intent(in) :: src
    integer(int32), intent(in) :: element
    integer(int32), intent(in) :: opt
    real(real64), intent(in) :: scale
    call ofmarkerartist_setxdata_c(to_c(src), to_c(element), to_c(opt), to_c(scale))
    end subroutine ofmarkerartist_setxdata

    subroutine ofmarkerartist_setydata(src, element, opt, scale)
    integer(int32), intent(in) :: src
    integer(int32), intent(in) :: element
    integer(int32), intent(in) :: opt
    real(real64), intent(in) :: scale
    call ofmarkerartist_setydata_c(to_c(src), to_c(element), to_c(opt), to_c(scale))
    end subroutine ofmarkerartist_setydata

    subroutine ofmarkerartist_setzdata(src, element, opt, scale)
    integer(int32), intent(in) :: src
    integer(int32), intent(in) :: element
    integer(int32), intent(in) :: opt
    real(real64), intent(in) :: scale
    call ofmarkerartist_setzdata_c(to_c(src), to_c(element), to_c(opt), to_c(scale))
    end subroutine ofmarkerartist_setzdata

    subroutine ofmarkerartist_setmarkers(markers)
    integer(int32), intent(in) :: markers
    call ofmarkerartist_setmarkers_c(to_c(markers))
    end subroutine ofmarkerartist_setmarkers

    subroutine ofmarkerartist_setmarkercolor(markers, r, g, b)
    integer(int32), intent(in) :: markers
    real(real32), intent(in) :: r
    real(real32), intent(in) :: g
    real(real32), intent(in) :: b
    call ofmarkerartist_setmarkercolor_c(to_c(markers), to_c(r), to_c(g), to_c(b))
    end subroutine ofmarkerartist_setmarkercolor

    subroutine ofmarkerartist_setmarkerimage(fname)
    character(len=*), intent(in) :: fname
    call ofmarkerartist_setmarkerimage_c(to_c(fname))
    end subroutine ofmarkerartist_setmarkerimage

    subroutine ofmarkerartist_setmarkershader(fname)
    character(len=*), intent(in) :: fname
    call ofmarkerartist_setmarkershader_c(to_c(fname))
    end subroutine ofmarkerartist_setmarkershader

    subroutine ofmarkerartist_setintermediatetype(type)
    integer(int32), intent(in) :: type
    call ofmarkerartist_setintermediatetype_c(to_c(type))
    end subroutine ofmarkerartist_setintermediatetype

    subroutine ofmarkerartist_setintermediatespacing(spacing)
    real(real64), intent(in) :: spacing
    call ofmarkerartist_setintermediatespacing_c(to_c(spacing))
    end subroutine ofmarkerartist_setintermediatespacing

    subroutine ofmarkerartist_setintermediatedirection(direction)
    integer(int32), intent(in) :: direction
    call ofmarkerartist_setintermediatedirection_c(to_c(direction))
    end subroutine ofmarkerartist_setintermediatedirection

    subroutine ofmarkerartist_setmarkersize(size)
    integer(int32), intent(in) :: size
    call ofmarkerartist_setmarkersize_c(to_c(size))
    end subroutine ofmarkerartist_setmarkersize

    subroutine ofmarkerartist_setautoattenuate(autoattenuate)
    logical, intent(in) :: autoattenuate
    call ofmarkerartist_setautoattenuate_c(to_c(autoattenuate))
    end subroutine ofmarkerartist_setautoattenuate

    ! View functions

    subroutine ofview_activate(name)
    character(len=*), intent(in) :: name
    call ofview_activate_c(to_c(name))
    end subroutine ofview_activate

    subroutine ofview_create(name)
    character(len=*), intent(in) :: name
    call ofview_create_c(to_c(name))
    end subroutine ofview_create

    subroutine ofview_setorthographic(left, right, bottom, top)
    real(real64), intent(in) :: left
    real(real64), intent(in) :: right
    real(real64), intent(in) :: bottom
    real(real64), intent(in) :: top
    call ofview_setorthographic_c(to_c(left), to_c(right), to_c(bottom), to_c(top))
    end subroutine ofview_setorthographic

    subroutine ofview_setperspective(fov, ratio)
    real(real64), intent(in) :: fov
    real(real64), intent(in) :: ratio
    call ofview_setperspective_c(to_c(fov), to_c(ratio))
    end subroutine ofview_setperspective

    subroutine ofview_setviewframe(root, frame)
    character(len=*), intent(in) :: root
    character(len=*), intent(in) :: frame
    call ofview_setviewframe_c(to_c(root), to_c(frame))
    end subroutine ofview_setviewframe

    subroutine ofview_setviewbetweenframes(root, srcframe, dstframe, frametype, rotationtype)
    character(len=*), intent(in) :: root
    character(len=*), intent(in) :: srcframe
    character(len=*), intent(in) :: dstframe
    integer(int32), intent(in) :: frameType
    integer(int32), intent(in) :: rotationType
    call ofview_setviewbetweenframes_c(to_c(root), to_c(srcframe), to_c(dstframe), to_c(frametype), to_c(rotationtype))
    end subroutine ofview_setviewbetweenframes

    subroutine ofview_setdefaultviewdistance(distance)
    real(real64), intent(in) :: distance
    call ofview_setdefaultviewdistance_c(to_c(distance))
    end subroutine ofview_setdefaultviewdistance

    subroutine ofview_gettrackball(eye, center, up)
    real(real64),dimension(3), intent(out) :: eye
    real(real64),dimension(3), intent(out) :: center
    real(real64),dimension(3), intent(out) :: up
    real(c_double),dimension(3) :: ceye, ccenter, cup
    call ofview_gettrackball_c(ceye, ccenter, cup)
    eye = to_f(ceye)
    center = to_f(ccenter)
    up = to_f(cup)
    end subroutine ofview_gettrackball

    subroutine ofview_settrackball(eye, center, up)
    real(real64),dimension(3), intent(in) :: eye
    real(real64),dimension(3), intent(in) :: center
    real(real64),dimension(3), intent(in) :: up
    call ofview_settrackball_c(to_c(eye), to_c(center), to_c(up))
    end subroutine ofview_settrackball

    subroutine ofview_isvalid(valid)
    logical, intent(out) :: valid
    logical(c_bool) :: cvalid
    call ofview_isvalid_c(cvalid)
    valid = to_f(cvalid)
    end subroutine ofview_isvalid

    subroutine ofview_reset()
    call ofview_reset_c()
    end subroutine ofview_reset

    !****************************************************************************************************
    ! helper functions
    !****************************************************************************************************

    pure function fortran_str_to_c(fstr) result(cstr)
    !! a function to convert a fortran default string into a c string.
    character(len=*),intent(in) :: fstr
    character(kind=c_char,len=1),dimension(len(fstr)+1) :: cstr
    integer :: i
    do i=1,len(fstr)
        cstr(i) = fstr(i:i)
    end do
    cstr(len(fstr)+1) = c_null_char
    end function fortran_str_to_c

    pure elemental function fortran_logical_to_c(fbool) result(cbool)
    !! convert a fortran default logical to a c bool.
    logical,intent(in) :: fbool
    logical(c_bool) :: cbool
    cbool = logical(fbool,kind=c_bool)
    end function fortran_logical_to_c

    pure elemental function fortran_int_to_c(fint) result(cint)
    !! convert a fortran default integer logical to a c int.
    integer(int32),intent(in) :: fint
    integer(c_int) :: cint
    cint = int(fint,kind=c_int)
    end function fortran_int_to_c

    pure elemental function fortran_int16_to_c(fint) result(cint)
    !! convert a fortran int16 integer logical to a c short int.
    integer(int16),intent(in) :: fint
    integer(c_short) :: cint
    cint = int(fint,kind=c_short)
    end function fortran_int16_to_c

    pure elemental function fortran_double_to_c(fdouble) result(cdouble)
    !! convert a fortran real64 to a c double.
    real(real64),intent(in) :: fdouble
    real(c_double) :: cdouble
    cdouble = real(fdouble,kind=c_double)
    end function fortran_double_to_c

    pure elemental function fortran_float_to_c(ffloat) result(cfloat)
    !! convert a fortran default real to a c float.
    real(real32),intent(in) :: ffloat
    real(c_float) :: cfloat
    cfloat = real(ffloat,kind=c_float)
    end function fortran_float_to_c

    pure elemental function c_int_to_fortran(cint) result(fint)
    integer(c_int),intent(in) :: cint
    integer(int32) :: fint
    fint = int(cint,kind=int32)
    end function c_int_to_fortran

    pure elemental function c_shortint_to_fortran(cint) result(fint)
    integer(c_short),intent(in) :: cint
    integer(int16) :: fint
    fint = int(cint,kind=int16)
    end function c_shortint_to_fortran

    pure elemental function c_double_to_fortran(cdouble) result(fdouble)
    real(c_double),intent(in) :: cdouble
    real(real64) :: fdouble
    fdouble = real(cdouble,kind=real64)
    end function c_double_to_fortran

    pure elemental function c_float_to_fortran(cfloat) result(ffloat)
    real(c_float),intent(in) :: cfloat
    real(real32) :: ffloat
    ffloat = real(cfloat,kind=real32)
    end function c_float_to_fortran

    pure elemental function c_logical_to_fortran(cbool) result(fbool)
    logical(c_bool),intent(in) :: cbool
    logical :: fbool
    fbool = logical(cbool)
    end function c_logical_to_fortran

!****************************************************************************************************
    end module openframes
!****************************************************************************************************