'From Pharo6.0 of 13 May 2016 [Latest update: #60519] on 6 November 2017 at 9:11:16.134618 pm'!
TestCase subclass: #TestImportCustomers
	instanceVariableNames: 'test id firstName lastName identificationType identificationNumber addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: '10Pines-C17-1-Model'!

!TestImportCustomers methodsFor: 'importing' stamp: 'LJ 11/6/2017 21:07'!
importCustomers

	"
	self importCustomers
	"
	| inputStream session newCustomer line |
	
	inputStream := FileStream fileNamed: 'input.txt'.
	session := DataBaseSession for: (Array 
		with: (ClassMapping 
			withDefaultTableNameFor: Address 
			mappingAll: (Array 
				with: (EmbededMapping withDefaultFieldNameFor: #streetName)
				with: (EmbededMapping withDefaultFieldNameFor: #streetNumber)
				with: (EmbededMapping withDefaultFieldNameFor: #town)
				with: (EmbededMapping withDefaultFieldNameFor: #zipCode)
				with: (EmbededMapping withDefaultFieldNameFor: #province))) 
		with: (ClassMapping 
			withDefaultTableNameFor: Customer 
			mappingAll: (Array 
				with: (EmbededMapping withDefaultFieldNameFor: #firstName)
				with: (EmbededMapping withDefaultFieldNameFor: #lastName)
				with: (EmbededMapping withDefaultFieldNameFor: #identificationType)
				with: (EmbededMapping withDefaultFieldNameFor: #identificationNumber)
				with: (OneToManyMapping withDefaultFieldNameFor: #addresses ofType: Address)))).
	session open.
	session beginTransaction.

	line := inputStream nextLine.
	[ line notNil ] whileTrue: [ 
		(line beginsWith: 'C') ifTrue: [ | customerData |
			customerData := line substrings: {$,}.
			newCustomer := Customer new.
			newCustomer firstName: customerData second.
			newCustomer lastName: customerData third.
			newCustomer identificationType: customerData fourth.
			newCustomer identificationNumber: customerData fourth.
			session persist: newCustomer ].
		
		(line beginsWith: 'A') ifTrue: [ | addressData newAddress |
			addressData := line substrings: { $, }.
			newAddress := Address new.
			newAddress streetName: addressData second.
			newAddress streetNumber: addressData third asInteger. 
			newAddress town: addressData fourth.
			newAddress zipCode: addressData fifth asInteger.
			newAddress province: addressData fourth.
			newCustomer addAddress: newAddress. ].
			
			line := inputStream nextLine. ].
			
		session commit.
		session close.
		
		inputStream close.
		! !

!TestImportCustomers methodsFor: 'importing' stamp: 'LJ 11/6/2017 21:07'!
setUp
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
	session beginTransaction! !

!TestImportCustomers methodsFor: 'importing' stamp: 'LJ 11/6/2017 21:07'!
tearDown
	session commit.
	session close! !


!TestImportCustomers methodsFor: 'tests' stamp: 'LJ 11/6/2017 21:07'!
test02FirstCustomerImportsCorrectly
	
	| customers customer |
	self importCustomers.
	
	self assert: (session selectAllOfType: Customer) size equals: 2.
	
	customers := session select: [:aCustomer | aCustomer firstName = 'Pepe'] ofType: Customer .
	
	self assert: customers size equals: 1.
	
	customer := customers first.
	
	self assert: (customer firstName) equals: 'Pepe'.
	self assert: (customer lastName) equals: 'Sanchez'.
	self assert: (customer identificationNumber) equals: '22333444'.
	self assert: (customer identificationType) equals: 'D'.
	! !

!TestImportCustomers methodsFor: 'tests' stamp: 'LJ 11/6/2017 21:07'!
pepeCustomer
	| customer customers |
	customers := session
		select: [ :aCustomer | aCustomer firstName = 'Pepe' ]
		ofType: Customer.
	self assert: customers size equals: 1.
	customer := customers first.
	^ customer! !

!TestImportCustomers methodsFor: 'tests' stamp: 'LJ 11/6/2017 21:07'!
test01DataWasImported

	self importCustomers.
	
	self assert: (session selectAllOfType: Customer) size equals: 2.
	self assert: (session selectAllOfType: Address) size equals: 3.! !

!TestImportCustomers methodsFor: 'tests' stamp: 'LJ 11/6/2017 21:07'!
test03FirstAddressImportsCorrectly
	
	| addresses address |
	self importCustomers.
	
	self assert: (session selectAllOfType: Address ) size equals: 3.
	
	addresses := session select: [:anAddress | anAddress streetName = 'San Martin']  ofType: Address.
	
	self assert: addresses size equals: 1.
	
	address := addresses first.
	self assert: (address province) equals: 'BsAs'.	
	self assert: (address zipCode) equals: 1636.	
	self assert: (address streetName) equals: 'San Martin'.				
	self assert: (address streetNumber) equals: 3322.	
	self assert: (address town) equals: 'Olivos'.	! !
