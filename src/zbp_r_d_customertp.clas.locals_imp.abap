CLASS lhc_ZR_D_CustomerTP DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ZR_D_CustomerTP RESULT result.
    METHODS createbooking FOR MODIFY
      IMPORTING keys FOR ACTION zr_d_customertp~createbooking.

ENDCLASS.

CLASS lhc_ZR_D_CustomerTP IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD createBooking.
    DATA new_bookings  TYPE TABLE FOR CREATE ZR_D_CustomerTP\_Bookings.

    DATA carrier_id    TYPE /dmo/carrier_id.
    DATA connection_id TYPE /dmo/connection_id.
    DATA flight_date   TYPE /dmo/flight_date.

    LOOP AT keys INTO DATA(key).
      carrier_id = key-%param-CarrierID.
      connection_id = key-%param-ConnectionID.
      flight_date = key-%param-FlightDate.
    ENDLOOP.

    SELECT SINGLE FROM /dmo/flight
      FIELDS *
      WHERE carrier_id = @carrier_id AND connection_id = @connection_id AND flight_date = @flight_date
      INTO @DATA(flight_information).

    SELECT FROM /dmo/booking
      FIELDS MAX( booking_id ) AS max_booking_id
      INTO @DATA(max_booking_id).

    IF flight_information IS INITIAL OR max_booking_id IS INITIAL.
      RETURN.
    ENDIF.

    max_booking_id += 1.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA occupancy_rate TYPE p LENGTH 12 DECIMALS 2.

    IF flight_information-seats_max = 0.
      occupancy_rate = 0.
    ELSE.
      occupancy_rate = flight_information-seats_occupied * 100 / flight_information-seats_max.
    ENDIF.

    SELECT SINGLE FROM /dmo/connection
      FIELDS airport_from_id, airport_to_id, arrival_time, departure_time
      WHERE connection_id = @connection_id AND carrier_id = @carrier_id
      INTO @DATA(connection_information).

    IF connection_information IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT keys INTO key.

      APPEND VALUE #( %tky    = key-%key
                      %target = VALUE #( ( CarrierID    = carrier_id
                                           FlightDate   = flight_date
                                           FlightPrice  = flight_information-price
                                           TravelId     = key-%param-TravelID
                                           CurrencyCode = flight_information-currency_code
                                           ConnectionID = flight_information-connection_id
                                           CustomerId   = key-%key
                                           BookingDate  = sy-datlo
                                           BookingId    = max_booking_id ) ) )
             TO new_bookings.

    ENDLOOP.

   SELECT SINGLE FROM /dmo/flight
        FIELDS *
        WHERE carrier_id = @carrier_id AND flight_date = @flight_date AND connection_id = @connection_id
        INTO @DATA(flight).

      IF flight-seats_max = flight-seats_occupied.
        RETURN.
        " TODO raise error
      ENDIF.


      flight-seats_occupied += 1.
      UPDATE /dmo/flight FROM @flight.

    MODIFY ENTITIES OF ZR_D_CustomerTP IN LOCAL MODE
           ENTITY ZR_D_CustomerTP
           CREATE BY \_Bookings AUTO FILL CID FIELDS (
           BookingDate
           BookingId
           CarrierId
           ConnectionId
           CurrencyCode
           CustomerID
           FlightDate
           FlightPrice
           TravelId )
           WITH new_bookings.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZR_D_BOOKINGTP DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_d_bookingtp RESULT result.

*    METHODS update_seats_occupied FOR DETERMINE ON SAVE
*      IMPORTING keys FOR zr_d_bookingtp~update_seats_occupied.
    METHODS remove FOR MODIFY
      IMPORTING keys FOR ACTION zr_d_bookingtp~remove.
    METHODS add_metadata FOR DETERMINE ON SAVE
      IMPORTING keys FOR zr_d_bookingtp~add_metadata.

ENDCLASS.

CLASS lhc_ZR_D_BOOKINGTP IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD update_seats_occupied.
*    READ ENTITIES OF ZR_D_CustomerTP IN LOCAL MODE
*
*         ENTITY zr_d_bookingtp
*         FIELDS ( CarrierId FlightDate ConnectionId )
*         WITH CORRESPONDING #( keys )
*         RESULT DATA(bookings).
*
*    LOOP AT bookings INTO DATA(booking).
*      SELECT SINGLE FROM /dmo/flight
*        FIELDS *
*        WHERE carrier_id = @booking-CarrierId AND flight_date = @booking-FlightDate AND connection_id = @booking-ConnectionId
*        INTO @DATA(flight).
*
*      IF flight-seats_max = flight-seats_occupied.
*        " TODO raise error
*      ENDIF.
*
*
*      flight-seats_occupied += 1.
*      UPDATE /dmo/flight FROM @flight.
*
*    ENDLOOP.
*  ENDMETHOD.

  METHOD remove.
    READ ENTITIES OF ZR_D_CustomerTP IN LOCAL MODE

         ENTITY zr_d_bookingtp
         FIELDS ( CarrierId FlightDate ConnectionId )
         WITH CORRESPONDING #( keys )
         RESULT DATA(bookings).

    LOOP AT bookings INTO DATA(booking).
      SELECT SINGLE FROM /dmo/flight
        FIELDS *
        WHERE carrier_id = @booking-CarrierId AND flight_date = @booking-FlightDate AND connection_id = @booking-ConnectionId
        INTO @DATA(flight).

      IF flight-seats_max = flight-seats_occupied.
        " TODO raise error
      ENDIF.

      flight-seats_occupied -= 1.
      UPDATE /dmo/flight FROM @flight.

    ENDLOOP.

    MODIFY ENTITIES OF ZR_D_CustomerTP IN LOCAL MODE
           ENTITY zr_d_bookingtp
           DELETE FROM CORRESPONDING #( keys ).
  ENDMETHOD.

*  METHOD current_date.
*    READ ENTITIES OF ZR_D_CustomerTP IN LOCAL MODE
*      ENTITY zr_d_bookingtp FIELDS ( BookingDate )
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(entities).
*
*
*      LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
*        <entity>-BookingDate = sy-datlo.
*      ENDLOOP.
*
*
*    MODIFY ENTITIES OF ZR_D_CustomerTP IN LOCAL MODE
*      ENTITY zr_d_bookingtp UPDATE FIELDS ( BookingDate )
*      WITH VALUE #( FOR entity IN entities ( %tky = entity-%tky BookingDate = entity-BookingDate ) ).
*  ENDMETHOD.


  METHOD add_metadata.
    READ ENTITIES OF ZR_D_CustomerTP IN LOCAL MODE
         ENTITY zr_d_bookingtp
         FIELDS ( BookingDate )
         WITH CORRESPONDING #( keys )
         RESULT DATA(bookings).

    LOOP AT bookings ASSIGNING FIELD-SYMBOL(<booking>).
      <booking>-BookingDate = sy-datlo.
      " Optionally, collect for persistence update here
    ENDLOOP.
    MODIFY ENTITIES OF ZR_D_CustomerTP IN LOCAL MODE
           ENTITY zr_d_bookingtp
           UPDATE FIELDS ( BookingDate )
           WITH VALUE #( ( %tky        = <booking>-%key
                           BookingDate = <booking>-BookingDate ) ).
  ENDMETHOD.
ENDCLASS.
