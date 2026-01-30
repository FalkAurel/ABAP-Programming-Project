@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface to Supplements'
@Metadata.allowExtensions: true
define view entity ZC_D_Supplements as select from ZR_D_SUPPLEMENT
{
  key SupplementId,
  key BookingID,
  SupplementCategory,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  Price,
  CurrencyCode,
  Descritpion
}
