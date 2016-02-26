//
//  CDAKVocabularyStructs.swift
//  CDAKit
//
//  Created by Eric Whitley on 2/19/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

//comprehensive HL7 FHIR reference list here: https://www.hl7.org/fhir/terminologies-v3.html

/**
 Contains commonly referenced keys you may use in value sets
 
 These keys are used to look up specific HL7 OIDs, so it's important they be used consistently
 */
public struct CDAKVocabularyKeys {
  /// Logical Observation Identifiers Names and Codes. Created and managed by the Regenstrief Institute, Inc.
  public static let LOINC = "LOINC"
  /// SNOMED-CT, Systematized Nomenclature of Clinical Terms. Created by the College of American Pathologists (CAP) and now managed by the International Health Terminology Standards Development Organisation  (IHTSDO)
  public static let SNOMEDCT = "SNOMED-CT"
  /// Current Procedural Terminology
  public static let CPT = "CPT"
  /// RxNorm. Medications (brand and generic), ingredients, packaging, and more. Managed by the National Library of Medicine (NLM)
  public static let RxNorm = "RxNorm"
  /// ICD-9-CM. International Classification of Diseases, Ninth Revision, Clinical Modification
  public static let ICD9CM = "ICD-9-CM"
  /// ICD-9-PCS. International Classification of Diseases, Ninth Revision, Procedure Coding System
  public static let ICD9PCS = "ICD-9-PCS"
  /// ICD-10-PCS. International Classification of Diseases, Tenth Revision, Procedure Coding System
  public static let ICD10PCS = "ICD-10-PCS"
  /// ICD-10-CM. International Classification of Diseases, Tenth Revision, Clinical Modification
  public static let ICD10CM = "ICD-10-CM"
  /// HCP. HCFA Common Procedure Coding System
  public static let HCP = "HCP"
  /// HCPCS. Healthcare Common Procedure Coding System
  public static let HCPCS = "HCPCS"
  /// HL7 Marital Status
  public static let HL7MaritalStatus = "HL7 Marital Status"
  /// CVX. Vaccine administered
  public static let CVX = "CVX"
  /// HITSP C80 Observation Status
  public static let HITSPC80ObservationStatus = "HITSP C80 Observation Status"
  /// NCI Thesaurus
  public static let NCIThesaurus = "NCI Thesaurus"
  /// FDA. Concepts specific to the US Food and Drug Administration.
  public static let FDA = "FDA"
  /// UNII. Unique Ingredient Identifier. Unique identifiers for active drug ingredient. Managed by the US Food and Drug Administration (FDA).
  public static let UNII = "UNII"
  /// NDC. National Drug Codes.
  public static let NDC = "NDC"
  /// HL7 ActStatus
  public static let HL7ActStatus = "HL7 ActStatus"
  /// HL7 Healthcare Service Location
  public static let HL7HealthcareServiceLocation = "HL7 Healthcare Service Location"
  /// HL7 Discharge Disposition
  public static let DischargeDisposition = "DischargeDisposition"
  /// HL7 Act Code
  public static let HL7ActCode = "HL7 Act Code"
  /// HL7 Relationship Code
  public static let HL7RelationshipCode = "HL7 Relationship Code"
  /// CDC Race
  public static let CDCRace = "CDC Race"
  /// NLM MeSH
  public static let NLMMeSH = "NLM MeSH"
  /// Religious Affiliation
  public static let ReligiousAffiliation = "Religious Affiliation"
  /// HL7 No Immunization Reason Value Set. This identifies the reason why the immunization did not occur.
  public static let HL7ActNoImmunicationReason = "HL7 ActNoImmunicationReason"
  /// NUBC. National Uniform Billing Committee (NUBC)
  public static let NUBC = "NUBC"
  /// HL7 Observation Interpretation
  public static let HL7ObservationInterpretation = "HL7 Observation Interpretation"
  /// Source of Payment Typology
  public static let SourceofPaymentTypology = "Source of Payment Typology"
  /// CDT. American Dental Association's Current Dental Terminology 2 (CDT-2)
  public static let CDT = "CDT"
  /// HL7 Administrative Sex
  public static let AdministrativeSex = "AdministrativeSex"
  /// HL7 RouteOfAdministration
  public static let HL7RouteOfAdministration = "HL7 RouteOfAdministration"
  // FDA SPL. Alias for NCIThesaurus
  //public static let NCIThesaurus = "FDA SPL"
  //NOTE: not including FDA SPL - the original Ruby says this is an alias of NCI Thesaurus
  // HSLOC. Alias for HL7HealthcareServiceLocation
  //public static let HL7HealthcareServiceLocation = "HSLOC"
  //NOTE: duplicate from code_system_helper aliases - may need to determine if one version is preferred
  /// SOP. Source Of Payment Typology
  public static let SourceOfPaymentTypology = "SOP"
}

/**
 Provides lists of fixed string constants you may wish to use for a specific type of CDA attribute
 */
public struct CDAKConceptHelpers {
  
  /**
   HL7 Address Use codes
   [Reference](https://www.hl7.org/fhir/v3/AddressUse/index.html)
   */
  public struct HL7AddressUse {
    //Description: Address uses that can apply to both postal and telecommunication addresses.
    public struct _GeneralAddressUse {
      /// bad address - Description: A flag indicating that the address is bad, in fact, useless.
      public static let BAD = "BAD"
      /// confidential address - Description: Indicates that the address is considered sensitive and should only be shared or published in accordance with organizational controls governing patient demographic information with increased sensitivity. Uses of Addresses. Lloyd to supply more complete description.
      public static let CONF = "CONF"
      /// home address - Description: A communication address at a home, attempted contacts for business purposes might intrude privacy and chances are one will contact family or other household members instead of the person one wishes to call. Typically used with urgent cases, or if no other contacts are available.
      public static let H = "H"
      /// primary home - Description: The primary home, to reach a person after business hours.
      public static let HP = "HP"
      /// vacation home - Description: A vacation home, to reach a person while on vacation.
      public static let HV = "HV"
      /// no longer in use - This address is no longer in use. Usage Note: Address may also carry valid time ranges. This code is used to cover the situations where it is known that the address is no longer valid, but no particular time range for its use is known.
      public static let OLD = "OLD"
      /// temporary address - Description: A temporary address, may be good for visit or mailing. Note that an address history can provide more detailed information.
      public static let TMP = "TMP"
      /// work place - Description: An office address. First choice for business related contacts during business hours.
      public static let WP = "WP"
      /// direct - Description: Indicates a work place address or telecommunication address that reaches the individual or organization directly without intermediaries. For phones, often referred to as a 'private line'.
      public static let DIR = "DIR"
      /// public - Description: Indicates a work place address or telecommunication address that is a 'standard' address which may reach a reception service, mail-room, or other intermediary prior to the target entity.
      public static let PUB = "PUB"
    }

    /// _PostalAddressUse - Description: Address uses that only apply to postal addresses, not telecommunication addresses.
    public struct _PostalAddressUse {
      /// physical visit address - Description: Used primarily to visit an address.
      public static let PHYS = "PHYS"
      /// postal address - Description: Used to send mail.
      public static let PST = "PST"
    }
    /// _TelecommunicationAddressUse - Description: Address uses that only apply to telecommunication addresses, not postal addresses.
    public struct _TelecommunicationAddressUse {
      /// answering service - Description: An automated answering machine used for less urgent cases and if the main purpose of contact is to leave a message or access an automated announcement.
      public static let AS = "AS"
      /// emergency contact - Description: A contact specifically designated to be used for emergencies. This is the first choice in emergencies, independent of any other use codes.
      public static let EC = "EC"
      /// mobile contact) - Description: A telecommunication device that moves and stays with its owner. May have characteristics of all other use codes, suitable for urgent matters, not the first choice for routine business.
      public static let MC = "MC"
      /// pager - Description: A paging device suitable to solicit a callback or to leave a very short message.
      public static let PG = "PG"
    }
  }
  /**
   HL7 Priority Codes
   Often used with CDA priority code
   [Reference](http://www.cdapro.com/know/25039)
   */
  public struct HL7PriorityCode {
    /// ASAP -
    public static let A = "A"
    /// Callback results -
    public static let CR = "CR"
    /// Callback for scheduling -
    public static let CS = "CS"
    /// Callback placer for scheduling -
    public static let CSP = "CSP"
    /// Contact recipient for scheduling -
    public static let CSR = "CSR"
    /// Elective -
    public static let EL = "EL"
    /// Emergency -
    public static let EM = "EM"
    /// Preoperative -
    public static let P = "P"
    /// As needed -
    public static let PRN = "PRN"
    /// Routine -
    public static let R = "R"
    /// Rush reporting -
    public static let RR = "RR"
    /// Stat -
    public static let S = "S"
    /// Timing critical -
    public static let T = "T"
    /// Use as directed -
    public static let UD = "UD"
    /// Urgent -
    public static let UR = "UR"
  }
  /**
   From CDAPro: "qualifies the timing and intent of the clinical act."
   [Reference](http://www.cdapro.com/know/25027)
   */
  public struct HL7MoodCode {
    /// The clinical statement/event already happened -
    public static let EVN = "EVN"
    /// The clinical statement is intended to happen in the future -
    public static let INT = "INT"
    /// The clinical statement is a request or order -
    public static let RQO = "RQO"
    /// The clinical statement is planned for a specific time/place (appointment) -
    public static let APT = "APT"
    /// The clinical statement is a request to book an appointment -
    public static let ARQ = "ARQ"
    /// The clinical statement is being proposed -
    public static let PRP = "PRP"
    /// The clinical statement is promised -
    public static let PRMS = "PRMS"
    /// The clinical statement is a definition/observation -
    public static let DEF = "DEF"
    /// The clinical statement is a goal/objective -
    public static let GOL = "GOL"
    /// The clinical statement is a pre-condition/criteria -
    public static let EVNCRT = "EVN.CRT"
  }
  /**
   HL7 Administrative Gender
   [Reference](https://www.hl7.org/fhir/v3/AdministrativeGender/index.html)
   */
  public struct HL7AdministrativeGender {
    ///Female
    public static let F = "Female"
    ///Male
    public static let M = "Male"
    ///The gender of a person could not be uniquely defined as male or female, such as hermaphrodite.
    public static let UN = "Undifferentiated"
  }
  
  
  /**
   "Codes representing the defined possible states of an Act, as defined by the Act class state machine."
   [Reference](https://www.hl7.org/fhir/v3/ActStatus/index.html)
  */
  public struct HL7ActStatus {
    /// normal - Encompasses the expected states of an Act, but excludes "nullified" and "obsolete" which represent unusual terminal states for the life-cycle.
    public static let normal = "normal"
    /// aborted - The Act has been terminated prior to the originally intended completion.
    public static let aborted = "aborted"
    /// active - The Act can be performed or is being performed
    public static let active = "active"
    /// cancelled - The Act has been abandoned before activation.
    public static let cancelled = "cancelled"
    /// completed - An Act that has terminated normally after all of its constituents have been performed.
    public static let completed = "completed"
    /// held - An Act that is still in the preparatory stages has been put aside. No action can occur until the Act is released.
    public static let held = "held"
    /// new - An Act that is in the preparatory stages and may not yet be acted upon
    public static let new = "new"
    /// suspended - An Act that has been activated (actions could or have been performed against it), but has been temporarily disabled. No further action should be taken against it until it is released
    public static let suspended = "suspended"
    /// nullified - This Act instance was created in error and has been 'removed' and is treated as though it never existed. A record is retained for audit purposes only.
    public static let nullified = "nullified"
    /// obsolete - This Act instance has been replaced by a new instance.
    public static let obsolete = "obsolete"
  }
  
  /**
   "An anatomical location on an organism which can be the focus of an act."
   [Reference](https://www.hl7.org/fhir/v3/ActSite/index.html)
   */
  public struct HL7ActSite {
    /// HumanActSite - An anatomical location on a human which can be the focus of an act.
    public struct _HumanActSite {
      /// HumanSubstanceAdministrationSite - The set of body locations to or through which a drug product may be administered.
      public struct  _HumanSubstanceAdministrationSite {
        /// bilateral ears - bilateral ears
        public static let BE = "BE"
        /// bilateral nares - bilateral nares
        public static let BN = "BN"
        /// buttock - buttock
        public static let BU = "BU"
        /// left arm - left arm
        public static let LA = "LA"
        /// left anterior chest - left anterior chest
        public static let LAC = "LAC"
        /// left antecubital fossa - left antecubital fossa
        public static let LACF = "LACF"
        /// left deltoid - left deltoid
        public static let LD = "LD"
        /// left ear - left ear
        public static let LE = "LE"
        /// left external jugular - left external jugular
        public static let LEJ = "LEJ"
        /// left foot - left foot
        public static let LF = "LF"
        /// left gluteus medius - left gluteus medius
        public static let LG = "LG"
        /// left hand - left hand
        public static let LH = "LH"
        /// left internal jugular - left internal jugular
        public static let LIJ = "LIJ"
        /// left lower abd quadrant - left lower abd quadrant
        public static let LLAQ = "LLAQ"
        /// left lower forearm - left lower forearm
        public static let LLFA = "LLFA"
        /// left mid forearm - left mid forearm
        public static let LMFA = "LMFA"
        /// left naris - left naris
        public static let LN = "LN"
        /// left posterior chest - left posterior chest
        public static let LPC = "LPC"
        /// left subclavian - left subclavian
        public static let LSC = "LSC"
        /// left thigh - left thigh
        public static let LT = "LT"
        /// left upper arm - left upper arm
        public static let LUA = "LUA"
        /// left upper abd quadrant - left upper abd quadrant
        public static let LUAQ = "LUAQ"
        /// left upper forearm - left upper forearm
        public static let LUFA = "LUFA"
        /// left ventragluteal - left ventragluteal
        public static let LVG = "LVG"
        /// left vastus lateralis - left vastus lateralis
        public static let LVL = "LVL"
        /// right eye - right eye
        public static let OD = "OD"
        /// left eye - left eye
        public static let OS = "OS"
        /// bilateral eyes - bilateral eyes
        public static let OU = "OU"
        /// perianal - perianal
        public static let PA = "PA"
        /// perineal - perineal
        public static let PERIN = "PERIN"
        /// right arm - right arm
        public static let RA = "RA"
        /// right anterior chest - right anterior chest
        public static let RAC = "RAC"
        /// right antecubital fossa - right antecubital fossa
        public static let RACF = "RACF"
        /// right deltoid - right deltoid
        public static let RD = "RD"
        /// right ear - right ear
        public static let RE = "RE"
        /// right external jugular - right external jugular
        public static let REJ = "REJ"
        /// right foot - right foot
        public static let RF = "RF"
        /// right gluteus medius - right gluteus medius
        public static let RG = "RG"
        /// right hand - right hand
        public static let RH = "RH"
        /// right internal jugular - right internal jugular
        public static let RIJ = "RIJ"
        /// right lower abd quadrant - right lower abd quadrant
        public static let RLAQ = "RLAQ"
        /// right lower forearm - right lower forearm
        public static let RLFA = "RLFA"
        /// right mid forearm - right mid forearm
        public static let RMFA = "RMFA"
        /// right naris - right naris
        public static let RN = "RN"
        /// right posterior chest - right posterior chest
        public static let RPC = "RPC"
        /// right subclavian - right subclavian
        public static let RSC = "RSC"
        /// right thigh - right thigh
        public static let RT = "RT"
        /// right upper arm - right upper arm
        public static let RUA = "RUA"
        /// right upper abd quadrant - right upper abd quadrant
        public static let RUAQ = "RUAQ"
        /// right upper forearm - right upper forearm
        public static let RUFA = "RUFA"
        /// right ventragluteal - right ventragluteal
        public static let RVG = "RVG"
        /// right vastus lateralis - right vastus lateralis
        public static let RVL = "RVL"
      }
    }
  }
  
  /**
   "A set of codes specifying the security classification of acts and roles in accordance with the definition for concept domain "Confidentiality"."
   
   [Reference](https://www.hl7.org/fhir/v3/Confidentiality/index.html)
   */
  public struct HL7Confidentiality {
    /// Confidentiality - A specializable code and its leaf codes used in Confidentiality value sets to value the Act.Confidentiality and Role.Confidentiality attribute in accordance with the definition for concept domain "Confidentiality".
    public struct _Confidentiality {
      /// low - Definition: Privacy metadata indicating that the information has been de-identified, and there are mitigating circumstances that prevent re-identification, which minimize risk of harm from unauthorized disclosure. The information requires protection to maintain low sensitivity.xamples: Includes anonymized, pseudonymized, or non-personally identifiable information such as HIPAA limited data sets.ap: No clear map to ISO 13606-4 Sensitivity Level (1) Care Management: RECORD_COMPONENTs that might need to be accessed by a wide range of administrative staff to manage the subject of care's access to health services.sage Note: This metadata indicates the receiver may have an obligation to comply with a data use agreement.
      public static let L = "L"
      /// moderate - Definition: Privacy metadata indicating moderately sensitive information, which presents moderate risk of harm if disclosed without authorization.xamples: Includes allergies of non-sensitive nature used inform food service; health information a patient authorizes to be used for marketing, released to a bank for a health credit card or savings account; or information in personal health record systems that are not governed under health privacy laws.ap: Partial Map to ISO 13606-4 Sensitivity Level (2) Clinical Management: Less sensitive RECORD_COMPONENTs that might need to be accessed by a wider range of personnel not all of whom are actively caring for the patient (e.g. radiology staff).sage Note: This metadata indicates that the receiver may be obligated to comply with the receiver's terms of use or privacy policies.
      public static let M = "M"
      /// normal - Definition: Privacy metadata indicating that the information is typical, non-stigmatizing health information, which presents typical risk of harm if disclosed without authorization.xamples: In the US, this includes what HIPAA identifies as the minimum necessary protected health information (PHI) given a covered purpose of use (treatment, payment, or operations). Includes typical, non-stigmatizing health information disclosed in an application for health, workers compensation, disability, or life insurance.ap: Partial Map to ISO 13606-4 Sensitivity Level (3) Clinical Care: Default for normal clinical care access (i.e. most clinical staff directly caring for the patient should be able to access nearly all of the EHR). Maps to normal confidentiality for treatment information but not to ancillary care, payment and operations.sage Note: This metadata indicates that the receiver may be obligated to comply with applicable jurisdictional privacy law or disclosure authorization.
      public static let N = "N"
      /// restricted - Privacy metadata indicating highly sensitive, potentially stigmatizing information, which presents a high risk to the information subject if disclosed without authorization. May be pre-empted by jurisdictional law, e.g. for public health reporting or emergency treatment.xamples: Includes information that is additionally protected such as sensitive conditions mental health, HIV, substance abuse, domestic violence, child abuse, genetic disease, and reproductive health; or sensitive demographic information such as a patient's standing as an employee or a celebrity. May be used to indicate proprietary or classified information that is not related to an individual, e.g. secret ingredients in a therapeutic substance; or the name of a manufacturer.ap: Partial Map to ISO 13606-4 Sensitivity Level (3) Clinical Care: Default for normal clinical care access (i.e. most clinical staff directly caring for the patient should be able to access nearly all of the EHR). Maps to normal confidentiality for treatment information but not to ancillary care, payment and operations..sage Note: This metadata indicates that the receiver may be obligated to comply with applicable, prevailing (default) jurisdictional privacy law or disclosure authorization..
      public static let R = "R"
      /// unrestricted - Definition: Privacy metadata indicating that the information is not classified as sensitive.xamples: Includes publicly available information, e.g. business name, phone, email or physical address.sage Note: This metadata indicates that the receiver has no obligation to consider additional policies when making access control decisions. Note that in some jurisdictions, personally identifiable information must be protected as confidential, so it would not be appropriate to assign a confidentiality code of "unrestricted" to that information even if it is publicly available.
      public static let U = "U"
      /// very restricted - . Privacy metadata indicating that the information is extremely sensitive and likely stigmatizing health information that presents a very high risk if disclosed without authorization. This information must be kept in the highest confidence. xamples: Includes information about a victim of abuse, patient requested information sensitivity, and taboo subjects relating to health status that must be discussed with the patient by an attending provider before sharing with the patient. May also include information held under â€œlegal lockâ€? or attorney-client privilegeap: This metadata indicates that the receiver may not disclose this information except as directed by the information custodian, who may be the information subject.sage Note: This metadata indicates that the receiver may not disclose this information except as directed by the information custodian, who may be the information subject.
      public static let V = "V"
    }

    /// ConfidentialityByAccessKind - Description: By accessing subject / role and relationship based rights (These concepts are mutually exclusive, one and only one is required for a valid confidentiality coding.)eprecation Comment:Deprecated due to updated confidentiality codes under ActCode
    public struct _ConfidentialityByAccessKind {
      /// business - Description: Since the service class can represent knowledge structures that may be considered a trade or business secret, there is sometimes (though rarely) the need to flag those items as of business level confidentiality. However, no patient related information may ever be of this confidentiality level.eprecation Comment: Replced by ActCode.B
      public static let B = "B"
      /// clinician - Description: Only clinicians may see this item, billing and administration persons can not access this item without special permission.eprecation Comment:Deprecated due to updated confidentiality codes under ActCode
      public static let D = "D"
      /// individual - Description: Access only to individual persons who are mentioned explicitly as actors of this service and whose actor type warrants that access (cf. to actor type code).eprecation Comment:Deprecated due to updated confidentiality codes under ActCode
      public static let I = "I"
    }

    /// ConfidentialityByInfoType - Description: By information type, only for service catalog entries (multiples allowed). Not to be used with actual patient data!eprecation Comment:Deprecated due to updated confidentiality codes under ActCode
    public struct _ConfidentialityByInfoType {
      /// substance abuse related - Description: Alcohol/drug-abuse related itemeprecation Comment:Replced by ActCode.ETH
      public static let ETH = "ETH"
      /// HIV related - Description: HIV and AIDS related itemeprecation Comment:Replced by ActCode.HIV
      public static let HIV = "HIV"
      /// psychiatry relate - Description: Psychiatry related itemeprecation Comment:Replced by ActCode.PSY
      public static let PSY = "PSY"
      /// sexual and domestic violence related - Description: Sexual assault / domestic violence related itemeprecation Comment:Replced by ActCode.SDV
      public static let SDV = "SDV"
      
    }
    /// ConfidentialityModifiers - Description: Modifiers of role based access rights (multiple allowed)eprecation Comment:Deprecated due to updated confidentiality codes under ActCode
    public struct _ConfidentialityModifiers {
      /// celebrity - Description: Celebrities are people of public interest (VIP) including employees, whose information require special protection.eprecation Comment:Replced by ActCode.CEL
      public static let C = "C"
      /// sensitive - Description: nformation for which the patient seeks heightened confidentiality. Sensitive information is not to be shared with family members. Information reported by the patient about family members is sensitive by default. Flag can be set or cleared on patient's request. Deprecation Comment:Deprecated due to updated confidentiality codes under ActCode
      public static let S = "S"
      /// taboo - Description: Information not to be disclosed or discussed with patient except through physician assigned to patient in this case. This is usually a temporary constraint only, example use is a new fatal diagnosis or finding, such as malignancy or HIV.eprecation Note:Replced by ActCode.TBOO
      public static let T = "T"
      
    }
  }
  /**
   "In the United States, federal standards for classifying data on ethnicity determine the categories used by federal agencies and exert a strong influence on categorization by state and local agencies and private sector organizations. The federal standards do not conceptually define ethnicity, and they recognize the absence of an anthropological or scientific basis for ethnicity classification. Instead, the federal standards acknowledge that ethnicity is a social-political construct in which an individual's own identification with a particular ethnicity is preferred to observer identification. The standards specify two minimum ethnicity categories: Hispanic or Latino, and Not Hispanic or Latino. The standards define a Hispanic or Latino as a person of "Mexican, Puerto Rican, Cuban, South or Central America, or other Spanish culture or origin, regardless of race." The standards stipulate that ethnicity data need not be limited to the two minimum categories, but any expansion must be collapsible to those categories. In addition, the standards stipulate that an individual can be Hispanic or Latino or can be Not Hispanic or Latino, but cannot be both."
   [Reference](https://www.hl7.org/fhir/v3/Ethnicity/index.html)
   */
  public struct HL7Ethnicity {
    /// Hispanic or Latino - Hispanic or Latino
    public static let HispanicOrLatino = "2135-2"
    /// Spaniard - Spaniard
    public static let Spaniard = "2137-8"
    /// Andalusian - Andalusian
    public static let Andalusian = "2138-6"
    /// Asturian - Asturian
    public static let Asturian = "2139-4"
    /// Castillian - Castillian
    public static let Castillian = "2140-2"
    /// Catalonian - Catalonian
    public static let Catalonian = "2141-0"
    /// Belearic Islander - Belearic Islander
    public static let BelearicIslander = "2142-8"
    /// Gallego - Gallego
    public static let Gallego = "2143-6"
    /// Valencian - Valencian
    public static let Valencian = "2144-4"
    /// Canarian - Canarian
    public static let Canarian = "2145-1"
    /// Spanish Basque - Spanish Basque
    public static let SpanishBasque = "2146-9"
    /// Mexican - Mexican
    public static let Mexican = "2148-5"
    /// Mexican American - Mexican American
    public static let MexicanAmerican = "2149-3"
    /// Mexicano - Mexicano
    public static let Mexicano = "2150-1"
    /// Chicano - Chicano
    public static let Chicano = "2151-9"
    /// La Raza - La Raza
    public static let LaRaza = "2152-7"
    /// Mexican American Indian - Mexican American Indian
    public static let MexicanAmericanIndian = "2153-5"
    /// Central American - Central American
    public static let CentralAmerican = "2155-0"
    /// Costa Rican - Costa Rican
    public static let CostaRican = "2156-8"
    /// Guatemalan - Guatemalan
    public static let Guatemalan = "2157-6"
    /// Honduran - Honduran
    public static let Honduran = "2158-4"
    /// Nicaraguan - Nicaraguan
    public static let Nicaraguan = "2159-2"
    /// Panamanian - Panamanian
    public static let Panamanian = "2160-0"
    /// Salvadoran - Salvadoran
    public static let Salvadoran = "2161-8"
    /// Central American Indian - Central American Indian
    public static let CentralAmericanIndian = "2162-6"
    /// Canal Zone - Canal Zone
    public static let CanalZone = "2163-4"
    /// South American - South American
    public static let SouthAmerican = "2165-9"
    /// Argentinean - Argentinean
    public static let Argentinean = "2166-7"
    /// Bolivian - Bolivian
    public static let Bolivian = "2167-5"
    /// Chilean - Chilean
    public static let Chilean = "2168-3"
    /// Colombian - Colombian
    public static let Colombian = "2169-1"
    /// Ecuadorian - Ecuadorian
    public static let Ecuadorian = "2170-9"
    /// Paraguayan - Paraguayan
    public static let Paraguayan = "2171-7"
    /// Peruvian - Peruvian
    public static let Peruvian = "2172-5"
    /// Uruguayan - Uruguayan
    public static let Uruguayan = "2173-3"
    /// Venezuelan - Venezuelan
    public static let Venezuelan = "2174-1"
    /// South American Indian - South American Indian
    public static let SouthAmericanIndian = "2175-8"
    /// Criollo - Criollo
    public static let Criollo = "2176-6"
    /// Latin American - Latin American
    public static let LatinAmerican = "2178-2"
    /// Puerto Rican - Puerto Rican
    public static let PuertoRican = "2180-8"
    /// Cuban - Cuban
    public static let Cuban = "2182-4"
    /// Dominican - Dominican
    public static let Dominican = "2184-0"
    /// Not Hispanic or Latino - Note that this term remains in the table for completeness, even though within HL7, the notion of "not otherwise coded" term is deprecated.
    public static let NotHispanicOrLatino = "2186-5"
  }
  
  /**
   8 standard SNOMED CT smoking status codes as mandated by US Meaningful Use
  */
  public struct SNOMEDCTSmokingStatus {
    /// Current Heavy tobacco smoker
    public static let CurrentHeavyTobaccoSmoker = "428071000124103"
    /// Current Light tobacco smoker
    public static let CurrentLightTobaccoSmoker = "428061000124105"
    /// Current some day smoker
    public static let CurrentSomeDaySmoker = "428041000124106"
    /// Ex-smoker (finding) - Ex-smoker
    public static let ExSmoker_Finding = "8517006"
    /// Never smoked tobacco (finding) - Never smoked tobacco
    public static let NeverSmokedTobacco_Finding = "266919005"
    /// Smoker (finding) - Smoker
    public static let Smoker_Finding = "77176002"
    /// Smokes tobacco daily (finding) - Smokes tobacco daily
    public static let SmokesTobaccoDaily_Finding = "449868002"
    /// Tobacco smoking consumption unknown (finding) - Tobacco smoking consumption unknown
    public static let TobaccoSmokingConsumptionUnknown_Finding = "266927001"
  }
  
  /**
   ```
   <functionCode code="PCP" displayName="Primary Care Physician"
   codeSystem="2.16.840.1.113883.5.88" codeSystemName="participationFunction">
   <originalText>Primary Care Provider</originalText>
   </functionCode>
   ```
   
   This is a complex element due to history and various use.
   
   You can read more about functionCode at the [CDAPro site](http://ushik.ahrq.gov/ViewItemDetails?system=mdr&itemKey=83329000)
   
  */
  public struct HL7ProviderFunctionCode {
    /**
     Historical C32 codes:
     ---
     
     Code System: "Provider Role" [2.16.840.1.113883.12.443](http://ushik.ahrq.gov/ViewItemDetails?system=mdr&itemKey=83329000)
     
     * PP (Primary Care Provider)
     * CP (Consulting Provider)
     * RP (Referring Provider)
     */
    public struct C32 {
      /// Primary Care Provider
      public static let PrimaryCareProvider = "PP"
      /// Consulting Provider
      public static let ConsultingProvider = "CP"
      /// Referring Provider
      public static let ReferringProvider = "RP"
    }
    /**
     C-CDA codes:
     ---
     
     Code System: "ParticipationFunction" [2.16.840.1.113883.5.88](http://www.hl7.org/documentcenter/public_temp_29B6E6E3-1C23-BA17-0C7B234C1C2C5A05/standards/vocabulary/vocabulary_tables/infrastructure/vocabulary/ParticipationFunction.html)
     
     Subset of list:
     
     * ADMPHYS (admitting physician)
     * ANEST (anesthesist)
     * ANRS (anesthesia nurse)
     * ATTPHYS (attending physician)
     * DISPHYS (discharging physician)
     * FASST (first assistant surgeon)
     * MDWF (midwife)
     * NASST (nurse assistant)
     * PCP (primary care physician)
     * PRISURG (primary surgeon)
     * RNDPHYS (rounding physician)
     * SASST (second assistant surgeon)
     * SNRS (scrub nurse)
     * TASST (third assistant)
     */
    public struct CCDA {
      /// admitting physician
      public static let admittingPhysician = "ADMPHYS"
      /// anesthesist
      public static let anesthesist = "ANEST"
      /// anesthesia nurse
      public static let anesthesiaNurse = "ANRS"
      /// attending physician
      public static let attendingPhysician = "ATTPHYS"
      /// discharging physician
      public static let dischargingPhysician = "DISPHYS"
      /// first assistant surgeon
      public static let firstAssistantSurgeon = "FASST"
      /// midwife
      public static let midwife = "MDWF"
      /// nurse assistant
      public static let nurseAssistant = "NASST"
      /// primary care physician
      public static let primaryCarePhysician = "PCP"
      /// primary surgeon
      public static let primarySurgeon = "PRISURG"
      /// rounding physician
      public static let roundingPhysician = "RNDPHYS"
      /// second assistant surgeon
      public static let secondAssistantSurgeon = "SASST"
      /// scrub nurse
      public static let scrubNurse = "SNRS"
      /// third assistant
      public static let thirdAssistant = "TASST"
    }
  }

  
}


