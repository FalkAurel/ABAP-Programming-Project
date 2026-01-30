@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Restrict View Access'
@Metadata.allowExtensions: true
define view entity ZR_D_BOOKINGTP
  as select from ZI_D_BookingTP as Booking
    inner join   ZR_D_FLIGHTS   as Flights on  Flights.ConnectionId = Booking.ConnectionId // Fields that make up the primary key for Flights
                                           and Flights.CarrierId    = Booking.CarrierId
                                           and Flights.FlightDate   = Booking.FlightDate
  association        to parent ZR_D_CustomerTP as _Customer    on _Customer.CustomerId = $projection.CustomerId
  association [0..*] to ZR_D_SUPPLEMENT        as _Supplements on _Supplements.BookingID = $projection.BookingId
{
  key Booking.TravelId,
  key Booking.BookingId,
      Booking.BookingDate,
      Booking.CustomerId,
      Booking.CarrierId,
      Flights.AirlineName,
      Booking.ConnectionId,
      Booking.FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Booking.FlightPrice,
      Booking.CurrencyCode,

      Flights.ImageUrl      as ImageUrl,
      Flights.PlaneTypeId   as PlaneTypeId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Flights.Price         as TicketPrice, // Retailing price
      Flights.OccupancyRate as OccupancyRate,
      Flights.SeatsMax      as SeatsMax,
      Flights.SeatsOccupied as SeatsOccupied,
      Flights.AirportFromId as AirportFromId,
      Flights.AirportToId   as AirportToId,
      Flights.ArrivalTime   as ArriavalTime,
      Flights.DepatureTime  as DepatureTime,

      /* Expose association */
      _Customer,
      _Supplements
}
