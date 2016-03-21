*&---------------------------------------------------------------------*
*&  How do I add a feature with Test-Driven Development in ABAP?
*&    based on Working Effectively with Legacy Code: Chapter 8
*&---------------------------------------------------------------------*
REPORT yy_pao_chapter08_tdd_test0.

*& Production Code
CLASS lcl_instrument_calculator DEFINITION.
  PUBLIC SECTION.
    METHODS:
      add_element
        IMPORTING iv_element      TYPE f.

  PRIVATE SECTION.
    DATA:
      mt_elements TYPE STANDARD TABLE OF f WITH EMPTY KEY.
  "...
ENDCLASS.

CLASS lcl_instrument_calculator IMPLEMENTATION.

  METHOD add_element.
    APPEND iv_element TO mt_elements.
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
ENDCLASS.

CLASS ltc_test_suite IMPLEMENTATION.

ENDCLASS.
