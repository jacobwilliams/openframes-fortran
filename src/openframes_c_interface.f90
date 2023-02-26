!****************************************************************************************************
!>
!  Interfaces for the OpenFrames C API.
!
!### Author
!  * Jacob Williams, 9/9/2018
!
!### Notes
!  Note that lines starting with "!DEC$" are compiler directives for
!  the Intel Fortran family of compilers, and should not be messed with.

!  TODO: should they all have `!dec$ attributes dllimport,c,reference`?
!  TODO: add compiler directives for platforms (these are not used on linux, for example).
!  TODO: what about for gfortran?

    module openframes_c_interface

    use, intrinsic :: iso_c_binding

    implicit none

    public

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

        subroutine of_adddatafilepath_c(newpath) bind(c,name='of_adddatafilepath')
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

        subroutine ofwin_getid_c(id) bind(c,name='ofwin_getid')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_getid
        import
        implicit none
        integer(c_int), intent(out) :: id
        end subroutine ofwin_getid_c

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

        subroutine ofwin_signalstop_c() bind(c,name='ofwin_signalstop')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofwin_signalstop
        import
        implicit none
        end subroutine ofwin_signalstop_c

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

        subroutine offrame_setlabelfont_c(font) bind(c,name='offrame_setlabelfont')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_setlabelfont
        import
        implicit none
        character(kind=c_char,len=1), dimension(*), intent(in) :: font
        end subroutine offrame_setlabelfont_c

        subroutine offrame_setlabelsize_c(font) bind(c,name='offrame_setlabelsize')
        !DEC$ ATTRIBUTES DLLIMPORT :: offrame_setlabelsize
        import
        implicit none
        integer(c_int), intent(in) :: font
        end subroutine offrame_setlabelsize_c

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

        subroutine ofcoordaxes_setaxiswidth_c(width) bind(c,name='ofcoordaxes_setaxiswidth')
        !DEC$ ATTRIBUTES DLLIMPORT :: ofcoordaxes_setaxiswidth
        import
        implicit none
        real(c_float), intent(in) :: width
        end subroutine ofcoordaxes_setaxiswidth_c

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

    end module openframes_c_interface