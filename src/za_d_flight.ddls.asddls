@EndUserText.label: 'Abstract View for Flights'
@Metadata.allowExtensions: true
define abstract entity ZA_D_Flight
{
    @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Carrier_StdVH', element: 'AirlineID' } }]
    CarrierID: /dmo/carrier_id;
    @Consumption.valueHelpDefinition: [ { entity: { name: '/DMO/I_Connection_StdVH', element: 'ConnectionID' } } ]
    ConnectionID: /dmo/connection_id;
    FlightDate: /dmo/flight_date;
    TravelID: /dmo/travel_id;
}
