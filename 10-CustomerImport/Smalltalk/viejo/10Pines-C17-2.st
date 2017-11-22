Object subclass: #ClassMapping	instanceVariableNames: 'mappedClass mappings tableName'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-PersistanceModel'!!ClassMapping methodsFor: 'mapping - private' stamp: 'HernanWilkinson 11/1/2016 00:40'!mapEmbededOf: anObject into: record

	mappings do: [ :aMapping | aMapping embeded: anObject into: record ]! !!ClassMapping methodsFor: 'mapping - private' stamp: 'LJ 11/20/2017 18:11'!assertHasIdInstanceVariable: aClass 		(aClass classThatDefinesInstanceVariable: #id) ifNil: [ self error: ('<1s> has no id instance variable' expandMacrosWith: aClass name) ]! !!ClassMapping methodsFor: 'mapping - private' stamp: 'HernanWilkinson 11/1/2016 00:40'!mapOneToManyRelationshipsOf: anObject using: aDataBaseSession

	mappings do: [ :aMapping | aMapping mapOneToManyRelationshipsOf: anObject using: aDataBaseSession ]! !!ClassMapping methodsFor: 'mapping - private' stamp: 'HernanWilkinson 11/1/2016 00:43'!unmapIdOf: aRecord into: unMappedObject

	unMappedObject instVarNamed: #id put: (aRecord at: #id)! !!ClassMapping methodsFor: 'mapping - private' stamp: 'HernanWilkinson 11/1/2016 00:43'!unmap: aRecord into: unMappedObject using: aDataBaseSession

	mappings do: [ :aMapping | aMapping unmap: aRecord into: unMappedObject using: aDataBaseSession ]! !!ClassMapping methodsFor: 'mapping - private' stamp: 'HernanWilkinson 11/1/2016 00:40'!mapIdOf: anObject into: record using: aDataBaseSession

	| newId |

	newId := aDataBaseSession newIdFor: anObject.
	anObject instVarNamed: #id put: newId.
	record at: #id put: newId! !!ClassMapping methodsFor: 'testing' stamp: 'HernanWilkinson 10/31/2016 23:02'!isFor: aClass

	^mappedClass = aClass! !!ClassMapping methodsFor: 'table' stamp: 'HernanWilkinson 10/31/2016 23:25'!tableName
	
	^tableName ! !!ClassMapping methodsFor: 'initialization' stamp: 'HernanWilkinson 10/31/2016 23:25'!initializeFor: aClass into: aTableName mappingAll: aCollectionOfMappings

	mappedClass := aClass.
	tableName := aTableName.
	mappings := aCollectionOfMappings ! !!ClassMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 11/1/2016 00:40'!map: anObject using: aDataBaseSession

	| record |

	self toDo: 'se puede optimizar usando array para registros y guardando definicion de tabla una vez'.
	record := Dictionary new.
	
	self mapIdOf: anObject into: record using: aDataBaseSession.
	self mapEmbededOf: anObject into: record.
	"agrego aca el registro y no luego de mapear el id para que lo agrege completo. Lo agrego antes de mapear las rel one to many 
	porque si usuara una db de verdad habria foreign key constrain"
	aDataBaseSession add: record on: self tableName.
	self mapOneToManyRelationshipsOf: anObject using: aDataBaseSession! !!ClassMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 11/1/2016 00:42'!unmap: aRecord using: aDataBaseSession

	| unMappedObject |

	unMappedObject := mappedClass basicNew.
	self unmapIdOf: aRecord into: unMappedObject.
	self unmap: aRecord into: unMappedObject using: aDataBaseSession.

	^ unMappedObject! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!ClassMapping class	instanceVariableNames: ''!!ClassMapping class methodsFor: 'instance creation' stamp: 'HernanWilkinson 10/31/2016 23:24'!for: aClass into: aTableName mappingAll: aCollectionOfMappings

	self assertValidTableName: aTableName.
	self assertHasIdInstanceVariable: aClass.
	self assertValidMappings: aCollectionOfMappings for: aClass.
	
	^self new initializeFor: aClass into: aTableName mappingAll: aCollectionOfMappings


		! !!ClassMapping class methodsFor: 'instance creation' stamp: 'HernanWilkinson 11/1/2016 00:44'!defaultTableNameFor: aClass
	
	^aClass name asString! !!ClassMapping class methodsFor: 'instance creation' stamp: 'HernanWilkinson 10/31/2016 23:23'!withDefaultTableNameFor: aClass mappingAll: aCollectionOfMappings

	^self for: aClass into: (self defaultTableNameFor: aClass) mappingAll: aCollectionOfMappings

		! !!ClassMapping class methodsFor: 'assertions' stamp: 'HernanWilkinson 10/31/2016 23:41'!assertValidTableName: aTableName

	aTableName trimBoth isEmpty ifTrue: [ self error: 'Table name can not be empty' ]! !!ClassMapping class methodsFor: 'assertions' stamp: 'HernanWilkinson 10/31/2016 21:15'!assertHasIdInstanceVariable: aClass 
	
	(aClass hasInstVarNamed: #id) ifFalse: [ self error: ('<1s> has no id instance variable' expandMacrosWith: aClass name) ]! !!ClassMapping class methodsFor: 'assertions' stamp: 'HernanWilkinson 10/31/2016 19:26'!assertValidMappings: aCollectionOfMappings for: aClass 

	self toDo: 'Lo mejor seria recolectar todos los erroes de mapeo y no parar en el primero'.
	aCollectionOfMappings do: [ :aMapping | aMapping assertIsValidFor: aClass ]
	! !Object subclass: #DataBaseSession	instanceVariableNames: 'configuration tables id cache'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-PersistanceModel'!!DataBaseSession methodsFor: 'persistence - private' stamp: 'HernanWilkinson 10/28/2016 16:35'!defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !!DataBaseSession methodsFor: 'persistence - private' stamp: 'HernanWilkinson 10/28/2016 16:41'!delay

	(Delay forMilliseconds: 100) wait! !!DataBaseSession methodsFor: 'initialization' stamp: 'HernanWilkinson 10/31/2016 22:55'!initializeFor: aConfiguration

	configuration := aConfiguration.
	id := 0.

	tables := nil.
	cache := nil.! !!DataBaseSession methodsFor: 'transaction management' stamp: 'HernanWilkinson 10/31/2016 22:55'!assertNotInTransasction
	
	cache notNil ifTrue: [ self error: 'There is an open transaction already' ]! !!DataBaseSession methodsFor: 'transaction management' stamp: 'HernanWilkinson 10/31/2016 22:55'!assertInTransaction
	
	cache isNil ifTrue: [ self error: 'There is no transaction currently' ]! !!DataBaseSession methodsFor: 'transaction management' stamp: 'HernanWilkinson 10/31/2016 22:57'!beginTransaction

	self assertIsOpen.
	self assertNotInTransasction.
	
	cache := WeakKeyDictionary new.
	
! !!DataBaseSession methodsFor: 'transaction management' stamp: 'HernanWilkinson 10/31/2016 22:57'!commit
	
	self assertInTransaction.
	
	cache := nil! !!DataBaseSession methodsFor: 'id' stamp: 'HernanWilkinson 11/1/2016 01:04'!recordId: aRecord

	^aRecord at: #id! !!DataBaseSession methodsFor: 'id' stamp: 'HernanWilkinson 10/28/2016 16:35'!newIdFor: anObject

	id := id + 1.
	^id! !!DataBaseSession methodsFor: 'id' stamp: 'HernanWilkinson 11/1/2016 01:00'!idOf: anObject

	^anObject instVarNamed: #id! !!DataBaseSession methodsFor: 'selecting' stamp: 'HernanWilkinson 11/1/2016 01:15'!objectIdentifiedAs: anId ofType: aClass

	self assertInTransaction.
	self delay.
	
	^ cache at: anId ifAbsentPut: [ self unmapRecordIdentifiedAs: anId ofType: aClass ]! !!DataBaseSession methodsFor: 'selecting' stamp: 'HernanWilkinson 10/31/2016 22:17'!selectAllOfType: aClass 
	
	^self select: [ :anObject | true ] ofType: aClass! !!DataBaseSession methodsFor: 'selecting' stamp: 'HernanWilkinson 11/1/2016 01:26'!select: aCondition ofType: aClass

	| mapper table |

	self assertInTransaction.
	self delay.
	
	mapper := self mapperFor: aClass.
	table := tables at: mapper tableName ifAbsent: [ ^ #() ].
	
	^ table inject: OrderedCollection new into: [ :selected :record | self addInto: selected theOnesThatHold: aCondition unmapping: record with: mapper ]! !!DataBaseSession methodsFor: 'persistance' stamp: 'LJ 11/16/2017 19:00'!addCustomer: anObject

	| mapper |
	
	self assertInTransaction.
	self delay.
	
	mapper := self mapperFor: anObject class.
	mapper map: anObject using: self.
	
	self addToCache: anObject ! !!DataBaseSession methodsFor: 'adding - private' stamp: 'HernanWilkinson 11/1/2016 01:10'!relatedIdsOwnedBy: anOwner forType: aRelatedClass

	| relatedIds table |

	table := self relationTableFor: anOwner class relatedTo: aRelatedClass.
	relatedIds := self relatedIdOwnedBy: anOwner on: table.
	
	^ relatedIds! !!DataBaseSession methodsFor: 'adding - private' stamp: 'HernanWilkinson 11/1/2016 01:06'!relatedIdOwnedBy: anOwner on: table

	^ table at: (self idOf: anOwner) ifAbsentPut: [ Set new ]! !!DataBaseSession methodsFor: 'adding - private' stamp: 'HernanWilkinson 11/1/2016 01:00'!signalRelationAlreadyExistBetween: anOwner and: aRelated 

	self error: ('Relation between id <1s> of type <2s> and id <3s> of type <4s> already exist'
		expandMacrosWith: (self idOf: anOwner) printString
		with: anOwner class name
		with: (self idOf: aRelated) printString
		with: aRelated class name)! !!DataBaseSession methodsFor: 'adding - private' stamp: 'HernanWilkinson 11/1/2016 01:05'!assertRelationOwnedBy: anOwner isUniqueFor: aRelated identifiedAs: relatedId in: relatedIds

	(relatedIds includes: relatedId) ifTrue: [ self signalRelationAlreadyExistBetween: anOwner and: aRelated ]! !!DataBaseSession methodsFor: 'adding - private' stamp: 'HernanWilkinson 11/1/2016 01:03'!addRelated: aRelated ownedBy: anOwner

	| relatedIds relatedId |

	relatedIds := self relatedIdsOwnedBy: anOwner forType: aRelated class.
	relatedId := aRelated instVarNamed: #id.
	self assertRelationOwnedBy: anOwner isUniqueFor: aRelated identifiedAs: relatedId in: relatedIds.
	
	relatedIds add: relatedId! !!DataBaseSession methodsFor: 'adding - private' stamp: 'HernanWilkinson 11/1/2016 01:03'!add: aRecord on: aTableName

	| table existingRecord |

	table := self tableNamed: aTableName.
	existingRecord := table at: (self recordId: aRecord) ifAbsentPut: [ aRecord ].
	existingRecord == aRecord ifFalse: [ self error: 'Duplicated primary key' ]! !!DataBaseSession methodsFor: 'adding - private' stamp: 'HernanWilkinson 11/1/2016 01:27'!addToCache: anObject 

	cache at: (self idOf: anObject) put: anObject ! !!DataBaseSession methodsFor: 'tables - private' stamp: 'HernanWilkinson 11/1/2016 00:48'!tableNamed: aTableName

	^ tables at: aTableName ifAbsentPut: [ Dictionary new ]! !!DataBaseSession methodsFor: 'tables - private' stamp: 'HernanWilkinson 11/1/2016 01:12'!relationTableFor: anOwnerClass relatedTo: aRelatedClass

	| relationTableName table |

	relationTableName := self relationTableNameOwnedBy: anOwnerClass relatedTo: aRelatedClass.
	table := self tableNamed: relationTableName.
	
	^ table! !!DataBaseSession methodsFor: 'tables - private' stamp: 'HernanWilkinson 11/1/2016 01:12'!relationTableNameOwnedBy: anOwnerClass relatedTo: aRelatedClass

	| ownerClassMapper relatedClassMapper |
	
	ownerClassMapper := self mapperFor: anOwnerClass.
	relatedClassMapper := self mapperFor: aRelatedClass.
	
	^ownerClassMapper tableName,'_', relatedClassMapper tableName asPlural.! !!DataBaseSession methodsFor: 'selecting - private' stamp: 'HernanWilkinson 11/1/2016 01:28'!addInto: selected theOnesThatHold: aCondition unmapping: record with: mapper

	| recordId aClassInstance |

	recordId := self recordId: record.
	aClassInstance := cache at: recordId ifAbsent: [ mapper unmap: record using: self ].
	(aCondition value: aClassInstance) ifTrue: [ 
		self addToCache: aClassInstance.
		selected add: aClassInstance ].
	
	^ selected! !!DataBaseSession methodsFor: 'open/close' stamp: 'HernanWilkinson 10/31/2016 18:36'!open

	self assertIsClose.
	
	tables := Dictionary new.
	! !!DataBaseSession methodsFor: 'open/close' stamp: 'HernanWilkinson 10/31/2016 18:37'!assertIsClose
	
	tables isNil ifFalse: [ self error: 'Session must be close' ]! !!DataBaseSession methodsFor: 'open/close' stamp: 'HernanWilkinson 10/31/2016 22:14'!close

	self assertIsOpen.
	
	tables := nil! !!DataBaseSession methodsFor: 'open/close' stamp: 'HernanWilkinson 10/31/2016 18:36'!assertIsOpen
	
	tables isNil ifTrue: [ self error: 'Session must be open to colaborate with it' ]! !!DataBaseSession methodsFor: 'mapping - private' stamp: 'HernanWilkinson 11/1/2016 01:14'!mapperFor: aClass

	self toDo: 'se puede mejorar performanco usando un dictionary'.
	^configuration
		detect: [ :aClassMapper | aClassMapper isFor: aClass ] 
		ifNone: [ self error: ('There is no mapper for <1s>' expandMacrosWith: aClass name) ]! !!DataBaseSession methodsFor: 'mapping - private' stamp: 'HernanWilkinson 11/1/2016 01:16'!unmapRecordIdentifiedAs: anId ofType: aClass

	| record table mapper |

	mapper := self mapperFor: aClass.
	table := self tableNamed: mapper tableName.
	record := table at: id ifAbsent: [ self error: ('Object identified as <1s> does not exist' expandMacrosWith: anId printString) ].
	
	^ mapper unmap: record using: self! !!DataBaseSession methodsFor: 'mapping - private' stamp: 'HernanWilkinson 11/1/2016 01:15'!relatedOfType: aRelatedClass for: anOwner

	| table relatedIds |
	
	table := self relationTableFor: anOwner class relatedTo: aRelatedClass.
	relatedIds := table at: (self idOf: anOwner) ifAbsent: [ ^#() ].
	
	^relatedIds collect: [ :aRelatedId | self objectIdentifiedAs: aRelatedId ofType: aRelatedClass ]
	

	! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!DataBaseSession class	instanceVariableNames: ''!!DataBaseSession class methodsFor: 'instance creation' stamp: 'HernanWilkinson 10/28/2016 13:07'!for: aConfiguration

	^self new initializeFor: aConfiguration! !Object subclass: #Mapping	instanceVariableNames: 'instanceVariableName'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-PersistanceModel'!!Mapping methodsFor: 'assertions' stamp: 'LJ 11/20/2017 18:11'!assertIsValidFor: aClass 	(aClass classThatDefinesInstanceVariable: instanceVariableName) ifNil: [ 		self error: ('Invalid mapping for <1s> in class <2s>' expandMacrosWith: instanceVariableName with: aClass name) ] 	! !!Mapping methodsFor: 'mapping' stamp: 'HernanWilkinson 10/31/2016 23:26'!embeded: anObject into: aRecord
	self subclassResponsibility! !!Mapping methodsFor: 'mapping' stamp: 'HernanWilkinson 10/31/2016 23:26'!mapOneToManyRelationshipsOf: anObject using: aDataBaseSession
	self subclassResponsibility! !!Mapping methodsFor: 'mapping' stamp: 'HernanWilkinson 10/31/2016 23:26'!unmap: aRecord into: anObject using: aDataBaseSession
	self subclassResponsibility! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Mapping class	instanceVariableNames: ''!!Mapping class methodsFor: 'instance creation' stamp: 'HernanWilkinson 11/1/2016 01:32'!defaultFieldNameFor: anInstanceVariableName

	^anInstanceVariableName asString! !!Mapping class methodsFor: 'assertions' stamp: 'HernanWilkinson 10/31/2016 23:41'!assertValidFieldName: aFieldName

	aFieldName trimBoth isEmpty ifTrue: [ self error: 'Field name can not be empty' ]! !Mapping subclass: #EmbededMapping	instanceVariableNames: 'fieldName'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-PersistanceModel'!!EmbededMapping methodsFor: 'initialization' stamp: 'HernanWilkinson 10/31/2016 23:30'!initializeFor: anInstanceVariableName into: aFieldName

	instanceVariableName := anInstanceVariableName.
	fieldName := aFieldName ! !!EmbededMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 10/31/2016 23:31'!embeded: anObject into: aRecord

	aRecord at: fieldName put: (anObject instVarNamed: instanceVariableName) ! !!EmbededMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 10/31/2016 21:23'!mapOneToManyRelationshipsOf: anObject using: aDataBaseSession 
	
	! !!EmbededMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 10/31/2016 23:31'!unmap: aRecord into: anObject using: aDataBaseSession 

	anObject instVarNamed: instanceVariableName put: (aRecord at: fieldName)! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!EmbededMapping class	instanceVariableNames: ''!!EmbededMapping class methodsFor: 'instance creation' stamp: 'HernanWilkinson 10/31/2016 23:30'!for: anInstanceVariableName into: aFieldName

	^self new initializeFor: anInstanceVariableName into: aFieldName ! !!EmbededMapping class methodsFor: 'instance creation' stamp: 'HernanWilkinson 10/31/2016 23:29'!withDefaultFieldNameFor: anInstanceVariableName

	^self for: anInstanceVariableName into: (self defaultFieldNameFor: anInstanceVariableName)! !Mapping subclass: #OneToManyMapping	instanceVariableNames: 'relatedType fieldName'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-PersistanceModel'!!OneToManyMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 11/1/2016 01:37'!unmap: aRecord into: anObject using: aDataBaseSession

	| newCollection related |

	related := aDataBaseSession relatedOfType: relatedType for: anObject.
	newCollection := self createRelationCollectionOn: aDataBaseSession ownedBy: anObject.

	newCollection addAllNotPersisting: related.
	anObject instVarNamed: instanceVariableName put: newCollection! !!OneToManyMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 10/31/2016 21:16'!embeded: anObject into: aRecord
	! !!OneToManyMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 11/1/2016 01:37'!mapOneToManyRelationshipsOf: anObject using: aDataBaseSession

	| oldCollection newCollection |

	newCollection := self createRelationCollectionOn: aDataBaseSession ownedBy: anObject.
	oldCollection := anObject instVarNamed: instanceVariableName.
	
	newCollection addAll: oldCollection.
	anObject instVarNamed: instanceVariableName put: newCollection! !!OneToManyMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 11/1/2016 01:35'!createRelationCollectionOn: aDataBaseSession ownedBy: anObject
	^ OneToManySet on: aDataBaseSession ownedBy: anObject! !!OneToManyMapping methodsFor: 'initialization' stamp: 'HernanWilkinson 10/31/2016 23:34'!initializeFor: anInstanceVariableName into: aFieldName ofType: aClass

	instanceVariableName := anInstanceVariableName.
	fieldName := aFieldName.
	relatedType := aClass ! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!OneToManyMapping class	instanceVariableNames: ''!!OneToManyMapping class methodsFor: 'instance creation' stamp: 'HernanWilkinson 10/31/2016 23:40'!for: anInstanceVariableName into: aFieldName ofType: aClass

	self assertValidFieldName: aFieldName.
	
	^self new initializeFor: anInstanceVariableName into: aFieldName ofType: aClass! !!OneToManyMapping class methodsFor: 'instance creation' stamp: 'HernanWilkinson 10/31/2016 23:32'!withDefaultFieldNameFor: anInstanceVariableName ofType: aClass

	^self for: anInstanceVariableName into: (self defaultFieldNameFor: anInstanceVariableName) ofType: aClass! !Set subclass: #OneToManySet	instanceVariableNames: 'session owner'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-PersistanceModel'!!OneToManySet methodsFor: 'removing' stamp: 'HernanWilkinson 10/31/2016 21:35'!remove: anObject ifAbsent: anAbsentBlock

	self shouldBeImplemented ! !!OneToManySet methodsFor: 'initialization' stamp: 'HernanWilkinson 11/1/2016 00:11'!initializeOn: aDataBaseSession ownedBy: anOwner
	
	session := aDataBaseSession.
	owner := anOwner ! !!OneToManySet methodsFor: 'adding' stamp: 'HernanWilkinson 11/1/2016 00:03'!addAllNotPersisting: aCollection 
	
	^aCollection do: [ :anObjectToAdd | super add: anObjectToAdd ]! !!OneToManySet methodsFor: 'adding' stamp: 'LJ 11/16/2017 19:00'!add: anObject

	session addCustomer: anObject.
	session addRelated: anObject ownedBy: owner.
	
	super add: anObject.
! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!OneToManySet class	instanceVariableNames: ''!!OneToManySet class methodsFor: 'instance creation' stamp: 'HernanWilkinson 11/1/2016 00:11'!on: aDataBaseSession ownedBy: anOwner
	
	^self new initializeOn: aDataBaseSession ownedBy: anOwner ! !Object subclass: #Address	instanceVariableNames: 'id streetName streetNumber town zipCode province'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!Address methodsFor: 'instance creation' stamp: 'LJ 11/19/2017 10:26'!withStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode province: aProvince
	streetName := aStreetName.
	streetNumber := aStreetNumber.
	town := aTown.
	zipCode := aZipCode.
	province := aProvince.! !!Address methodsFor: 'twon' stamp: 'HernanWilkinson 10/28/2016 16:12'!town

	^town! !!Address methodsFor: 'province' stamp: 'HernanWilkinson 10/28/2016 16:11'!province

	^province! !!Address methodsFor: 'province' stamp: 'LJ 11/19/2017 10:27'!isAt: aStreetName
	^streetName = aStreetName! !!Address methodsFor: 'zip code' stamp: 'HernanWilkinson 10/28/2016 16:13'!zipCode

	^zipCode! !!Address methodsFor: 'street' stamp: 'HernanWilkinson 10/28/2016 16:12'!streetName

	^streetName ! !!Address methodsFor: 'street' stamp: 'HernanWilkinson 10/28/2016 16:12'!streetNumber

	^streetNumber ! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Address class	instanceVariableNames: ''!!Address class methodsFor: 'instance creation' stamp: 'LJ 11/19/2017 10:22'!withStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode province: aProvince 
	^ super new withStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode province: aProvince.! !TestCase subclass: #CustomerImportTest	instanceVariableNames: 'session importer system'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!CustomerImportTest methodsFor: 'test data' stamp: 'LJ 11/16/2017 19:07'!customersIsEmpty
	^ system allCustomersIsEmpty.! !!CustomerImportTest methodsFor: 'test data' stamp: 'LJ 11/20/2017 19:44'!validCustomerTestData

	^ ReadStream on: self alwaysImportedCustomerRecord,'
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !!CustomerImportTest methodsFor: 'test data' stamp: 'HernanWilkinson 11/2/2016 15:52'!dataWithEmptyLine
	
	^ ReadStream on: self alwaysImportedCustomerRecord,'

A,San Martin,3322,Olivos,1636,BsAs'
! !!CustomerImportTest methodsFor: 'test data' stamp: 'LJ 11/20/2017 22:49'!validSupplierTestData

	^ ReadStream on: self alwaysImportedCustomerRecord, (String with: Character cr),							  self alwaysImportedSuplierRecord,'
NC,Pato,Lucas,D,1234EC,', self alwaysImportedCustomerIdType, ',', self alwaysImportedCustomerIdNumber,'A,San Martin,3322,Olivos,1636,BsAsA,Maipu,888,Florida,1122,Buenos Aires'! !!CustomerImportTest methodsFor: 'importing' stamp: 'LJ 11/20/2017 22:11'!supplierIdentifiedAs: anId
	^ system supplierIdentifiedAs: anId! !!CustomerImportTest methodsFor: 'importing' stamp: 'LJ 11/20/2017 19:43'!importCustomersFrom: inputStream

	(Importer from: inputStream on: system withLineImporters: (OrderedCollection with: (AddressLineImporter new) with: (CustomerLineImporter new))) import! !!CustomerImportTest methodsFor: 'importing' stamp: 'LJ 11/20/2017 21:58'!customerIdentifiedAs: anId
	^ system customerIdentifiedAs: anId! !!CustomerImportTest methodsFor: 'importing' stamp: 'LJ 11/20/2017 19:44'!importSuppliersFrom: inputStream

	(Importer from: inputStream on: system withLineImporters: (OrderedCollection with: (AddressLineImporter new) with: (CustomerLineImporter new) with: (ExistingCustomerLineImporter new)	with: (NewCustomerLineImporter new) with: (SupplierLineImporter new))) import! !!CustomerImportTest methodsFor: 'test data - customer' stamp: 'HernanWilkinson 11/1/2016 17:48'!customerRecordStartingWithMoreThanOneCTestData
	
	^ ReadStream on:'CC,Pepe,Sanchez,D,22333444'! !!CustomerImportTest methodsFor: 'test data - customer' stamp: 'LJ 11/20/2017 19:47'!alwaysImportedSupplierIdType
	^ 'D'! !!CustomerImportTest methodsFor: 'test data - customer' stamp: 'LJ 11/20/2017 19:47'!alwaysImportedSupplierIdNumber
	^ '123'! !!CustomerImportTest methodsFor: 'test data - customer' stamp: 'HernanWilkinson 11/2/2016 10:50'!customerRecordWithLessThanFiveFieldsTestData
	
	^ ReadStream on: 'C,Pepe,Sanchez,D'! !!CustomerImportTest methodsFor: 'test data - customer' stamp: 'HernanWilkinson 11/2/2016 10:53'!customerRecordWithMoreThanFiveFieldsTestData
	
	^ ReadStream on: self alwaysImportedCustomerRecord,',x'! !!CustomerImportTest methodsFor: 'test data - customer' stamp: 'LJ 11/20/2017 22:06'!alwaysImportedCustomer
	^ self
		customerIdentifiedAs: (Identification ofType: (self alwaysImportedCustomerIdType) numbered: (self alwaysImportedCustomerIdNumber))! !!CustomerImportTest methodsFor: 'test data - customer' stamp: 'LJ 11/20/2017 19:47'!alwaysImportedSuplierRecord

	^ 'S,Supplier1,', self alwaysImportedSupplierIdType, ',', self alwaysImportedSupplierIdNumber ! !!CustomerImportTest methodsFor: 'test data - customer' stamp: 'HernanWilkinson 11/2/2016 10:46'!alwaysImportedCustomerIdType
	^ 'D'! !!CustomerImportTest methodsFor: 'test data - customer' stamp: 'HernanWilkinson 11/2/2016 10:47'!alwaysImportedCustomerIdNumber
	^ '22333444'! !!CustomerImportTest methodsFor: 'test data - customer' stamp: 'HernanWilkinson 11/2/2016 10:47'!alwaysImportedCustomerRecord

	^ 'C,Pepe,Sanchez,', self alwaysImportedCustomerIdType, ',', self alwaysImportedCustomerIdNumber ! !!CustomerImportTest methodsFor: 'initialization' stamp: 'LJ 11/19/2017 11:47'!setUp
	system := Environment current createErpSystem.
	system start.
	system beginTransaction! !!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/20/2017 11:01'!testCanNotImportAddressRecordWithMoreThanSixFields

	self 
		should: [ self importCustomersFrom: self addressRecordWithMoreThanSixFieldsTestData ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: anError messageText equals: AddressLineImporter invalidAddressRecordErrorDescription.
			self assert: self alwaysImportedCustomer addressesIsEmpty ]

	! !!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/20/2017 11:27'!testShouldNotImportAddressRecordsStartingWithMoreThanA

	self 
		should: [ self importCustomersFrom: self addressRecordStartingWithMoreThanOneATestData ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: anError messageText equals: Importer invalidRecordTypeErrorDescription.
			self assert: self alwaysImportedCustomer addressesIsEmpty ]

	! !!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/20/2017 19:44'!testImportCustomers

	self importCustomersFrom: self validCustomerTestData.

	self assertImportedCustomersSizeIsCorrect.
	self assertPepeSanchezWasImportedCorrectly.
	self assertJuanPerezWasImportedCorrectly! !!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/20/2017 11:27'!testShouldNotImportCustomerRecordsStartingWithMoreThanC

	self 
		should: [ self importCustomersFrom: self customerRecordStartingWithMoreThanOneCTestData ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Importer invalidRecordTypeErrorDescription.
			self assert: self customersIsEmpty ]

	! !!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/20/2017 10:42'!testCanNotImportCustomerRecordWithLessThanFiveFields

	self 
		should: [ self importCustomersFrom: self customerRecordWithLessThanFiveFieldsTestData ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: anError messageText equals: CustomerLineImporter invalidCustomerRecordErrorDescription.
			self assert: self customersIsEmpty ]

	! !!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/20/2017 11:27'!testEmptyLinesAreRecognizedAsInvalidRecords
	
	self
		should: [ self importCustomersFrom: self dataWithEmptyLine ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText equals: Importer invalidRecordTypeErrorDescription.
			self assert: self alwaysImportedCustomer addressesIsEmpty ]! !!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/20/2017 11:27'!testCanNotImportAddressWithoutCustomer

	self 
		should: [ self importCustomersFrom: self addressWithoutCustomerTestData ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Importer addressWithoutCustomerErrorDescription.
			self assert: self customersIsEmpty ]

	! !!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/20/2017 22:36'!testImportSupplier
	self importSuppliersFrom: self validSupplierTestData .		self assertImportedSuppliersSizeIsCorrect.	
	self assertImportedCustomersSizeIsCorrect.		self assertSupplier1WasImportedCorrectly.	
	! !!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/20/2017 10:42'!testCanNotImportCustomerRecordWithMoreThanFiveFields

	self 
		should: [ self importCustomersFrom: self customerRecordWithMoreThanFiveFieldsTestData ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: anError messageText equals: CustomerLineImporter invalidCustomerRecordErrorDescription.
			self assert: self customersIsEmpty ]

	! !!CustomerImportTest methodsFor: 'testing' stamp: 'LJ 11/20/2017 11:01'!testCanNotImportAddressRecordWithLessThanSixFields
	
	self
		should: [ self importCustomersFrom: self addressRecordWithLessThanSixFieldsTestData ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText equals: AddressLineImporter invalidAddressRecordErrorDescription.
			self assert: self alwaysImportedCustomer addressesIsEmpty ]! !!CustomerImportTest methodsFor: 'test data - address' stamp: 'HernanWilkinson 11/2/2016 10:45'!addressRecordStartingWithMoreThanOneATestData
	
	^ ReadStream on: self alwaysImportedCustomerRecord,'
AA,San Martin,3322,Olivos,1636,BsAs'! !!CustomerImportTest methodsFor: 'test data - address' stamp: 'HernanWilkinson 11/1/2016 15:59'!addressWithoutCustomerTestData
	
	^ ReadStream on: 'A,San Martin,3322,Olivos,1636,BsAs'! !!CustomerImportTest methodsFor: 'test data - address' stamp: 'HernanWilkinson 11/2/2016 10:45'!addressRecordWithMoreThanSixFieldsTestData
	
	^ ReadStream on: self alwaysImportedCustomerRecord,'
A,San Martin,3322,Olivos,1636,BsAs,y otra cosa'! !!CustomerImportTest methodsFor: 'test data - address' stamp: 'HernanWilkinson 11/2/2016 10:45'!addressRecordWithLessThanSixFieldsTestData
	
	^ ReadStream on: self alwaysImportedCustomerRecord,'
A,San Martin,3322,Olivos,1636'! !!CustomerImportTest methodsFor: 'asserting' stamp: 'HernanWilkinson 11/1/2016 11:00'!assert: customer hasAddressAt: streetName number: streetNumber in: town zipCode: zipCode province: province

	| address |
	
	address := customer addressAt: streetName ifNone: [ self fail ].
	self assert: address streetName equals: streetName.
	self assert: address streetNumber equals: streetNumber.
	self assert: address town equals: town.
	self assert: address zipCode equals: zipCode.
	self assert: address province equals: province.
	! !!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 22:39'!assertSupplierHasCorrectAddresses: aSupplier
	self assertPartyHasCorrectAddresses: aSupplier. ! !!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 22:38'!assert: aSupplier isNamed: aName andIsIdentifiedAs: anId andNumberOfAddresses: aNumberOfAddresses andNumberOfCustomers: aNumberOfCustomers	self assert: aSupplier name equals: aName.	self assert: (aSupplier isIdentifiedAs: anId). 	self assert: aSupplier numberOfAddresses equals: aNumberOfAddresses.	self assert: aSupplier numberOfCustomers equals: aNumberOfCustomers.! !!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 22:59'!assertSupplierHasCorrectCustomers: aSupplier	|pepeSanchezIdentification patoLucasIdentification|		pepeSanchezIdentification := Identification ofType: self alwaysImportedCustomerIdType  numbered: self alwaysImportedCustomerIdNumber.	patoLucasIdentification := Identification ofType: 'D' numbered: '1234'. 	
	self assert: aSupplier hasCustomerIdentifiedAs: pepeSanchezIdentification named: 'Pepe' lastName: 'Sanchez'.	self assert: aSupplier hasCustomerIdentifiedAs: patoLucasIdentification named: 'Pato' lastName: 'Lucas'.! !!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 22:38'!assertSupplier1WasImportedCorrectly		|supplier identification|		identification := 	(Identification ofType: self alwaysImportedSupplierIdType  numbered: self alwaysImportedSupplierIdNumber ).	supplier := self supplierIdentifiedAs: identification .		self assert: supplier 		 isNamed: 'Supplier1'		 andIsIdentifiedAs: identification		 andNumberOfAddresses: 2		 andNumberOfCustomers: 2.			self assertSupplierHasCorrectAddresses: supplier.	self assertSupplierHasCorrectCustomers: supplier.! !!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 22:25'!assertPepeSanchezWasImportedCorrectly
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
		self assertCustomerHasCorrectAddresses: customer.! !!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 22:58'!assert: aSupplier hasCustomerIdentifiedAs: anId named: aName lastName: aLastName

	| customer |
	
	customer := aSupplier customerIdentifiedAs: anId ifNone: [ self fail ].
	self assert: (customer firstName) equals: aName.	self assert: (customer lastName) equals: aLastName.
	! !!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 22:06'!assertJuanPerezWasImportedCorrectly
	
	| customer idType idNumber |
	
	idType := 'C'.
	idNumber := '23-25666777-9'.
	customer := self customerIdentifiedAs: (Identification ofType: idType numbered: idNumber).
	
	self assert: customer isNamed: 'Juan' lastName: 'Perez' identfiedAs: idType withNumber: idNumber andNumberOfAddresses: 1.
	self assert: customer hasAddressAt: 'Alem' number: 1122 in: 'CABA' zipCode: 1001 province: 'CABA'.
	! !!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 22:15'!assert: customer isNamed: firstName lastName: lastName identfiedAs: idType withNumber: idNumber andNumberOfAddresses: addressesSize
	self assert: customer firstName equals: firstName.
	self assert: customer lastName equals: lastName.
	self assert: (customer isIdentifiedAs: (Identification ofType: idType numbered: idNumber)).
	self assert: customer numberOfAddresses equals: addressesSize! !!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 19:50'!assertImportedSuppliersSizeIsCorrect
	self assert: system allSuppliersSize equals: 1! !!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 22:26'!assertCustomerHasCorrectAddresses: aCustomer
	self assertPartyHasCorrectAddresses: aCustomer. ! !!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/16/2017 19:03'!assertImportedCustomersSizeIsCorrect
	self assert: system allCustomersSize equals: 2! !!CustomerImportTest methodsFor: 'asserting' stamp: 'LJ 11/20/2017 22:27'!assertPartyHasCorrectAddresses: aParty
	self		assert: aParty		hasAddressAt: 'San Martin'		number: 3322		in: 'Olivos'		zipCode: 1636		province: 'BsAs'.	self		assert: aParty		hasAddressAt: 'Maipu'		number: 888		in: 'Florida'		zipCode: 1122		province: 'Buenos Aires'! !!CustomerImportTest methodsFor: 'setup-teardown' stamp: 'LJ 11/13/2017 21:13'!tearDown

	system commit.
	system stop.! !Object subclass: #CustomerSystem	instanceVariableNames: 'session'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!CustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:00'!addCustomer: aCustomer
	^ self subclassResponsibility.! !!CustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:02'!allCustomersSize
	 ^ self subclassResponsibility .! !!CustomerSystem methodsFor: 'customers' stamp: 'LJ 11/19/2017 15:52'!customerIdentifiedAs: anId
	self subclassResponsibility.! !!CustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:05'!allCustomersIsEmpty
	^ self subclassResponsibility! !!CustomerSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/13/2017 21:14'!stop
	^ self subclassResponsibility.! !!CustomerSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/13/2017 20:52'!beginTransaction
	^ self subclassResponsibility.! !!CustomerSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/13/2017 20:51'!start
	^ self subclassResponsibility.! !!CustomerSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/13/2017 20:51'!commit
	^ self subclassResponsibility.! !Object subclass: #Environment	instanceVariableNames: ''	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!Environment methodsFor: 'as yet unclassified' stamp: 'LJ 11/19/2017 11:47'!createErpSystem
	^ self subclassResponsibility .! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Environment class	instanceVariableNames: ''!!Environment class methodsFor: 'accessing' stamp: 'LJ 11/13/2017 20:43'!current
	^ self subclasses detect: [:aSubclass | aSubclass isCurrent ]  ifFound: [:aSubclass | aSubclass new ]  ifNone: [ self error: self noEnvironmentFoundErrorMessage ] .! !!Environment class methodsFor: 'as yet unclassified' stamp: 'LJ 11/13/2017 20:39'!noEnvironmentFoundErrorMessage
	^ 'No environment found'! !!Environment class methodsFor: 'testing' stamp: 'LJ 11/13/2017 20:41'!isCurrent
	^ self subclassResponsibility .! !Environment subclass: #DevelopmentEnvironment	instanceVariableNames: ''	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!DevelopmentEnvironment methodsFor: 'as yet unclassified' stamp: 'LJ 11/19/2017 11:52'!createErpSystem
	^ ErpSystem withCustomerSystem: TransientCustomerSystem new supplierSystem: TransientSupplierSystem new.! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!DevelopmentEnvironment class	instanceVariableNames: ''!!DevelopmentEnvironment class methodsFor: 'testing' stamp: 'LJ 11/13/2017 20:41'!isCurrent
	^ IntegrationEnvironment isCurrent not.! !Object subclass: #ErpSystem	instanceVariableNames: 'customerSystem supplierSystem session'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!ErpSystem methodsFor: 'as yet unclassified' stamp: 'LJ 11/19/2017 11:53'!withCustomerSystem: aCustomerSystem supplierSystem: aSupplierSystem
	customerSystem := aCustomerSystem.
	supplierSystem := aSupplierSystem.! !!ErpSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 12:23'!stop
	supplierSystem stop.
	customerSystem stop.! !!ErpSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 12:22'!beginTransaction
	customerSystem beginTransaction.
	supplierSystem beginTransaction.! !!ErpSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 12:22'!start
	customerSystem start.
	supplierSystem start.! !!ErpSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 12:22'!commit
	customerSystem commit.
	supplierSystem commit.! !!ErpSystem methodsFor: 'customers' stamp: 'LJ 11/20/2017 19:52'!allSuppliersSize
	^ supplierSystem allSuppliersSize! !!ErpSystem methodsFor: 'customers' stamp: 'LJ 11/19/2017 12:36'!allCustomersSize
	^ customerSystem allCustomersSize! !!ErpSystem methodsFor: 'customers' stamp: 'LJ 11/19/2017 12:24'!addCustomer: aCustomer
	customerSystem addCustomer: aCustomer.! !!ErpSystem methodsFor: 'customers' stamp: 'LJ 11/20/2017 19:53'!addSupplier: aSupplier
	supplierSystem addSupplier: aSupplier! !!ErpSystem methodsFor: 'customers' stamp: 'LJ 11/20/2017 21:51'!supplierIdentifiedAs: anIdentification
	^ supplierSystem supplierIdentifiedAs: anIdentification! !!ErpSystem methodsFor: 'customers' stamp: 'LJ 11/20/2017 11:45'!customerIdentifiedAs: anIdentification
	^ customerSystem customerIdentifiedAs: anIdentification! !!ErpSystem methodsFor: 'customers' stamp: 'LJ 11/19/2017 12:36'!allCustomersIsEmpty
	^ customerSystem allCustomersIsEmpty! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!ErpSystem class	instanceVariableNames: ''!!ErpSystem class methodsFor: 'as yet unclassified' stamp: 'LJ 11/19/2017 11:53'!withCustomerSystem: aCustomerSystem supplierSystem: aSupplierSystem
	^ self new withCustomerSystem: aCustomerSystem supplierSystem: aSupplierSystem.! !Object subclass: #Identification	instanceVariableNames: 'id identificationType identificationNumber'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!Identification methodsFor: 'as yet unclassified' stamp: 'LJ 11/20/2017 22:06'!ofType: anIdentificationType numbered: anIdentificationNumber
	identificationType := anIdentificationType.
	identificationNumber := anIdentificationNumber ! !!Identification methodsFor: 'accessing' stamp: 'LJ 11/19/2017 16:10'!identificationNumber
	^ identificationNumber! !!Identification methodsFor: 'accessing' stamp: 'LJ 11/19/2017 16:10'!identificationType
	^ identificationType.! !!Identification methodsFor: 'comparing' stamp: 'LJ 11/19/2017 16:10'!= anId
	^ identificationType = anId identificationType and: [ identificationNumber = anId identificationNumber ]! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Identification class	instanceVariableNames: ''!!Identification class methodsFor: 'as yet unclassified' stamp: 'LJ 11/20/2017 22:06'!ofType: anIdentificationType numbered: anIdentificationNumber
	^ self new ofType: anIdentificationType numbered: anIdentificationNumber.! !Object subclass: #Importer	instanceVariableNames: 'line readStream record newParty system lineImporters'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!Importer methodsFor: 'error signal' stamp: 'LJ 11/20/2017 11:12'!record
	^ record.! !!Importer methodsFor: 'error signal' stamp: 'LJ 11/20/2017 11:21'!signalAddressWithoutPartyError

	self error: self class addressWithoutCustomerErrorDescription.! !!Importer methodsFor: 'error signal' stamp: 'HernanWilkinson 11/1/2016 17:54'!signalInvalidRecordType

	self error: self class invalidRecordTypeErrorDescription! !!Importer methodsFor: 'importing - private' stamp: 'HernanWilkinson 11/2/2016 15:54'!convertLineToRecord

	record := line substrings: {$,}.
	
	self assertRecordNotEmpty! !!Importer methodsFor: 'importing - private' stamp: 'LJ 11/20/2017 11:11'!importRecord
	lineImporters
		select: [ :aLineImporter | aLineImporter imports: record ]
		thenDo: [ :aLineImporter | aLineImporter importFrom: self ]
		ifNone: [ self signalInvalidRecordType ]! !!Importer methodsFor: 'importing - private' stamp: 'LJ 11/20/2017 21:55'!addNewCustomer: aCustomer
	"Tanto ac√° como en addCustomerWithIdentification ver si agregamos un chequeo antes que diga si la newParty es de tipo Supplier y si no explot√° (if o double dispatch, da lo mismo)"
	newParty addCustomer: aCustomer.	system addCustomer: aCustomer.! !!Importer methodsFor: 'importing - private' stamp: 'LJ 11/20/2017 20:05'!addExistingCustomerWithIdentification: anIdentification
	newParty addCustomer: (system customerIdentifiedAs: anIdentification )

	! !!Importer methodsFor: 'importing - private' stamp: 'HernanWilkinson 11/2/2016 10:55'!canImportNextLine

	line := readStream nextLine.
	^ line notNil! !!Importer methodsFor: 'importing - private' stamp: 'HernanWilkinson 11/2/2016 15:55'!assertRecordNotEmpty
	
	record isEmpty ifTrue: [ self signalInvalidRecordType ]! !!Importer methodsFor: 'importing - private' stamp: 'LJ 11/20/2017 11:25'!addSupplier: aSupplier
	newParty := aSupplier.
	system addSupplier: aSupplier! !!Importer methodsFor: 'importing - private' stamp: 'LJ 11/20/2017 11:29'!addAddress: anAddress
	self assertThereIsPartyForAddress.
	newParty addAddress: anAddress! !!Importer methodsFor: 'importing - private' stamp: 'LJ 11/20/2017 11:20'!addCustomer: aCustomer
	newParty := aCustomer.
	system addCustomer: aCustomer! !!Importer methodsFor: 'importing' stamp: 'HernanWilkinson 11/1/2016 17:51'!import

	[ self canImportNextLine ] whileTrue: [ 
		self convertLineToRecord.
		self importRecord ]! !!Importer methodsFor: 'importing - private - address' stamp: 'LJ 11/20/2017 11:21'!assertThereIsPartyForAddress

	newParty isNil ifTrue: [ self signalAddressWithoutPartyError ].
	! !!Importer methodsFor: 'initialization' stamp: 'LJ 11/20/2017 19:41'!initializeOn: aReadStream on: aSession withLineImporters: alineImporterCollection
	readStream := aReadStream.
	system := aSession.
	lineImporters := alineImporterCollection! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Importer class	instanceVariableNames: ''!!Importer class methodsFor: 'instance creation' stamp: 'LJ 11/20/2017 19:42'!from: aReadStream on: aSystem withLineImporters: aLineImporterCollection
	^ self new initializeOn: aReadStream on: aSystem withLineImporters: aLineImporterCollection . ! !!Importer class methodsFor: 'error descriptions' stamp: 'HernanWilkinson 11/1/2016 16:02'!addressWithoutCustomerErrorDescription
	
	^'There is no Customer for the imported address'! !!Importer class methodsFor: 'error descriptions' stamp: 'HernanWilkinson 11/1/2016 17:54'!invalidRecordTypeErrorDescription
	
	^'Invalid record type'! !Environment subclass: #IntegrationEnvironment	instanceVariableNames: ''	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!IntegrationEnvironment methodsFor: 'as yet unclassified' stamp: 'LJ 11/19/2017 11:54'!createErpSystem
	^ ErpSystem withCustomerSystem: PersistentCustomerSystem new supplierSystem: PersistentSupplierSystem new.! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!IntegrationEnvironment class	instanceVariableNames: ''!!IntegrationEnvironment class methodsFor: 'testing' stamp: 'LJ 11/20/2017 18:41'!isCurrent
	^ false! !Object subclass: #LineImporter	instanceVariableNames: ''	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!LineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 10:54'!importFrom: anImporter
	^ self subclassResponsibility! !!LineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:07'!signalInvalidRecord
	^ self subclassResponsibility! !!LineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:06'!assertValidRecordSize: aRecord
	^ self subclassResponsibility! !!LineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 10:50'!imports: aRecord
	^self subclassResponsibility! !LineImporter subclass: #AddressLineImporter	instanceVariableNames: ''	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!AddressLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:05'!importFrom: anImporter
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
				province: record sixth)! !!AddressLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:06'!assertValidRecordSize: aRecord
	aRecord size ~= 6
		ifTrue: [ self signalInvalidRecord ]! !!AddressLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:07'!signalInvalidRecord
	self error: self class invalidAddressRecordErrorDescription! !!AddressLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 10:51'!imports: aRecord
	^ aRecord first = 'A'! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!AddressLineImporter class	instanceVariableNames: ''!!AddressLineImporter class methodsFor: 'error descriptions' stamp: 'LJ 11/20/2017 11:01'!invalidAddressRecordErrorDescription
	^ 'Invalid address record'! !LineImporter subclass: #CustomerLineImporter	instanceVariableNames: ''	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!CustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 22:06'!importFrom: anImporter
	| record |
	record := anImporter record.
	self assertValidRecordSize: record.
	anImporter
		addCustomer:
			(Customer
				withFirstName: record second
				lastName: record third
				identification: (Identification ofType: record fourth numbered: record fifth))! !!CustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:07'!signalInvalidRecord
	self error: self class invalidCustomerRecordErrorDescription! !!CustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:06'!assertValidRecordSize: aRecord
	aRecord size ~= 5
		ifTrue: [ self signalInvalidRecord ]! !!CustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 10:51'!imports: aRecord
	^ aRecord first = 'C'! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!CustomerLineImporter class	instanceVariableNames: ''!!CustomerLineImporter class methodsFor: 'error descriptions' stamp: 'LJ 11/20/2017 10:41'!invalidCustomerRecordErrorDescription
	^ 'Invalid customer record'! !LineImporter subclass: #ExistingCustomerLineImporter	instanceVariableNames: ''	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!ExistingCustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 22:06'!importFrom: anImporter
	| record |
	record := anImporter record.
	self assertValidRecordSize: record.
	anImporter addExistingCustomerWithIdentification: (Identification ofType: record second numbered: record third)! !!ExistingCustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:37'!signalInvalidRecord
	self error: self class invalidExistingCustomerRecordErrorDescription! !!ExistingCustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:37'!assertValidRecordSize: aRecord
	aRecord size ~= 3
		ifTrue: [ self signalInvalidRecord ]! !!ExistingCustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 20:00'!imports: aRecord
	^ aRecord first = 'EC'! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!ExistingCustomerLineImporter class	instanceVariableNames: ''!!ExistingCustomerLineImporter class methodsFor: 'as yet unclassified' stamp: 'LJ 11/20/2017 11:38'!invalidExistingCustomerRecordErrorDescription
	^ 'Invalid existing customer record'! !LineImporter subclass: #NewCustomerLineImporter	instanceVariableNames: ''	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!NewCustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 22:06'!importFrom: anImporter
	| record |
	record := anImporter record.
	self assertValidRecordSize: record.
	anImporter
		addNewCustomer:
			(Customer
				withFirstName: record second
				lastName: record third
				identification: (Identification ofType: record fourth numbered: record fifth))! !!NewCustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:37'!signalInvalidRecord
	self error: self class invalidNewCustomerRecordErrorDescription! !!NewCustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:37'!assertValidRecordSize: aRecord
	aRecord size ~= 5
		ifTrue: [ self signalInvalidRecord ]! !!NewCustomerLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 20:00'!imports: aRecord
	^ aRecord first = 'NC'! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!NewCustomerLineImporter class	instanceVariableNames: ''!!NewCustomerLineImporter class methodsFor: 'as yet unclassified' stamp: 'LJ 11/20/2017 11:38'!invalidNewCustomerRecordErrorDescription
	^ 'Invalid new customer record'! !Object subclass: #Party	instanceVariableNames: 'id identification addresses'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!Party methodsFor: 'identification' stamp: 'LJ 11/20/2017 09:28'!isIdentifiedAs: anId
	^ identification = anId.! !!Party methodsFor: 'addresses' stamp: 'LJ 11/20/2017 09:51'!addAddress: anAddress 

	addresses add: anAddress ! !!Party methodsFor: 'addresses' stamp: 'LJ 11/20/2017 09:53'!numberOfAddresses
	
	^addresses size! !!Party methodsFor: 'addresses' stamp: 'LJ 11/20/2017 09:51'!addressAt: aStreetName ifNone: noneClosure 
	
	^addresses detect: [ :anAddress | anAddress isAt: aStreetName ] ifNone: noneClosure ! !!Party methodsFor: 'addresses' stamp: 'LJ 11/20/2017 09:51'!addresses

	^ addresses! !!Party methodsFor: 'addresses' stamp: 'LJ 11/20/2017 09:51'!addressesIsEmpty
	
	^addresses isEmpty! !Party subclass: #Customer	instanceVariableNames: 'firstName lastName'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!Customer methodsFor: 'initialization' stamp: 'LJ 11/19/2017 10:07'!initialize

	super initialize.
	addresses := OrderedCollection new.! !!Customer methodsFor: 'initialization' stamp: 'LJ 11/20/2017 09:27'!withFirstName: aFirstName lastName: aLastName identification: anIdentification
	super initialize.
	firstName := aFirstName.
	lastName := aLastName.
	identification := anIdentification.
	addresses := OrderedCollection new! !!Customer methodsFor: 'name' stamp: 'HernanWilkinson 10/28/2016 16:15'!lastName

	^lastName ! !!Customer methodsFor: 'name' stamp: 'HernanWilkinson 10/28/2016 16:15'!firstName
	
	^firstName ! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Customer class	instanceVariableNames: ''!!Customer class methodsFor: 'accessing' stamp: 'LJ 11/19/2017 16:29'!withFirstName: aFirstName lastName: aLastName identification: anIdentification
	^ super new withFirstName: aFirstName lastName: aLastName identification: anIdentification! !CustomerSystem subclass: #PersistentCustomerSystem	instanceVariableNames: ''	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!PersistentCustomerSystem methodsFor: 'setup-teardown' stamp: 'LJ 11/13/2017 20:23'!commit
	session commit.! !!PersistentCustomerSystem methodsFor: 'setup-teardown' stamp: 'LJ 11/13/2017 20:22'!beginTransaction
	session beginTransaction.! !!PersistentCustomerSystem methodsFor: 'setup-teardown' stamp: 'LJ 11/19/2017 16:25'!start
	session := DataBaseSession for: (Array with: self addressMapping with: self customerMapping with: self idMapping ).
	session open! !!PersistentCustomerSystem methodsFor: 'setup-teardown' stamp: 'LJ 11/13/2017 21:14'!stop
	session close.! !!PersistentCustomerSystem methodsFor: 'mapping' stamp: 'LJ 11/19/2017 16:29'!idMapping
	^ ClassMapping
		withDefaultTableNameFor: Identification
		mappingAll:
			(Array
				with: (EmbededMapping withDefaultFieldNameFor: #identificationType)
				with: (EmbededMapping withDefaultFieldNameFor: #identificationNumber)
				)! !!PersistentCustomerSystem methodsFor: 'mapping' stamp: 'LJ 11/13/2017 20:13'!addressMapping
	^ ClassMapping
		withDefaultTableNameFor: Address
		mappingAll:
			(Array
				with: (EmbededMapping withDefaultFieldNameFor: #streetName)
				with: (EmbededMapping withDefaultFieldNameFor: #streetNumber)
				with: (EmbededMapping withDefaultFieldNameFor: #town)
				with: (EmbededMapping withDefaultFieldNameFor: #zipCode)
				with: (EmbededMapping withDefaultFieldNameFor: #province))! !!PersistentCustomerSystem methodsFor: 'mapping' stamp: 'LJ 11/19/2017 16:47'!customerMapping
	^ ClassMapping
		withDefaultTableNameFor: Customer
		mappingAll:
			(Array
				with: (EmbededMapping withDefaultFieldNameFor: #firstName)
				with: (EmbededMapping withDefaultFieldNameFor: #lastName)
				with: (EmbededMapping withDefaultFieldNameFor: #identification)
				with: (OneToManyMapping withDefaultFieldNameFor: #addresses ofType: Address))! !!PersistentCustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:00'!addCustomer: aCustomer
	session addCustomer: aCustomer.! !!PersistentCustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:03'!allCustomersSize
	^ (session selectAllOfType: Customer) size.! !!PersistentCustomerSystem methodsFor: 'customers' stamp: 'LJ 11/19/2017 15:53'!customerIdentifiedAs: anId
	| customers |
	customers := session
		select: [ :aCustomer | aCustomer isIdentifiedAs: anId]
		ofType: Customer.
	customers size = 1
		ifFalse: [ self error: 'There should be just one client identified.' ].
	^ customers anyOne! !!PersistentCustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:05'!allCustomersIsEmpty
	^ self allCustomersSize = 0.! !Party subclass: #Supplier	instanceVariableNames: 'name customers'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!Supplier methodsFor: 'accessing' stamp: 'LJ 11/20/2017 20:17'!initialize	customers := OrderedCollection new.	addresses := OrderedCollection new.! !!Supplier methodsFor: 'accessing' stamp: 'LJ 11/19/2017 10:03'!name
	^ name! !!Supplier methodsFor: 'addresses-customers' stamp: 'LJ 11/19/2017 15:04'!addCustomer: aCustomer
	^ customers add: aCustomer! !!Supplier methodsFor: 'addresses-customers' stamp: 'LJ 11/19/2017 15:03'!numberOfCustomers
	^ customers size! !!Supplier methodsFor: 'addresses-customers' stamp: 'LJ 11/19/2017 15:05'!customersIsEmpty
	^ customers isEmpty! !!Supplier methodsFor: 'addresses-customers' stamp: 'LJ 11/20/2017 22:54'!customerIdentifiedAs: anId ifNone: noneClosure 		^customers detect: [ :aCustomer | aCustomer isIdentifiedAs: anId ] ifNone: noneClosure ! !!Supplier methodsFor: 'initializing' stamp: 'LJ 11/20/2017 09:37'!withName: aName identification: anIdentification
	name := aName.
	identification := anIdentification.! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Supplier class	instanceVariableNames: ''!!Supplier class methodsFor: 'as yet unclassified' stamp: 'LJ 11/20/2017 09:37'!withName: aName identification: anIdentification
	^ self new withName: aName identification: anIdentification.! !LineImporter subclass: #SupplierLineImporter	instanceVariableNames: ''	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!SupplierLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 22:06'!importFrom: anImporter
	| record |
	record := anImporter record.
	self assertValidRecordSize: record.
	^ anImporter
		addSupplier:
			(Supplier
				withName: record second 
				identification: (Identification ofType: record third 
				numbered: record fourth)
				)! !!SupplierLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:23'!signalInvalidRecord
	self error: self class invalidSupplierRecordErrorDescription
	! !!SupplierLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 11:22'!assertValidRecordSize: aRecord
	aRecord size ~= 4
		ifTrue: [ self signalInvalidRecord ]! !!SupplierLineImporter methodsFor: 'api-configuration' stamp: 'LJ 11/20/2017 10:51'!imports: aRecord
	^ aRecord first = 'S'! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!SupplierLineImporter class	instanceVariableNames: ''!!SupplierLineImporter class methodsFor: 'as yet unclassified' stamp: 'LJ 11/20/2017 11:23'!invalidSupplierRecordErrorDescription
	^ 'Invalid supplier record'! !Object subclass: #SupplierSystem	instanceVariableNames: ''	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!SupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 15:31'!commit
	^ self subclassResponsibility! !!SupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 15:31'!beginTransaction
	^ self subclassResponsibility.! !!SupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 15:32'!addSupplier: aSupplier
	^ self subclassResponsibility! !!SupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 15:31'!start
	^ self subclassResponsibility! !!SupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 15:31'!stop
	^ self subclassResponsibility! !!SupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:52'!supplierIdentifiedAs: anId
	^ self subclassResponsibility! !!SupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:34'!allSuppliersIsEmpty
	self subclassResponsibility! !!SupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:34'!addSuplier: aSupplier
	self subclassResponsibility! !!SupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:34'!allSuppliersSize
	self subclassResponsibility! !SupplierSystem subclass: #PersistentSupplierSystem	instanceVariableNames: 'session'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!PersistentSupplierSystem methodsFor: 'mapping' stamp: 'LJ 11/19/2017 14:33'!commit
	session commit! !!PersistentSupplierSystem methodsFor: 'mapping' stamp: 'LJ 11/19/2017 14:33'!beginTransaction
	session beginTransaction! !!PersistentSupplierSystem methodsFor: 'mapping' stamp: 'LJ 11/19/2017 16:31'!supplierMapping
	^ ClassMapping withDefaultTableNameFor: Supplier mappingAll: (Array with: (EmbededMapping withDefaultFieldNameFor: #name)
	
				with: (OneToManyMapping withDefaultFieldNameFor: #id ofType: Identification))! !!PersistentSupplierSystem methodsFor: 'mapping' stamp: 'LJ 11/19/2017 14:34'!start
	session := DataBaseSession
		for: (Array with: self supplierMapping ).
	session open! !!PersistentSupplierSystem methodsFor: 'mapping' stamp: 'LJ 11/19/2017 14:34'!stop
	session close! !!PersistentSupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:51'!supplierIdentifiedAs: anId
	| suppliers |
	suppliers := session
		select: [ :aSupplier | aSupplier isIdentifiedAs: anId ]
		ofType: Supplier.
	suppliers size = 1
		ifFalse: [ self error: 'There should be just one client identified.' ].
	^ suppliers anyOne! !!PersistentSupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:37'!allSuppliersIsEmpty
	^ self allSuppliersSize = 0! !!PersistentSupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:37'!addSupplier: aSupplier
	session addSupplier: aSupplier! !!PersistentSupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:38'!allSuppliersSize
	^ (session selectAllOfType: Supplier) size! !CustomerSystem subclass: #TransientCustomerSystem	instanceVariableNames: 'customers'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!TransientCustomerSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/13/2017 21:03'!commit! !!TransientCustomerSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/13/2017 21:02'!beginTransaction! !!TransientCustomerSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/13/2017 21:12'!start
	customers := OrderedCollection new.! !!TransientCustomerSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/13/2017 21:14'!stop! !!TransientCustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:00'!addCustomer: aCustomer
	customers add: aCustomer.! !!TransientCustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:03'!allCustomersSize
	^ customers size.! !!TransientCustomerSystem methodsFor: 'customers' stamp: 'LJ 11/19/2017 15:54'!customerIdentifiedAs: anId
	| customer |
	customer := customers select: [ :aCustomer | aCustomer isIdentifiedAs: anId ].
	customer size = 1
		ifFalse: [ self error: 'There should be just one client identified.' ].
	^ customer anyOne! !!TransientCustomerSystem methodsFor: 'customers' stamp: 'LJ 11/16/2017 19:06'!allCustomersIsEmpty
	^ self allCustomersSize = 0.! !SupplierSystem subclass: #TransientSupplierSystem	instanceVariableNames: 'suppliers'	classVariableNames: ''	poolDictionaries: ''	category: '10Pines-C17-2-Model'!!TransientSupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:33'!allSuppliersSize
	^ suppliers size.! !!TransientSupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:33'!addSupplier: aSupplier
	suppliers add: aSupplier.! !!TransientSupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/20/2017 22:21'!supplierIdentifiedAs: anId
	| supplier |
	supplier := suppliers select: [ :aSupplier | aSupplier isIdentifiedAs: anId ].
	supplier size = 1
		ifFalse: [ self error: 'There should be just one supplier identified.' ].
	^ supplier anyOne! !!TransientSupplierSystem methodsFor: 'suppliers' stamp: 'LJ 11/19/2017 15:33'!allSuppliersIsEmpty
	^ suppliers isEmpty.! !!TransientSupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 12:28'!stop	! !!TransientSupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 12:27'!beginTransaction
	! !!TransientSupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/20/2017 19:59'!start
	suppliers := OrderedCollection new.
	! !!TransientSupplierSystem methodsFor: 'setUp - tearDown' stamp: 'LJ 11/19/2017 12:28'!commit
! !'From Pharo6.0 of 13 May 2016 [Latest update: #60519] on 20 November 2017 at 11:01:13.528843 pm'!!String methodsFor: '*10Pines-C17-2' stamp: 'HernanWilkinson 10/31/2016 23:57'!asPlural
	
	^self last = $s 
		ifTrue: [ self, 'es' ]
		ifFalse: [ self, 's' ]! !'From Pharo6.0 of 13 May 2016 [Latest update: #60519] on 20 November 2017 at 11:01:13.529843 pm'!!Object methodsFor: '*10Pines-C17-2' stamp: 'HernanWilkinson 10/31/2016 19:27'!toDo: aString 
	! !