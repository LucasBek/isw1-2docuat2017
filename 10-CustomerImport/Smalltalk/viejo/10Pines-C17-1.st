Object subclass: #ClassMapping
	instanceVariableNames: 'mappedClass mappings tableName'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-1-PersistanceModel'!

!ClassMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 11/1/2016 00:40'!
map: anObject using: aDataBaseSession

	| record |

	self toDo: 'se puede optimizar usando array para registros y guardando definicion de tabla una vez'.
	record := Dictionary new.
	
	self mapIdOf: anObject into: record using: aDataBaseSession.
	self mapEmbededOf: anObject into: record.
	"agrego aca el registro y no luego de mapear el id para que lo agrege completo. Lo agrego antes de mapear las rel one to many 
	porque si usuara una db de verdad habria foreign key constrain"
	aDataBaseSession add: record on: self tableName.
	self mapOneToManyRelationshipsOf: anObject using: aDataBaseSession! !

!ClassMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 11/1/2016 00:42'!
unmap: aRecord using: aDataBaseSession

	| unMappedObject |

	unMappedObject := mappedClass basicNew.
	self unmapIdOf: aRecord into: unMappedObject.
	self unmap: aRecord into: unMappedObject using: aDataBaseSession.

	^ unMappedObject! !


!ClassMapping methodsFor: 'mapping - private' stamp: 'HernanWilkinson 11/1/2016 00:40'!
mapIdOf: anObject into: record using: aDataBaseSession

	| newId |

	newId := aDataBaseSession newIdFor: anObject.
	anObject instVarNamed: #id put: newId.
	record at: #id put: newId! !

!ClassMapping methodsFor: 'mapping - private' stamp: 'HernanWilkinson 11/1/2016 00:40'!
mapEmbededOf: anObject into: record

	mappings do: [ :aMapping | aMapping embeded: anObject into: record ]! !

!ClassMapping methodsFor: 'mapping - private' stamp: 'HernanWilkinson 11/1/2016 00:43'!
unmapIdOf: aRecord into: unMappedObject

	unMappedObject instVarNamed: #id put: (aRecord at: #id)! !

!ClassMapping methodsFor: 'mapping - private' stamp: 'HernanWilkinson 11/1/2016 00:40'!
mapOneToManyRelationshipsOf: anObject using: aDataBaseSession

	mappings do: [ :aMapping | aMapping mapOneToManyRelationshipsOf: anObject using: aDataBaseSession ]! !

!ClassMapping methodsFor: 'mapping - private' stamp: 'HernanWilkinson 11/1/2016 00:43'!
unmap: aRecord into: unMappedObject using: aDataBaseSession

	mappings do: [ :aMapping | aMapping unmap: aRecord into: unMappedObject using: aDataBaseSession ]! !


!ClassMapping methodsFor: 'table' stamp: 'HernanWilkinson 10/31/2016 23:25'!
tableName
	
	^tableName ! !


!ClassMapping methodsFor: 'initialization' stamp: 'HernanWilkinson 10/31/2016 23:25'!
initializeFor: aClass into: aTableName mappingAll: aCollectionOfMappings

	mappedClass := aClass.
	tableName := aTableName.
	mappings := aCollectionOfMappings ! !


!ClassMapping methodsFor: 'testing' stamp: 'HernanWilkinson 10/31/2016 23:02'!
isFor: aClass

	^mappedClass = aClass! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ClassMapping class
	instanceVariableNames: ''!

!ClassMapping class methodsFor: 'instance creation' stamp: 'HernanWilkinson 11/1/2016 00:44'!
defaultTableNameFor: aClass
	
	^aClass name asString! !

!ClassMapping class methodsFor: 'instance creation' stamp: 'HernanWilkinson 10/31/2016 23:24'!
for: aClass into: aTableName mappingAll: aCollectionOfMappings

	self assertValidTableName: aTableName.
	self assertHasIdInstanceVariable: aClass.
	self assertValidMappings: aCollectionOfMappings for: aClass.
	
	^self new initializeFor: aClass into: aTableName mappingAll: aCollectionOfMappings


		! !

!ClassMapping class methodsFor: 'instance creation' stamp: 'HernanWilkinson 10/31/2016 23:23'!
withDefaultTableNameFor: aClass mappingAll: aCollectionOfMappings

	^self for: aClass into: (self defaultTableNameFor: aClass) mappingAll: aCollectionOfMappings

		! !


!ClassMapping class methodsFor: 'assertions' stamp: 'HernanWilkinson 10/31/2016 19:26'!
assertValidMappings: aCollectionOfMappings for: aClass 

	self toDo: 'Lo mejor seria recolectar todos los erroes de mapeo y no parar en el primero'.
	aCollectionOfMappings do: [ :aMapping | aMapping assertIsValidFor: aClass ]
	! !

!ClassMapping class methodsFor: 'assertions' stamp: 'HernanWilkinson 10/31/2016 21:15'!
assertHasIdInstanceVariable: aClass 
	
	(aClass hasInstVarNamed: #id) ifFalse: [ self error: ('<1s> has no id instance variable' expandMacrosWith: aClass name) ]! !

!ClassMapping class methodsFor: 'assertions' stamp: 'HernanWilkinson 10/31/2016 23:41'!
assertValidTableName: aTableName

	aTableName trimBoth isEmpty ifTrue: [ self error: 'Table name can not be empty' ]! !


Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id cache'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-1-PersistanceModel'!

!DataBaseSession methodsFor: 'persistance' stamp: 'HernanWilkinson 11/1/2016 01:28'!
persist: anObject

	| mapper |
	
	self assertInTransaction.
	self delay.
	
	mapper := self mapperFor: anObject class.
	mapper map: anObject using: self.
	
	self addToCache: anObject ! !


!DataBaseSession methodsFor: 'selecting' stamp: 'HernanWilkinson 10/31/2016 22:17'!
selectAllOfType: aClass 
	
	^self select: [ :anObject | true ] ofType: aClass! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HernanWilkinson 11/1/2016 01:26'!
select: aCondition ofType: aClass

	| mapper table |

	self assertInTransaction.
	self delay.
	
	mapper := self mapperFor: aClass.
	table := tables at: mapper tableName ifAbsent: [ ^ #() ].
	
	^ table inject: OrderedCollection new into: [ :selected :record | self addInto: selected theOnesThatHold: aCondition unmapping: record with: mapper ]! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HernanWilkinson 11/1/2016 01:15'!
objectIdentifiedAs: anId ofType: aClass

	self assertInTransaction.
	self delay.
	
	^ cache at: anId ifAbsentPut: [ self unmapRecordIdentifiedAs: anId ofType: aClass ]! !


!DataBaseSession methodsFor: 'mapping - private' stamp: 'HernanWilkinson 11/1/2016 01:15'!
relatedOfType: aRelatedClass for: anOwner

	| table relatedIds |
	
	table := self relationTableFor: anOwner class relatedTo: aRelatedClass.
	relatedIds := table at: (self idOf: anOwner) ifAbsent: [ ^#() ].
	
	^relatedIds collect: [ :aRelatedId | self objectIdentifiedAs: aRelatedId ofType: aRelatedClass ]
	

	! !

!DataBaseSession methodsFor: 'mapping - private' stamp: 'HernanWilkinson 11/1/2016 01:16'!
unmapRecordIdentifiedAs: anId ofType: aClass

	| record table mapper |

	mapper := self mapperFor: aClass.
	table := self tableNamed: mapper tableName.
	record := table at: id ifAbsent: [ self error: ('Object identified as <1s> does not exist' expandMacrosWith: anId printString) ].
	
	^ mapper unmap: record using: self! !

!DataBaseSession methodsFor: 'mapping - private' stamp: 'HernanWilkinson 11/1/2016 01:14'!
mapperFor: aClass

	self toDo: 'se puede mejorar performanco usando un dictionary'.
	^configuration
		detect: [ :aClassMapper | aClassMapper isFor: aClass ] 
		ifNone: [ self error: ('There is no mapper for <1s>' expandMacrosWith: aClass name) ]! !


!DataBaseSession methodsFor: 'adding - private' stamp: 'HernanWilkinson 11/1/2016 01:03'!
addRelated: aRelated ownedBy: anOwner

	| relatedIds relatedId |

	relatedIds := self relatedIdsOwnedBy: anOwner forType: aRelated class.
	relatedId := aRelated instVarNamed: #id.
	self assertRelationOwnedBy: anOwner isUniqueFor: aRelated identifiedAs: relatedId in: relatedIds.
	
	relatedIds add: relatedId! !

!DataBaseSession methodsFor: 'adding - private' stamp: 'HernanWilkinson 11/1/2016 01:00'!
signalRelationAlreadyExistBetween: anOwner and: aRelated 

	self error: ('Relation between id <1s> of type <2s> and id <3s> of type <4s> already exist'
		expandMacrosWith: (self idOf: anOwner) printString
		with: anOwner class name
		with: (self idOf: aRelated) printString
		with: aRelated class name)! !

!DataBaseSession methodsFor: 'adding - private' stamp: 'HernanWilkinson 11/1/2016 01:03'!
add: aRecord on: aTableName

	| table existingRecord |

	table := self tableNamed: aTableName.
	existingRecord := table at: (self recordId: aRecord) ifAbsentPut: [ aRecord ].
	existingRecord == aRecord ifFalse: [ self error: 'Duplicated primary key' ]! !

!DataBaseSession methodsFor: 'adding - private' stamp: 'HernanWilkinson 11/1/2016 01:05'!
assertRelationOwnedBy: anOwner isUniqueFor: aRelated identifiedAs: relatedId in: relatedIds

	(relatedIds includes: relatedId) ifTrue: [ self signalRelationAlreadyExistBetween: anOwner and: aRelated ]! !

!DataBaseSession methodsFor: 'adding - private' stamp: 'HernanWilkinson 11/1/2016 01:10'!
relatedIdsOwnedBy: anOwner forType: aRelatedClass

	| relatedIds table |

	table := self relationTableFor: anOwner class relatedTo: aRelatedClass.
	relatedIds := self relatedIdOwnedBy: anOwner on: table.
	
	^ relatedIds! !

!DataBaseSession methodsFor: 'adding - private' stamp: 'HernanWilkinson 11/1/2016 01:06'!
relatedIdOwnedBy: anOwner on: table

	^ table at: (self idOf: anOwner) ifAbsentPut: [ Set new ]! !

!DataBaseSession methodsFor: 'adding - private' stamp: 'HernanWilkinson 11/1/2016 01:27'!
addToCache: anObject 

	cache at: (self idOf: anObject) put: anObject ! !


!DataBaseSession methodsFor: 'id' stamp: 'HernanWilkinson 11/1/2016 01:04'!
recordId: aRecord

	^aRecord at: #id! !

!DataBaseSession methodsFor: 'id' stamp: 'HernanWilkinson 10/28/2016 16:35'!
newIdFor: anObject

	id := id + 1.
	^id! !

!DataBaseSession methodsFor: 'id' stamp: 'HernanWilkinson 11/1/2016 01:00'!
idOf: anObject

	^anObject instVarNamed: #id! !


!DataBaseSession methodsFor: 'open/close' stamp: 'HernanWilkinson 10/31/2016 18:36'!
assertIsOpen
	
	tables isNil ifTrue: [ self error: 'Session must be open to colaborate with it' ]! !

!DataBaseSession methodsFor: 'open/close' stamp: 'HernanWilkinson 10/31/2016 18:36'!
open

	self assertIsClose.
	
	tables := Dictionary new.
	! !

!DataBaseSession methodsFor: 'open/close' stamp: 'HernanWilkinson 10/31/2016 22:14'!
close

	self assertIsOpen.
	
	tables := nil! !

!DataBaseSession methodsFor: 'open/close' stamp: 'HernanWilkinson 10/31/2016 18:37'!
assertIsClose
	
	tables isNil ifFalse: [ self error: 'Session must be close' ]! !


!DataBaseSession methodsFor: 'selecting - private' stamp: 'HernanWilkinson 11/1/2016 01:28'!
addInto: selected theOnesThatHold: aCondition unmapping: record with: mapper

	| recordId aClassInstance |

	recordId := self recordId: record.
	aClassInstance := cache at: recordId ifAbsent: [ mapper unmap: record using: self ].
	(aCondition value: aClassInstance) ifTrue: [ 
		self addToCache: aClassInstance.
		selected add: aClassInstance ].
	
	^ selected! !


!DataBaseSession methodsFor: 'initialization' stamp: 'HernanWilkinson 10/31/2016 22:55'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	id := 0.

	tables := nil.
	cache := nil.! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'HernanWilkinson 10/28/2016 16:35'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HernanWilkinson 10/28/2016 16:41'!
delay

	(Delay forMilliseconds: 100) wait! !


!DataBaseSession methodsFor: 'transaction management' stamp: 'HernanWilkinson 10/31/2016 22:57'!
commit
	
	self assertInTransaction.
	
	cache := nil! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HernanWilkinson 10/31/2016 22:55'!
assertInTransaction
	
	cache isNil ifTrue: [ self error: 'There is no transaction currently' ]! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HernanWilkinson 10/31/2016 22:55'!
assertNotInTransasction
	
	cache notNil ifTrue: [ self error: 'There is an open transaction already' ]! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HernanWilkinson 10/31/2016 22:57'!
beginTransaction

	self assertIsOpen.
	self assertNotInTransasction.
	
	cache := WeakKeyDictionary new.
	
! !


!DataBaseSession methodsFor: 'tables - private' stamp: 'HernanWilkinson 11/1/2016 01:12'!
relationTableNameOwnedBy: anOwnerClass relatedTo: aRelatedClass

	| ownerClassMapper relatedClassMapper |
	
	ownerClassMapper := self mapperFor: anOwnerClass.
	relatedClassMapper := self mapperFor: aRelatedClass.
	
	^ownerClassMapper tableName,'_', relatedClassMapper tableName asPlural.! !

!DataBaseSession methodsFor: 'tables - private' stamp: 'HernanWilkinson 11/1/2016 00:48'!
tableNamed: aTableName

	^ tables at: aTableName ifAbsentPut: [ Dictionary new ]! !

!DataBaseSession methodsFor: 'tables - private' stamp: 'HernanWilkinson 11/1/2016 01:12'!
relationTableFor: anOwnerClass relatedTo: aRelatedClass

	| relationTableName table |

	relationTableName := self relationTableNameOwnedBy: anOwnerClass relatedTo: aRelatedClass.
	table := self tableNamed: relationTableName.
	
	^ table! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HernanWilkinson 10/28/2016 13:07'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !


Object subclass: #Mapping
	instanceVariableNames: 'instanceVariableName'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-1-PersistanceModel'!

!Mapping methodsFor: 'mapping' stamp: 'HernanWilkinson 10/31/2016 23:26'!
unmap: aRecord into: anObject using: aDataBaseSession
	self subclassResponsibility! !

!Mapping methodsFor: 'mapping' stamp: 'HernanWilkinson 10/31/2016 23:26'!
embeded: anObject into: aRecord
	self subclassResponsibility! !

!Mapping methodsFor: 'mapping' stamp: 'HernanWilkinson 10/31/2016 23:26'!
mapOneToManyRelationshipsOf: anObject using: aDataBaseSession
	self subclassResponsibility! !


!Mapping methodsFor: 'assertions' stamp: 'HernanWilkinson 11/1/2016 01:31'!
assertIsValidFor: aClass 

	(aClass hasInstVarNamed: instanceVariableName) ifFalse: [ 
		self error: ('Invalid mapping for <1s> in class <2s>' expandMacrosWith: instanceVariableName with: aClass name) ] ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Mapping class
	instanceVariableNames: ''!

!Mapping class methodsFor: 'instance creation' stamp: 'HernanWilkinson 11/1/2016 01:32'!
defaultFieldNameFor: anInstanceVariableName

	^anInstanceVariableName asString! !


!Mapping class methodsFor: 'assertions' stamp: 'HernanWilkinson 10/31/2016 23:41'!
assertValidFieldName: aFieldName

	aFieldName trimBoth isEmpty ifTrue: [ self error: 'Field name can not be empty' ]! !


Mapping subclass: #EmbededMapping
	instanceVariableNames: 'fieldName'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-1-PersistanceModel'!

!EmbededMapping methodsFor: 'initialization' stamp: 'HernanWilkinson 10/31/2016 23:30'!
initializeFor: anInstanceVariableName into: aFieldName

	instanceVariableName := anInstanceVariableName.
	fieldName := aFieldName ! !


!EmbededMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 10/31/2016 23:31'!
unmap: aRecord into: anObject using: aDataBaseSession 

	anObject instVarNamed: instanceVariableName put: (aRecord at: fieldName)! !

!EmbededMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 10/31/2016 23:31'!
embeded: anObject into: aRecord

	aRecord at: fieldName put: (anObject instVarNamed: instanceVariableName) ! !

!EmbededMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 10/31/2016 21:23'!
mapOneToManyRelationshipsOf: anObject using: aDataBaseSession 
	
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

EmbededMapping class
	instanceVariableNames: ''!

!EmbededMapping class methodsFor: 'instance creation' stamp: 'HernanWilkinson 10/31/2016 23:30'!
for: anInstanceVariableName into: aFieldName

	^self new initializeFor: anInstanceVariableName into: aFieldName ! !

!EmbededMapping class methodsFor: 'instance creation' stamp: 'HernanWilkinson 10/31/2016 23:29'!
withDefaultFieldNameFor: anInstanceVariableName

	^self for: anInstanceVariableName into: (self defaultFieldNameFor: anInstanceVariableName)! !


Mapping subclass: #OneToManyMapping
	instanceVariableNames: 'relatedType fieldName'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-1-PersistanceModel'!

!OneToManyMapping methodsFor: 'initialization' stamp: 'HernanWilkinson 10/31/2016 23:34'!
initializeFor: anInstanceVariableName into: aFieldName ofType: aClass

	instanceVariableName := anInstanceVariableName.
	fieldName := aFieldName.
	relatedType := aClass ! !


!OneToManyMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 10/31/2016 21:16'!
embeded: anObject into: aRecord
	! !

!OneToManyMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 11/1/2016 01:37'!
unmap: aRecord into: anObject using: aDataBaseSession

	| newCollection related |

	related := aDataBaseSession relatedOfType: relatedType for: anObject.
	newCollection := self createRelationCollectionOn: aDataBaseSession ownedBy: anObject.

	newCollection addAllNotPersisting: related.
	anObject instVarNamed: instanceVariableName put: newCollection! !

!OneToManyMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 11/1/2016 01:35'!
createRelationCollectionOn: aDataBaseSession ownedBy: anObject
	^ OneToManySet on: aDataBaseSession ownedBy: anObject! !

!OneToManyMapping methodsFor: 'mapping' stamp: 'HernanWilkinson 11/1/2016 01:37'!
mapOneToManyRelationshipsOf: anObject using: aDataBaseSession

	| oldCollection newCollection |

	newCollection := self createRelationCollectionOn: aDataBaseSession ownedBy: anObject.
	oldCollection := anObject instVarNamed: instanceVariableName.
	
	newCollection addAll: oldCollection.
	anObject instVarNamed: instanceVariableName put: newCollection! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

OneToManyMapping class
	instanceVariableNames: ''!

!OneToManyMapping class methodsFor: 'instance creation' stamp: 'HernanWilkinson 10/31/2016 23:32'!
withDefaultFieldNameFor: anInstanceVariableName ofType: aClass

	^self for: anInstanceVariableName into: (self defaultFieldNameFor: anInstanceVariableName) ofType: aClass! !

!OneToManyMapping class methodsFor: 'instance creation' stamp: 'HernanWilkinson 10/31/2016 23:40'!
for: anInstanceVariableName into: aFieldName ofType: aClass

	self assertValidFieldName: aFieldName.
	
	^self new initializeFor: anInstanceVariableName into: aFieldName ofType: aClass! !


Set subclass: #OneToManySet
	instanceVariableNames: 'session owner'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-1-PersistanceModel'!

!OneToManySet methodsFor: 'adding' stamp: 'HernanWilkinson 11/1/2016 00:03'!
addAllNotPersisting: aCollection 
	
	^aCollection do: [ :anObjectToAdd | super add: anObjectToAdd ]! !

!OneToManySet methodsFor: 'adding' stamp: 'HernanWilkinson 11/1/2016 00:11'!
add: anObject

	session persist: anObject.
	session addRelated: anObject ownedBy: owner.
	
	super add: anObject.
! !


!OneToManySet methodsFor: 'removing' stamp: 'HernanWilkinson 10/31/2016 21:35'!
remove: anObject ifAbsent: anAbsentBlock

	self shouldBeImplemented ! !


!OneToManySet methodsFor: 'initialization' stamp: 'HernanWilkinson 11/1/2016 00:11'!
initializeOn: aDataBaseSession ownedBy: anOwner
	
	session := aDataBaseSession.
	owner := anOwner ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

OneToManySet class
	instanceVariableNames: ''!

!OneToManySet class methodsFor: 'instance creation' stamp: 'HernanWilkinson 11/1/2016 00:11'!
on: aDataBaseSession ownedBy: anOwner
	
	^self new initializeOn: aDataBaseSession ownedBy: anOwner ! !
Object subclass: #Address
	instanceVariableNames: 'id streetName streetNumber town zipCode province'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-1-Model'!

!Address methodsFor: 'street' stamp: 'HernanWilkinson 10/28/2016 13:27'!
streetNumber: aStreetNumber
 
	streetNumber := aStreetNumber ! !

!Address methodsFor: 'street' stamp: 'HernanWilkinson 10/28/2016 13:27'!
streetName: aStreetName
 
	streetName := aStreetName ! !

!Address methodsFor: 'street' stamp: 'HernanWilkinson 10/28/2016 16:12'!
streetNumber

	^streetNumber ! !

!Address methodsFor: 'street' stamp: 'HernanWilkinson 10/28/2016 16:12'!
streetName

	^streetName ! !


!Address methodsFor: 'twon' stamp: 'HernanWilkinson 10/28/2016 16:07'!
town: aTown
 
	town := aTown! !

!Address methodsFor: 'twon' stamp: 'HernanWilkinson 10/28/2016 16:12'!
town

	^town! !


!Address methodsFor: 'province' stamp: 'HernanWilkinson 10/28/2016 16:08'!
province: aProvince
 
	province := aProvince
	! !

!Address methodsFor: 'province' stamp: 'HernanWilkinson 10/28/2016 16:11'!
province

	^province! !


!Address methodsFor: 'zip code' stamp: 'HernanWilkinson 10/28/2016 16:13'!
zipCode

	^zipCode! !

!Address methodsFor: 'zip code' stamp: 'HernanWilkinson 10/28/2016 16:08'!
zipCode: aZipCode
 
	zipCode := aZipCode! !


Object subclass: #Customer
	instanceVariableNames: 'test id firstName lastName identificationType identificationNumber addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-1-Model'!

!Customer methodsFor: 'name' stamp: 'HernanWilkinson 10/28/2016 13:09'!
lastName: aLastName
 
	lastName := aLastName
! !

!Customer methodsFor: 'name' stamp: 'HernanWilkinson 10/28/2016 16:15'!
lastName

	^lastName ! !

!Customer methodsFor: 'name' stamp: 'HernanWilkinson 10/28/2016 16:15'!
firstName
	
	^firstName ! !

!Customer methodsFor: 'name' stamp: 'HernanWilkinson 10/28/2016 13:09'!
firstName: aName
 
	firstName := aName! !


!Customer methodsFor: 'addresses' stamp: 'HernanWilkinson 10/28/2016 13:25'!
addresses

	^ addresses! !

!Customer methodsFor: 'addresses' stamp: 'HernanWilkinson 10/28/2016 13:27'!
addAddress: anAddress 

	addresses add: anAddress ! !


!Customer methodsFor: 'importing' stamp: 'LJ 11/7/2017 00:39'!
importCustomers
	"
	self importCustomers
	"

	test importCustomers! !


!Customer methodsFor: 'identification' stamp: 'HernanWilkinson 10/28/2016 13:10'!
identificationNumber: anIdentificationNumber
 
	identificationNumber := anIdentificationNumber! !

!Customer methodsFor: 'identification' stamp: 'HernanWilkinson 10/28/2016 16:13'!
identificationType
	
	^identificationType ! !

!Customer methodsFor: 'identification' stamp: 'HernanWilkinson 10/28/2016 13:10'!
identificationType: anIdentificationType 

	identificationType := anIdentificationType! !

!Customer methodsFor: 'identification' stamp: 'HernanWilkinson 10/28/2016 16:13'!
identificationNumber
	
	^identificationNumber ! !


!Customer methodsFor: 'initialization' stamp: 'HernanWilkinson 10/28/2016 13:26'!
initialize

	super initialize.
	addresses := OrderedCollection new.! !


Object subclass: #CustomerImporter
	instanceVariableNames: 'line inputStream session currentRecordData lastCustomerImported'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-1-Model'!

!CustomerImporter methodsFor: 'importing' stamp: 'LJ 11/9/2017 20:40'!
importFrom: anInputStream
	"
	self importCustomers
	"

	inputStream := anInputStream.
	[ self hasRecordsLeftToImport ] whileTrue:
		[ self importRecord ]! !

!CustomerImporter methodsFor: 'importing' stamp: 'LJ 11/9/2017 21:12'!
importAddress
	| newAddress |
	newAddress := Address new.
	currentRecordData size < 6 ifTrue: [ self error: CustomerImporter missingFieldsErrorMessage ].
	
	newAddress streetName:
		currentRecordData second.
	newAddress streetNumber:
		currentRecordData third asInteger.
	newAddress town:
		currentRecordData fourth.
	newAddress zipCode:
		currentRecordData fifth asInteger.
	newAddress province:
		currentRecordData sixth.
	^ newAddress! !

!CustomerImporter methodsFor: 'importing' stamp: 'LJ 11/9/2017 20:40'!
withSession: aSession
	session := aSession ! !

!CustomerImporter methodsFor: 'importing' stamp: 'LJ 11/9/2017 21:37'!
importRecord
	currentRecordData := self obtainDataToProcess.
	
	self isNextRecordValid ifFalse: [self error: CustomerImporter invalidRecordTypeMessageError  ].
	 
	self
		ifHasToImportCustomer: [ lastCustomerImported := self importCustomer.
			session persist: lastCustomerImported ].
	^ self
		ifHasToImportAddress: [ | newAddress |
			newAddress := self importAddress.
			lastCustomerImported addAddress: newAddress ]
		! !

!CustomerImporter methodsFor: 'importing' stamp: 'LJ 11/9/2017 21:25'!
hasToImportCustomer
	^ currentRecordData first = 'C'! !

!CustomerImporter methodsFor: 'importing' stamp: 'LJ 11/9/2017 20:13'!
ifHasToImportCustomer: aBlock
	^ self hasToImportCustomer
		ifTrue: aBlock! !

!CustomerImporter methodsFor: 'importing' stamp: 'LJ 11/9/2017 19:49'!
ifHasToImportAddress: aBlock
	^ self hasToImportAddress
		ifTrue: aBlock! !

!CustomerImporter methodsFor: 'importing' stamp: 'LJ 11/9/2017 21:08'!
importCustomer
	| newCustomer |
	newCustomer := Customer new.
	currentRecordData size < 5 ifTrue: [ self error: CustomerImporter missingFieldsErrorMessage ].
	 
	newCustomer firstName:
		currentRecordData second.
	newCustomer lastName:
		currentRecordData third.
	newCustomer identificationType:
		currentRecordData fourth.
	newCustomer identificationNumber:
		currentRecordData fifth.
	^ newCustomer! !

!CustomerImporter methodsFor: 'importing' stamp: 'LJ 11/9/2017 21:28'!
isNextRecordValid
	 ^ self hasToImportAddress or: self hasToImportCustomer .! !

!CustomerImporter methodsFor: 'importing' stamp: 'LJ 11/9/2017 20:21'!
obtainDataToProcess
	^ line substrings: {$,}! !

!CustomerImporter methodsFor: 'importing' stamp: 'LJ 11/9/2017 21:25'!
hasToImportAddress
	^ line beginsWith: 'A'! !

!CustomerImporter methodsFor: 'importing' stamp: 'LJ 11/9/2017 20:16'!
hasRecordsLeftToImport
	| hasNextLine |
	line := inputStream nextLine.
	hasNextLine := line notNil.
	^ hasNextLine! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'importing' stamp: 'LJ 11/9/2017 21:05'!
missingFieldsErrorMessage
	^ 'Missing fields'! !

!CustomerImporter class methodsFor: 'importing' stamp: 'LJ 11/9/2017 21:37'!
invalidRecordTypeMessageError
	^ 'Unknown record, only C or D allowed'! !

!CustomerImporter class methodsFor: 'importing' stamp: 'LJ 11/9/2017 20:42'!
withSession: aSession
	^ self new withSession: aSession.! !
TestCase subclass: #CustomerImporterTest
	instanceVariableNames: 'customerImporter session inputStream'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-1-Test'!

!CustomerImporterTest methodsFor: 'importing' stamp: 'LJ 11/9/2017 20:41'!
setUp
	


	inputStream := self fileDataTest.
	session := DataBaseSession
		for:
			(Array
				with:
					(ClassMapping
						withDefaultTableNameFor: Address
						mappingAll:
							(Array
								with: (EmbededMapping withDefaultFieldNameFor: #streetName)
								with: (EmbededMapping withDefaultFieldNameFor: #streetNumber)
								with: (EmbededMapping withDefaultFieldNameFor: #town)
								with: (EmbededMapping withDefaultFieldNameFor: #zipCode)
								with: (EmbededMapping withDefaultFieldNameFor: #province)))
				with:
					(ClassMapping
						withDefaultTableNameFor: Customer
						mappingAll:
							(Array
								with: (EmbededMapping withDefaultFieldNameFor: #firstName)
								with: (EmbededMapping withDefaultFieldNameFor: #lastName)
								with: (EmbededMapping withDefaultFieldNameFor: #identificationType)
								with: (EmbededMapping withDefaultFieldNameFor: #identificationNumber)
								with: (OneToManyMapping withDefaultFieldNameFor: #addresses ofType: Address)))).
	session open.
	session beginTransaction.
	
	customerImporter := CustomerImporter withSession: session.! !

!CustomerImporterTest methodsFor: 'importing' stamp: 'LJ 11/9/2017 20:41'!
importCustomers
	"
	self importCustomers
	"

	customerImporter importFrom: inputStream.! !

!CustomerImporterTest methodsFor: 'importing' stamp: 'LJ 11/7/2017 00:42'!
tearDown
	session commit.
	session close.
	inputStream close! !


!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/9/2017 21:46'!
test05FileWithRecordTypeStartingWithAButHasMoreCharactersThrowsError
	
! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/7/2017 01:37'!
fileDataTest
	^ ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'.! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/9/2017 21:42'!
numberOfAddresses
	^ (session selectAllOfType: Address) size! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/7/2017 01:16'!
assertAddress: anAddress hasTown: aTown andProvince: aProvince andZipCode: aZipCode andStreetName: aStreetName andStretNumber: aStreetNumber

	self assert: anAddress town equals: aTown.
	self assert: anAddress province equals: aProvince .
	self assert: anAddress zipCode equals: aZipCode .
	self assert: anAddress streetName equals: aStreetName.
	self assert: anAddress streetNumber equals: aStreetNumber.! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/7/2017 01:04'!
assertCustomer: aCustomer hasIdentificationNumber: anIdentificationNumber andIdentificationType: anIdentificationType andFirstName: aFirstName andLastName: aLastName
	self assert: aCustomer identificationNumber equals: anIdentificationNumber.
	self assert: aCustomer identificationType equals: anIdentificationType.
	self assert: aCustomer firstName equals: aFirstName.
	self assert: aCustomer lastName equals: aLastName.! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/9/2017 21:41'!
numberOfCustomers
	^ (session selectAllOfType: Customer) size! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/9/2017 21:40'!
fileWithRecordTypeStartingWithCC
	^ ReadStream on: 'CC,Pepe,Sanchez,D,22333444'	! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/9/2017 21:46'!
test07FileWithTooManyCustomerFieldsThrowsError
	! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/9/2017 21:42'!
assertAmountOfDataImportedIsCorrect
	self assert: self numberOfCustomers equals: 2.
	self assert: self numberOfAddresses equals: 3! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/9/2017 21:13'!
fileWithAddressDataMissingTest
	^ ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636'	! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/9/2017 21:47'!
test08FileWithTooManyAddressFieldsThrowsError
	! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/7/2017 01:10'!
selectCustomerAddress: aCustomer withTown: aTown
	^ aCustomer addresses
		detect: [ :anAddress | anAddress town = aTown ].! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/9/2017 21:47'!
test02FileWithMissingCustomerFieldsThrowsError
	inputStream := self fileWithCustomerDataMissingTest.
	self
		should: [ customerImporter importFrom: inputStream ]
		raise: Error
		withExceptionDo: [ :anException | 
			self
				assert: anException messageText
				equals: CustomerImporter missingFieldsErrorMessage.
			self assert: self numberOfCustomers equals: 0 ]! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/9/2017 21:47'!
test03FileWithMissingAddressFieldsThrowsError
	inputStream := self fileWithAddressDataMissingTest.
	
	self should: [customerImporter importFrom: inputStream.]
	raise: Error
	withExceptionDo: [:anException | 
		self assert: anException messageText equals: CustomerImporter missingFieldsErrorMessage.
		self assert: self numberOfAddresses  equals: 0.
		].
	
! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/7/2017 01:18'!
assertPepeCustomerImportedCorrectly
	| pepeCustomer olivosAddress floridaAddress |
	pepeCustomer := self selectCustomer: '22333444' withType: 'D'.
	self
		assertCustomer: pepeCustomer
		hasIdentificationNumber: '22333444'
		andIdentificationType: 'D'
		andFirstName: 'Pepe'
		andLastName: 'Sanchez'.
		
	self assert: pepeCustomer addresses size equals: 2.
	
	olivosAddress := self selectCustomerAddress: pepeCustomer withTown: 'Olivos'.
	
	self assertAddress: olivosAddress hasTown: 'Olivos'  andProvince: 'BsAs' andZipCode: 1636 andStreetName: 'San Martin'  andStretNumber: 3322.
	
	floridaAddress := self selectCustomerAddress: pepeCustomer withTown: 'Florida'.  
	
	self assertAddress: floridaAddress hasTown: 'Florida'  andProvince: 'Buenos Aires' andZipCode: 1122 andStreetName: 'Maipu'  andStretNumber: 888.! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/9/2017 18:37'!
test01ImportCustomersWorksCorrectly
	self importCustomers.
	self assertAmountOfDataImportedIsCorrect.
	self assertPepeCustomerImportedCorrectly.
	self assertJuanCustomerImportedCorrectly.! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/7/2017 00:57'!
selectCustomer: anIdentificationNumber withType: aType
	| customers |
	customers := session
		select: [ :aCustomer | 
			aCustomer identificationNumber = anIdentificationNumber
				and: [ aCustomer identificationType = aType ] ]
		ofType: Customer.
	self assert: customers size equals: 1.
	^ customers anyOne! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/9/2017 21:09'!
fileWithCustomerDataMissingTest
	^ ReadStream on: 'C,Pepe,Sanchez,D'.! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/9/2017 21:46'!
test06CantImportAddressWithoutCustomer
	! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/9/2017 21:43'!
test04FileWithRecordTypeStartingWithCButHasMoreCharactersThrowsError
	inputStream := self fileWithRecordTypeStartingWithCC.
	
	self should: [customerImporter importFrom: inputStream.]
	raise: Error
	withExceptionDo: [:anException | 
		self assert: anException messageText equals: CustomerImporter invalidRecordTypeMessageError.
		self assert: self numberOfCustomers equals: 0.
		].
	
! !

!CustomerImporterTest methodsFor: 'tests' stamp: 'LJ 11/7/2017 01:22'!
assertJuanCustomerImportedCorrectly
	| juanCustomer alemAddress  |
	juanCustomer := self selectCustomer: '23-25666777-9' withType: 'C'.
	self
		assertCustomer: juanCustomer
		hasIdentificationNumber: '23-25666777-9'
		andIdentificationType: 'C'
		andFirstName: 'Juan'
		andLastName: 'Perez'.
		
	self assert: juanCustomer addresses size equals: 1.
	
	alemAddress := self selectCustomerAddress: juanCustomer withTown: 'CABA'.
	
	self assertAddress: alemAddress hasTown: 'CABA'  andProvince: 'CABA' andZipCode: 1001 andStreetName: 'Alem'  andStretNumber: 1122.
! !
'From Pharo6.0 of 13 May 2016 [Latest update: #60519] on 9 November 2017 at 9:48:33.869247 pm'!

!String methodsFor: '*10Pines-C17-1' stamp: 'HernanWilkinson 10/31/2016 23:57'!
asPlural
	
	^self last = $s 
		ifTrue: [ self, 'es' ]
		ifFalse: [ self, 's' ]! !
'From Pharo6.0 of 13 May 2016 [Latest update: #60519] on 9 November 2017 at 9:48:33.869803 pm'!

!Object methodsFor: '*10Pines-C17-1' stamp: 'HernanWilkinson 10/31/2016 19:27'!
toDo: aString 
	! !
