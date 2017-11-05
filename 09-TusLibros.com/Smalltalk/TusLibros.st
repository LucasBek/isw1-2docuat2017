!classDefinition: #TestTusLibros category: #TusLibros!
TestCase subclass: #TestTusLibros
	instanceVariableNames: 'cart book anotherEditorialBook catalogue secondBook cashier expiredCreditCard creditCard testObjectFactory priceValuator currentMonthYear salesBook merchantProcessorClosure restInterface timer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TestTusLibros methodsFor: 'Cart' stamp: 'kl 10/26/2017 21:25:38'!
test01WhenCreatingACartItIsEmpty
	self assert: cart isEmpty.! !

!TestTusLibros methodsFor: 'Cart' stamp: 'kl 10/26/2017 21:26:24'!
test02WhenAddingAProductToACartItIsNotEmpty
	cart add: book.
	self deny: cart isEmpty.! !

!TestTusLibros methodsFor: 'Cart' stamp: 'LJ 10/28/2017 17:27:07'!
test03WhenAddingABookFromAnotherEditorialToACartItThrowsNotInCatalogueErrorAndRemainsEmpty
	self
		should: [cart add: anotherEditorialBook]
		raise: Error
		withExceptionDo: [:anError | 
			self assert: (anError messageText) equals: Cart productNotInCatalogueErrorMessage.
			self assert: cart isEmpty.
		]
	! !

!TestTusLibros methodsFor: 'Cart' stamp: 'kl 10/26/2017 21:27:54'!
test04WhenAddingTwiceTheSameBookToACartItsSizeIsTwo
	cart add: book.
	cart add: book.
	self assert: (cart size) equals: 2.! !

!TestTusLibros methodsFor: 'Cart' stamp: 'kl 10/30/2017 19:08:22'!
test06CartListOfProductsEqualsBooksAdded
	cart add: book times: 10.
	cart add: secondBook.
	cart add: book.
	self assert: (cart occurrencesOf: book) equals: 11.
	self assert: (cart occurrencesOf: secondBook) equals: 1.
! !

!TestTusLibros methodsFor: 'Cart' stamp: 'kl 10/30/2017 18:58:58'!
test07WhenAddingANotNaturalNumberOfItemsToTheCartThrowsIncorrectNumberErrorAndRemainsEmpty
	
	|notNaturalNumbers|
	notNaturalNumbers := OrderedCollection with: -10 with: 0 with: 1/3.
	
	notNaturalNumbers do: [:aNotNaturalnumber |
		self
			should: [cart add: book times: aNotNaturalnumber]
			raise: Error
			withExceptionDo: [:anError | 
				self assert: (anError messageText) equals: Cart numberNotNaturalErrorMessage.
				self assert: cart isEmpty.
			].
	].
	! !


!TestTusLibros methodsFor: 'Setup' stamp: 'LJ 11/4/2017 23:06:51'!
setUp
	|priceBook|
	
	testObjectFactory _ TestObjectFactory new.
	book _ testObjectFactory bookFromEditorial.
	secondBook _ testObjectFactory anotherBookFromEditorial.
	anotherEditorialBook _ testObjectFactory bookNotFromEditorial.
	catalogue _ testObjectFactory catalogue.
	cart _ Cart withCatalogue: catalogue.
	
	currentMonthYear := GregorianMonthOfYear current.
	expiredCreditCard _ testObjectFactory expiredCreditCardFor: 'Pepe'.
	creditCard _ testObjectFactory notExpiredCreditCardFor: 'Pepe'.
	priceBook _ testObjectFactory priceBook.
	priceValuator _ [:aProduct | priceBook at: aProduct].
	
	salesBook _ OrderedCollection new.
	
	cashier _ Cashier with: priceValuator on: (salesBook) withMerchantProcessor: self.
	
	merchantProcessorClosure _ [:anAmount :aCreditCard |].
	
	timer _ ManualTimer new.
	
	restInterface _ RestInterface withUsers: (self validUsersAndPasswords)  withMerchantProcessor: self  withSalesBook: salesBook  withCatalogue: catalogue  withPriceValuator: priceValuator withTimer: timer.! !


!TestTusLibros methodsFor: 'Cashier' stamp: 'LJ 11/4/2017 23:59:40'!
test08WhenCheckingOutEmptyCartErrorMessageIsThrown
	self
		should: [cashier charge: cart to: creditCard withUser: creditCard owner]
		raise: Error
		withExceptionDo: [:anError | 
			self assert: (anError messageText) equals: Cashier emptyCartErrorMessage.
			self assert: salesBook isEmpty.
		]! !

!TestTusLibros methodsFor: 'Cashier' stamp: 'LJ 11/5/2017 00:00:12'!
test09WhenCheckingOutCartToExpiredCardErrorMessageIsThrown
	cart add: book.
	self
		should: [cashier charge: cart to: expiredCreditCard  withUser: expiredCreditCard owner]
		raise: Error
		withExceptionDo: [:anError | 
			self assert: (anError messageText) equals: Cashier expiratedCreditCardErrorMessage.
			self assert: salesBook isEmpty.
		]! !

!TestTusLibros methodsFor: 'Cashier' stamp: 'LJ 11/5/2017 01:45:06'!
test10WhenCheckingOutSuccessfullyAmountChargedInTicketIsCorrect
	|ticket|
	cart add: book times: 1.
	cart add: secondBook times: 2.
	 
	ticket _  cashier charge: cart to: creditCard  withUser: creditCard owner.
	self assert: (ticket items size) equals: 2.
	self assert: (ticket total) equals: ((1 * (priceValuator value: book)) + (2 * (priceValuator value: secondBook))).! !

!TestTusLibros methodsFor: 'Cashier' stamp: 'LJ 11/4/2017 23:59:57'!
test11OnCartCheckoutSaleIsStoredInSalesBook
	cart add: secondBook times: 5. 
	cashier charge: cart to: creditCard  withUser: creditCard owner.
	self assert: (salesBook size = 1).
		"When there is a problem with the credit card, there was no comunication"
	! !


!TestTusLibros methodsFor: 'MerchantProcessorInterface' stamp: 'kl 10/30/2017 21:43:48'!
changeMerchantProcessorClosure: aBlockClosure 
	merchantProcessorClosure _ aBlockClosure .! !

!TestTusLibros methodsFor: 'MerchantProcessorInterface' stamp: 'kl 11/2/2017 18:25:48'!
debit: anAmount from: aCreditCard
	^ merchantProcessorClosure value: anAmount value: aCreditCard.! !

!TestTusLibros methodsFor: 'MerchantProcessorInterface' stamp: 'LJ 11/5/2017 00:00:04'!
test12CantCheckoutWithStolenCreditCard
	cart add: secondBook times: 5.
	
	self changeMerchantProcessorClosure: [:anAmount :aCreditCard | self error: Cashier stolenCreditCardErrorMessage].
	
	self should: [cashier charge: cart to: creditCard  withUser: creditCard owner.] 
		 raise: Error
		withExceptionDo: [:anError |
			self assert: (anError messageText) equals: (Cashier stolenCreditCardErrorMessage).
			self assert: salesBook isEmpty.
		].
			
	
	! !

!TestTusLibros methodsFor: 'MerchantProcessorInterface' stamp: 'LJ 11/5/2017 00:00:39'!
test13CantCheckoutWithNoCashCreditCard
	cart add: secondBook times: 5.
	
	self changeMerchantProcessorClosure: [:anAmount :aCreditCard | self error: Cashier noFoundsCreditCardErrorMessage].
	
	self should: [cashier charge: cart to: creditCard withUser: creditCard owner] 
		 raise: Error
		withExceptionDo: [:anError |
			self assert: (anError messageText) equals: (Cashier noFoundsCreditCardErrorMessage).
			self assert: salesBook isEmpty.
		].
			
	
	! !

!TestTusLibros methodsFor: 'MerchantProcessorInterface' stamp: 'LJ 11/5/2017 00:00:44'!
test14WhenCheckingOutAmounAndCreditCardAreCorrect
	|usedCreditCard amountInTIcket ticket|
	cart add: secondBook times: 5.
	
	self changeMerchantProcessorClosure: [:anAmount :aCreditCard | 
		usedCreditCard := aCreditCard.
		amountInTIcket := anAmount.
	].
	
	ticket := cashier charge: cart to: creditCard withUser: creditCard owner.
	self assert: usedCreditCard equals: (creditCard).
	self assert: amountInTIcket equals: (ticket total).

"Si mantenemos que hay un cajero persona entonces agregar test donde el closure tenga [self fail]"

"Dummy son aquellos que no son relevantes para el test y los creo nada mas porque se necesitan"
"Stub son los que configuro con respuestas predefinidas para comprobar que se esta testeando "		
"Mock es para ver como se colaboro con ellos. no hace falta configurarlos. Son tests de caja blanca y son fragiles ante cambios. Es mejor tener factories de objetos que son utilizados en los tests."
"Proveen la misma funcionalidad pero mas light. BD en memoria por ejemplo"

"Hoy Mockito usa mezcla entre stubs y mocks."
"Usar los simuladores para que el test este en control de todo y para representar todo aquello que este externo al modelo."! !


!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 23:07:35'!
advanceTime: aTimeAmount
	timer advanceTime: aTimeAmount.! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 18:25:32'!
invalidCartId
	^ nil! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 18:18:38'!
invalidPassword
	^ 'invalid password'! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 18:16:25'!
invalidUser
	^ 'invalid user'! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 18:23:35'!
test15CannotCreateCartWithInvalidUser
	self
		should: [
			restInterface 
				createCartFor: self invalidUser
				withPassword: 'Brianesco' ]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface invalidUserErrorMessage ].
	
	self
		should: [
			restInterface 
				createCartFor: self validUser
				withPassword: self invalidPassword ]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface invalidUserErrorMessage ].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 18:24:52'!
test16AfterCreatingaCartItIsEmpty
	| id |
	id _ restInterface 
		createCartFor: self validUser
		withPassword: self validPassword.
	self
		assert: (restInterface listCartWithId: id)
		equals: Bag new.! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 18:25:42'!
test18CannotListAnInexistentCart
	self
		should: [restInterface listCartWithId: self invalidCartId]
		raise: Error
		withExceptionDo: [ :anError | 
			self assert: anError messageText = RestInterface invalidCartIdErrorMessage].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 18:25:51'!
test19CannotAddAProductToAnInexistentCart
	self
		should: [restInterface addToCart: (self invalidCartId) aProduct: book times: 1]
		raise: Error
		withExceptionDo: [ :anError | 
			self assert: anError messageText = RestInterface invalidCartIdErrorMessage].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 18:55:57'!
test20AddingAProductToACartMakesItNotEmptyAnyMore
	| id |
	id _ restInterface 
		createCartFor: self validUser
		withPassword: self validPassword.
	restInterface addToCart: id aProduct: book times: 1.
	restInterface addToCart: id aProduct: secondBook times: 2.

	self assert: (((restInterface listCartWithId: id) occurrencesOf: book) = 1).
	self assert: (((restInterface listCartWithId: id) occurrencesOf: secondBook) = 2).
	! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 18:26:33'!
test21CannotAddProductNotInCatalogueToACart
	| id |
	id _ restInterface 
		createCartFor: self validUser
		withPassword: self validPassword.
	
	self
		should: [ restInterface addToCart: id aProduct: anotherEditorialBook times: 1. ]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface productNotInCatalogueErrorMessage ].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 18:26:41'!
test22WhenCheckingOutInexistentCartErrorMessageIsThrown
	self
		should: [ restInterface checkout: (self invalidCartId) withCreditCard: creditCard.]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface invalidCartIdErrorMessage ].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 18:27:04'!
test23WhenCheckingOutEmptyCartErrorMessageIsThrown
	| id |
	id _ restInterface 
		createCartFor: self validUser
		withPassword: self validPassword.
	self
		should: [ restInterface checkout: id withCreditCard: creditCard.]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface emptyCartErrorMessage ].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 18:27:27'!
test24WhenCheckingOutCartToExpiredCardErrorMessageIsThrown
	| id |
	id _ restInterface 
		createCartFor: self validUser
		withPassword: self validPassword.
	restInterface addToCart: id aProduct: book times: 1.
	self
		should: [ restInterface checkout: id withCreditCard: expiredCreditCard .]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface expiratedCreditCardErrorMessage ].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 18:28:54'!
test26CannotListPurchasesWithInvalidUser
	self
		should: [
			restInterface 
				listPurchasesFor: self invalidUser
				withPassword: 'Brianesco' ]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface invalidUserErrorMessage ].
	
	self
		should: [
			restInterface 
				listPurchasesFor: self validUser
				withPassword:  self invalidPassword]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface invalidUserErrorMessage ].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 01:27:05'!
test27ListPurchasesForAValidUser
	| id purchases |
	id _ restInterface 
		createCartFor: self validUser
		withPassword: self validPassword.
	restInterface addToCart: id aProduct: book times: 1.
	restInterface addToCart: id aProduct: secondBook times: 5.
	restInterface checkout: id withCreditCard: creditCard.
	purchases _ restInterface 
		listPurchasesFor: self validUser
		withPassword: self validPassword.

		self assert: (purchases amountPurchasedOf: book) equals: 1.
		self assert: (purchases amountPurchasedOf: secondBook) equals: 5.
		self assert: (purchases total) equals: ((priceValuator value: book) + ((priceValuator value: secondBook) * 5)).! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 01:03:40'!
test31CantOperateOnExpiredCart
	| id operations |
	id _ restInterface 
		createCartFor: self validUser
		withPassword: self validPassword.
		
	self advanceTime: 30 minutes.
	
	operations _ OrderedCollection with: [restInterface addToCart: id aProduct: book times: 1] with: [restInterface listCartWithId: id] with: [restInterface checkout: id withCreditCard: creditCard ].
	
	operations do: [:operationBlock |
		self should: operationBlock
		  raise: Error
		  withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: CartSession sessionExpiredErrorMessage ].	
	].
	
	
	
	! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 18:31:47'!
validPassword
	^ 'valid password'! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 18:16:17'!
validUser
	^ 'valid user'! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 18:19:26'!
validUsersAndPasswords
	^ Dictionary newFromPairs: {(self validUser). (self validPassword)}.! !


!classDefinition: #Cart category: #TusLibros!
Object subclass: #Cart
	instanceVariableNames: 'products catalogue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 01:20:37'!
add: aProduct
	self add: aProduct times: 1.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 01:25:40'!
add: aProduct times: numberOfTimes
	self assertIsInCatalogue: aProduct.
	self assertIsPositiveInteger: numberOfTimes .
	numberOfTimes timesRepeat: [products add: aProduct]! !

!Cart methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 01:22:32'!
assertIsInCatalogue: aProduct
	(catalogue includes: aProduct) ifFalse: [self error: Cart productNotInCatalogueErrorMessage] .! !

!Cart methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 01:24:16'!
assertIsPositiveInteger: aNumber
	((aNumber > 0) and: (aNumber isInteger)) ifFalse: [self error: Cart numberNotNaturalErrorMessage].! !

!Cart methodsFor: 'as yet unclassified' stamp: 'kl 11/2/2017 20:23:47'!
costBasedOn: aValuator
	^ (products collect: [:aProduct | aValuator value: aProduct]) sum.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 01:32:44'!
initializeWithCatalogue: aCatalogue
	catalogue := aCatalogue.
	products := Bag new.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'kl 10/26/2017 19:46:58'!
isEmpty
	^ products isEmpty.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 19:09:41'!
occurrencesOf: aProduct
	^ products occurrencesOf: aProduct.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 11:32:03'!
products
	^ products copy.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'kl 10/26/2017 21:06:27'!
size
	^ products size.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 19:20:04'!
uniqueProducts	
	^ products asSet.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #TusLibros!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'as yet unclassified' stamp: 'LJ 10/28/2017 17:35:36'!
numberNotNaturalErrorMessage
	^ 'Number must be natural'! !

!Cart class methodsFor: 'as yet unclassified' stamp: 'kl 10/26/2017 20:34:59'!
productNotInCatalogueErrorMessage
	^ 'Product does not exist in catalogue'! !

!Cart class methodsFor: 'as yet unclassified' stamp: 'kl 10/26/2017 20:01:39'!
withCatalogue: aCatalogue
	^ self new initializeWithCatalogue: aCatalogue.! !


!classDefinition: #CartSession category: #TusLibros!
Object subclass: #CartSession
	instanceVariableNames: 'cart lastOperationTime sessionDuration timer user'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartSession methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 00:27:04'!
assertNotExpired
	self hasExpired ifTrue: [self error: CartSession sessionExpiredErrorMessage ].! !

!CartSession methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 00:29:53'!
hasExpired
	^ lastOperationTime + sessionDuration <= timer now.! !

!CartSession methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 00:05:24'!
user
	^ user! !

!CartSession methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 00:03:58'!
with: aCart sessionDuration: aTime withTimer: aTimer withUser: aUser
	cart _ aCart.
	sessionDuration _ aTime.
	timer _ aTimer.
	lastOperationTime _ timer now.
	user _ aUser .
! !

!CartSession methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 00:06:52'!
withCartDo: aBlock
	self assertNotExpired.
	^ [aBlock value: cart value: user] ensure: [lastOperationTime _ timer now].
				! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CartSession class' category: #TusLibros!
CartSession class
	instanceVariableNames: ''!

!CartSession class methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 00:27:09'!
sessionExpiredErrorMessage
	^ 'Session has expired'! !

!CartSession class methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 00:02:53'!
with: aCart sessionDuration: aTime withTimer: aTimer withUser: aUser
	^ self new with: aCart sessionDuration: aTime withTimer: aTimer withUser: aUser.! !


!classDefinition: #Cashier category: #TusLibros!
Object subclass: #Cashier
	instanceVariableNames: 'valuator salesBook merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 23:58:42'!
charge: aCart to: aCreditCard withUser: aUser
	| ticket total|
	aCart isEmpty ifTrue: [self error: Cashier emptyCartErrorMessage].
	(aCreditCard isExpiredOn: GregorianMonthOfYear current) ifTrue: [self error: Cashier expiratedCreditCardErrorMessage.].
	total _ aCart costBasedOn: valuator.
	self debit: total from: aCreditCard.
	ticket _ self makeTicketFor: aCart.
	salesBook add: (Sale with: (ticket copy) for: aUser).
	^ ticket.! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'kl 11/2/2017 20:21:08'!
debit: aTotal from: aCreditCard
  merchantProcessor debit: aTotal from: aCreditCard.
! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'kl 11/2/2017 20:25:26'!
makeTicketFor: aCart 
	^ Ticket with: ( (aCart uniqueProducts collect: [:aProduct | TicketItem for: aProduct withPrice: (valuator value: aProduct) withAmount: (aCart occurrencesOf: aProduct)])).! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 19:10:48'!
salesBook
	^ salesBook! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 21:40:45'!
with: aValuator on: aSalesBook withMerchantProcessor: aMerchantProcessor
	valuator := aValuator.
	salesBook _ aSalesBook.
	merchantProcessor _ aMerchantProcessor .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: #TusLibros!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'error handling' stamp: 'LJ 10/28/2017 17:45:20'!
emptyCartErrorMessage
	^ 'Cart must have at least one product to charge it'.! !

!Cashier class methodsFor: 'error handling' stamp: 'LJ 10/28/2017 18:02:55'!
expiratedCreditCardErrorMessage
	^ 'Credit card must not be expired'.! !

!Cashier class methodsFor: 'error handling' stamp: 'kl 11/2/2017 18:32:03'!
noFoundsCreditCardErrorMessage
	^ 'Credit Card with no founds'! !

!Cashier class methodsFor: 'error handling' stamp: 'kl 11/2/2017 18:31:01'!
stolenCreditCardErrorMessage
	^ 'Stolen credit card'.! !

!Cashier class methodsFor: 'error handling' stamp: 'kl 10/30/2017 21:40:25'!
with: aValuator on: aSalesBook withMerchantProcessor: aMerchantProcessor
	^ self new with: aValuator on: aSalesBook withMerchantProcessor: aMerchantProcessor.! !


!classDefinition: #CreditCard category: #TusLibros!
Object subclass: #CreditCard
	instanceVariableNames: 'person number expirationDate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 21:43:22'!
for: aPerson withNumber: aNumber andExpirationDate: anExpirationDate 
"	(aPerson trim) length = 0 ifTrue: [self error: 'Person name cannot be empty'].
	"
	person := aPerson.
	number := aNumber.
	expirationDate := anExpirationDate.! !

!CreditCard methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 18:35:49'!
isExpiredOn: aDate
	^ expirationDate < aDate.! !

!CreditCard methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 13:16:39'!
owner
	^ person.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: #TusLibros!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'class initialization' stamp: 'LJ 10/28/2017 18:09:34'!
for: aPerson withNumber: aNumber andExpirationDate: anExpirationDate 
	^ self new for: aPerson withNumber: aNumber andExpirationDate: anExpirationDate.! !


!classDefinition: #ManualTimer category: #TusLibros!
Object subclass: #ManualTimer
	instanceVariableNames: 'now'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!ManualTimer methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 23:06:08'!
advanceTime: aTimeAmount
	now _ now + aTimeAmount ! !

!ManualTimer methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 23:04:55'!
initialize
	now _ 0 seconds.! !

!ManualTimer methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 23:09:50'!
now
	^ now! !


!classDefinition: #Purchases category: #TusLibros!
Object subclass: #Purchases
	instanceVariableNames: 'total purchased'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Purchases methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 20:01:00'!
amountPurchasedOf: aProduct
	^ purchased at: aProduct.
! !

!Purchases methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 00:48:26'!
productsPurchased
	^ purchased keys.! !

!Purchases methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 19:58:55'!
total
	^ total.! !

!Purchases methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 20:01:06'!
with: aPurchasesDictionary totaling: aTotal
	purchased _ aPurchasesDictionary .
	total _ aTotal .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Purchases class' category: #TusLibros!
Purchases class
	instanceVariableNames: ''!

!Purchases class methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 19:54:46'!
with: aPurchasesDictionary totaling: aTotal
	^ self new with: aPurchasesDictionary totaling: aTotal
! !


!classDefinition: #RestInterface category: #TusLibros!
Object subclass: #RestInterface
	instanceVariableNames: 'users cartSessions catalogue cashier salesBook timer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 19:36:47'!
addSale: aSale to: salesByProduct
	aSale productsSoldDo: [:aProduct :anAmount | 
		salesByProduct at: aProduct put: ((salesByProduct at: aProduct ifAbsent: 0) + anAmount).
	].! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 00:09:13'!
addToCart: aCartId aProduct: aProduct times: aNumberOfTimes 
	self withCart: aCartId do: [:aCart :aUser | aCart add: aProduct times: aNumberOfTimes ].
! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 00:23:40'!
cartSessionExpiredErrorMessage
	^ ''.! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 00:07:23'!
checkout: aCartId withCreditCard: aCreditCard
	self withCart: aCartId do: [:aCart :aUser| cashier charge: aCart to: aCreditCard withUser: aUser].
! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 00:05:05'!
createCartFor: aUser withPassword: aPassword
	| aCartId aCart|
	self verifyUser: aUser withPassword: aPassword.
	aCartId _ self newCartId.
	aCart _ Cart withCatalogue: catalogue.
	cartSessions at: (aCartId) put: (CartSession with: aCart sessionDuration: (self sessionDuration) withTimer: timer withUser: aUser).
	^ aCartId.! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 00:08:57'!
listCartWithId: aCartId 
	^ self withCart: aCartId  do: [:aCart :aUser | aCart products]
	! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 00:42:00'!
listPurchasesFor: aUser withPassword: aPassword
	|total purchases|
	self verifyUser: aUser withPassword: aPassword.
	
	total _ 0.
	purchases _ Dictionary new.
		
	(self salesByUser: aUser)
				inject: purchases
				into: [:salesByProduct :aSale | 
					self addSale: aSale to: salesByProduct.	
					total _ total + aSale total.
					salesByProduct.			
				].
			
	^ Purchases with: purchases totaling: total.		! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 11:25:25'!
newCartId
	^ LaggedFibonacciRandom new next.! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 19:43:12'!
salesByUser: aUser
	^ salesBook select: [:aSale | aSale soldTo: aUser]
	! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 22:36:25'!
sessionDuration
	^ 30 minutes.! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 11:04:49'!
verifyUser: aUser withPassword: aPassword
	users at: aUser ifAbsent: [ self error: RestInterface invalidUserErrorMessage ].
	aPassword = (users at: aUser) ifFalse: [ self error: RestInterface invalidUserErrorMessage ].! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 22:51:36'!
withCart: aCartId do: aBlock
	|cartSession|
	cartSession _ cartSessions at: aCartId ifAbsent: [self error: RestInterface invalidCartIdErrorMessage].
	^ cartSession withCartDo: aBlock.! !


!RestInterface methodsFor: 'initialization' stamp: 'LJ 11/4/2017 22:37:18'!
withUsers: validUsers withMerchantProcessor: aMerchantProcessor withSalesBook: aSalesBook withCatalogue: aCatalogue withPriceValuator: aPriceValuator withTimer: aTimer
	users _ validUsers.
	cartSessions _ Dictionary new.
	catalogue _ aCatalogue.
	cashier _ Cashier with: aPriceValuator on: aSalesBook withMerchantProcessor: aMerchantProcessor.	
	salesBook _ aSalesBook.
	timer _ aTimer .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RestInterface class' category: #TusLibros!
RestInterface class
	instanceVariableNames: 'carts'!

!RestInterface class methodsFor: 'Error messages' stamp: 'LJ 11/4/2017 20:59:20'!
cartExpiredErrorMessage
	^ 'session expired'! !

!RestInterface class methodsFor: 'Error messages' stamp: 'LJ 11/4/2017 21:00:44'!
cartSessionExpiredErrorMessage
	^ 'Cart session expired'! !

!RestInterface class methodsFor: 'Error messages' stamp: 'LJ 11/4/2017 12:17:56'!
emptyCartErrorMessage
	^ Cashier emptyCartErrorMessage .! !

!RestInterface class methodsFor: 'Error messages' stamp: 'LJ 11/4/2017 12:19:50'!
expiratedCreditCardErrorMessage
	^ Cashier expiratedCreditCardErrorMessage .! !

!RestInterface class methodsFor: 'Error messages' stamp: 'LJ 11/4/2017 11:11:04'!
invalidCartIdErrorMessage
	^ 'Cart not present'! !

!RestInterface class methodsFor: 'Error messages' stamp: 'LJ 11/4/2017 18:24:15'!
invalidUserErrorMessage
	^ 'Invalid user or password'! !

!RestInterface class methodsFor: 'Error messages' stamp: 'LJ 11/4/2017 11:52:04'!
productNotInCatalogueErrorMessage
	^ Cart productNotInCatalogueErrorMessage.! !


!RestInterface class methodsFor: 'initialization' stamp: 'LJ 11/4/2017 22:36:50'!
withUsers: validUsers withMerchantProcessor: aMerchantProcessor withSalesBook: aSalesBook withCatalogue: aCatalogue withPriceValuator: aPriceValuator withTimer: aTimer
	^ self new withUsers: validUsers withMerchantProcessor: aMerchantProcessor withSalesBook: aSalesBook withCatalogue: aCatalogue withPriceValuator: aPriceValuator withTimer: aTimer.! !


!classDefinition: #Sale category: #TusLibros!
Object subclass: #Sale
	instanceVariableNames: 'ticket person'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Sale methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 19:33:25'!
productsSoldDo: aBlock 
	ticket items do: [:aTicketItem| aBlock value: (aTicketItem product) value: (aTicketItem amount)].! !

!Sale methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 19:21:45'!
soldTo: aPerson
	^ person = aPerson.! !

!Sale methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 19:56:13'!
total
	^ ticket total.! !

!Sale methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 13:18:27'!
with: aTicket for: aPerson
	ticket _ aTicket.
	person _ aPerson.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: #TusLibros!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 19:42:36'!
with: aTicket for: aPerson
	^ self new with: aTicket for: aPerson.! !


!classDefinition: #TestObjectFactory category: #TusLibros!
Object subclass: #TestObjectFactory
	instanceVariableNames: 'currentMonthYear'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TestObjectFactory methodsFor: 'as yet unclassified'!
anotherBookFromEditorial
	^ 'another book'.! !

!TestObjectFactory methodsFor: 'as yet unclassified'!
bookFromEditorial
	^ 'a book'.! !

!TestObjectFactory methodsFor: 'as yet unclassified'!
bookNotFromEditorial
	^ 'invalid Book'.! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 18:10:06'!
catalogue
	^ (Set
		with: self bookFromEditorial
		with: self anotherBookFromEditorial).! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 18:15:05'!
expiredCreditCardFor: aPerson
	^ CreditCard
		for: aPerson
		withNumber: 1
		andExpirationDate: currentMonthYear previous.! !

!TestObjectFactory methodsFor: 'as yet unclassified'!
initialize
	currentMonthYear _ GregorianMonthOfYear current.! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 18:15:09'!
notExpiredCreditCardFor: aPerson
	^ CreditCard
		for: aPerson
		withNumber: 1
		andExpirationDate: currentMonthYear next next.! !

!TestObjectFactory methodsFor: 'as yet unclassified'!
priceBook
	^ Dictionary newFromPairs: {self bookFromEditorial. 10. self anotherBookFromEditorial. 5}.! !

!TestObjectFactory methodsFor: 'as yet unclassified'!
salesBook
	^ OrderedCollection new.! !


!classDefinition: #Ticket category: #TusLibros!
Object subclass: #Ticket
	instanceVariableNames: 'items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Ticket methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 19:12:44'!
initializeWith:	aListOfTicketItems
	items := aListOfTicketItems.! !

!Ticket methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 19:29:32'!
items
	^ items.! !

!Ticket methodsFor: 'as yet unclassified' stamp: 'LJ 11/5/2017 01:46:11'!
total
	^ (items sum: [:aTicketItem | aTicketItem summarizedAmount]).! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Ticket class' category: #TusLibros!
Ticket class
	instanceVariableNames: ''!

!Ticket class methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 19:13:07'!
with: aListOfTicketItems
	^ self new initializeWith: aListOfTicketItems.! !


!classDefinition: #TicketItem category: #TusLibros!
Object subclass: #TicketItem
	instanceVariableNames: 'amount price product'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TicketItem methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 19:29:20'!
amount
	^ amount! !

!TicketItem methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 19:17:08'!
for: aProduct withPrice: aPrice withAmount: anAmount
	product := aProduct.
	price := aPrice.
	amount := anAmount.
	! !

!TicketItem methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 19:29:10'!
product
	^ product! !

!TicketItem methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 19:14:59'!
summarizedAmount
	^ amount * price.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TicketItem class' category: #TusLibros!
TicketItem class
	instanceVariableNames: ''!

!TicketItem class methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 23:08:38'!
for: aProduct withPrice: aPrice withAmount: anAmount
	^ self new for: aProduct withPrice: aPrice withAmount: anAmount.! !
