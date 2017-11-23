Object subclass: #Address
	instanceVariableNames: 'id streetName streetNumber town zipCode province'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!Address methodsFor: 'street' stamp: 'HernanWilkinson 10/28/2016 16:12'!
streetName

	^streetName ! !

!Address methodsFor: 'street' stamp: 'HernanWilkinson 10/28/2016 16:12'!
streetNumber

	^streetNumber ! !


!Address methodsFor: 'twon' stamp: 'HernanWilkinson 10/28/2016 16:12'!
town

	^town! !


!Address methodsFor: 'zip code' stamp: 'HernanWilkinson 10/28/2016 16:13'!
zipCode

	^zipCode! !


!Address methodsFor: 'instance creation' stamp: 'LJ 11/19/2017 10:26'!
withStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode province: aProvince
	streetName := aStreetName.
	streetNumber := aStreetNumber.
	town := aTown.
	zipCode := aZipCode.
	province := aProvince.! !


!Address methodsFor: 'province' stamp: 'HernanWilkinson 10/28/2016 16:11'!
province

	^province! !

!Address methodsFor: 'province' stamp: 'LJ 11/19/2017 10:27'!
isAt: aStreetName
	^streetName = aStreetName! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Address class
	instanceVariableNames: ''!

!Address class methodsFor: 'instance creation' stamp: 'LJ 11/19/2017 10:22'!
withStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode province: aProvince 
	^ super new withStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode province: aProvince.! !


TestCase subclass: #CustomerImportTest
	instanceVariableNames: 'session importer system testData'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!CustomerImportTest methodsFor: 'setup-teardown' stamp: 'LJ 11/13/2017 21:13'!
tearDown

	system commit.
	system stop.! !


!CustomerImportTest methodsFor: 'test data' stamp: 'LJ 11/16/2017 19:07'!
customersIsEmpty
	^ system allCustomersIsEmpty.! !


!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/21/2017 23:30'!
testCanNotImportAddressRecordWithMoreThanSixFields
	self
		should: [ self
				importCustomersFrom: testData addressRecordWithMoreThanSixFieldsTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals: AddressLineImporter invalidAddressRecordErrorDescription.
			self assert: self alwaysImportedCustomer addressesIsEmpty ]! !

!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/21/2017 23:32'!
testShouldNotImportAddressRecordsStartingWithMoreThanA
	self
		should: [ self
				importCustomersFrom: testData addressRecordStartingWithMoreThanOneATestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals: Importer invalidRecordTypeErrorDescription.
			self assert: self alwaysImportedCustomer addressesIsEmpty ]! !

!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/21/2017 23:09'!
testImportCustomers
	self importCustomersFrom: testData validCustomerTestData.
	self assertImportedCustomersSizeIsCorrect.
	self assertPepeSanchezWasImportedCorrectly.
	self assertJuanPerezWasImportedCorrectly! !

!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/21/2017 23:32'!
testShouldNotImportCustomerRecordsStartingWithMoreThanC
	self
		should: [ self
				importCustomersFrom: testData customerRecordStartingWithMoreThanOneCTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals: Importer invalidRecordTypeErrorDescription.
			self assert: self customersIsEmpty ]! !

!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/21/2017 23:33'!
testCanNotImportCustomerRecordWithLessThanFiveFields
	self
		should: [ self
				importCustomersFrom: testData customerRecordWithLessThanFiveFieldsTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals: CustomerLineImporter invalidCustomerRecordErrorDescription.
			self assert: self customersIsEmpty ]! !

!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/21/2017 23:35'!
testEmptyLinesAreRecognizedAsInvalidRecords
	self
		should: [ self importCustomersFrom: testData dataWithEmptyLine ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals: Importer invalidRecordTypeErrorDescription.
			self assert: self alwaysImportedCustomer addressesIsEmpty ]! !

!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/22/2017 00:01'!
testCanNotImportAddressWithoutCustomer
	self
		should: [ self importCustomersFrom: testData addressWithoutCustomerTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals: Importer addressWithoutPartyErrorDescription.
			self assert: self customersIsEmpty ]! !

!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/21/2017 23:34'!
testCanNotImportCustomerRecordWithMoreThanFiveFields
	self
		should: [ self
				importCustomersFrom: testData customerRecordWithMoreThanFiveFieldsTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals: CustomerLineImporter invalidCustomerRecordErrorDescription.
			self assert: self customersIsEmpty ]! !

!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/21/2017 23:31'!
testCanNotImportAddressRecordWithLessThanSixFields
	self
		should: [ self
				importCustomersFrom: testData addressRecordWithLessThanSixFieldsTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals: AddressLineImporter invalidAddressRecordErrorDescription.
			self assert: self alwaysImportedCustomer addressesIsEmpty ]! !


!CustomerImportTest methodsFor: 'importing' stamp: 'LJ 11/21/2017 23:16'!
importCustomersFrom: inputStream
	(Importer
		from: inputStream
		on: system
		withLineImporters: testData customerLineImporters) import! !

!CustomerImportTest methodsFor: 'importing' stamp: 'LJ 11/20/2017 21:58'!
customerIdentifiedAs: anId
	^ system customerIdentifiedAs: anId! !


!CustomerImportTest methodsFor: 'test data - customer' stamp: 'LJ 11/21/2017 23:29'!
alwaysImportedCustomer
	^ self
		customerIdentifiedAs: testData alwaysImportedCustomerIdentification! !


!CustomerImportTest methodsFor: 'initialization' stamp: 'LJ 11/21/2017 23:02'!
setUp
	system := Environment current createErpSystem.
	system start.
	system beginTransaction.
	testData := ImporterTestData new.! !


!CustomerImportTest methodsFor: 'asserting' stamp: 'HernanWilkinson 11/1/2016 11:00'!
assert: customer hasAddressAt: streetName number: streetNumber in: town zipCode: zipCode province: province

	| address |
	
	address := customer addressAt: streetName ifNone: [ self fail ].
	self assert: address streetName equals: streetName.
	self assert: address streetNumber equals: streetNumber.
	self assert: address town equals: town.
	self assert: address zipCode equals: zipCode.
	self assert: address province equals: province.
	! !

!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 22:38'!
assert: aSupplier isNamed: aName andIsIdentifiedAs: anId andNumberOfAddresses: aNumberOfAddresses andNumberOfCustomers: aNumberOfCustomers
	self assert: aSupplier name equals: aName.
	self assert: (aSupplier isIdentifiedAs: anId). 
	self assert: aSupplier numberOfAddresses equals: aNumberOfAddresses.
	self assert: aSupplier numberOfCustomers equals: aNumberOfCustomers.! !

!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 22:25'!
assertPepeSanchezWasImportedCorrectly
	| customer idType idNumber |
	idType := 'D'.
	idNumber := '22333444'.
	customer := self customerIdentifiedAs: (Identification ofType: idType numbered: idNumber).
	self
		assert: customer
		isNamed: 'Pepe'
		lastName: 'Sanchez'
		identfiedAs: idType 
		withNumber: idNumber
		andNumberOfAddresses: 2.
	
	self assertCustomerHasCorrectAddresses: customer.! !

!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 22:58'!
assert: aSupplier hasCustomerIdentifiedAs: anId named: aName lastName: aLastName

	| customer |
	
	customer := aSupplier customerIdentifiedAs: anId ifNone: [ self fail ].
	self assert: (customer firstName) equals: aName.
	self assert: (customer lastName) equals: aLastName.
	! !

!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 22:06'!
assertJuanPerezWasImportedCorrectly
	
	| customer idType idNumber |
	
	idType := 'C'.
	idNumber := '23-25666777-9'.
	customer := self customerIdentifiedAs: (Identification ofType: idType numbered: 
idNumber).
	
	self assert: customer isNamed: 'Juan' lastName: 'Perez' identfiedAs: idType withNumber: idNumber andNumberOfAddresses: 1.
	self assert: customer hasAddressAt: 'Alem' number: 1122 in: 'CABA' zipCode: 1001 province: 'CABA'.
	! !

!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 22:15'!
assert: customer isNamed: firstName lastName: lastName identfiedAs: idType withNumber: idNumber andNumberOfAddresses: addressesSize
	self assert: customer firstName equals: firstName.
	self assert: customer lastName equals: lastName.
	self assert: (customer isIdentifiedAs: (Identification ofType: idType numbered: idNumber)).
	self assert: customer numberOfAddresses equals: addressesSize! !

!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 22:26'!
assertCustomerHasCorrectAddresses: aCustomer
	self assertPartyHasCorrectAddresses: aCustomer. ! !

!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 22:27'!
assertPartyHasCorrectAddresses: aParty
	self
		assert: aParty
		hasAddressAt: 'San Martin'
		number: 3322
		in: 'Olivos'
		zipCode: 1636
		province: 'BsAs'.
	self
		assert: aParty
		hasAddressAt: 'Maipu'
		number: 888
		in: 'Florida'
		zipCode: 1122
		province: 'Buenos Aires'! !

!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/16/2017 19:03'!
assertImportedCustomersSizeIsCorrect
	self assert: system allCustomersSize equals: 2! !


Object subclass: #CustomerSystem
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!CustomerSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/13/2017 21:14'!
stop
	^ self subclassResponsibility.! !

!CustomerSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/13/2017 20:52'!
beginTransaction
	^ self subclassResponsibility.! !

!CustomerSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/13/2017 20:51'!
start
	^ self subclassResponsibility.! !

!CustomerSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/13/2017 20:51'!
commit
	^ self subclassResponsibility.! !


!CustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:00'!
addCustomer: aCustomer
	^ self subclassResponsibility.! !

!CustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:02'!
allCustomersSize
	 ^ self subclassResponsibility .! !

!CustomerSystem methodsFor: 'customers' stamp: 'LJ 11/19/2017 15:52'!
customerIdentifiedAs: anId
	self subclassResponsibility.! !

!CustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:05'!
allCustomersIsEmpty
	^ self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

CustomerSystem class
	instanceVariableNames: ''!

!CustomerSystem class methodsFor: 'as yet unclassified' stamp: 'LJ 11/22/2017 00:23'!
customerDoesNotExistError
	'a customer with specified identification does not exist'! !


Object subclass: #Environment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!Environment methodsFor: 'as yet unclassified' stamp: 'LJ 11/19/2017 11:47'!
createErpSystem
	^ self subclassResponsibility .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Environment class
	instanceVariableNames: ''!

!Environment class methodsFor: 'as yet unclassified' stamp: 'LJ 11/13/2017 20:39'!
noEnvironmentFoundErrorMessage
	^ 'No environment found'! !


!Environment class methodsFor: 'testing' stamp: 'LJ 11/13/2017 20:41'!
isCurrent
	^ self subclassResponsibility .! !


!Environment class methodsFor: 'accessing' stamp: 'LJ 11/13/2017 20:43'!
current
	^ self subclasses detect: [:aSubclass | aSubclass isCurrent ]  ifFound: [:aSubclass | aSubclass new ]  ifNone: [ self error: self noEnvironmentFoundErrorMessage ] .! !


Environment subclass: #DevelopmentEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!DevelopmentEnvironment methodsFor: 'as yet unclassified' stamp: 'LJ 11/19/2017 11:52'!
createErpSystem
	^ ErpSystem withCustomerSystem: TransientCustomerSystem new supplierSystem: TransientSupplierSystem new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

DevelopmentEnvironment class
	instanceVariableNames: ''!

!DevelopmentEnvironment class methodsFor: 'testing' stamp: 'LJ 11/13/2017 20:41'!
isCurrent
	^ IntegrationEnvironment isCurrent not.! !


Object subclass: #ErpSystem
	instanceVariableNames: 'customerSystem supplierSystem session'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!ErpSystem methodsFor: 'as yet unclassified' stamp: 'LJ 11/19/2017 11:53'!
withCustomerSystem: aCustomerSystem supplierSystem: aSupplierSystem
	customerSystem := aCustomerSystem.
	supplierSystem := aSupplierSystem.! !


!ErpSystem methodsFor: 'customers' stamp: 'LJ 11/20/2017 19:52'!
allSuppliersSize
	^ supplierSystem allSuppliersSize! !

!ErpSystem methodsFor: 'customers' stamp: 'LJ 11/19/2017 12:36'!
allCustomersSize
	^ customerSystem allCustomersSize! !

!ErpSystem methodsFor: 'customers' stamp: 'LJ 11/19/2017 12:24'!
addCustomer: aCustomer
	customerSystem addCustomer: aCustomer.! !

!ErpSystem methodsFor: 'customers' stamp: 'LJ 11/20/2017 19:53'!
addSupplier: aSupplier
	supplierSystem addSupplier: aSupplier! !

!ErpSystem methodsFor: 'customers' stamp: 'LJ 11/20/2017 21:51'!
supplierIdentifiedAs: anIdentification
	^ supplierSystem supplierIdentifiedAs: anIdentification! !

!ErpSystem methodsFor: 'customers' stamp: 'LJ 11/21/2017 23:46'!
allSuppliersIsEmpty
	^ supplierSystem allSuppliersIsEmpty ! !

!ErpSystem methodsFor: 'customers' stamp: 'LJ 11/19/2017 12:36'!
allCustomersIsEmpty
	^ customerSystem allCustomersIsEmpty! !

!ErpSystem methodsFor: 'customers' stamp: 'LJ 11/20/2017 11:45'!
customerIdentifiedAs: anIdentification
	^ customerSystem customerIdentifiedAs: anIdentification! !


!ErpSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 12:23'!
stop
	supplierSystem stop.
	customerSystem stop.! !

!ErpSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 12:22'!
beginTransaction
	customerSystem beginTransaction.
	supplierSystem beginTransaction.! !

!ErpSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 12:22'!
start
	customerSystem start.
	supplierSystem start.! !

!ErpSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 12:22'!
commit
	customerSystem commit.
	supplierSystem commit.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ErpSystem class
	instanceVariableNames: ''!

!ErpSystem class methodsFor: 'as yet unclassified' stamp: 'LJ 11/19/2017 11:53'!
withCustomerSystem: aCustomerSystem supplierSystem: aSupplierSystem
	^ self new withCustomerSystem: aCustomerSystem supplierSystem: aSupplierSystem.! !


Object subclass: #Identification
	instanceVariableNames: 'id identificationType identificationNumber'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!Identification methodsFor: 'as yet unclassified' stamp: 'LJ 11/20/2017 22:06'!
ofType: anIdentificationType numbered: anIdentificationNumber
	identificationType := anIdentificationType.
	identificationNumber := anIdentificationNumber ! !


!Identification methodsFor: 'comparing' stamp: 'LJ 11/19/2017 16:10'!
= anId
	^ identificationType = anId identificationType and: [ identificationNumber = anId identificationNumber ]! !


!Identification methodsFor: 'accessing' stamp: 'LJ 11/19/2017 16:10'!
identificationNumber
	^ identificationNumber! !

!Identification methodsFor: 'accessing' stamp: 'LJ 11/19/2017 16:10'!
identificationType
	^ identificationType.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Identification class
	instanceVariableNames: ''!

!Identification class methodsFor: 'as yet unclassified' stamp: 'LJ 11/20/2017 22:06'!
ofType: anIdentificationType numbered: anIdentificationNumber
	^ self new ofType: anIdentificationType numbered: anIdentificationNumber.! !


Object subclass: #Importer
	instanceVariableNames: 'line readStream record newParty system lineImporters'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!Importer methodsFor: 'importing' stamp: 'HernanWilkinson 11/1/2016 17:51'!
import

	[ self canImportNextLine ] whileTrue: [ 
		self convertLineToRecord.
		self importRecord ]! !


!Importer methodsFor: 'importing - private - address' stamp: 'LJ 11/20/2017 11:21'!
assertThereIsPartyForAddress

	newParty isNil ifTrue: [ self signalAddressWithoutPartyError ].
	! !


!Importer methodsFor: 'initialization' stamp: 'LJ 11/20/2017 19:41'!
initializeOn: aReadStream on: aSession withLineImporters: alineImporterCollection
	readStream := aReadStream.
	system := aSession.
	lineImporters := alineImporterCollection! !


!Importer methodsFor: 'importing - private' stamp: 'LJ 11/22/2017 00:09'!
assertThereIsSupplierForAddedCustomer
	
	newParty ifNil: [ self signalAddCustomerWithoutSupplierError ].! !

!Importer methodsFor: 'importing - private' stamp: 'HernanWilkinson 11/2/2016 15:54'!
convertLineToRecord

	record := line substrings: {$,}.
	
	self assertRecordNotEmpty! !

!Importer methodsFor: 'importing - private' stamp: 'LJ 11/21/2017 22:10'!
importRecord
	| importers |
	importers := lineImporters select: [ :aLineImporter | aLineImporter imports: record ].
	importers size = 1
		ifTrue: [ importers first importFrom: self ]
		ifFalse:[
	self signalInvalidRecordType]! !

!Importer methodsFor: 'importing - private' stamp: 'LJ 11/22/2017 00:09'!
addNewCustomer: aCustomer
	self assertThereIsSupplierForAddedCustomer.
	newParty addCustomer: aCustomer.
	system addCustomer: aCustomer.! !

!Importer methodsFor: 'importing - private' stamp: 'LJ 11/22/2017 00:23'!
addExistingCustomerWithIdentification: anIdentification
	self assertThereIsSupplierForAddedCustomer.
	newParty addCustomer: (system customerIdentifiedAs: anIdentification).

	! !

!Importer methodsFor: 'importing - private' stamp: 'HernanWilkinson 11/2/2016 10:55'!
canImportNextLine

	line := readStream nextLine.
	^ line notNil! !

!Importer methodsFor: 'importing - private' stamp: 'HernanWilkinson 11/2/2016 15:55'!
assertRecordNotEmpty
	
	record isEmpty ifTrue: [ self signalInvalidRecordType ]! !

!Importer methodsFor: 'importing - private' stamp: 'LJ 11/20/2017 11:25'!
addSupplier: aSupplier
	newParty := aSupplier.
	system addSupplier: aSupplier! !

!Importer methodsFor: 'importing - private' stamp: 'LJ 11/20/2017 11:29'!
addAddress: anAddress
	self assertThereIsPartyForAddress.
	newParty addAddress: anAddress! !

!Importer methodsFor: 'importing - private' stamp: 'LJ 11/20/2017 11:20'!
addCustomer: aCustomer
	newParty := aCustomer.
	system addCustomer: aCustomer! !


!Importer methodsFor: 'error signal' stamp: 'LJ 11/22/2017 00:08'!
signalAddCustomerWithoutSupplierError

	self error: self class cantAddCustomerWithoutSupplierErrorDescription.! !

!Importer methodsFor: 'error signal' stamp: 'LJ 11/22/2017 00:01'!
signalAddressWithoutPartyError

	self error: self class addressWithoutPartyErrorDescription.! !

!Importer methodsFor: 'error signal' stamp: 'LJ 11/20/2017 11:12'!
record
	^ record.! !

!Importer methodsFor: 'error signal' stamp: 'HernanWilkinson 11/1/2016 17:54'!
signalInvalidRecordType

	self error: self class invalidRecordTypeErrorDescription! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Importer class
	instanceVariableNames: ''!

!Importer class methodsFor: 'instance creation' stamp: 'LJ 11/20/2017 19:42'!
from: aReadStream on: aSystem withLineImporters: aLineImporterCollection
	^ self new initializeOn: aReadStream on: aSystem withLineImporters: aLineImporterCollection . ! !


!Importer class methodsFor: 'error descriptions' stamp: 'LJ 11/22/2017 00:01'!
addressWithoutPartyErrorDescription
	
	^'There is no Party for the imported address'! !

!Importer class methodsFor: 'error descriptions' stamp: 'LJ 11/22/2017 00:08'!
cantAddCustomerWithoutSupplierErrorDescription
	
	^'There is no Supplier to add customer on'! !

!Importer class methodsFor: 'error descriptions' stamp: 'HernanWilkinson 11/1/2016 17:54'!
invalidRecordTypeErrorDescription
	
	^'Invalid record type'! !


Object subclass: #ImporterTestData
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!ImporterTestData methodsFor: 'test data - customer' stamp: 'LJ 11/21/2017 23:32'!
customerRecordStartingWithMoreThanOneCTestData
	
	^ ReadStream on:'CC,Pepe,Sanchez,D,22333444'! !

!ImporterTestData methodsFor: 'test data - customer' stamp: 'LJ 11/21/2017 23:33'!
customerRecordWithLessThanFiveFieldsTestData
	
	^ ReadStream on: 'C,Pepe,Sanchez,D'! !

!ImporterTestData methodsFor: 'test data - customer' stamp: 'LJ 11/21/2017 23:55'!
alwaysImportedCustomerTestData
	^ ReadStream on: self alwaysImportedCustomerRecord ! !

!ImporterTestData methodsFor: 'test data - customer' stamp: 'LJ 11/21/2017 23:33'!
customerRecordWithMoreThanFiveFieldsTestData
	^ ReadStream on:
		self alwaysImportedCustomerRecord , ',x'! !

!ImporterTestData methodsFor: 'test data - customer' stamp: 'LJ 11/21/2017 23:29'!
alwaysImportedCustomerIdentification
	^ Identification
		ofType: self alwaysImportedCustomerIdType
		numbered: self alwaysImportedCustomerIdNumber! !

!ImporterTestData methodsFor: 'test data - customer' stamp: 'LJ 11/21/2017 23:04'!
alwaysImportedCustomerIdType
	^ 'D'! !

!ImporterTestData methodsFor: 'test data - customer' stamp: 'LJ 11/21/2017 23:05'!
alwaysImportedCustomerIdNumber
	^ '22333444'! !

!ImporterTestData methodsFor: 'test data - customer' stamp: 'LJ 11/21/2017 23:06'!
alwaysImportedCustomerRecord
	^ 'C,Pepe,Sanchez,' , self alwaysImportedCustomerIdType , ','
		, self alwaysImportedCustomerIdNumber! !


!ImporterTestData methodsFor: 'importing' stamp: 'LJ 11/21/2017 23:16'!
customerLineImporters
	^ OrderedCollection
		with: AddressLineImporter new
		with: CustomerLineImporter new! !

!ImporterTestData methodsFor: 'importing' stamp: 'LJ 11/21/2017 23:53'!
supplierLineImporters
	^ (OrderedCollection with: (AddressLineImporter new) with: (ExistingCustomerLineImporter new)
	with: (NewCustomerLineImporter new) with: (SupplierLineImporter new))! !


!ImporterTestData methodsFor: 'test data - new customer' stamp: 'LJ 11/22/2017 00:42'!
newCustomerWithLessThanFiveFieldsTestData
	^ ReadStream on: self alwaysImportedSupplierRecord,'
NC,Pepe,Sanchez,D'! !

!ImporterTestData methodsFor: 'test data - new customer' stamp: 'LJ 11/22/2017 00:04'!
newCustomerWithoutSupplierTestData
	^ ReadStream on: 'NC,Pepe,Sanchez,D,22333444'! !

!ImporterTestData methodsFor: 'test data - new customer' stamp: 'LJ 11/22/2017 00:42'!
newCustomerWithMoreThanFiveFieldsTestData
	^ ReadStream on: self alwaysImportedSupplierRecord,'
NC,Pepe,Sanchez,D,12222,R'! !


!ImporterTestData methodsFor: 'test data - existing customer' stamp: 'LJ 11/22/2017 00:37'!
existingCustomerWithLessThanThreeFieldsTestData
	^ ReadStream on: self alwaysImportedSupplierRecord,' 
EC,', self alwaysImportedCustomerIdType! !

!ImporterTestData methodsFor: 'test data - existing customer' stamp: 'LJ 11/22/2017 00:40'!
existingCustomerWithMoreThanThreeFieldsTestData
	^ ReadStream on: self alwaysImportedSupplierRecord,' 
EC,', self alwaysImportedCustomerIdType, ',123,R'! !

!ImporterTestData methodsFor: 'test data - existing customer' stamp: 'LJ 11/22/2017 00:12'!
existingCustomerWithoutSupplierTestData
	^ ReadStream on: 'EC,', self alwaysImportedCustomerIdType, ',', self alwaysImportedCustomerIdNumber .! !


!ImporterTestData methodsFor: 'test data - supplier' stamp: 'LJ 11/21/2017 23:44'!
supplierRecordWithMoreThanFourFieldsTestData
	^ ReadStream on: 'S,Supplier,D,223,R'! !

!ImporterTestData methodsFor: 'test data - supplier' stamp: 'LJ 11/21/2017 23:09'!
validCustomerTestData
	^ ReadStream
		on:
			self alwaysImportedCustomerRecord
				,
					'
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !

!ImporterTestData methodsFor: 'test data - supplier' stamp: 'LJ 11/21/2017 23:07'!
alwaysImportedSupplierIdType
	^ 'D'! !

!ImporterTestData methodsFor: 'test data - supplier' stamp: 'LJ 11/21/2017 23:35'!
dataWithEmptyLine
	^ ReadStream
		on:
			self alwaysImportedCustomerRecord
				,
					'

A,San Martin,3322,Olivos,1636,BsAs'! !

!ImporterTestData methodsFor: 'test data - supplier' stamp: 'LJ 11/21/2017 23:06'!
alwaysImportedSupplierNumber
	^ '123'! !

!ImporterTestData methodsFor: 'test data - supplier' stamp: 'LJ 11/21/2017 23:44'!
supplierRecordWithLessThanFourFieldsTestData
	^ ReadStream on: 'S,Supplier,D'! !

!ImporterTestData methodsFor: 'test data - supplier' stamp: 'LJ 11/22/2017 00:31'!
validSupplierTestData
	^ ReadStream
		on: self alwaysImportedSupplierRecord
				,
					'
EC,' , self alwaysImportedCustomerIdType , ','
				, self alwaysImportedCustomerIdNumber
				,
					'
NC,Pato,Lucas,D,1234
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'! !

!ImporterTestData methodsFor: 'test data - supplier' stamp: 'LJ 11/21/2017 23:08'!
alwaysImportedSupplierRecord
	^ 'S,Supplier1,' , self alwaysImportedSupplierIdType , ','
		, self alwaysImportedSupplierNumber! !

!ImporterTestData methodsFor: 'test data - supplier' stamp: 'LJ 11/22/2017 00:27'!
alwaysImportedSupplierIdentification
	^ Identification ofType: self alwaysImportedSupplierIdType numbered: self alwaysImportedSupplierNumber.! !


!ImporterTestData methodsFor: 'test data - address' stamp: 'LJ 11/21/2017 23:31'!
addressRecordStartingWithMoreThanOneATestData
	^ ReadStream
		on:
			self alwaysImportedCustomerRecord
				,
					'
AA,San Martin,3322,Olivos,1636,BsAs'! !

!ImporterTestData methodsFor: 'test data - address' stamp: 'LJ 11/22/2017 00:00'!
addressWithoutSupplierTestData
	
	^ ReadStream on: 'A,San Martin,3322,Olivos,1636,BsAs'! !

!ImporterTestData methodsFor: 'test data - address' stamp: 'LJ 11/21/2017 23:29'!
addressWithoutCustomerTestData
	
	^ ReadStream on: 'A,San Martin,3322,Olivos,1636,BsAs'! !

!ImporterTestData methodsFor: 'test data - address' stamp: 'LJ 11/21/2017 23:30'!
addressRecordWithMoreThanSixFieldsTestData
	^ ReadStream
		on:
			self alwaysImportedCustomerRecord
				,
					'
A,San Martin,3322,Olivos,1636,BsAs,y otra cosa'! !

!ImporterTestData methodsFor: 'test data - address' stamp: 'LJ 11/21/2017 23:31'!
addressRecordWithLessThanSixFieldsTestData
	^ ReadStream
		on:
			self alwaysImportedCustomerRecord
				,
					'
A,San Martin,3322,Olivos,1636'! !


Environment subclass: #IntegrationEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!IntegrationEnvironment methodsFor: 'as yet unclassified' stamp: 'LJ 11/21/2017 22:05'!
createErpSystem
	| mappingSystem |
	mappingSystem := MappingSystem new.
	^ ErpSystem withCustomerSystem: (PersistentCustomerSystem withSystemMapping: mappingSystem) supplierSystem: (PersistentSupplierSystem withMappingSystem: mappingSystem).! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

IntegrationEnvironment class
	instanceVariableNames: ''!

!IntegrationEnvironment class methodsFor: 'testing' stamp: 'LJ 11/22/2017 00:52'!
isCurrent
	^ false! !


Object subclass: #LineImporter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!LineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 10:54'!
importFrom: anImporter
	^ self subclassResponsibility! !

!LineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:06'!
assertValidRecordSize: aRecord
	^ self subclassResponsibility! !

!LineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:07'!
signalInvalidRecord
	^ self subclassResponsibility! !

!LineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 10:50'!
imports: aRecord
	^self subclassResponsibility! !


LineImporter subclass: #AddressLineImporter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!AddressLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:05'!
importFrom: anImporter
	| record |
	record := anImporter record.
	self assertValidRecordSize: record.
	^ anImporter
		addAddress:
			(Address
				withStreetName: record second
				streetNumber: record third asInteger
				town: record fourth
				zipCode: record fifth asInteger
				province: record sixth)! !

!AddressLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:07'!
signalInvalidRecord
	self error: self class invalidAddressRecordErrorDescription! !

!AddressLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:06'!
assertValidRecordSize: aRecord
	aRecord size ~= 6
		ifTrue: [ self signalInvalidRecord ]! !

!AddressLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 10:51'!
imports: aRecord
	^ aRecord first = 'A'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

AddressLineImporter class
	instanceVariableNames: ''!

!AddressLineImporter class methodsFor: 'error descriptions' stamp: 'LJ 11/20/2017 11:01'!
invalidAddressRecordErrorDescription
	^ 'Invalid address record'! !


LineImporter subclass: #CustomerLineImporter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!CustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 22:06'!
importFrom: anImporter
	| record |
	record := anImporter record.
	self assertValidRecordSize: record.
	anImporter
		addCustomer:
			(Customer
				withFirstName: record second
				lastName: record third
				identification: (Identification ofType: record fourth numbered: record fifth))! !

!CustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:06'!
assertValidRecordSize: aRecord
	aRecord size ~= 5
		ifTrue: [ self signalInvalidRecord ]! !

!CustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:07'!
signalInvalidRecord
	self error: self class invalidCustomerRecordErrorDescription! !

!CustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 10:51'!
imports: aRecord
	^ aRecord first = 'C'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

CustomerLineImporter class
	instanceVariableNames: ''!

!CustomerLineImporter class methodsFor: 'error descriptions' stamp: 'LJ 11/20/2017 10:41'!
invalidCustomerRecordErrorDescription
	^ 'Invalid customer record'! !


LineImporter subclass: #ExistingCustomerLineImporter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!ExistingCustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 22:06'!
importFrom: anImporter
	| record |
	record := anImporter record.
	self assertValidRecordSize: record.
	anImporter addExistingCustomerWithIdentification: (Identification ofType: record second numbered: record third)! !

!ExistingCustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:37'!
assertValidRecordSize: aRecord
	aRecord size ~= 3
		ifTrue: [ self signalInvalidRecord ]! !

!ExistingCustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:37'!
signalInvalidRecord
	self error: self class invalidExistingCustomerRecordErrorDescription! !

!ExistingCustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 20:00'!
imports: aRecord
	^ aRecord first = 'EC'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ExistingCustomerLineImporter class
	instanceVariableNames: ''!

!ExistingCustomerLineImporter class methodsFor: 'as yet unclassified' stamp: 'LJ 11/20/2017 11:38'!
invalidExistingCustomerRecordErrorDescription
	^ 'Invalid existing customer record'! !


Object subclass: #MappingSystem
	instanceVariableNames: 'mappings'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!MappingSystem methodsFor: 'mapping' stamp: 'LJ 11/21/2017 21:57'!
supplierMapping
	^ ClassMapping
		withDefaultTableNameFor: Supplier
		mappingAll:
			(Array
				with: (EmbededMapping withDefaultFieldNameFor: #name)
				with: (EmbededMapping withDefaultFieldNameFor: #id)
				with: (OneToManyMapping withDefaultFieldNameFor: #customers ofType: Customer)
				with: (OneToManyMapping withDefaultFieldNameFor: #addresses ofType: Address))! !

!MappingSystem methodsFor: 'mapping' stamp: 'LJ 11/21/2017 22:00'!
allMappings
	^ (Array
				with: (self addressMapping )
				with: (self customerMapping )
				with: (self supplierMapping )
)! !

!MappingSystem methodsFor: 'mapping' stamp: 'LJ 11/21/2017 21:57'!
customerMapping
	^ ClassMapping
		withDefaultTableNameFor: Customer
		mappingAll:
			(Array
				with: (EmbededMapping withDefaultFieldNameFor: #firstName)
				with: (EmbededMapping withDefaultFieldNameFor: #lastName)
				with: (EmbededMapping withDefaultFieldNameFor: #identification)
				with: (OneToManyMapping withDefaultFieldNameFor: #addresses ofType: Address))! !

!MappingSystem methodsFor: 'mapping' stamp: 'LJ 11/21/2017 21:57'!
addressMapping
	^ ClassMapping
		withDefaultTableNameFor: Address
		mappingAll:
			(Array
				with: (EmbededMapping withDefaultFieldNameFor: #streetName)
				with: (EmbededMapping withDefaultFieldNameFor: #streetNumber)
				with: (EmbededMapping withDefaultFieldNameFor: #town)
				with: (EmbededMapping withDefaultFieldNameFor: #zipCode)
				with: (EmbededMapping withDefaultFieldNameFor: #province))! !


LineImporter subclass: #NewCustomerLineImporter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!NewCustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 22:06'!
importFrom: anImporter
	| record |
	record := anImporter record.
	self assertValidRecordSize: record.
	anImporter
		addNewCustomer:
			(Customer
				withFirstName: record second
				lastName: record third
				identification: (Identification ofType: record fourth numbered: record fifth))! !

!NewCustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:37'!
assertValidRecordSize: aRecord
	aRecord size ~= 5
		ifTrue: [ self signalInvalidRecord ]! !

!NewCustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:37'!
signalInvalidRecord
	self error: self class invalidNewCustomerRecordErrorDescription! !

!NewCustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 20:00'!
imports: aRecord
	^ aRecord first = 'NC'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

NewCustomerLineImporter class
	instanceVariableNames: ''!

!NewCustomerLineImporter class methodsFor: 'as yet unclassified' stamp: 'LJ 11/20/2017 11:38'!
invalidNewCustomerRecordErrorDescription
	^ 'Invalid new customer record'! !


Object subclass: #Party
	instanceVariableNames: 'id identification addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!Party methodsFor: 'identification' stamp: 'LJ 11/20/2017 09:28'!
isIdentifiedAs: anId
	^ identification = anId.! !


!Party methodsFor: 'addresses' stamp: 'LJ 11/20/2017 09:51'!
addAddress: anAddress 

	addresses add: anAddress ! !

!Party methodsFor: 'addresses' stamp: 'LJ 11/20/2017 09:51'!
addressesIsEmpty
	
	^addresses isEmpty! !

!Party methodsFor: 'addresses' stamp: 'LJ 11/20/2017 09:53'!
numberOfAddresses
	
	^addresses size! !

!Party methodsFor: 'addresses' stamp: 'LJ 11/20/2017 09:51'!
addresses

	^ addresses! !

!Party methodsFor: 'addresses' stamp: 'LJ 11/20/2017 09:51'!
addressAt: aStreetName ifNone: noneClosure 
	
	^addresses detect: [ :anAddress | anAddress isAt: aStreetName ] ifNone: noneClosure ! !


Party subclass: #Customer
	instanceVariableNames: 'firstName lastName'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!Customer methodsFor: 'name' stamp: 'HernanWilkinson 10/28/2016 16:15'!
lastName

	^lastName ! !

!Customer methodsFor: 'name' stamp: 'HernanWilkinson 10/28/2016 16:15'!
firstName
	
	^firstName ! !


!Customer methodsFor: 'initialization' stamp: 'LJ 11/19/2017 10:07'!
initialize

	super initialize.
	addresses := OrderedCollection new.! !

!Customer methodsFor: 'initialization' stamp: 'LJ 11/20/2017 09:27'!
withFirstName: aFirstName lastName: aLastName identification: anIdentification
	super initialize.
	firstName := aFirstName.
	lastName := aLastName.
	identification := anIdentification.
	addresses := OrderedCollection new! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Customer class
	instanceVariableNames: ''!

!Customer class methodsFor: 'accessing' stamp: 'LJ 11/19/2017 16:29'!
withFirstName: aFirstName lastName: aLastName identification: anIdentification
	^ super new withFirstName: aFirstName lastName: aLastName identification: anIdentification! !


CustomerSystem subclass: #PersistentCustomerSystem
	instanceVariableNames: 'mappingSystem'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!PersistentCustomerSystem methodsFor: 'setup-teardown' stamp: 'LJ 11/13/2017 20:23'!
commit
	session commit.! !

!PersistentCustomerSystem methodsFor: 'setup-teardown' stamp: 'LJ 11/13/2017 20:22'!
beginTransaction
	session beginTransaction.! !

!PersistentCustomerSystem methodsFor: 'setup-teardown' stamp: 'LJ 11/21/2017 22:03'!
start
	session := DataBaseSession for: mappingSystem allMappings.
	session open! !

!PersistentCustomerSystem methodsFor: 'setup-teardown' stamp: 'LJ 11/13/2017 21:14'!
stop
	session close.! !


!PersistentCustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:03'!
allCustomersSize
	^ (session selectAllOfType: Customer) size.! !

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:00'!
addCustomer: aCustomer
	session addCustomer: aCustomer.! !

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'LJ 11/21/2017 22:03'!
initializeWith: aMappingSystem
	mappingSystem := aMappingSystem! !

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:05'!
allCustomersIsEmpty
	^ self allCustomersSize = 0.! !

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'LJ 11/22/2017 00:23'!
customerIdentifiedAs: anId
	| customers |
	customers := session
		select: [ :aCustomer | aCustomer isIdentifiedAs: anId]
		ofType: Customer.
	customers size = 0
		ifTrue: [ self error: CustomerSystem customerDoesNotExistError ].
	^ customers anyOne! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

PersistentCustomerSystem class
	instanceVariableNames: ''!

!PersistentCustomerSystem class methodsFor: 'as yet unclassified' stamp: 'LJ 11/21/2017 22:04'!
withSystemMapping: aSystemMapping
	^ self new initializeWith: aSystemMapping.! !


Party subclass: #Supplier
	instanceVariableNames: 'name customers'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!Supplier methodsFor: 'accessing' stamp: 'LJ 11/20/2017 20:17'!
initialize
	customers := OrderedCollection new.
	addresses := OrderedCollection new.! !

!Supplier methodsFor: 'accessing' stamp: 'LJ 11/19/2017 10:03'!
name
	^ name! !


!Supplier methodsFor: 'addresses-customers' stamp: 'LJ 11/19/2017 15:04'!
addCustomer: aCustomer
	^ customers add: aCustomer! !

!Supplier methodsFor: 'addresses-customers' stamp: 'LJ 11/19/2017 15:05'!
customersIsEmpty
	^ customers isEmpty! !

!Supplier methodsFor: 'addresses-customers' stamp: 'LJ 11/19/2017 15:03'!
numberOfCustomers
	^ customers size! !

!Supplier methodsFor: 'addresses-customers' stamp: 'LJ 11/20/2017 22:54'!
customerIdentifiedAs: anId ifNone: noneClosure 
	
	^customers detect: [ :aCustomer | aCustomer isIdentifiedAs: anId ] ifNone: noneClosure ! !


!Supplier methodsFor: 'initializing' stamp: 'LJ 11/20/2017 09:37'!
withName: aName identification: anIdentification
	name := aName.
	identification := anIdentification.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Supplier class
	instanceVariableNames: ''!

!Supplier class methodsFor: 'as yet unclassified' stamp: 'LJ 11/20/2017 09:37'!
withName: aName identification: anIdentification
	^ self new withName: aName identification: anIdentification.! !


TestCase subclass: #SupplierImportTest
	instanceVariableNames: 'session importer system testData'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!SupplierImportTest methodsFor: 'test-data' stamp: 'LJ 11/22/2017 00:24'!
customersIsEmpty
	^ system allCustomersIsEmpty.! !

!SupplierImportTest methodsFor: 'test-data' stamp: 'LJ 11/21/2017 23:45'!
suppliersIsEmpty
	^ system allSuppliersIsEmpty.! !


!SupplierImportTest methodsFor: 'tests' stamp: 'LJ 11/22/2017 00:38'!
testCanNotImportExistingCustomerWithMoreThanThreeFields
	self
		should: [ self
				importSuppliersFrom: testData existingCustomerWithMoreThanThreeFieldsTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals: ExistingCustomerLineImporter  invalidExistingCustomerRecordErrorDescription  .
			self assert: self customersIsEmpty  ]! !

!SupplierImportTest methodsFor: 'tests' stamp: 'LJ 11/21/2017 23:46'!
testCanNotImportSupplierRecordWithMoreThanFourFields
	self
		should: [ self
				importSuppliersFrom: testData supplierRecordWithMoreThanFourFieldsTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals: SupplierLineImporter invalidSupplierRecordErrorDescription .
			self assert: self suppliersIsEmpty ]! !

!SupplierImportTest methodsFor: 'tests' stamp: 'LJ 11/21/2017 23:58'!
testCanNotImportCustomerRecordWithSupplierImporter
	self
		should: [ self
				importSuppliersFrom:  testData alwaysImportedCustomerTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals: Importer invalidRecordTypeErrorDescription .
			self assert: self suppliersIsEmpty ]! !

!SupplierImportTest methodsFor: 'tests' stamp: 'LJ 11/22/2017 00:42'!
testCanNotImportNewCustomerWithLessThanFiveFields
	self
		should: [ self
				importSuppliersFrom: testData newCustomerWithLessThanFiveFieldsTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals:  NewCustomerLineImporter invalidNewCustomerRecordErrorDescription   .
			self assert: self customersIsEmpty  ]! !

!SupplierImportTest methodsFor: 'tests' stamp: 'LJ 11/22/2017 00:11'!
testCanNotImportExistingCustomerRecordWithoutSupplier
	self
		should: [ self importCustomersFrom: testData alwaysImportedCustomerTestData .
			self importSuppliersFrom:  testData existingCustomerWithoutSupplierTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals: Importer cantAddCustomerWithoutSupplierErrorDescription  .
			self assert: self suppliersIsEmpty ]! !

!SupplierImportTest methodsFor: 'tests' stamp: 'LJ 11/22/2017 00:38'!
testCanNotImportExistingCustomerWithLessThanThreeFields
	self
		should: [ self
				importSuppliersFrom: testData existingCustomerWithLessThanThreeFieldsTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals: ExistingCustomerLineImporter  invalidExistingCustomerRecordErrorDescription  .
			self assert: self customersIsEmpty  ]! !

!SupplierImportTest methodsFor: 'tests' stamp: 'LJ 11/22/2017 00:29'!
testCanNotImportInexistentCustomerAsExistingCustomerRecord
	self
		should: [	self importSuppliersFrom:  testData validSupplierTestData  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals: CustomerSystem customerDoesNotExistError .
			self assert: self alwaysImportedSupplier customersIsEmpty  ]! !

!SupplierImportTest methodsFor: 'tests' stamp: 'LJ 11/21/2017 23:55'!
testImportSupplier
	self importCustomersFrom: testData alwaysImportedCustomerTestData.
	self importSuppliersFrom: testData validSupplierTestData.
	self assertImportedSuppliersSizeIsCorrect.
	self assertImportedCustomersSizeIsCorrect.
	self assertSupplier1WasImportedCorrectly! !

!SupplierImportTest methodsFor: 'tests' stamp: 'LJ 11/22/2017 00:02'!
testCanNotImportAddressRecordWithoutSupplier
	self
		should: [ self
				importSuppliersFrom:  testData addressWithoutSupplierTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals: Importer addressWithoutPartyErrorDescription .
			self assert: self suppliersIsEmpty ]! !

!SupplierImportTest methodsFor: 'tests' stamp: 'LJ 11/21/2017 23:44'!
testCanNotImportSupplierRecordWithLessThanFourFields
	self
		should: [ self
				importSuppliersFrom: testData supplierRecordWithLessThanFourFieldsTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals: SupplierLineImporter invalidSupplierRecordErrorDescription .
			self assert: self suppliersIsEmpty ]! !

!SupplierImportTest methodsFor: 'tests' stamp: 'LJ 11/22/2017 00:43'!
testCanNotImportNewCustomerWithMoreThanFiveFields
	self
		should: [ self
				importSuppliersFrom: testData newCustomerWithMoreThanFiveFieldsTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals:  NewCustomerLineImporter invalidNewCustomerRecordErrorDescription   .
			self assert: self customersIsEmpty  ]! !

!SupplierImportTest methodsFor: 'tests' stamp: 'LJ 11/22/2017 00:10'!
testCanNotImportNewCustomerRecordWithoutSupplier
	self
		should: [ self
				importSuppliersFrom:  testData newCustomerWithoutSupplierTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self
				assert: anError messageText
				equals: Importer cantAddCustomerWithoutSupplierErrorDescription  .
			self assert: self suppliersIsEmpty ]! !


!SupplierImportTest methodsFor: 'test data - supplier' stamp: 'LJ 11/22/2017 00:26'!
alwaysImportedSupplier
	^ self
		supplierIdentifiedAs: testData alwaysImportedSupplierIdentification! !


!SupplierImportTest methodsFor: 'setup-teardown' stamp: 'LJ 11/21/2017 22:54'!
tearDown

	system commit.
	system stop.! !


!SupplierImportTest methodsFor: 'asserting' stamp: 'LJ 11/21/2017 23:27'!
assert: customer hasAddressAt: streetName number: streetNumber in: town zipCode: zipCode province: province

	| address |
	
	address := customer addressAt: streetName ifNone: [ self fail ].
	self assert: address streetName equals: streetName.
	self assert: address streetNumber equals: streetNumber.
	self assert: address town equals: town.
	self assert: address zipCode equals: zipCode.
	self assert: address province equals: province.
	! !

!SupplierImportTest methodsFor: 'asserting' stamp: 'LJ 11/21/2017 23:20'!
assertSupplierHasCorrectAddresses: aSupplier
	self assertPartyHasCorrectAddresses: aSupplier. ! !

!SupplierImportTest methodsFor: 'asserting' stamp: 'LJ 11/21/2017 23:19'!
assert: aSupplier isNamed: aName andIsIdentifiedAs: anId andNumberOfAddresses: aNumberOfAddresses andNumberOfCustomers: aNumberOfCustomers
	self assert: aSupplier name equals: aName.
	self assert: (aSupplier isIdentifiedAs: anId). 
	self assert: aSupplier numberOfAddresses equals: aNumberOfAddresses.
	self assert: aSupplier numberOfCustomers equals: aNumberOfCustomers.! !

!SupplierImportTest methodsFor: 'asserting' stamp: 'LJ 11/21/2017 23:20'!
assertSupplierHasCorrectCustomers: aSupplier
	| pepeSanchezIdentification patoLucasIdentification |
	pepeSanchezIdentification := Identification
		ofType: testData alwaysImportedCustomerIdType
		numbered: testData alwaysImportedCustomerIdNumber.
	patoLucasIdentification := Identification
		ofType: 'D'
		numbered: '1234'.
	self
		assert: aSupplier
		hasCustomerIdentifiedAs: pepeSanchezIdentification
		named: 'Pepe'
		lastName: 'Sanchez'.
	self
		assert: aSupplier
		hasCustomerIdentifiedAs: patoLucasIdentification
		named: 'Pato'
		lastName: 'Lucas'! !

!SupplierImportTest methodsFor: 'asserting' stamp: 'LJ 11/21/2017 23:26'!
assertSupplier1WasImportedCorrectly
		|supplier identification|
	
	identification := 	(Identification ofType: testData  alwaysImportedSupplierIdType  numbered: testData alwaysImportedSupplierNumber ).
	supplier := self supplierIdentifiedAs: identification .
	
	self assert: supplier 
		 isNamed: 'Supplier1'
		 andIsIdentifiedAs: identification
		 andNumberOfAddresses: 2
		 andNumberOfCustomers: 2.
		
	self assertSupplierHasCorrectAddresses: supplier.
	self assertSupplierHasCorrectCustomers: supplier.! !

!SupplierImportTest methodsFor: 'asserting' stamp: 'LJ 11/21/2017 23:27'!
assert: aSupplier hasCustomerIdentifiedAs: anId named: aName lastName: aLastName

	| customer |
	
	customer := aSupplier customerIdentifiedAs: anId ifNone: [ self fail ].
	self assert: (customer firstName) equals: aName.
	self assert: (customer lastName) equals: aLastName.
	! !

!SupplierImportTest methodsFor: 'asserting' stamp: 'LJ 11/21/2017 23:21'!
assert: customer isNamed: firstName lastName: lastName identfiedAs: idType withNumber: idNumber andNumberOfAddresses: addressesSize
	self assert: customer firstName equals: firstName.
	self assert: customer lastName equals: lastName.
	self assert: (customer isIdentifiedAs: (Identification ofType: idType numbered: idNumber)).
	self assert: customer numberOfAddresses equals: addressesSize! !

!SupplierImportTest methodsFor: 'asserting' stamp: 'LJ 11/21/2017 23:17'!
assertImportedSuppliersSizeIsCorrect
	self assert: system allSuppliersSize equals: 1! !

!SupplierImportTest methodsFor: 'asserting' stamp: 'LJ 11/21/2017 23:22'!
assertPartyHasCorrectAddresses: aParty
	self
		assert: aParty
		hasAddressAt: 'San Martin'
		number: 3322
		in: 'Olivos'
		zipCode: 1636
		province: 'BsAs'.
	self
		assert: aParty
		hasAddressAt: 'Maipu'
		number: 888
		in: 'Florida'
		zipCode: 1122
		province: 'Buenos Aires'! !

!SupplierImportTest methodsFor: 'asserting' stamp: 'LJ 11/21/2017 23:18'!
assertImportedCustomersSizeIsCorrect
	self assert: system allCustomersSize equals: 2! !


!SupplierImportTest methodsFor: 'importing' stamp: 'LJ 11/21/2017 23:14'!
importSuppliersFrom: inputStream

	(Importer from: inputStream on: system withLineImporters: (testData supplierLineImporters)) import! !

!SupplierImportTest methodsFor: 'importing' stamp: 'LJ 11/21/2017 23:53'!
importCustomersFrom: inputStream
	(Importer
		from: inputStream
		on: system
		withLineImporters: testData customerLineImporters) import! !

!SupplierImportTest methodsFor: 'importing' stamp: 'LJ 11/21/2017 23:23'!
supplierIdentifiedAs: anId
	^ system supplierIdentifiedAs: anId! !


!SupplierImportTest methodsFor: 'initialization' stamp: 'LJ 11/21/2017 23:03'!
setUp
	system := Environment current createErpSystem.
	system start.
	system beginTransaction.
	testData := ImporterTestData new.! !


LineImporter subclass: #SupplierLineImporter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!SupplierLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 22:06'!
importFrom: anImporter
	| record |
	record := anImporter record.
	self assertValidRecordSize: record.
	^ anImporter
		addSupplier:
			(Supplier
				withName: record second 
				identification: (Identification ofType: record third 
				numbered: record fourth)
				)! !

!SupplierLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:22'!
assertValidRecordSize: aRecord
	aRecord size ~= 4
		ifTrue: [ self signalInvalidRecord ]! !

!SupplierLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:23'!
signalInvalidRecord
	self error: self class invalidSupplierRecordErrorDescription
	! !

!SupplierLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 10:51'!
imports: aRecord
	^ aRecord first = 'S'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SupplierLineImporter class
	instanceVariableNames: ''!

!SupplierLineImporter class methodsFor: 'as yet unclassified' stamp: 'LJ 11/20/2017 11:23'!
invalidSupplierRecordErrorDescription
	^ 'Invalid supplier record'! !


Object subclass: #SupplierSystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!SupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:52'!
supplierIdentifiedAs: anId
	^ self subclassResponsibility! !

!SupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:34'!
allSuppliersIsEmpty
	self subclassResponsibility! !

!SupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:34'!
addSuplier: aSupplier
	self subclassResponsibility! !

!SupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:34'!
allSuppliersSize
	self subclassResponsibility! !


!SupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 15:31'!
commit
	^ self subclassResponsibility! !

!SupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 15:31'!
beginTransaction
	^ self subclassResponsibility.! !

!SupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 15:32'!
addSupplier: aSupplier
	^ self subclassResponsibility! !

!SupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 15:31'!
start
	^ self subclassResponsibility! !

!SupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 15:31'!
stop
	^ self subclassResponsibility! !


SupplierSystem subclass: #PersistentSupplierSystem
	instanceVariableNames: 'session mappingSystem'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!PersistentSupplierSystem methodsFor: 'mapping' stamp: 'LJ 11/19/2017 14:34'!
stop
	session close! !

!PersistentSupplierSystem methodsFor: 'mapping' stamp: 'LJ 11/19/2017 14:33'!
beginTransaction
	session beginTransaction! !

!PersistentSupplierSystem methodsFor: 'mapping' stamp: 'LJ 11/21/2017 22:02'!
start
	session := DataBaseSession for: mappingSystem allMappings.
	session open! !

!PersistentSupplierSystem methodsFor: 'mapping' stamp: 'LJ 11/19/2017 14:33'!
commit
	session commit! !


!PersistentSupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:38'!
allSuppliersSize
	^ (session selectAllOfType: Supplier) size! !

!PersistentSupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/21/2017 21:30'!
addSupplier: aSupplier
	session addCustomer:  aSupplier! !

!PersistentSupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:51'!
supplierIdentifiedAs: anId
	| suppliers |
	suppliers := session
		select: [ :aSupplier | aSupplier isIdentifiedAs: anId ]
		ofType: Supplier.
	suppliers size = 1
		ifFalse: [ self error: 'There should be just one client identified.' ].
	^ suppliers anyOne! !

!PersistentSupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/21/2017 22:03'!
initializeWith: aMappingSystem
	mappingSystem := aMappingSystem.! !

!PersistentSupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:37'!
allSuppliersIsEmpty
	^ self allSuppliersSize = 0! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

PersistentSupplierSystem class
	instanceVariableNames: ''!

!PersistentSupplierSystem class methodsFor: 'as yet unclassified' stamp: 'LJ 11/21/2017 22:02'!
withMappingSystem: aMappingSystem
	^ self new initializeWith: aMappingSystem.! !


CustomerSystem subclass: #TransientCustomerSystem
	instanceVariableNames: 'customers'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!TransientCustomerSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/13/2017 21:03'!
commit! !

!TransientCustomerSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/13/2017 21:02'!
beginTransaction! !

!TransientCustomerSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/13/2017 21:12'!
start
	customers := OrderedCollection new.! !

!TransientCustomerSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/13/2017 21:14'!
stop! !


!TransientCustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:00'!
addCustomer: aCustomer
	customers add: aCustomer.! !

!TransientCustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:03'!
allCustomersSize
	^ customers size.! !

!TransientCustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:06'!
allCustomersIsEmpty
	^ self allCustomersSize = 0.! !

!TransientCustomerSystem methodsFor: 'customers' stamp: 'LJ 11/22/2017 00:23'!
customerIdentifiedAs: anId
	| customer |
	customer := customers select: [ :aCustomer | aCustomer isIdentifiedAs: anId ].
	customer size = 0
		ifTrue: [ self error: CustomerSystem customerDoesNotExistError ].
	^ customer anyOne! !


SupplierSystem subclass: #TransientSupplierSystem
	instanceVariableNames: 'suppliers'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-2-Model'!

!TransientSupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/20/2017 22:21'!
supplierIdentifiedAs: anId
	| supplier |
	supplier := suppliers select: [ :aSupplier | aSupplier isIdentifiedAs: anId ].
	supplier size = 1
		ifFalse: [ self error: 'There should be just one supplier identified.' ].
	^ supplier anyOne! !

!TransientSupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:33'!
addSupplier: aSupplier
	suppliers add: aSupplier.! !

!TransientSupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:33'!
allSuppliersIsEmpty
	^ suppliers isEmpty.! !

!TransientSupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:33'!
allSuppliersSize
	^ suppliers size.! !


!TransientSupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 12:28'!
stop	! !

!TransientSupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 12:27'!
beginTransaction
	! !

!TransientSupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/20/2017 19:59'!
start
	suppliers := OrderedCollection new.
	! !

!TransientSupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 12:28'!
commit
! !
