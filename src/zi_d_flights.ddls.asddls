@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight Interface'
@Metadata.allowExtensions
define view entity ZI_D_Flights
  as select from /dmo/flight         as Flight
    inner join   /dmo/connection     as Connection on  Connection.carrier_id    = Flight.carrier_id
                                                   and Connection.connection_id = Flight.connection_id
{
  key Flight.carrier_id          as CarrierId,
  key Flight.connection_id       as ConnectionId,
  key Flight.flight_date         as FlightDate,
      Flight.price               as Price,
      Flight.currency_code       as CurrencyCode,
      Flight.plane_type_id       as PlaneTypeId,
      Flight.seats_max           as SeatsMax,
      Flight.seats_occupied      as SeatsOccupied,
      Connection.airport_from_id as AirportFromId,
      Connection.airport_to_id   as AirportToId,
      Connection.departure_time  as DepatureTime,
      Connection.arrival_time    as ArrivalTime
}
