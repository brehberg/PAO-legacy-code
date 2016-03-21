*&---------------------------------------------------------------------*
*&  How do I add a feature with Test-Driven Development in ABAP?
*&    based on Working Effectively with Legacy Code: Chapter 8
*&---------------------------------------------------------------------*
REPORT yy_pao_chapter08_tdd_test2.

*& Production Code
CLASS lcx_invalid_basis_exception DEFINITION
  INHERITING FROM cx_dynamic_check.
ENDCLASS.

CLASS lcl_instrument_calculator DEFINITION.
  PUBLIC SECTION.
    METHODS:
      add_element
        IMPORTING iv_element      TYPE f,
      first_moment_about
        IMPORTING iv_point        TYPE f
        RETURNING VALUE(rv_value) TYPE f
        RAISING lcx_invalid_basis_exception.

  PRIVATE SECTION.
    DATA:
      mt_elements TYPE STANDARD TABLE OF f WITH EMPTY KEY.
  "...
ENDCLASS.

CLASS lcl_instrument_calculator IMPLEMENTATION.

  METHOD add_element.
    APPEND iv_element TO mt_elements.
  ENDMETHOD.

  METHOD first_moment_about.
    IF lines( mt_elements ) = 0.
      RAISE EXCEPTION TYPE lcx_invalid_basis_exception.
    ENDIF.

    DATA(lv_numerator) = VALUE f( ).
    LOOP AT mt_elements INTO DATA(lv_element).
      lv_numerator = lv_numerator + lv_element - iv_point.
    ENDLOOP.
    rv_value = lv_numerator / lines( mt_elements ).
  ENDMETHOD.
  "...
ENDCLASS.


*& Test Code
CLASS ltc_test_suite DEFINITION
  INHERITING FROM cl_aunit_assert
  FOR TESTING RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CONSTANTS:
      tolerance TYPE f VALUE '0.001'.
    METHODS:
      test_first_moment FOR TESTING,
      test_first_moment_exception FOR TESTING.
ENDCLASS.

CLASS ltc_test_suite IMPLEMENTATION.

  METHOD test_first_moment.
    DATA(lo_calculator) = NEW lcl_instrument_calculator( ).
    lo_calculator->add_element( '1.0' ).
    lo_calculator->add_element( '2.0' ).

    assert_equals( exp = '-0.5'
                   act = lo_calculator->first_moment_about( '2.0' )
                   tol = tolerance ).
  ENDMETHOD.

  METHOD test_first_moment_exception.
    TRY.
      DATA(lv_value) = NEW lcl_instrument_calculator( )->first_moment_about( '0.0' ).
      fail( |expected LCX_INVALID_BASIS_EXCEPTION| ).
    CATCH lcx_invalid_basis_exception.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
