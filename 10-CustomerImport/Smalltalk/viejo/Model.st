﻿Object subclass: #Address
	streetName := aStreetName.
	streetNumber := aStreetNumber.
	town := aTown.
	zipCode := aZipCode.
	province := aProvince.! !

	^town! !

	^province! !
	^streetName = aStreetName! !

	^zipCode! !

	^streetName ! !

	^streetNumber ! !
	^ super new withStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode province: aProvince.! !
	^ system allCustomersIsEmpty.! !

	^ ReadStream on: self alwaysImportedCustomerRecord,'
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !
	
	^ ReadStream on: self alwaysImportedCustomerRecord,'

A,San Martin,3322,Olivos,1636,BsAs'
! !

	^ ReadStream on: self alwaysImportedCustomerRecord, (String with: Character cr),	
NC,Pato,Lucas,D,1234
	^ system supplierIdentifiedAs: anId! !

	(Importer from: inputStream on: system withLineImporters: (OrderedCollection with: (AddressLineImporter new) with: (CustomerLineImporter new))) import! !
	^ system customerIdentifiedAs: anId! !

	(Importer from: inputStream on: system withLineImporters: (OrderedCollection with: (AddressLineImporter new) with: (CustomerLineImporter new) with: (ExistingCustomerLineImporter new)
	
	^ ReadStream on:'CC,Pepe,Sanchez,D,22333444'! !
	^ 'D'! !
	^ '123'! !
	
	^ ReadStream on: 'C,Pepe,Sanchez,D'! !
	
	^ ReadStream on: self alwaysImportedCustomerRecord,',x'! !
	^ self
		customerIdentifiedAs: (Identification ofType: (self alwaysImportedCustomerIdType) numbered: (self alwaysImportedCustomerIdNumber))! !

	^ 'S,Supplier1,', self alwaysImportedSupplierIdType, ',', self alwaysImportedSupplierIdNumber ! !
	^ 'D'! !
	^ '22333444'! !

	^ 'C,Pepe,Sanchez,', self alwaysImportedCustomerIdType, ',', self alwaysImportedCustomerIdNumber ! !
	system := Environment current createErpSystem.
	system start.
	system beginTransaction! !

	self 
		should: [ self importCustomersFrom: self addressRecordWithMoreThanSixFieldsTestData ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: anError messageText equals: AddressLineImporter invalidAddressRecordErrorDescription.
			self assert: self alwaysImportedCustomer addressesIsEmpty ]

	! !

	self 
		should: [ self importCustomersFrom: self addressRecordStartingWithMoreThanOneATestData ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: anError messageText equals: Importer invalidRecordTypeErrorDescription.
			self assert: self alwaysImportedCustomer addressesIsEmpty ]

	! !

	self importCustomersFrom: self validCustomerTestData.

	self assertImportedCustomersSizeIsCorrect.
	self assertPepeSanchezWasImportedCorrectly.
	self assertJuanPerezWasImportedCorrectly! !

	self 
		should: [ self importCustomersFrom: self customerRecordStartingWithMoreThanOneCTestData ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Importer invalidRecordTypeErrorDescription.
			self assert: self customersIsEmpty ]

	! !

	self 
		should: [ self importCustomersFrom: self customerRecordWithLessThanFiveFieldsTestData ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: anError messageText equals: CustomerLineImporter invalidCustomerRecordErrorDescription.
			self assert: self customersIsEmpty ]

	! !
	
	self
		should: [ self importCustomersFrom: self dataWithEmptyLine ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText equals: Importer invalidRecordTypeErrorDescription.
			self assert: self alwaysImportedCustomer addressesIsEmpty ]! !

	self 
		should: [ self importCustomersFrom: self addressWithoutCustomerTestData ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Importer addressWithoutCustomerErrorDescription.
			self assert: self customersIsEmpty ]

	! !
	self importSuppliersFrom: self validSupplierTestData .
	self assertImportedCustomersSizeIsCorrect.
	! !

	self 
		should: [ self importCustomersFrom: self customerRecordWithMoreThanFiveFieldsTestData ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: anError messageText equals: CustomerLineImporter invalidCustomerRecordErrorDescription.
			self assert: self customersIsEmpty ]

	! !
	
	self
		should: [ self importCustomersFrom: self addressRecordWithLessThanSixFieldsTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText equals: AddressLineImporter invalidAddressRecordErrorDescription.
			self assert: self alwaysImportedCustomer addressesIsEmpty ]! !
	
	^ ReadStream on: self alwaysImportedCustomerRecord,'
AA,San Martin,3322,Olivos,1636,BsAs'! !
	
	^ ReadStream on: 'A,San Martin,3322,Olivos,1636,BsAs'! !
	
	^ ReadStream on: self alwaysImportedCustomerRecord,'
A,San Martin,3322,Olivos,1636,BsAs,y otra cosa'! !
	
	^ ReadStream on: self alwaysImportedCustomerRecord,'
A,San Martin,3322,Olivos,1636'! !

	| address |
	
	address := customer addressAt: streetName ifNone: [ self fail ].
	self assert: address streetName equals: streetName.
	self assert: address streetNumber equals: streetNumber.
	self assert: address town equals: town.
	self assert: address zipCode equals: zipCode.
	self assert: address province equals: province.
	! !
	self assertPartyHasCorrectAddresses: aSupplier. ! !
	self assert: aSupplier hasCustomerIdentifiedAs: pepeSanchezIdentification named: 'Pepe' lastName: 'Sanchez'.
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
	

	| customer |
	
	customer := aSupplier customerIdentifiedAs: anId ifNone: [ self fail ].
	self assert: (customer firstName) equals: aName.
	! !
	
	| customer idType idNumber |
	
	idType := 'C'.
	idNumber := '23-25666777-9'.
	customer := self customerIdentifiedAs: (Identification ofType: idType numbered: 
	
	self assert: customer isNamed: 'Juan' lastName: 'Perez' identfiedAs: idType withNumber: idNumber andNumberOfAddresses: 1.
	self assert: customer hasAddressAt: 'Alem' number: 1122 in: 'CABA' zipCode: 1001 province: 'CABA'.
	! !
	self assert: customer firstName equals: firstName.
	self assert: customer lastName equals: lastName.
	self assert: (customer isIdentifiedAs: (Identification ofType: idType numbered: idNumber)).
	self assert: customer numberOfAddresses equals: addressesSize! !
	self assert: system allSuppliersSize equals: 1! !
	self assertPartyHasCorrectAddresses: aCustomer. ! !
	self assert: system allCustomersSize equals: 2! !
	self

	system commit.
	system stop.! !
	^ self subclassResponsibility.! !
	 ^ self subclassResponsibility .! !
	self subclassResponsibility.! !
	^ self subclassResponsibility! !
	^ self subclassResponsibility.! !
	^ self subclassResponsibility.! !
	^ self subclassResponsibility.! !
	^ self subclassResponsibility.! !
	^ self subclassResponsibility .! !
	^ self subclasses detect: [:aSubclass | aSubclass isCurrent ]  ifFound: [:aSubclass | aSubclass new ]  ifNone: [ self error: self noEnvironmentFoundErrorMessage ] .! !
	^ 'No environment found'! !
	^ self subclassResponsibility .! !
	^ ErpSystem withCustomerSystem: TransientCustomerSystem new supplierSystem: TransientSupplierSystem new.! !
	^ IntegrationEnvironment isCurrent not.! !
	customerSystem := aCustomerSystem.
	supplierSystem := aSupplierSystem.! !
	supplierSystem stop.
	customerSystem stop.! !
	customerSystem beginTransaction.
	supplierSystem beginTransaction.! !
	customerSystem start.
	supplierSystem start.! !
	customerSystem commit.
	supplierSystem commit.! !
	^ supplierSystem allSuppliersSize! !
	^ customerSystem allCustomersSize! !
	customerSystem addCustomer: aCustomer.! !
	supplierSystem addSupplier: aSupplier! !
	^ supplierSystem supplierIdentifiedAs: anIdentification! !
	^ customerSystem customerIdentifiedAs: anIdentification! !
	^ customerSystem allCustomersIsEmpty! !
	^ self new withCustomerSystem: aCustomerSystem supplierSystem: aSupplierSystem.! !
	identificationType := anIdentificationType.
	identificationNumber := anIdentificationNumber ! !
	^ identificationNumber! !
	^ identificationType.! !
	^ identificationType = anId identificationType and: [ identificationNumber = anId identificationNumber ]! !
	^ self new ofType: anIdentificationType numbered: anIdentificationNumber.! !
	^ record.! !

	self error: self class addressWithoutCustomerErrorDescription.! !

	self error: self class invalidRecordTypeErrorDescription! !

	record := line substrings: {$,}.
	
	self assertRecordNotEmpty! !
	lineImporters
		select: [ :aLineImporter | aLineImporter imports: record ]
		thenDo: [ :aLineImporter | aLineImporter importFrom: self ]
		ifNone: [ self signalInvalidRecordType ]! !
	"Tanto ac√° como en addCustomerWithIdentification ver si agregamos un chequeo antes que diga si la newParty es de tipo Supplier y si no explot√° (if o double dispatch, da lo mismo)"
	newParty addCustomer: aCustomer.
	newParty addCustomer: (system customerIdentifiedAs: anIdentification )

	! !

	line := readStream nextLine.
	^ line notNil! !
	
	record isEmpty ifTrue: [ self signalInvalidRecordType ]! !
	newParty := aSupplier.
	system addSupplier: aSupplier! !
	self assertThereIsPartyForAddress.
	newParty addAddress: anAddress! !
	newParty := aCustomer.
	system addCustomer: aCustomer! !

	[ self canImportNextLine ] whileTrue: [ 
		self convertLineToRecord.
		self importRecord ]! !

	newParty isNil ifTrue: [ self signalAddressWithoutPartyError ].
	! !
	readStream := aReadStream.
	system := aSession.
	lineImporters := alineImporterCollection! !
	^ self new initializeOn: aReadStream on: aSystem withLineImporters: aLineImporterCollection . ! !
	
	^'There is no Customer for the imported address'! !
	
	^'Invalid record type'! !
	^ ErpSystem withCustomerSystem: PersistentCustomerSystem new supplierSystem: PersistentSupplierSystem new.! !
	^ false! !
	^ self subclassResponsibility! !
	^ self subclassResponsibility! !
	^ self subclassResponsibility! !
	^self subclassResponsibility! !
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
	aRecord size ~= 6
		ifTrue: [ self signalInvalidRecord ]! !
	self error: self class invalidAddressRecordErrorDescription! !
	^ aRecord first = 'A'! !
	^ 'Invalid address record'! !
	| record |
	record := anImporter record.
	self assertValidRecordSize: record.
	anImporter
		addCustomer:
			(Customer
				withFirstName: record second
				lastName: record third
				identification: (Identification ofType: record fourth numbered: record fifth))! !
	self error: self class invalidCustomerRecordErrorDescription! !
	aRecord size ~= 5
		ifTrue: [ self signalInvalidRecord ]! !
	^ aRecord first = 'C'! !
	^ 'Invalid customer record'! !
	| record |
	record := anImporter record.
	self assertValidRecordSize: record.
	anImporter addExistingCustomerWithIdentification: (Identification ofType: record second numbered: record third)! !
	self error: self class invalidExistingCustomerRecordErrorDescription! !
	aRecord size ~= 3
		ifTrue: [ self signalInvalidRecord ]! !
	^ aRecord first = 'EC'! !
	^ 'Invalid existing customer record'! !
	| record |
	record := anImporter record.
	self assertValidRecordSize: record.
	anImporter
		addNewCustomer:
			(Customer
				withFirstName: record second
				lastName: record third
				identification: (Identification ofType: record fourth numbered: record fifth))! !
	self error: self class invalidNewCustomerRecordErrorDescription! !
	aRecord size ~= 5
		ifTrue: [ self signalInvalidRecord ]! !
	^ aRecord first = 'NC'! !
	^ 'Invalid new customer record'! !
	^ identification = anId.! !

	addresses add: anAddress ! !
	
	^addresses size! !
	
	^addresses detect: [ :anAddress | anAddress isAt: aStreetName ] ifNone: noneClosure ! !

	^ addresses! !
	
	^addresses isEmpty! !

	super initialize.
	addresses := OrderedCollection new.! !
	super initialize.
	firstName := aFirstName.
	lastName := aLastName.
	identification := anIdentification.
	addresses := OrderedCollection new! !

	^lastName ! !
	
	^firstName ! !
	^ super new withFirstName: aFirstName lastName: aLastName identification: anIdentification! !
	session commit.! !
	session beginTransaction.! !
	session := DataBaseSession for: (Array with: self addressMapping with: self customerMapping with: self idMapping ).
	session open! !
	session close.! !
	^ ClassMapping
		withDefaultTableNameFor: Identification
		mappingAll:
			(Array
				with: (EmbededMapping withDefaultFieldNameFor: #identificationType)
				with: (EmbededMapping withDefaultFieldNameFor: #identificationNumber)
				)! !
	^ ClassMapping
		withDefaultTableNameFor: Address
		mappingAll:
			(Array
				with: (EmbededMapping withDefaultFieldNameFor: #streetName)
				with: (EmbededMapping withDefaultFieldNameFor: #streetNumber)
				with: (EmbededMapping withDefaultFieldNameFor: #town)
				with: (EmbededMapping withDefaultFieldNameFor: #zipCode)
				with: (EmbededMapping withDefaultFieldNameFor: #province))! !
	^ ClassMapping
		withDefaultTableNameFor: Customer
		mappingAll:
			(Array
				with: (EmbededMapping withDefaultFieldNameFor: #firstName)
				with: (EmbededMapping withDefaultFieldNameFor: #lastName)
				with: (EmbededMapping withDefaultFieldNameFor: #identification)
				with: (OneToManyMapping withDefaultFieldNameFor: #addresses ofType: Address))! !
	session addCustomer: aCustomer.! !
	^ (session selectAllOfType: Customer) size.! !
	| customers |
	customers := session
		select: [ :aCustomer | aCustomer isIdentifiedAs: anId]
		ofType: Customer.
	customers size = 1
		ifFalse: [ self error: 'There should be just one client identified.' ].
	^ customers anyOne! !
	^ self allCustomersSize = 0.! !
	^ name! !
	^ customers add: aCustomer! !
	^ customers size! !
	^ customers isEmpty! !
	name := aName.
	identification := anIdentification.! !
	^ self new withName: aName identification: anIdentification.! !
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
	self error: self class invalidSupplierRecordErrorDescription
	! !
	aRecord size ~= 4
		ifTrue: [ self signalInvalidRecord ]! !
	^ aRecord first = 'S'! !
	^ 'Invalid supplier record'! !
	^ self subclassResponsibility! !
	^ self subclassResponsibility.! !
	^ self subclassResponsibility! !
	^ self subclassResponsibility! !
	^ self subclassResponsibility! !
	^ self subclassResponsibility! !
	self subclassResponsibility! !
	self subclassResponsibility! !
	self subclassResponsibility! !
	session commit! !
	session beginTransaction! !
	^ ClassMapping withDefaultTableNameFor: Supplier mappingAll: (Array with: (EmbededMapping withDefaultFieldNameFor: #name)
	
				with: (OneToManyMapping withDefaultFieldNameFor: #id ofType: Identification))! !
	session := DataBaseSession
		for: (Array with: self supplierMapping ).
	session open! !
	session close! !
	| suppliers |
	suppliers := session
		select: [ :aSupplier | aSupplier isIdentifiedAs: anId ]
		ofType: Supplier.
	suppliers size = 1
		ifFalse: [ self error: 'There should be just one client identified.' ].
	^ suppliers anyOne! !
	^ self allSuppliersSize = 0! !
	session addSupplier: aSupplier! !
	^ (session selectAllOfType: Supplier) size! !
	customers := OrderedCollection new.! !
	customers add: aCustomer.! !
	^ customers size.! !
	| customer |
	customer := customers select: [ :aCustomer | aCustomer isIdentifiedAs: anId ].
	customer size = 1
		ifFalse: [ self error: 'There should be just one client identified.' ].
	^ customer anyOne! !
	^ self allCustomersSize = 0.! !
	^ suppliers size.! !
	suppliers add: aSupplier.! !
	| supplier |
	supplier := suppliers select: [ :aSupplier | aSupplier isIdentifiedAs: anId ].
	supplier size = 1
		ifFalse: [ self error: 'There should be just one supplier identified.' ].
	^ supplier anyOne! !
	^ suppliers isEmpty.! !
	! !
	suppliers := OrderedCollection new.
	! !
! !