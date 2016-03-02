#Versions

* **1.0**: Initial release
* **1.0.1**: Enhancements to providers, encounters, and medications

#1.0.1

[Commits](https://github.com/ewhitley/CDAKit/compare/1.0.1...1.0)


##Changes

###Globals

*  in anticipation of future changes and probable removal, the cross-record public `allProviders` member has been made internal

###Allergies
*  `reaction` and `severity`  changed to a new structure - `CDAKEntryDetail` as it must also capture additional data like times and identifiers (not just codes).  Importer and models updated to reflect this change.

###Encounter

*  Now contains `indication` (CDAKEntry) for problem list entries that drive reason for encounter

###Medication

*  `indication` no longer a String. This was not really used by the importer/exporter, so it's being treated as a non-breaking change. `indication` is now a (CDAKEntryDetail) for more fully defined problem list entries that drive reason for encounter
*  Model and importer now supports `precondition` (CDAKCodedEntries) for capturing precondition supporting reason for medication (template OID: 2.16.840.1.113883.10.20.22.4.25)
*  `reaction` changed to a new structure - `CDAKEntryDetail` as it must also capture additional data like times and identifiers (not just codes).  Importer and models updated to reflect this change.
*  Added `severity`  to model, importer, and exporter so it can be used with `reaction`

###Person

*  `Title` element removed and replaced with `Prefix` and `Suffix` to more closely model CDA and allow for both prefix and suffix (as opposed to a single combined title)
*  Importers updated to reflect changes to `Title` and introduce `Prefix` and `Suffix`

###Provider

*  Updated model and importer to support `functionCode` (Provider Role like "Primary Care Provider")

###Person import - addresses and phone numbers

*  The original Ruby HDS created "empty" addresses and telecoms even if all fields were empty. This results in an "invalid" address or telecom - it exists, but no member properties are populated.  The import process has been changed to avoid creating these "empty" entries and treat the members as nil optionals to better reflect their actual state.

###Provider import

*  The Ruby HDS approach to managing providers during import has been changed slightly (in anticipation of future changes and to fix some things). Provider matching has been changed to loosen provider matching criteria and promote more frequent provider creation.


###C32 and C-CDA XML Generation

* Person / Provider `Title` references replaced with `Prefix` and `Suffix` values
* Result values moved to dedicated `values` (format_values.format, etc.) template to improve reusability
* Providers (aka: performer) from `CDAKProviderPerformances` now placed in `documentationOf` XML during output
* `Performer` template updated to display `code` (provider specialty)
* `Performer` template updated to allow for incorporation into `documentationOf` which contains additional elements for `time` and `functionCode`
* Fix to `format_code_with_reference.format` to remove some translation code duplication
* New C32 and C-CDA template `format_indication.format` for `indication` (entry detail problem on some entries like `encounter` and `medication`) display
* New C-CDA template `format_medication_precondition.format` for `precondition` (Precondition for Substance Administration) display
* New C-CDA templates for `reaction` and `severity` applied to allergy and medication
* C-CDA medication now exports `vehicle`
* C-CDA and C32 medication now exports `routeCode`
* C-CDA and C32 medication now exports `doseQuantity` , `rateQuantity`, and `maxDoseQuantity` (using new embedded `ccda_medication_dose.ccda` template)
* C-CDA and C32 medication now exports `effectiveTime(2)` including `institutionSpecified` and `period` for schedule of administration (timing, frequency, interval, duration)
* Minor changes in CDAKEntry MustacheBox values and some filters to handle issues where child Entry's members were nil, so Mustache was (correctly) kicking up to the parent element - which resulted in undesired (parent) data being rendered in the child entry.

