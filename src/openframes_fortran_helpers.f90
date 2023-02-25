!****************************************************************************************************
!>
!  Helper functions for Fortran/C interfacing
!
!### Author
!  * Jacob Williams, 9/9/2018

    module openframes_fortran_helpers

    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env

    implicit none

    interface to_c
        !! convert fortran variables to C variables.
        module procedure :: fortran_str_to_c,&
                            fortran_logical_to_c,&
                            fortran_int_to_c,&
                            fortran_int16_to_c,&
                            fortran_double_to_c,&
                            fortran_float_to_c
    end interface to_c
    public :: to_c

    interface to_f
        !! convert C variables to fortran variables
        module procedure :: c_int_to_fortran,&
                            c_shortint_to_fortran,&
                            c_double_to_fortran,&
                            c_float_to_fortran,&
                            c_logical_to_fortran
    end interface to_f
    public :: to_f

    contains
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
    end module openframes_fortran_helpers
!****************************************************************************************************