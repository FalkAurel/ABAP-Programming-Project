@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BO Projection view on Customer'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_D_Customer provider contract transactional_query
 as projection on ZR_D_CustomerTP
{
  key CustomerId,
  FirstName,
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.7
  LastName,
  Title,
  Street,
  PostalCode,
  City,
  CountryCode,
  PhoneNumber,
  EmailAddress,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt,
  FullName,
  
  /* Associations */
  
  _Bookings : redirected to composition child ZC_D_Booking
}
