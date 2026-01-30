@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Restricted Access Interface'
define view entity ZR_D_SUPPLEMENT as select from ZI_D_Supplement
{
  key SupplementId,
  key BookingID,
  SupplementCategory,
  Price,
  CurrencyCode,
  Descritpion,
  TravelId
}
