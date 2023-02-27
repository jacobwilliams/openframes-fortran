from ctypes import *

class OpenFrames():
    """
    EXPERIMENTAL!

    An OpenFrames class for Python that wraps the C API.
    """

    def __init__(self, lib):

        self.lib = lib

        # note, in the SWIG file there are some %thread directives..
        # what is that all about? is that something that can't be done
        # with a basic ctypes interface like this ???

        # Define the ctypes interfaces to the OpenFrames C API.

        # callback functions .. TODO:
        # self.lib.keypresscallback.argtypes                          = (winid,row,col,key)
        # self.lib.mousemotioncallback.argtypes                       = (winid,row,col,x,y)
        # self.lib.buttonpresscallback.argtypes                       = (winid,row,col,x,y,button)
        # self.lib.buttonreleasecallback.argtypes                     = (winid,row,col,x,y,button)
        # self.lib.swapbuffersfunction.argtypes                       = (winid)
        # self.lib.makecurrentfunction.argtypes                       = (winid,success)
        # self.lib.updatecontextfunction.argtypes                     = (winid,success)

        # _MakeCurrentCallbackType = CFUNCTYPE(None, POINTER(c_uint), POINTER(c_bool))
        # _UpdateContextCallbackType = CFUNCTYPE(None, POINTER(c_uint), POINTER(c_bool))
        # _SwapBuffersCallbackType = CFUNCTYPE(None, POINTER(c_uint))
        # _KeyPressCallbackType = CFUNCTYPE(None, POINTER(c_uint), POINTER(c_uint), POINTER(c_uint), POINTER(c_int))
        # _MouseMotionCallbackType = CFUNCTYPE(None, POINTER(c_uint), POINTER(c_uint), POINTER(c_uint), POINTER(c_float), POINTER(c_float))
        # _MouseButtonCallbackType = CFUNCTYPE(None, POINTER(c_uint), POINTER(c_uint), POINTER(c_uint), POINTER(c_uint))

        self.lib.of_initialize.argtypes                           = [ ]
        self.lib.of_cleanup.argtypes                              = [ ]
        self.lib.of_getreturnedvalue.argtypes                     = [ POINTER(c_int) ]
        self.lib.of_adddatafilepath.argtypes                      = [ newpath ]
        self.lib.ofwin_activate.argtypes                          = [ POINTER(c_int) ]
        self.lib.ofwin_getid.argtypes                             = [ POINTER(c_int) ]
        self.lib.ofwin_createproxy.argtypes                       = [ POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_bool), POINTER(c_int), POINTER(c_bool) ]
        self.lib.ofwin_setwindowname.argtypes                     = [ winname ]
        self.lib.ofwin_setgridsize.argtypes                       = [ POINTER(c_int), POINTER(c_int) ]
        self.lib.ofwin_setkeypresscallback.argtypes               = [ fcn ]
        self.lib.ofwin_setmousemotioncallback.argtypes            = [ fcn ]
        self.lib.ofwin_setbuttonpresscallback.argtypes            = [ fcn ]
        self.lib.ofwin_setbuttonreleasecallback.argtypes          = [ fcn ]
        self.lib.ofwin_start.argtypes                             = [ ]
        self.lib.ofwin_stop.argtypes                              = [ ]
        self.lib.ofwin_waitforstop.argtypes                       = [ ]
        self.lib.ofwin_signalstop.argtypes                        = [ ]
        self.lib.ofwin_pauseanimation.argtypes                    = [ POINTER(c_bool)  ]
        self.lib.ofwin_isrunning.argtypes                         = [ POINTER(c_int) ]
        self.lib.ofwin_setscene.argtypes                          = [ POINTER(c_int), POINTER(c_int) ]
        self.lib.ofwin_settime.argtypes                           = [ POINTER(c_double) ]
        self.lib.ofwin_gettime.argtypes                           = [ POINTER(c_double) ]
        self.lib.ofwin_pausetime.argtypes                         = [ POINTER(c_bool) ]
        self.lib.ofwin_istimepaused.argtypes                      = [ POINTER(c_bool) ]
        self.lib.ofwin_settimescale.argtypes                      = [ POINTER(c_double) ]
        self.lib.ofwin_gettimescale.argtypes                      = [ POINTER(c_double) ]
        self.lib.ofwin_setlightambient.argtypes                   = [ POINTER(c_int), POINTER(c_int), POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.ofwin_setlightdiffuse.argtypes                   = [ POINTER(c_int), POINTER(c_int), POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.ofwin_setlightspecular.argtypes                  = [ POINTER(c_int), POINTER(c_int), POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.ofwin_setlightposition.argtypes                  = [ POINTER(c_int), POINTER(c_int), POINTER(c_float), POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.ofwin_setstereo.argtypes                         = [ POINTER(c_int), POINTER(c_int), POINTER(c_bool), POINTER(c_float), POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.ofwin_setbackgroundcolor.argtypes                = [ POINTER(c_int), POINTER(c_int), POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.ofwin_setbackgroundtexture.argtypes              = [ POINTER(c_int), POINTER(c_int), fname ]
        self.lib.ofwin_setbackgroundstardata.argtypes             = [ POINTER(c_int), POINTER(c_int), POINTER(c_float), POINTER(c_float), fname ]
        self.lib.ofwin_enablehudtext.argtypes                     = [ POINTER(c_int), POINTER(c_int), POINTER(c_bool) ]
        self.lib.ofwin_sethudtextfont.argtypes                    = [ POINTER(c_int), POINTER(c_int), fname ]
        self.lib.ofwin_sethudtextparameters.argtypes              = [ POINTER(c_int), POINTER(c_int), POINTER(c_float), POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.ofwin_sethudtextposition.argtypes                = [ POINTER(c_int), POINTER(c_int), POINTER(c_float), POINTER(c_float), POINTER(c_int) ]
        self.lib.ofwin_sethudtext.argtypes                        = [ POINTER(c_int), POINTER(c_int), text ]
        self.lib.ofwin_setdesiredframerate.argtypes               = [ POINTER(c_double) ]
        self.lib.ofwin_addview.argtypes                           = [ POINTER(c_int), POINTER(c_int) ]
        self.lib.ofwin_removeview.argtypes                        = [ POINTER(c_int), POINTER(c_int) ]
        self.lib.ofwin_removeallviews.argtypes                    = [ POINTER(c_int), POINTER(c_int) ]
        self.lib.ofwin_selectview.argtypes                        = [ POINTER(c_int), POINTER(c_int) ]
        self.lib.ofwin_setswapbuffersfunction.argtypes            = [ fcn ]
        self.lib.ofwin_setmakecurrentfunction.argtypes            = [ fcn ]
        self.lib.ofwin_setupdatecontextfunction.argtypes          = [ fcn ]
        self.lib.ofwin_resizewindow.argtypes                      = [ POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_int) ]
        self.lib.ofwin_keypress.argtypes                          = [ POINTER(c_int) ]
        self.lib.ofwin_keyrelease.argtypes                        = [ POINTER(c_int) ]
        self.lib.ofwin_buttonpress.argtypes                       = [ POINTER(c_float), POINTER(c_float), POINTER(c_int) ]
        self.lib.ofwin_buttonrelease.argtypes                     = [ POINTER(c_float), POINTER(c_float), POINTER(c_int) ]
        self.lib.ofwin_mousemotion.argtypes                       = [ POINTER(c_float), POINTER(c_float) ]
        self.lib.ofwin_capturewindow.argtypes                     = [ ]
        self.lib.ofwin_setwindowcapturefile.argtypes              = [ fname, fext ]
        self.lib.ofwin_setwindowcapturekey.argtypes               = [ POINTER(c_int) ]
        self.lib.offm_activate.argtypes                           = [ POINTER(c_int) ]
        self.lib.offm_create.argtypes                             = [ POINTER(c_int) ]
        self.lib.offm_setframe.argtypes                           = [ ]
        self.lib.offm_lock.argtypes                               = [ ]
        self.lib.offm_unlock.argtypes                             = [ ]
        self.lib.offrame_activate.argtypes                        = [ name ]
        self.lib.offrame_create.argtypes                          = [ name ]
        self.lib.offrame_setcolor.argtypes                        = [ POINTER(c_float), POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.offrame_addchild.argtypes                        = [ name ]
        self.lib.offrame_removechild.argtypes                     = [ name ]
        self.lib.offrame_removeallchildren.argtypes               = [ ]
        self.lib.offrame_getnumchildren.argtypes                  = [ POINTER(c_int) ]
        self.lib.offrame_setposition.argtypes                     = [ POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.offrame_getposition.argtypes                     = [ POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.offrame_setattitude.argtypes                     = [ POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.offrame_getattitude.argtypes                     = [ POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.offrame_showaxes.argtypes                        = [ POINTER(c_int) ]
        self.lib.offrame_shownamelabel.argtypes                   = [ POINTER(c_bool) ]
        self.lib.offrame_showaxeslabels.argtypes                  = [ POINTER(c_int) ]
        self.lib.offrame_setnamelabel.argtypes                    = [ name ]
        self.lib.offrame_setlabelfont.argtypes                    = [ font ]
        self.lib.offrame_setlabelsize.argtypes                    = [ POINTER(c_int) ]
        self.lib.offrame_setaxeslabels.argtypes                   = [ xlabel, ylabel, zlabel ]
        self.lib.offrame_movexaxis.argtypes                       = [ POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.offrame_moveyaxis.argtypes                       = [ POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.offrame_movezaxis.argtypes                       = [ POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.offrame_setlightsourceenabled.argtypes           = [ POINTER(c_bool) ]
        self.lib.offrame_getlightsourceenabled.argtypes           = [ POINTER(c_bool) ]
        self.lib.offrame_setlightambient.argtypes                 = [ POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.offrame_setlightdiffuse.argtypes                 = [ POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.offrame_setlightspecular.argtypes                = [ POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.offrame_followtrajectory.argtypes                = [ name ]
        self.lib.offrame_followtype.argtypes                      = [ POINTER(c_int), POINTER(c_int) ]
        self.lib.offrame_followposition.argtypes                  = [ POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_double) ]
        self.lib.offrame_printframestring.argtypes                = [ ]
        self.lib.ofsphere_create.argtypes                         = [ name ]
        self.lib.ofsphere_setradius.argtypes                      = [ POINTER(c_double) ]
        self.lib.ofsphere_settexturemap.argtypes                  = [ fname ]
        self.lib.ofsphere_setnighttexturemap.argtypes             = [ fname ]
        self.lib.ofsphere_setautolod.argtypes                     = [ POINTER(c_bool) ]
        self.lib.ofsphere_setsphereposition.argtypes              = [ POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.ofsphere_setsphereattitude.argtypes              = [ POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.ofsphere_setspherescale.argtypes                 = [ POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.ofsphere_setmaterialambient.argtypes             = [ POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.ofsphere_setmaterialdiffuse.argtypes             = [ POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.ofsphere_setmaterialspecular.argtypes            = [ POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.ofsphere_setmaterialemission.argtypes            = [ POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.ofsphere_setmaterialshininess.argtypes           = [ POINTER(c_float) ]
        self.lib.ofmodel_create.argtypes                          = [ name ]
        self.lib.ofmodel_setmodel.argtypes                        = [ fname ]
        self.lib.ofmodel_setmodelposition.argtypes                = [ POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.ofmodel_getmodelposition.argtypes                = [ POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.ofmodel_setmodelscale.argtypes                   = [ POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.ofmodel_getmodelscale.argtypes                   = [ POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.ofmodel_setmodelpivot.argtypes                   = [ POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.ofmodel_getmodelpivot.argtypes                   = [ POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.ofmodel_getmodelsize.argtypes                    = [ POINTER(c_double) ]
        self.lib.ofdrawtraj_create.argtypes                       = [ name ]
        self.lib.ofdrawtraj_addartist.argtypes                    = [ name ]
        self.lib.ofdrawtraj_removeartist.argtypes                 = [ name ]
        self.lib.ofdrawtraj_removeallartists.argtypes             = [ ]
        self.lib.ofcoordaxes_create.argtypes                      = [ name ]
        self.lib.ofcoordaxes_setaxislength.argtypes               = [ POINTER(c_double) ]
        self.lib.ofcoordaxes_setaxiswidth.argtypes                = [ POINTER(c_float) ]
        self.lib.ofcoordaxes_setdrawaxes.argtypes                 = [ POINTER(c_int) ]
        self.lib.ofcoordaxes_settickspacing.argtypes              = [ POINTER(c_double), POINTER(c_double) ]
        self.lib.ofcoordaxes_setticksize.argtypes                 = [ POINTER(c_int), POINTER(c_int) ]
        self.lib.ofcoordaxes_settickimage.argtypes                = [ fname ]
        self.lib.ofcoordaxes_settickshader.argtypes               = [ fname ]
        self.lib.oflatlongrid_create.argtypes                     = [ name ]
        self.lib.oflatlongrid_setparameters.argtypes              = [ POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.ofradialplane_create.argtypes                    = [ name ]
        self.lib.ofradialplane_setparameters.argtypes             = [ POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.ofradialplane_setplanecolor.argtypes             = [ POINTER(c_float), POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.ofradialplane_setlinecolor.argtypes              = [ POINTER(c_float), POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.oftraj_activate.argtypes                         = [ name ]
        self.lib.oftraj_create.argtypes                           = [ name, POINTER(c_int), POINTER(c_int) ]
        self.lib.oftraj_setnumoptionals.argtypes                  = [ POINTER(c_int) ]
        self.lib.oftraj_setdof.argtypes                           = [ POINTER(c_int) ]
        self.lib.oftraj_addtime.argtypes                          = [ POINTER(c_double) ]
        self.lib.oftraj_addposition.argtypes                      = [ POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.oftraj_addpositionvec.argtypes                   = [ POINTER(c_double) ]
        self.lib.oftraj_addattitude.argtypes                      = [ POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.oftraj_addattitudevec.argtypes                   = [ POINTER(c_double) ]
        self.lib.oftraj_setoptional.argtypes                      = [ POINTER(c_int), POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.oftraj_setoptionalvec.argtypes                   = [ POINTER(c_int), POINTER(c_double) ]
        self.lib.oftraj_clear.argtypes                            = [ ]
        self.lib.oftraj_informartists.argtypes                    = [ ]
        self.lib.oftraj_autoinformartists.argtypes                = [ POINTER(c_bool) ]
        self.lib.oftrajartist_activate.argtypes                   = [ name ]
        self.lib.oftrajartist_settrajectory.argtypes              = [ ]
        self.lib.ofcurveartist_create.argtypes                    = [ name ]
        self.lib.ofcurveartist_setxdata.argtypes                  = [ POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_double) ]
        self.lib.ofcurveartist_setydata.argtypes                  = [ POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_double) ]
        self.lib.ofcurveartist_setzdata.argtypes                  = [ POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_double) ]
        self.lib.ofcurveartist_setcolor.argtypes                  = [ POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.ofcurveartist_setwidth.argtypes                  = [ POINTER(c_float) ]
        self.lib.ofcurveartist_setpattern.argtypes                = [ POINTER(c_int), POINTER(c_short) ]
        self.lib.ofsegmentartist_create.argtypes                  = [ name ]
        self.lib.ofsegmentartist_setstartxdata.argtypes           = [ POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_double) ]
        self.lib.ofsegmentartist_setstartydata.argtypes           = [ POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_double) ]
        self.lib.ofsegmentartist_setstartzdata.argtypes           = [ POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_double) ]
        self.lib.ofsegmentartist_setendxdata.argtypes             = [ POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_double) ]
        self.lib.ofsegmentartist_setendydata.argtypes             = [ POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_double) ]
        self.lib.ofsegmentartist_setendzdata.argtypes             = [ POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_double) ]
        self.lib.ofsegmentartist_setstride.argtypes               = [ POINTER(c_int) ]
        self.lib.ofsegmentartist_setcolor.argtypes                = [ POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.ofsegmentartist_setwidth.argtypes                = [ POINTER(c_float) ]
        self.lib.ofsegmentartist_setpattern.argtypes              = [ POINTER(c_int), POINTER(c_short) ]
        self.lib.ofmarkerartist_create.argtypes                   = [ name ]
        self.lib.ofmarkerartist_setxdata.argtypes                 = [ POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_double) ]
        self.lib.ofmarkerartist_setydata.argtypes                 = [ POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_double) ]
        self.lib.ofmarkerartist_setzdata.argtypes                 = [ POINTER(c_int), POINTER(c_int), POINTER(c_int), POINTER(c_double) ]
        self.lib.ofmarkerartist_setmarkers.argtypes               = [ POINTER(c_int) ]
        self.lib.ofmarkerartist_setmarkercolor.argtypes           = [ POINTER(c_int), POINTER(c_float), POINTER(c_float), POINTER(c_float) ]
        self.lib.ofmarkerartist_setmarkerimage.argtypes           = [ fname ]
        self.lib.ofmarkerartist_setmarkershader.argtypes          = [ fname ]
        self.lib.ofmarkerartist_setintermediatetype.argtypes      = [ POINTER(c_int) ]
        self.lib.ofmarkerartist_setintermediatespacing.argtypes   = [ POINTER(c_double) ]
        self.lib.ofmarkerartist_setintermediatedirection.argtypes = [ POINTER(c_int) ]
        self.lib.ofmarkerartist_setmarkersize.argtypes            = [ POINTER(c_int) ]
        self.lib.ofmarkerartist_setautoattenuate.argtypes         = [ POINTER(c_bool) ]
        self.lib.ofview_activate.argtypes                         = [ name ]
        self.lib.ofview_create.argtypes                           = [ name ]
        self.lib.ofview_setorthographic.argtypes                  = [ POINTER(c_double), POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.ofview_setperspective.argtypes                   = [ POINTER(c_double), POINTER(c_double) ]
        self.lib.ofview_setviewframe.argtypes                     = [ root, frame ]
        self.lib.ofview_setviewbetweenframes.argtypes             = [ root, srcframe, dstframe, POINTER(c_int), POINTER(c_int) ]
        self.lib.ofview_setdefaultviewdistance.argtypes           = [ POINTER(c_double) ]
        self.lib.ofview_gettrackball.argtypes                     = [ POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.ofview_settrackball.argtypes                     = [ POINTER(c_double), POINTER(c_double), POINTER(c_double) ]
        self.lib.ofview_isvalid.argtypes                          = [ POINTER(c_bool) ]
        self.lib.ofview_reset.argtypes                            = [ ]

    def of_initialize(self):
        self.lib.of_initialize()

    def of_cleanup(self):
        self.lib.of_cleanup()

    def of_getreturnedvalue(self):
        val = c_int(0)
        self.lib.of_getreturnedvalue(POINTER(val))
        return val.value

    def of_adddatafilepath(self):
        pass

    def ofwin_activate(self):
        pass

    def ofwin_getid(self):
        pass

    def ofwin_createproxy(self):
        pass

    def ofwin_setwindowname(self):
        pass

    def ofwin_setgridsize(self):
        pass

    def ofwin_setkeypresscallback(self):
        pass

    def ofwin_setmousemotioncallback(self):
        pass

    def ofwin_setbuttonpresscallback(self):
        pass

    def ofwin_setbuttonreleasecallback(self):
        pass

    def ofwin_start(self):
        pass

    def ofwin_stop(self):
        pass

    def ofwin_waitforstop(self):
        pass

    def ofwin_signalstop(self):
        pass

    def ofwin_pauseanimation(self):
        pass

    def ofwin_isrunning(self):
        pass

    def ofwin_setscene(self):
        pass

    def ofwin_settime(self):
        pass

    def ofwin_gettime(self):
        pass

    def ofwin_pausetime(self):
        pass

    def ofwin_istimepaused(self):
        pass

    def ofwin_settimescale(self):
        pass

    def ofwin_gettimescale(self):
        pass

    def ofwin_setlightambient(self):
        pass

    def ofwin_setlightdiffuse(self):
        pass

    def ofwin_setlightspecular(self):
        pass

    def ofwin_setlightposition(self):
        pass

    def ofwin_setstereo(self):
        pass

    def ofwin_setbackgroundcolor(self):
        pass

    def ofwin_setbackgroundtexture(self):
        pass

    def ofwin_setbackgroundstardata(self):
        pass

    def ofwin_enablehudtext(self):
        pass

    def ofwin_sethudtextfont(self):
        pass

    def ofwin_sethudtextparameters(self):
        pass

    def ofwin_sethudtextposition(self):
        pass

    def ofwin_sethudtext(self):
        pass

    def ofwin_setdesiredframerate(self):
        pass

    def ofwin_addview(self):
        pass

    def ofwin_removeview(self):
        pass

    def ofwin_removeallviews(self):
        pass

    def ofwin_selectview(self):
        pass

    def ofwin_setswapbuffersfunction(self):
        pass

    def ofwin_setmakecurrentfunction(self):
        pass

    def ofwin_setupdatecontextfunction(self):
        pass

    def ofwin_resizewindow(self):
        pass

    def ofwin_keypress(self):
        pass

    def ofwin_keyrelease(self):
        pass

    def ofwin_buttonpress(self):
        pass

    def ofwin_buttonrelease(self):
        pass

    def ofwin_mousemotion(self):
        pass

    def ofwin_capturewindow(self):
        pass

    def ofwin_setwindowcapturefile(self):
        pass

    def ofwin_setwindowcapturekey(self):
        pass

    def offm_activate(self):
        pass

    def offm_create(self):
        pass

    def offm_setframe(self):
        pass

    def offm_lock(self):
        pass

    def offm_unlock(self):
        pass

    def offrame_activate(self):
        pass

    def offrame_create(self):
        pass

    def offrame_setcolor(self):
        pass

    def offrame_addchild(self):
        pass

    def offrame_removechild(self):
        pass

    def offrame_removeallchildren(self):
        pass

    def offrame_getnumchildren(self):
        pass

    def offrame_setposition(self):
        pass

    def offrame_getposition(self):
        pass

    def offrame_setattitude(self):
        pass

    def offrame_getattitude(self):
        pass

    def offrame_showaxes(self):
        pass

    def offrame_shownamelabel(self):
        pass

    def offrame_showaxeslabels(self):
        pass

    def offrame_setnamelabel(self):
        pass

    def offrame_setlabelfont(self):
        pass

    def offrame_setlabelsize(self):
        pass

    def offrame_setaxeslabels(self):
        pass

    def offrame_movexaxis(self):
        pass

    def offrame_moveyaxis(self):
        pass

    def offrame_movezaxis(self):
        pass

    def offrame_setlightsourceenabled(self):
        pass

    def offrame_getlightsourceenabled(self):
        pass

    def offrame_setlightambient(self):
        pass

    def offrame_setlightdiffuse(self):
        pass

    def offrame_setlightspecular(self):
        pass

    def offrame_followtrajectory(self):
        pass

    def offrame_followtype(self):
        pass

    def offrame_followposition(self):
        pass

    def offrame_printframestring(self):
        pass

    def ofsphere_create(self):
        pass

    def ofsphere_setradius(self):
        pass

    def ofsphere_settexturemap(self):
        pass

    def ofsphere_setnighttexturemap(self):
        pass

    def ofsphere_setautolod(self):
        pass

    def ofsphere_setsphereposition(self):
        pass

    def ofsphere_setsphereattitude(self):
        pass

    def ofsphere_setspherescale(self):
        pass

    def ofsphere_setmaterialambient(self):
        pass

    def ofsphere_setmaterialdiffuse(self):
        pass

    def ofsphere_setmaterialspecular(self):
        pass

    def ofsphere_setmaterialemission(self):
        pass

    def ofsphere_setmaterialshininess(self):
        pass

    def ofmodel_create(self):
        pass

    def ofmodel_setmodel(self):
        pass

    def ofmodel_setmodelposition(self):
        pass

    def ofmodel_getmodelposition(self):
        pass

    def ofmodel_setmodelscale(self):
        pass

    def ofmodel_getmodelscale(self):
        pass

    def ofmodel_setmodelpivot(self):
        pass

    def ofmodel_getmodelpivot(self):
        pass

    def ofmodel_getmodelsize(self):
        pass

    def ofdrawtraj_create(self):
        pass

    def ofdrawtraj_addartist(self):
        pass

    def ofdrawtraj_removeartist(self):
        pass

    def ofdrawtraj_removeallartists(self):
        pass

    def ofcoordaxes_create(self):
        pass

    def ofcoordaxes_setaxislength(self):
        pass

    def ofcoordaxes_setaxiswidth(self):
        pass

    def ofcoordaxes_setdrawaxes(self):
        pass

    def ofcoordaxes_settickspacing(self):
        pass

    def ofcoordaxes_setticksize(self):
        pass

    def ofcoordaxes_settickimage(self):
        pass

    def ofcoordaxes_settickshader(self):
        pass

    def oflatlongrid_create(self):
        pass

    def oflatlongrid_setparameters(self):
        pass

    def ofradialplane_create(self):
        pass

    def ofradialplane_setparameters(self):
        pass

    def ofradialplane_setplanecolor(self):
        pass

    def ofradialplane_setlinecolor(self):
        pass

    def oftraj_activate(self):
        pass

    def oftraj_create(self):
        pass

    def oftraj_setnumoptionals(self):
        pass

    def oftraj_setdof(self):
        pass

    def oftraj_addtime(self):
        pass

    def oftraj_addposition(self):
        pass

    def oftraj_addpositionvec(self):
        pass

    def oftraj_addattitude(self):
        pass

    def oftraj_addattitudevec(self):
        pass

    def oftraj_setoptional(self):
        pass

    def oftraj_setoptionalvec(self):
        pass

    def oftraj_clear(self):
        pass

    def oftraj_informartists(self):
        pass

    def oftraj_autoinformartists(self):
        pass

    def oftrajartist_activate(self):
        pass

    def oftrajartist_settrajectory(self):
        pass

    def ofcurveartist_create(self):
        pass

    def ofcurveartist_setxdata(self):
        pass

    def ofcurveartist_setydata(self):
        pass

    def ofcurveartist_setzdata(self):
        pass

    def ofcurveartist_setcolor(self):
        pass

    def ofcurveartist_setwidth(self):
        pass

    def ofcurveartist_setpattern(self):
        pass

    def ofsegmentartist_create(self):
        pass

    def ofsegmentartist_setstartxdata(self):
        pass

    def ofsegmentartist_setstartydata(self):
        pass

    def ofsegmentartist_setstartzdata(self):
        pass

    def ofsegmentartist_setendxdata(self):
        pass

    def ofsegmentartist_setendydata(self):
        pass

    def ofsegmentartist_setendzdata(self):
        pass

    def ofsegmentartist_setstride(self):
        pass

    def ofsegmentartist_setcolor(self):
        pass

    def ofsegmentartist_setwidth(self):
        pass

    def ofsegmentartist_setpattern(self):
        pass

    def ofmarkerartist_create(self):
        pass

    def ofmarkerartist_setxdata(self):
        pass

    def ofmarkerartist_setydata(self):
        pass

    def ofmarkerartist_setzdata(self):
        pass

    def ofmarkerartist_setmarkers(self):
        pass

    def ofmarkerartist_setmarkercolor(self):
        pass

    def ofmarkerartist_setmarkerimage(self):
        pass

    def ofmarkerartist_setmarkershader(self):
        pass

    def ofmarkerartist_setintermediatetype(self):
        pass

    def ofmarkerartist_setintermediatespacing(self):
        pass

    def ofmarkerartist_setintermediatedirection(self):
        pass

    def ofmarkerartist_setmarkersize(self):
        pass

    def ofmarkerartist_setautoattenuate(self):
        pass

    def ofview_activate(self):
        pass

    def ofview_create(self):
        pass

    def ofview_setorthographic(self):
        pass

    def ofview_setperspective(self):
        pass

    def ofview_setviewframe(self):
        pass

    def ofview_setviewbetweenframes(self):
        pass

    def ofview_setdefaultviewdistance(self):
        pass

    def ofview_gettrackball(self):
        pass

    def ofview_settrackball(self):
        pass

    def ofview_isvalid(self):
        pass

    def ofview_reset(self):
        pass
