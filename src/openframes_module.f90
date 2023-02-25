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

    module openframes_module

    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env
    use openframes_c_interface
    use openframes_fortran_helpers

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
    end module openframes_module
!****************************************************************************************************