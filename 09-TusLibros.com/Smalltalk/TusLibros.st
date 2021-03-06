!classDefinition: #TestTusLibros category: #TusLibros!
TestCase subclass: #TestTusLibros
	instanceVariableNames: 'cart book anotherEditorialBook catalogue secondBook cashier expiredCreditCard creditCard testObjectFactory priceValuator currentMonthYear salesBook merchantProcessorClosure restInterface timer validPassword invalidPassword validUser invalidUser invalidCartId validUsersAndPasswords'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TestTusLibros methodsFor: 'Cart' stamp: 'LJ 10/26/2017 21:25:38'!
test01WhenCreatingACartItIsEmpty
	self assert: cart isEmpty.! !

!TestTusLibros methodsFor: 'Cart' stamp: 'LJ 10/26/2017 21:26:24'!
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

!TestTusLibros methodsFor: 'Cart' stamp: 'LJ 10/26/2017 21:27:54'!
test04WhenAddingTwiceTheSameBookToACartItsSizeIsTwo
	cart add: book.
	cart add: book.
	self assert: (cart size) equals: 2.! !

!TestTusLibros methodsFor: 'Cart' stamp: 'LJ 10/30/2017 19:08:22'!
test06CartListOfProductsEqualsBooksAdded
	cart add: book times: 10.
	cart add: secondBook.
	cart add: book.
	self assert: (cart occurrencesOf: book) equals: 11.
	self assert: (cart occurrencesOf: secondBook) equals: 1.
! !

!TestTusLibros methodsFor: 'Cart' stamp: 'LJ 10/30/2017 18:58:58'!
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


!TestTusLibros methodsFor: 'Setup' stamp: 'LJ 11/5/2017 15:49:09'!
setUp
	
	testObjectFactory _ TestObjectFactory new.
	book _ testObjectFactory bookFromEditorial.
	secondBook _ testObjectFactory anotherBookFromEditorial.
	anotherEditorialBook _ testObjectFactory bookNotFromEditorial.
	catalogue _ testObjectFactory catalogue.
	cart _  testObjectFactory emptyCart.
	
	currentMonthYear := GregorianMonthOfYear current.
	expiredCreditCard _ testObjectFactory expiredCreditCardFor: 'Pepe'.
	creditCard _ testObjectFactory notExpiredCreditCardFor: 'Pepe'.

	priceValuator _ [:aProduct | testObjectFactory priceBook at: aProduct].
	
	salesBook _ OrderedCollection new.
	
	cashier _ Cashier with: priceValuator on: (salesBook) withMerchantProcessor: self.
	
	merchantProcessorClosure _ [:anAmount :aCreditCard |].
			
	validUser _ testObjectFactory validUser .
	invalidUser _ testObjectFactory invalidUser .
	invalidPassword _ testObjectFactory invalidPassword .
	validPassword _ testObjectFactory validPassword .
	validUsersAndPasswords _ testObjectFactory validUsersAndPasswords .
	
	invalidCartId _ testObjectFactory invalidCartId .
	
	timer _ ManualTimer new.
	restInterface _ RestInterface withUsers: validUsersAndPasswords  withMerchantProcessor: self  withSalesBook: salesBook  withCatalogue: catalogue  withPriceValuator: priceValuator withTimer: timer.
! !


!TestTusLibros methodsFor: 'Cashier' stamp: 'LJ 11/5/2017 16:09:43'!
shouldNotMakeSaleWhenMerchantProcessorReturnsError: anErrorMessage
	
	self changeMerchantProcessorClosure: [:anAmount :aCreditCard | 
		self error: anErrorMessage.
	].
	
	cart add: book times: 1.
	
	self
		should: [cashier charge: cart to: creditCard owner with: creditCard]
		raise: Error
		withExceptionDo: [:anError | 
			self assert: (anError messageText) equals: anErrorMessage.
			self assert: salesBook isEmpty.
		]
		
	! !

!TestTusLibros methodsFor: 'Cashier' stamp: 'LJ 11/5/2017 09:43:40'!
test08WhenCheckingOutEmptyCartErrorMessageIsThrown
	self
		should: [cashier charge: cart to: (creditCard owner) with: creditCard]
		raise: Error
		withExceptionDo: [:anError | 
			self assert: (anError messageText) equals: Cashier emptyCartErrorMessage.
			self assert: salesBook isEmpty.
		]! !

!TestTusLibros methodsFor: 'Cashier' stamp: 'LJ 11/5/2017 15:56:11'!
test09WhenCheckingOutCartToExpiredCardErrorMessageIsThrownAndMerchantProcessorIsNotContacted
	cart add: book.
	
	self changeMerchantProcessorClosure: [:anAmount :aCreditCard | self fail].
	
	self
		should: [cashier charge: cart to: expiredCreditCard owner with: expiredCreditCard]
		raise: Error
		withExceptionDo: [:anError | 
			self assert: (anError messageText) equals: Cashier expiratedCreditCardErrorMessage.
			self assert: salesBook isEmpty.
		]! !

!TestTusLibros methodsFor: 'Cashier' stamp: 'LJ 11/5/2017 09:44:19'!
test10WhenCheckingOutSuccessfullyAmountChargedInTicketIsCorrect
	|ticket|
	cart add: book times: 1.
	cart add: secondBook times: 2.
	 
	ticket _  cashier charge: cart to: creditCard owner with: creditCard.
	self assert: (ticket items size) equals: 2.
	self assert: (ticket total) equals: ((1 * (priceValuator value: book)) + (2 * (priceValuator value: secondBook))).! !

!TestTusLibros methodsFor: 'Cashier' stamp: 'LJ 11/5/2017 15:56:03'!
test11OnCartCheckoutSaleIsStoredInSalesBook
	cart add: secondBook times: 5. 
	cashier charge: cart to: creditCard owner with: creditCard .
	self assert: (salesBook size = 1).
	! !

!TestTusLibros methodsFor: 'Cashier' stamp: 'LJ 11/5/2017 15:59:30'!
test12WhenCheckingOutSuccessfullyCreditCardAndAmountChargedIsCorrect
	| amountCharged creditCardCharged|
	
	self changeMerchantProcessorClosure: [:anAmount :aCreditCard | 
		amountCharged _ anAmount .
		creditCardCharged _ aCreditCard .	
	].
	
	cart add: book times: 1.
	cart add: secondBook times: 2.
	 
	cashier charge: cart to: creditCard owner with: creditCard.
	
	self assert: creditCardCharged equals: creditCard .
	
	self assert: amountCharged equals: ((1 * (priceValuator value: book)) + (2 * (priceValuator value: secondBook))).! !

!TestTusLibros methodsFor: 'Cashier' stamp: 'LJ 11/5/2017 16:10:10'!
test13WhenCheckingOutWithNoFundsInCreditCardMakesNoSale
	
	self shouldNotMakeSaleWhenMerchantProcessorReturnsError: Cashier noFoundsCreditCardErrorMessage.
	
	! !

!TestTusLibros methodsFor: 'Cashier' stamp: 'LJ 11/5/2017 16:10:45'!
test14WhenCheckingOutWithStolenCreditCardMakesNoSale
	
	
	self shouldNotMakeSaleWhenMerchantProcessorReturnsError: Cashier stolenCreditCardErrorMessage.! !


!TestTusLibros methodsFor: 'MerchantProcessorInterface' stamp: 'LJ 10/30/2017 21:43:48'!
changeMerchantProcessorClosure: aBlockClosure 
	merchantProcessorClosure _ aBlockClosure .! !

!TestTusLibros methodsFor: 'MerchantProcessorInterface' stamp: 'LJ 11/2/2017 18:25:48'!
debit: anAmount from: aCreditCard
	^ merchantProcessorClosure value: anAmount value: aCreditCard.! !

!TestTusLibros methodsFor: 'MerchantProcessorInterface' stamp: 'LJ 11/5/2017 09:44:46'!
test12CantCheckoutWithStolenCreditCard
	cart add: secondBook times: 5.
	
	self changeMerchantProcessorClosure: [:anAmount :aCreditCard | self error: Cashier stolenCreditCardErrorMessage].
	
	self should: [cashier charge: cart to: creditCard owner with: creditCard.] 
		 raise: Error
		withExceptionDo: [:anError |
			self assert: (anError messageText) equals: (Cashier stolenCreditCardErrorMessage).
			self assert: salesBook isEmpty.
		].
			
	
	! !

!TestTusLibros methodsFor: 'MerchantProcessorInterface' stamp: 'LJ 11/5/2017 09:44:55'!
test13CantCheckoutWithNoCashCreditCard
	cart add: secondBook times: 5.
	
	self changeMerchantProcessorClosure: [:anAmount :aCreditCard | self error: Cashier noFoundsCreditCardErrorMessage].
	
	self should: [cashier charge: cart to: creditCard owner with: creditCard] 
		 raise: Error
		withExceptionDo: [:anError |
			self assert: (anError messageText) equals: (Cashier noFoundsCreditCardErrorMessage).
			self assert: salesBook isEmpty.
		].
			
	
	! !

!TestTusLibros methodsFor: 'MerchantProcessorInterface' stamp: 'LJ 11/5/2017 09:45:07'!
test14WhenCheckingOutAmounAndCreditCardAreCorrect
	|usedCreditCard amountInTIcket ticket|
	cart add: secondBook times: 5.
	
	self changeMerchantProcessorClosure: [:anAmount :aCreditCard | 
		usedCreditCard := aCreditCard.
		amountInTIcket := anAmount.
	].
	
	ticket := cashier charge: cart to: creditCard owner with: creditCard.
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

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 15:32:15'!
shouldNotBeAbleToOperateOnExpiredCart: anOperationBlock
	|id|	
	id _ restInterface 
		createCartFor: validUser
		withPassword: validPassword.
		
	self advanceTime: 30 minutes.
		
	self should: [anOperationBlock value: id]
		 raise: Error
		 withExceptionDo: [ :anError |
			self assert: anError messageText
			equals: CartSession sessionExpiredErrorMessage ].	
	
	
	
	! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 15:25:13'!
test15CannotCreateCartWithInvalidUser
	self
		should: [
			restInterface 
				createCartFor: invalidUser
				withPassword: validPassword ]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface invalidUserErrorMessage ].
	
	self
		should: [
			restInterface 
				createCartFor: validUser
				withPassword: invalidPassword ]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface invalidUserErrorMessage ].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 15:26:10'!
test16AfterCreatingaCartItIsEmpty
	| id |
	id _ restInterface 
		createCartFor: validUser
		withPassword: validPassword.
	self
		assert: (restInterface listCartWithId: id)
		equals: Bag new.! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 15:24:29'!
test18CannotListAnInexistentCart
	self
		should: [restInterface listCartWithId: invalidCartId]
		raise: Error
		withExceptionDo: [ :anError | 
			self assert: anError messageText = RestInterface invalidCartIdErrorMessage].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 15:24:34'!
test19CannotAddAProductToAnInexistentCart
	self
		should: [restInterface addToCart: (invalidCartId) aProduct: book times: 1]
		raise: Error
		withExceptionDo: [ :anError | 
			self assert: anError messageText = RestInterface invalidCartIdErrorMessage].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 16:34:24'!
test20AfterAddingProductsListCartIncludesThemCorrectly
	| id |
	id _ restInterface 
		createCartFor: validUser
		withPassword: validPassword.
	restInterface addToCart: id aProduct: book times: 1.
	restInterface addToCart: id aProduct: secondBook times: 2.

	self assert: (((restInterface listCartWithId: id) occurrencesOf: book) = 1).
	self assert: (((restInterface listCartWithId: id) occurrencesOf: secondBook) = 2).
	! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 15:26:18'!
test21CannotAddProductNotInCatalogueToACart
	| id |
	id _ restInterface 
		createCartFor: validUser
		withPassword: validPassword.
	
	self
		should: [ restInterface addToCart: id aProduct: anotherEditorialBook times: 1. ]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface productNotInCatalogueErrorMessage ].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 15:24:38'!
test22WhenCheckingOutInexistentCartErrorMessageIsThrown
	self
		should: [ restInterface checkout: (invalidCartId) withCreditCard: creditCard.]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface invalidCartIdErrorMessage ].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 15:26:23'!
test23WhenCheckingOutEmptyCartErrorMessageIsThrown
	| id |
	id _ restInterface 
		createCartFor: validUser
		withPassword: validPassword.
	self
		should: [ restInterface checkout: id withCreditCard: creditCard.]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface emptyCartErrorMessage ].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 15:26:28'!
test24WhenCheckingOutCartToExpiredCardErrorMessageIsThrown
	| id |
	id _ restInterface 
		createCartFor: validUser
		withPassword: validPassword.
	restInterface addToCart: id aProduct: book times: 1.
	self
		should: [ restInterface checkout: id withCreditCard: expiredCreditCard .]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface expiratedCreditCardErrorMessage ].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 15:25:46'!
test26CannotListPurchasesWithInvalidUser
	self
		should: [
			restInterface 
				listPurchasesFor: invalidUser
				withPassword: validPassword ]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface invalidUserErrorMessage ].
	
	self
		should: [
			restInterface 
				listPurchasesFor: validUser
				withPassword:  invalidPassword]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface invalidUserErrorMessage ].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 16:41:01'!
test27ListPurchasesForAValidUserIsCorrect
	| id purchases |
	id _ restInterface 
		createCartFor: validUser
		withPassword: validPassword.
	restInterface addToCart: id aProduct: book times: 1.
	restInterface addToCart: id aProduct: secondBook times: 5.
	restInterface checkout: id withCreditCard: creditCard.
	purchases _ restInterface 
		listPurchasesFor: validUser
		withPassword: validPassword.

		self assert: (purchases amountPurchasedOf: book) equals: 1.
		self assert: (purchases amountPurchasedOf: secondBook) equals: 5.
		self assert: (purchases total) equals: ((priceValuator value: book) + ((priceValuator value: secondBook) * 5)).! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 15:31:47'!
test28CantAddProductsToExpiredCart
	self shouldNotBeAbleToOperateOnExpiredCart:  [:id | restInterface addToCart: id aProduct: book times: 1].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 15:33:29'!
test29CantListProductsOnExpiredCart
	self shouldNotBeAbleToOperateOnExpiredCart:  [:id | restInterface listCartWithId: id].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 15:34:16'!
test30CantCheckoutOnExpiredCart
	self shouldNotBeAbleToOperateOnExpiredCart:  [:id | restInterface checkout: id withCreditCard: creditCard].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/5/2017 17:38:00'!
test31UserCanHaveMultipleCarts
	|firstCartId secondCartID|
	
	firstCartId _ restInterface createCartFor: validUser withPassword: validPassword .
	secondCartID _ restInterface createCartFor: validUser withPassword: validPassword .
	
	restInterface addToCart: firstCartId aProduct: book  times: 1. 
	restInterface addToCart: secondCartID aProduct: book  times: 2.
	
	self assert: ((restInterface listCartWithId: firstCartId) occurrencesOf: book) equals: 1.
	self assert: ((restInterface listCartWithId: secondCartID) occurrencesOf: book) equals: 2.! !


!classDefinition: #Cart category: #TusLibros!
Object subclass: #Cart
	instanceVariableNames: 'products catalogue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'Add products' stamp: 'LJ 11/5/2017 01:20:37'!
add: aProduct
	self add: aProduct times: 1.! !

!Cart methodsFor: 'Add products' stamp: 'LJ 11/5/2017 01:25:40'!
add: aProduct times: numberOfTimes
	self assertIsInCatalogue: aProduct.
	self assertIsPositiveInteger: numberOfTimes .
	numberOfTimes timesRepeat: [products add: aProduct]! !


!Cart methodsFor: 'Content questions' stamp: 'LJ 11/2/2017 20:23:47'!
costBasedOn: aValuator
	^ (products collect: [:aProduct | aValuator value: aProduct]) sum.! !

!Cart methodsFor: 'Content questions' stamp: 'LJ 10/26/2017 19:46:58'!
isEmpty
	^ products isEmpty.! !

!Cart methodsFor: 'Content questions' stamp: 'LJ 10/30/2017 19:09:41'!
occurrencesOf: aProduct
	^ products occurrencesOf: aProduct.! !

!Cart methodsFor: 'Content questions' stamp: 'LJ 10/26/2017 21:06:27'!
size
	^ products size.! !


!Cart methodsFor: 'Content' stamp: 'LJ 11/4/2017 11:32:03'!
products
	^ products copy.! !

!Cart methodsFor: 'Content' stamp: 'LJ 10/30/2017 19:20:04'!
uniqueProducts	
	^ products asSet.! !


!Cart methodsFor: 'Initialization' stamp: 'LJ 11/5/2017 01:32:44'!
initializeWithCatalogue: aCatalogue
	catalogue := aCatalogue.
	products := Bag new.! !


!Cart methodsFor: 'Validation' stamp: 'LJ 11/5/2017 01:22:32'!
assertIsInCatalogue: aProduct
	(catalogue includes: aProduct) ifFalse: [self error: Cart productNotInCatalogueErrorMessage] .! !

!Cart methodsFor: 'Validation' stamp: 'LJ 11/5/2017 01:24:16'!
assertIsPositiveInteger: aNumber
	((aNumber > 0) and: (aNumber isInteger)) ifFalse: [self error: Cart numberNotNaturalErrorMessage].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #TusLibros!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'as yet unclassified' stamp: 'LJ 10/28/2017 17:35:36'!
numberNotNaturalErrorMessage
	^ 'Number must be natural'! !

!Cart class methodsFor: 'as yet unclassified' stamp: 'LJ 10/26/2017 20:34:59'!
productNotInCatalogueErrorMessage
	^ 'Product does not exist in catalogue'! !

!Cart class methodsFor: 'as yet unclassified' stamp: 'LJ 10/26/2017 20:01:39'!
withCatalogue: aCatalogue
	^ self new initializeWithCatalogue: aCatalogue.! !


!classDefinition: #CartSession category: #TusLibros!
Object subclass: #CartSession
	instanceVariableNames: 'cart lastOperationTime sessionDuration timer user'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartSession methodsFor: 'validation' stamp: 'LJ 11/5/2017 00:27:04'!
assertNotExpired
	self hasExpired ifTrue: [self error: CartSession sessionExpiredErrorMessage ].! !

!CartSession methodsFor: 'validation' stamp: 'LJ 11/5/2017 00:29:53'!
hasExpired
	^ lastOperationTime + sessionDuration <= timer now.! !


!CartSession methodsFor: 'initialization' stamp: 'LJ 11/5/2017 00:03:58'!
with: aCart sessionDuration: aTime withTimer: aTimer withUser: aUser
	cart _ aCart.
	sessionDuration _ aTime.
	timer _ aTimer.
	lastOperationTime _ timer now.
	user _ aUser .
! !


!CartSession methodsFor: 'access' stamp: 'LJ 11/5/2017 00:06:52'!
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

!Cashier methodsFor: 'Charging' stamp: 'LJ 11/5/2017 09:42:42'!
charge: aCart to: aUser with: aCreditCard
	| ticket total|
	aCart isEmpty ifTrue: [self error: Cashier emptyCartErrorMessage].
	(aCreditCard isExpiredOn: GregorianMonthOfYear current) ifTrue: [self error: Cashier expiratedCreditCardErrorMessage.].
	total _ aCart costBasedOn: valuator.
	self debit: total from: aCreditCard.
	ticket _ self makeTicketFor: aCart.
	salesBook add: (Sale with: (ticket copy) for: aUser).
	^ ticket.! !

!Cashier methodsFor: 'Charging' stamp: 'LJ 11/2/2017 20:21:08'!
debit: aTotal from: aCreditCard
  merchantProcessor debit: aTotal from: aCreditCard.
! !

!Cashier methodsFor: 'Charging' stamp: 'LJ 11/2/2017 20:25:26'!
makeTicketFor: aCart 
	^ Ticket with: ( (aCart uniqueProducts collect: [:aProduct | TicketItem for: aProduct withPrice: (valuator value: aProduct) withAmount: (aCart occurrencesOf: aProduct)])).! !


!Cashier methodsFor: 'Initialization' stamp: 'LJ 10/30/2017 21:40:45'!
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

!Cashier class methodsFor: 'error handling' stamp: 'LJ 11/2/2017 18:32:03'!
noFoundsCreditCardErrorMessage
	^ 'Credit Card with no founds'! !

!Cashier class methodsFor: 'error handling' stamp: 'LJ 11/2/2017 18:31:01'!
stolenCreditCardErrorMessage
	^ 'Stolen credit card'.! !

!Cashier class methodsFor: 'error handling' stamp: 'LJ 10/30/2017 21:40:25'!
with: aValuator on: aSalesBook withMerchantProcessor: aMerchantProcessor
	^ self new with: aValuator on: aSalesBook withMerchantProcessor: aMerchantProcessor.! !


!classDefinition: #CreditCard category: #TusLibros!
Object subclass: #CreditCard
	instanceVariableNames: 'person number expirationDate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'Initialization' stamp: 'LJ 11/5/2017 09:46:15'!
for: aPerson withNumber: aNumber andExpirationDate: anExpirationDate
	person := aPerson.
	number := aNumber.
	expirationDate := anExpirationDate.! !


!CreditCard methodsFor: 'Accessing' stamp: 'LJ 10/30/2017 18:35:49'!
isExpiredOn: aDate
	^ expirationDate < aDate.! !

!CreditCard methodsFor: 'Accessing' stamp: 'LJ 11/4/2017 13:16:39'!
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

!ManualTimer methodsFor: 'Time' stamp: 'LJ 11/4/2017 23:06:08'!
advanceTime: aTimeAmount
	now _ now + aTimeAmount ! !

!ManualTimer methodsFor: 'Time' stamp: 'LJ 11/4/2017 23:09:50'!
now
	^ now! !


!ManualTimer methodsFor: 'Initialization' stamp: 'LJ 11/4/2017 23:04:55'!
initialize
	now _ 0 seconds.! !


!classDefinition: #Purchases category: #TusLibros!
Object subclass: #Purchases
	instanceVariableNames: 'total purchased'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Purchases methodsFor: 'access' stamp: 'LJ 11/4/2017 20:01:00'!
amountPurchasedOf: aProduct
	^ purchased at: aProduct.
! !

!Purchases methodsFor: 'access' stamp: 'LJ 11/4/2017 19:58:55'!
total
	^ total.! !


!Purchases methodsFor: 'Initialization' stamp: 'LJ 11/4/2017 20:01:06'!
with: aPurchasesDictionary totaling: aTotal
	purchased _ aPurchasesDictionary .
	total _ aTotal .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Purchases class' category: #TusLibros!
Purchases class
	instanceVariableNames: ''!

!Purchases class methodsFor: 'Class Initialization' stamp: 'LJ 11/4/2017 19:54:46'!
with: aPurchasesDictionary totaling: aTotal
	^ self new with: aPurchasesDictionary totaling: aTotal
! !


!classDefinition: #RestInterface category: #TusLibros!
Object subclass: #RestInterface
	instanceVariableNames: 'users cartSessions catalogue cashier salesBook timer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!RestInterface methodsFor: 'Purchases listing' stamp: 'LJ 11/4/2017 19:36:47'!
addSale: aSale to: salesByProduct
	aSale productsSoldDo: [:aProduct :anAmount | 
		salesByProduct at: aProduct put: ((salesByProduct at: aProduct ifAbsent: 0) + anAmount).
	].! !

!RestInterface methodsFor: 'Purchases listing' stamp: 'LJ 11/5/2017 00:42:00'!
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

!RestInterface methodsFor: 'Purchases listing' stamp: 'LJ 11/4/2017 19:43:12'!
salesByUser: aUser
	^ salesBook select: [:aSale | aSale soldTo: aUser]
	! !


!RestInterface methodsFor: 'Adding Products' stamp: 'LJ 11/5/2017 00:09:13'!
addToCart: aCartId aProduct: aProduct times: aNumberOfTimes 
	self withCart: aCartId do: [:aCart :aUser | aCart add: aProduct times: aNumberOfTimes ].
! !


!RestInterface methodsFor: 'Checkout' stamp: 'LJ 11/5/2017 09:43:10'!
checkout: aCartId withCreditCard: aCreditCard
	self withCart: aCartId do: [:aCart :aUser| cashier charge: aCart to: aUser with: aCreditCard].
! !


!RestInterface methodsFor: 'Cart creation' stamp: 'LJ 11/5/2017 00:05:05'!
createCartFor: aUser withPassword: aPassword
	| aCartId aCart|
	self verifyUser: aUser withPassword: aPassword.
	aCartId _ self newCartId.
	aCart _ Cart withCatalogue: catalogue.
	cartSessions at: (aCartId) put: (CartSession with: aCart sessionDuration: (self sessionDuration) withTimer: timer withUser: aUser).
	^ aCartId.! !

!RestInterface methodsFor: 'Cart creation' stamp: 'LJ 11/5/2017 17:28:50'!
newCartId
	|id|
	id _ LaggedFibonacciRandom new next.
	^ (cartSessions includesKey: id) ifTrue: [self newCartId] ifFalse: [id ].
! !


!RestInterface methodsFor: 'Cart listing' stamp: 'LJ 11/5/2017 00:08:57'!
listCartWithId: aCartId 
	^ self withCart: aCartId  do: [:aCart :aUser | aCart products]
	! !


!RestInterface methodsFor: 'Session' stamp: 'LJ 11/4/2017 22:36:25'!
sessionDuration
	^ 30 minutes.! !


!RestInterface methodsFor: 'User verification' stamp: 'LJ 11/4/2017 11:04:49'!
verifyUser: aUser withPassword: aPassword
	users at: aUser ifAbsent: [ self error: RestInterface invalidUserErrorMessage ].
	aPassword = (users at: aUser) ifFalse: [ self error: RestInterface invalidUserErrorMessage ].! !


!RestInterface methodsFor: 'Cart accessing' stamp: 'LJ 11/4/2017 22:51:36'!
withCart: aCartId do: aBlock
	|cartSession|
	cartSession _ cartSessions at: aCartId ifAbsent: [self error: RestInterface invalidCartIdErrorMessage].
	^ cartSession withCartDo: aBlock.! !


!RestInterface methodsFor: 'Initialization' stamp: 'LJ 11/4/2017 22:37:18'!
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

!Sale methodsFor: 'initialization' stamp: 'LJ 11/4/2017 13:18:27'!
with: aTicket for: aPerson
	ticket _ aTicket.
	person _ aPerson.! !


!Sale methodsFor: 'question' stamp: 'LJ 11/4/2017 19:21:45'!
soldTo: aPerson
	^ person = aPerson.! !


!Sale methodsFor: 'access' stamp: 'LJ 11/4/2017 19:33:25'!
productsSoldDo: aBlock 
	ticket items do: [:aTicketItem| aBlock value: (aTicketItem product) value: (aTicketItem amount)].! !

!Sale methodsFor: 'access' stamp: 'LJ 11/4/2017 19:56:13'!
total
	^ ticket total.! !

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

!TestObjectFactory methodsFor: 'Books'!
anotherBookFromEditorial
	^ 'another book'.! !

!TestObjectFactory methodsFor: 'Books'!
bookFromEditorial
	^ 'a book'.! !

!TestObjectFactory methodsFor: 'Books'!
bookNotFromEditorial
	^ 'invalid Book'.! !

!TestObjectFactory methodsFor: 'Books'!
priceBook
	^ Dictionary newFromPairs: {self bookFromEditorial. 10. self anotherBookFromEditorial. 5}.! !


!TestObjectFactory methodsFor: 'Catalogue' stamp: 'LJ 11/4/2017 18:10:06'!
catalogue
	^ (Set
		with: self bookFromEditorial
		with: self anotherBookFromEditorial).! !


!TestObjectFactory methodsFor: 'Credit card' stamp: 'LJ 11/4/2017 18:15:05'!
expiredCreditCardFor: aPerson
	^ CreditCard
		for: aPerson
		withNumber: 1
		andExpirationDate: currentMonthYear previous.! !

!TestObjectFactory methodsFor: 'Credit card' stamp: 'LJ 11/4/2017 18:15:09'!
notExpiredCreditCardFor: aPerson
	^ CreditCard
		for: aPerson
		withNumber: 1
		andExpirationDate: currentMonthYear next next.! !


!TestObjectFactory methodsFor: 'Initialization'!
initialize
	currentMonthYear _ GregorianMonthOfYear current.! !


!TestObjectFactory methodsFor: 'Users' stamp: 'LJ 11/5/2017 09:54:45'!
invalidPassword
	^ 'invalid password'! !

!TestObjectFactory methodsFor: 'Users' stamp: 'LJ 11/5/2017 09:54:21'!
invalidUser
	^ 'invalid user'.! !

!TestObjectFactory methodsFor: 'Users' stamp: 'LJ 11/5/2017 09:55:49'!
validPassword
	^ 'valid password'! !

!TestObjectFactory methodsFor: 'Users' stamp: 'LJ 11/5/2017 09:56:15'!
validUser
	^ 'valid user'! !

!TestObjectFactory methodsFor: 'Users' stamp: 'LJ 11/5/2017 09:56:36'!
validUsersAndPasswords
	^ Dictionary newFromPairs: {(self validUser). (self validPassword)}.! !


!TestObjectFactory methodsFor: 'Salesbook'!
salesBook
	^ OrderedCollection new.! !


!TestObjectFactory methodsFor: 'cart' stamp: 'LJ 11/5/2017 15:49:23'!
emptyCart
	^ Cart withCatalogue: self catalogue ! !

!TestObjectFactory methodsFor: 'cart' stamp: 'LJ 11/5/2017 15:20:15'!
invalidCartId
	^ nil! !


!classDefinition: #Ticket category: #TusLibros!
Object subclass: #Ticket
	instanceVariableNames: 'items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Ticket methodsFor: 'access' stamp: 'LJ 11/4/2017 19:29:32'!
items
	^ items.! !

!Ticket methodsFor: 'access' stamp: 'LJ 11/5/2017 01:46:11'!
total
	^ (items sum: [:aTicketItem | aTicketItem summarizedAmount]).! !


!Ticket methodsFor: 'initialization' stamp: 'LJ 10/30/2017 19:12:44'!
initializeWith:	aListOfTicketItems
	items := aListOfTicketItems.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Ticket class' category: #TusLibros!
Ticket class
	instanceVariableNames: ''!

!Ticket class methodsFor: 'as yet unclassified' stamp: 'LJ 10/30/2017 19:13:07'!
with: aListOfTicketItems
	^ self new initializeWith: aListOfTicketItems.! !


!classDefinition: #TicketItem category: #TusLibros!
Object subclass: #TicketItem
	instanceVariableNames: 'amount price product'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TicketItem methodsFor: 'access' stamp: 'LJ 11/5/2017 09:52:26'!
amount
	^ amount! !

!TicketItem methodsFor: 'access' stamp: 'LJ 11/4/2017 19:29:10'!
product
	^ product! !

!TicketItem methodsFor: 'access' stamp: 'LJ 10/30/2017 19:14:59'!
summarizedAmount
	^ amount * price.! !


!TicketItem methodsFor: 'initialization' stamp: 'LJ 10/30/2017 19:17:08'!
for: aProduct withPrice: aPrice withAmount: anAmount
	product := aProduct.
	price := aPrice.
	amount := anAmount.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TicketItem class' category: #TusLibros!
TicketItem class
	instanceVariableNames: ''!

!TicketItem class methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 23:08:38'!
for: aProduct withPrice: aPrice withAmount: anAmount
	^ self new for: aProduct withPrice: aPrice withAmount: anAmount.! !
