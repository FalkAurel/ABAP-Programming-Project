@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Restricted Access Customers'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZR_D_CustomerTP
  as select from ZI_D_CustomersTP
    composition [0..*] of ZR_D_BOOKINGTP as _Bookings
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
  
  concat_with_space(FirstName, LastName, 1) as FullName,

  _Bookings
}
