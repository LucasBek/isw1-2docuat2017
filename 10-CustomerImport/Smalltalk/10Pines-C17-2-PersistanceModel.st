Object subclass: #ClassMapping
	
	^tableName ! !

	mappings do: [ :aMapping | aMapping mapOneToManyRelationshipsOf: anObject using: aDataBaseSession ]! !

	mappings do: [ :aMapping | aMapping embeded: anObject into: record ]! !

	| newId |

	newId := aDataBaseSession newIdFor: anObject.
	anObject instVarNamed: #id put: newId.
	record at: #id put: newId! !

	mappings do: [ :aMapping | aMapping unmap: aRecord into: unMappedObject using: aDataBaseSession ]! !

	unMappedObject instVarNamed: #id put: (aRecord at: #id)! !

	^mappedClass = aClass! !

	mappedClass := aClass.
	tableName := aTableName.
	mappings := aCollectionOfMappings ! !

	| unMappedObject |

	unMappedObject := mappedClass basicNew.
	self unmapIdOf: aRecord into: unMappedObject.
	self unmap: aRecord into: unMappedObject using: aDataBaseSession.

	^ unMappedObject! !

	| record |

	self toDo: 'se puede optimizar usando array para registros y guardando definicion de tabla una vez'.
	record := Dictionary new.
	
	self mapIdOf: anObject into: record using: aDataBaseSession.
	self mapEmbededOf: anObject into: record.
	"agrego aca el registro y no luego de mapear el id para que lo agrege completo. Lo agrego antes de mapear las rel one to many 
	porque si usuara una db de verdad habria foreign key constrain"
	aDataBaseSession add: record on: self tableName.
	self mapOneToManyRelationshipsOf: anObject using: aDataBaseSession! !

	self assertValidTableName: aTableName.
	self assertHasIdInstanceVariable: aClass.
	self assertValidMappings: aCollectionOfMappings for: aClass.
	
	^self new initializeFor: aClass into: aTableName mappingAll: aCollectionOfMappings


		! !

	^self for: aClass into: (self defaultTableNameFor: aClass) mappingAll: aCollectionOfMappings

		! !
	
	^aClass name asString! !

	self toDo: 'Lo mejor seria recolectar todos los erroes de mapeo y no parar en el primero'.
	aCollectionOfMappings do: [ :aMapping | aMapping assertIsValidFor: aClass ]
	! !

	aTableName trimBoth isEmpty ifTrue: [ self error: 'Table name can not be empty' ]! !

	(Delay forMilliseconds: 100) wait! !

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !
	
	^self select: [ :anObject | true ] ofType: aClass! !

	self assertInTransaction.
	self delay.
	
	^ cache at: anId ifAbsentPut: [ self unmapRecordIdentifiedAs: anId ofType: aClass ]! !

	| mapper table |

	self assertInTransaction.
	self delay.
	
	mapper := self mapperFor: aClass.
	table := tables at: mapper tableName ifAbsent: [ ^ #() ].
	
	^ table inject: OrderedCollection new into: [ :selected :record | self addInto: selected theOnesThatHold: aCondition unmapping: record with: mapper ]! !

	| table existingRecord |

	table := self tableNamed: aTableName.
	existingRecord := table at: (self recordId: aRecord) ifAbsentPut: [ aRecord ].
	existingRecord == aRecord ifFalse: [ self error: 'Duplicated primary key' ]! !

	^ table at: (self idOf: anOwner) ifAbsentPut: [ Set new ]! !

	cache at: (self idOf: anObject) put: anObject ! !

	self error: ('Relation between id <1s> of type <2s> and id <3s> of type <4s> already exist'
		expandMacrosWith: (self idOf: anOwner) printString
		with: anOwner class name
		with: (self idOf: aRelated) printString
		with: aRelated class name)! !

	| relatedIds relatedId |

	relatedIds := self relatedIdsOwnedBy: anOwner forType: aRelated class.
	relatedId := aRelated instVarNamed: #id.
	self assertRelationOwnedBy: anOwner isUniqueFor: aRelated identifiedAs: relatedId in: relatedIds.
	
	relatedIds add: relatedId! !

	(relatedIds includes: relatedId) ifTrue: [ self signalRelationAlreadyExistBetween: anOwner and: aRelated ]! !

	| relatedIds table |

	table := self relationTableFor: anOwner class relatedTo: aRelatedClass.
	relatedIds := self relatedIdOwnedBy: anOwner on: table.
	
	^ relatedIds! !

	configuration := aConfiguration.
	id := 0.

	tables := nil.
	cache := nil.! !

	self toDo: 'se puede mejorar performanco usando un dictionary'.
	^configuration
		detect: [ :aClassMapper | aClassMapper isFor: aClass ] 
		ifNone: [ self error: ('There is no mapper for <1s>' expandMacrosWith: aClass name) ]! !

	| record table mapper |

	mapper := self mapperFor: aClass.
	table := self tableNamed: mapper tableName.
	record := table at: id ifAbsent: [ self error: ('Object identified as <1s> does not exist' expandMacrosWith: anId printString) ].
	
	^ mapper unmap: record using: self! !

	| table relatedIds |
	
	table := self relationTableFor: anOwner class relatedTo: aRelatedClass.
	relatedIds := table at: (self idOf: anOwner) ifAbsent: [ ^#() ].
	
	^relatedIds collect: [ :aRelatedId | self objectIdentifiedAs: aRelatedId ofType: aRelatedClass ]
	

	! !
	
	cache notNil ifTrue: [ self error: 'There is an open transaction already' ]! !

	self assertIsOpen.
	self assertNotInTransasction.
	
	cache := WeakKeyDictionary new.
	
! !
	
	cache isNil ifTrue: [ self error: 'There is no transaction currently' ]! !
	
	self assertInTransaction.
	
	cache := nil! !

	^aRecord at: #id! !

	id := id + 1.
	^id! !

	^anObject instVarNamed: #id! !

	| relationTableName table |

	relationTableName := self relationTableNameOwnedBy: anOwnerClass relatedTo: aRelatedClass.
	table := self tableNamed: relationTableName.
	
	^ table! !

	| ownerClassMapper relatedClassMapper |
	
	ownerClassMapper := self mapperFor: anOwnerClass.
	relatedClassMapper := self mapperFor: aRelatedClass.
	
	^ownerClassMapper tableName,'_', relatedClassMapper tableName asPlural.! !

	^ tables at: aTableName ifAbsentPut: [ Dictionary new ]! !

	| recordId aClassInstance |

	recordId := self recordId: record.
	aClassInstance := cache at: recordId ifAbsent: [ mapper unmap: record using: self ].
	(aCondition value: aClassInstance) ifTrue: [ 
		self addToCache: aClassInstance.
		selected add: aClassInstance ].
	
	^ selected! !
	
	tables isNil ifTrue: [ self error: 'Session must be open to colaborate with it' ]! !
	
	tables isNil ifFalse: [ self error: 'Session must be close' ]! !

	self assertIsOpen.
	
	tables := nil! !

	self assertIsClose.
	
	tables := Dictionary new.
	! !

	^self new initializeFor: aConfiguration! !
	self subclassResponsibility! !
	self subclassResponsibility! !
	self subclassResponsibility! !

	aFieldName trimBoth isEmpty ifTrue: [ self error: 'Field name can not be empty' ]! !

	^anInstanceVariableName asString! !

	aRecord at: fieldName put: (anObject instVarNamed: instanceVariableName) ! !

	anObject instVarNamed: instanceVariableName put: (aRecord at: fieldName)! !
	
	! !

	instanceVariableName := anInstanceVariableName.
	fieldName := aFieldName ! !

	^self for: anInstanceVariableName into: (self defaultFieldNameFor: anInstanceVariableName)! !

	^self new initializeFor: anInstanceVariableName into: aFieldName ! !

	instanceVariableName := anInstanceVariableName.
	fieldName := aFieldName.
	relatedType := aClass ! !
	! !

	| newCollection related |

	related := aDataBaseSession relatedOfType: relatedType for: anObject.
	newCollection := self createRelationCollectionOn: aDataBaseSession ownedBy: anObject.

	newCollection addAllNotPersisting: related.
	anObject instVarNamed: instanceVariableName put: newCollection! !
	^ OneToManySet on: aDataBaseSession ownedBy: anObject! !

	| oldCollection newCollection |

	newCollection := self createRelationCollectionOn: aDataBaseSession ownedBy: anObject.
	oldCollection := anObject instVarNamed: instanceVariableName.
	
	newCollection addAll: oldCollection.
	anObject instVarNamed: instanceVariableName put: newCollection! !

	self assertValidFieldName: aFieldName.
	
	^self new initializeFor: anInstanceVariableName into: aFieldName ofType: aClass! !

	^self for: anInstanceVariableName into: (self defaultFieldNameFor: anInstanceVariableName) ofType: aClass! !
	
	session := aDataBaseSession.
	owner := anOwner ! !

	self shouldBeImplemented ! !
	
	^aCollection do: [ :anObjectToAdd | super add: anObjectToAdd ]! !

	session addCustomer: anObject.
	session addRelated: anObject ownedBy: owner.
	
	super add: anObject.
! !
	
	^self new initializeOn: aDataBaseSession ownedBy: anOwner ! !