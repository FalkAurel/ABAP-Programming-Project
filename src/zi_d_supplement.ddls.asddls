@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplement/Food Interface'
define view entity ZI_D_Supplement as select distinct from /dmo/supplement as Supplements
inner join /dmo/suppl_text as SupplText on SupplText.supplement_id = Supplements.supplement_id
inner join /dmo/book_suppl as BookSuppl on BookSuppl.supplement_id = Supplements.supplement_id
inner join /dmo/travel as Travel on Travel.travel_id = BookSuppl.travel_id

{
  key Supplements.supplement_id as SupplementId,
  key BookSuppl.booking_id as BookingID,
  Supplements.supplement_category as SupplementCategory,
  Supplements.price as Price,
  Supplements.currency_code as CurrencyCode,
  SupplText.description as Descritpion,
  Travel.travel_id as TravelId
} where Supplements.supplement_category = 'BV' or Supplements.supplement_category = 'ML'
