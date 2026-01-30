@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Restricted Access Interface'
@Metadata.allowExtensions
define view entity ZR_D_FLIGHTS
  as select from ZI_D_Flights as Flights
  inner join /DMO/I_Carrier_StdVH as ValueHelp on ValueHelp.AirlineID = Flights.CarrierId
{
  key Flights.CarrierId,
  key Flights.ConnectionId,
  key Flights.FlightDate,
      Flights.Price,
      Flights.CurrencyCode,
      Flights.PlaneTypeId,
      Flights.SeatsMax,
      Flights.SeatsOccupied,
      Flights.AirportFromId,
      Flights.AirportToId,
      Flights.DepatureTime,
      Flights.ArrivalTime,
      ValueHelp.Name as AirlineName,
      
      @EndUserText.label: 'Occupancy Rate'
      concat(cast(cast(
        case
          when Flights.SeatsMax = 0 then 0
          else (Flights.SeatsOccupied * 100) / Flights.SeatsMax
        end
        as abap.dec(12,2)
      ) as abap.char( 22 )), '%') as OccupancyRate,
      
      
      @Semantics.imageUrl: true
      case Flights.CarrierId
        when 'LH' then 'https://companieslogo.com/img/orig/LHA.DE-909aa95f.png'
        when 'AA' then 'https://companieslogo.com/img/orig/AAL-dfaff49c.png'
        when 'AC' then 'https://companieslogo.com/img/orig/AC.TO-01622528.png'
        when 'AF' then 'https://www.frankfurt-airport.com/content/dam/fraport-travel/airport/fl%C3%BCge-und-airlines/airlines/airline-icons_1_1/AF_Air%20France1.png/_jcr_content/renditions/original./AF_Air%20France1.png%27'
        when 'AZ' then 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2UanEQ47KW6EYq40iF98C30L7w3uOTp50fg&s'
        when 'BA' then 'https://img.icons8.com/color/1200/british-airways.jpg'
        when 'CO' then 'https://annerowlingclinic.org/sites/default/files/styles/simplecroparticle/public/upload/images/COBALT%20750x500.png%27'
        when 'DL' then 'https://companieslogo.com/img/orig/DAL-3ea1d23b.png'
        when 'NG' then 'https://www.ch-aviation.com/images/stockPhotos/6086/4a22b5bfef9c8a0d0b960381944a9b742c107022.png'
        when 'JL' then 'https://substackcdn.com/image/fetch/$s_!wOOq!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fcd66df65-d354-4519-a423-ab11093c3c89_1000x1000.jpeg'
        when 'QF' then 'https://images.seeklogo.com/logo-png/32/1/qantas-logo-png_seeklogo-326607.png'
        when 'SA' then 'https://cdn.freebiesupply.com/logos/large/2x/south-african-airways-logo-png-transparent.png'
        when 'SQ' then 'https://companieslogo.com/img/orig/C6L.SI-4461b2e9.png'
        when 'SR' then 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTn9RizXaD5Wp4AqSYwIOKEihY2XJ2gtVPxaA&s'
        when 'UA' then 'https://img.icons8.com/color/1200/United-Airlines.jpg'
        else 'https://www.youtube.com/watch?v=i6CrbqeksJ8'
      end                                        as ImageUrl
 
}
