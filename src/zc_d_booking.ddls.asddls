@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Consumption view for Bookings'
@Metadata.allowExtensions

define view entity ZC_D_Booking
  as projection on ZR_D_BOOKINGTP
{
  key TravelId,
  key BookingId,

      BookingDate,
      CustomerId,
      @ObjectModel.text.element: [ 'AirlineName' ]
      CarrierId,
      AirlineName,

      @Consumption.valueHelpDefinition: [ { entity: { name: '/DMO/I_Connection_StdVH', element: 'ConnectionID' } } ]
      ConnectionId,

      FlightDate,
      FlightPrice,
      CurrencyCode,
      PlaneTypeId,
      TicketPrice,
      OccupancyRate,
      SeatsMax,
      SeatsOccupied,
      ImageUrl,
      

      AirportFromId,
      AirportToId,

      ArriavalTime,
      DepatureTime,

      /* Associations */
      _Supplements,
      _Customer : redirected to parent ZC_D_Customer
}
