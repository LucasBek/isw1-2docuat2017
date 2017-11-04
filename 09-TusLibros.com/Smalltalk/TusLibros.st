!classDefinition: #TestTusLibros category: #TusLibros!
TestCase subclass: #TestTusLibros
	instanceVariableNames: 'cart book anotherEditorialBook catalogue secondBook cashier expiredCreditCard creditCard valuator currentMonthYear salesBook merchantProcessorClosure restInterface'
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


!TestTusLibros methodsFor: 'Setup' stamp: 'LJ 11/4/2017 11:36:18'!
setUp
	book _'1'.
	secondBook _ '2'.
	anotherEditorialBook _ '3'.
	catalogue _ Set with: book with: secondBook.
	cart _ Cart withCatalogue: catalogue.
	
	currentMonthYear := GregorianMonthOfYear current.
	expiredCreditCard _ CreditCard for: 'Pepe' withNumber: 1 andExpirationDate: (currentMonthYear previous).
	creditCard _ CreditCard for: 'Pepe' withNumber: 1 andExpirationDate: (currentMonthYear next next).
	valuator _ Dictionary newFromPairs: {book . 10 . secondBook . 5 .}.
	
	salesBook _ OrderedCollection new.
	
	cashier _ Cashier with: [:aProduct | valuator at: aProduct] on: (salesBook) withMerchantProcessor: self.
	
	merchantProcessorClosure _ [:anAmount :aCreditCard |].
	
	restInterface _ RestInterface withUsers: (Dictionary newFromPairs: {'Pepe'. 'Pepito'}) andCatalogue: catalogue.! !


!TestTusLibros methodsFor: 'Cashier' stamp: 'kl 10/30/2017 20:50:27'!
test08WhenCheckingOutEmptyCartErrorMessageIsThrown
	self
		should: [cashier charge: cart to: creditCard]
		raise: Error
		withExceptionDo: [:anError | 
			self assert: (anError messageText) equals: Cashier emptyCartErrorMessage.
			self assert: salesBook isEmpty.
		]! !

!TestTusLibros methodsFor: 'Cashier' stamp: 'kl 10/30/2017 20:51:12'!
test09WhenCheckingOutCartToExpiredCardErrorMessageIsThrown
	cart add: book.
	self
		should: [cashier charge: cart to: expiredCreditCard]
		raise: Error
		withExceptionDo: [:anError | 
			self assert: (anError messageText) equals: Cashier expiratedCreditCardErrorMessage.
			self assert: salesBook isEmpty.
		]! !

!TestTusLibros methodsFor: 'Cashier' stamp: 'kl 10/30/2017 18:46:26'!
test10WhenCheckingOutSuccessfullyAmountChargedInTicketIsCorrect
	cart add: book times: 3.
	cart add: secondBook times: 5. 
	self assert: ((cashier charge: cart to: creditCard) total) equals: ((3 * valuator at: book) + (5 * valuator at: secondBook)).! !

!TestTusLibros methodsFor: 'Cashier' stamp: 'kl 11/2/2017 19:03:41'!
test11OnCartCheckoutSaleIsStoredInSalesBook
	| ticket |
	cart add: secondBook times: 5. 
	ticket _ cashier charge: cart to: creditCard.
	self assert: (salesBook includes: ticket).
	
		"When there is a problem with the credit card, there was no comunication"
	! !


!TestTusLibros methodsFor: 'MerchantProcessorInterface' stamp: 'kl 11/2/2017 18:28:12'!
test12CantCheckoutWithStolenCreditCard
	cart add: secondBook times: 5.
	
	self changeMerchantProcessorClosure: [:anAmount :aCreditCard | self error: Cashier stolenCreditCardErrorMessage].
	
	self should: [cashier charge: cart to: creditCard.] 
		 raise: Error
		withExceptionDo: [:anError |
			self assert: (anError messageText) equals: (Cashier stolenCreditCardErrorMessage).
			self assert: salesBook isEmpty.
		].
			
	
	! !

!TestTusLibros methodsFor: 'MerchantProcessorInterface' stamp: 'kl 11/2/2017 18:32:18'!
test13CantCheckoutWithNoCashCreditCard
	cart add: secondBook times: 5.
	
	self changeMerchantProcessorClosure: [:anAmount :aCreditCard | self error: Cashier noFoundsCreditCardErrorMessage].
	
	self should: [cashier charge: cart to: creditCard.] 
		 raise: Error
		withExceptionDo: [:anError |
			self assert: (anError messageText) equals: (Cashier noFoundsCreditCardErrorMessage).
			self assert: salesBook isEmpty.
		].
			
	
	! !

!TestTusLibros methodsFor: 'MerchantProcessorInterface' stamp: 'kl 11/2/2017 19:03:28'!
test14WhenCheckingOutAmounAndCreditCardAreCorrect
	|usedCreditCard amountInTIcket ticket|
	cart add: secondBook times: 5.
	
	self changeMerchantProcessorClosure: [:anAmount :aCreditCard | 
		usedCreditCard := aCreditCard.
		amountInTIcket := anAmount.
	].
	
	ticket := cashier charge: cart to: creditCard.
	self assert: usedCreditCard equals: (creditCard).
	self assert: amountInTIcket equals: (ticket total).

"Si mantenemos que hay un cajero persona entonces agregar test donde el closure tenga [self fail]"

"Dummy son aquellos que no son relevantes para el test y los creo nada mas porque se necesitan"
"Stub son los que configuro con respuestas predefinidas para comprobar que se esta testeando "		
"Mock es para ver como se colaboro con ellos. no hace falta configurarlos. Son tests de caja blanca y son fragiles ante cambios. Es mejor tener factories de objetos que son utilizados en los tests."
"Proveen la misma funcionalidad pero mas light. BD en memoria por ejemplo"

"Hoy Mockito usa mezcla entre stubs y mocks."
"Usar los simuladores para que el test este en control de todo y para representar todo aquello que este externo al modelo."! !


!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 11:53:25'!
test15CantCreateCartWithInvalidUser
	self
		should: [
			restInterface 
				createCartFor: 'Brian'
				withPassword: 'Brianesco' ]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface invalidUserErrorMessage ].
	
	self
		should: [
			restInterface 
				createCartFor: 'Pepe'
				withPassword: 'Brianesco' ]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface invalidUserErrorMessage ].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 11:39:26'!
test16AfterCreatingaCartItIsEmpty
	| id |
	id _ restInterface 
		createCartFor: 'Pepe'
		withPassword: 'Pepito'.
	self
		assert: (restInterface listCartWithId: id)
		equals: Bag new.! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 11:17:55'!
test18CannotListAnInexistentCart
	self
		should: [restInterface listCartWithId: 'InvalidId']
		raise: Error
		withExceptionDo: [ :anError | 
			self assert: anError messageText = RestInterface invalidCartIdErrorMessage].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 11:25:36'!
test19CannotAddAProductToAnInexistentCart
	self
		should: [restInterface addToCart: 'InvalidId' aProduct: book times: 1]
		raise: Error
		withExceptionDo: [ :anError | 
			self assert: anError messageText = RestInterface invalidCartIdErrorMessage].! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 11:39:09'!
test20AddingAProductToACartMakesItIsNotEmptyAnyMore
	| id |
	id _ restInterface 
		createCartFor: 'Pepe'
		withPassword: 'Pepito'.
	restInterface addToCart: id aProduct: book times: 1.
	restInterface addToCart: id aProduct: secondBook times: 2.

	self assert: (((restInterface listCartWithId: id) occurrencesOf: book) = 1).
	self assert: (((restInterface listCartWithId: id) occurrencesOf: secondBook) = 2).
	! !

!TestTusLibros methodsFor: 'RestInterface' stamp: 'LJ 11/4/2017 11:47:57'!
test21CannotAddProductNotInCatalogueToACart
	| id |
	id _ restInterface 
		createCartFor: 'Pepe'
		withPassword: 'Pepito'.
	
	self
		should: [ restInterface addToCart: id aProduct: anotherEditorialBook times: 1. ]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: anError messageText
				equals: RestInterface productNotInCatalogueErrorMessage ].! !


!TestTusLibros methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 21:43:48'!
changeMerchantProcessorClosure: aBlockClosure 
	merchantProcessorClosure _ aBlockClosure .! !

!TestTusLibros methodsFor: 'as yet unclassified' stamp: 'kl 11/2/2017 18:25:48'!
debit: anAmount from: aCreditCard
	^ merchantProcessorClosure value: anAmount value: aCreditCard.! !


!classDefinition: #Cart category: #TusLibros!
Object subclass: #Cart
	instanceVariableNames: 'products catalogue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'as yet unclassified' stamp: 'LJ 10/28/2017 17:28:34'!
add: aProduct
	(catalogue includes: aProduct) ifTrue: 
		[products add: aProduct] ifFalse:
		[self error: 'Product does not exist in catalogue']. ! !

!Cart methodsFor: 'as yet unclassified' stamp: 'LJ 10/28/2017 17:37:44'!
add: aProduct times: numberOfTimes
	(catalogue includes: aProduct) ifTrue: 
		[((numberOfTimes > 0) and: (numberOfTimes isInteger)) ifTrue: [ 
			numberOfTimes timesRepeat: [ self add: aProduct] ]  ifFalse: [
			self error: Cart numberNotNaturalErrorMessage.
			] ] ifFalse:
		[self error: Cart productNotInCatalogueErrorMessage]. ! !

!Cart methodsFor: 'as yet unclassified' stamp: 'kl 11/2/2017 20:23:47'!
costBasedOn: aValuator
	^ (products collect: [:aProduct | aValuator value: aProduct]) sum.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'LJ 10/28/2017 17:29:38'!
initialize
	products := Bag new.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'kl 10/26/2017 20:02:00'!
initializeWithCatalogue: aCatalogue
	catalogue := aCatalogue.! !

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


!classDefinition: #Cashier category: #TusLibros!
Object subclass: #Cashier
	instanceVariableNames: 'valuator salesBook merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'as yet unclassified' stamp: 'kl 11/2/2017 20:20:22'!
charge: aCart to: aCreditCard
	| ticket total|
	aCart isEmpty ifTrue: [self error: Cashier emptyCartErrorMessage].
	(aCreditCard isExpiredOn: GregorianMonthOfYear current) ifTrue: [self error: Cashier expiratedCreditCardErrorMessage.].
	total _ aCart costBasedOn: valuator.
	self debit: total from: aCreditCard.
	ticket _ self makeTicketFor: aCart.
	^ salesBook add: ticket.! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'kl 11/2/2017 20:21:08'!
debit: aTotal from: aCreditCard
  merchantProcessor debit: aTotal from: aCreditCard.
! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'kl 11/2/2017 20:25:26'!
makeTicketFor: aCart 
	^ Ticket with: ( (aCart uniqueProducts collect: [:aProduct | TicketItem for: aProduct withPrice: (valuator value: aProduct) withAmount: (aCart occurrencesOf: aProduct)])).! !

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
for: aPerson withNumber: aNumber andExpirationDate: anExpirationDate "	(aPerson trim) length = 0 ifTrue: [self error: 'Person name cannot be empty'].
	"
	person := aPerson.
	number := aNumber.
	expirationDate := anExpirationDate.! !

!CreditCard methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 18:35:49'!
isExpiredOn: aDate
	^ expirationDate < aDate.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: #TusLibros!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'class initialization' stamp: 'LJ 10/28/2017 18:09:34'!
for: aPerson withNumber: aNumber andExpirationDate: anExpirationDate 
	^ self new for: aPerson withNumber: aNumber andExpirationDate: anExpirationDate.! !


!classDefinition: #RestInterface category: #TusLibros!
Object subclass: #RestInterface
	instanceVariableNames: 'users carts catalogue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 11:51:10'!
addToCart: aCartId aProduct: aProduct times: aNumberOfTimes 
	| cart |
	cart _ self verifyItExists: aCartId.
	cart add: aProduct times: aNumberOfTimes.! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 11:35:22'!
createCartFor: aUser withPassword: aPassword
	| aCartId |
	self verifyUser: aUser withPassword: aPassword.
	aCartId _ self newCartId.
	carts at: (aCartId) put: (Cart withCatalogue: catalogue).
	^ aCartId.! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 11:33:05'!
listCartWithId: aCartId 
	^ (self verifyItExists: aCartId) products.
	! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 11:25:25'!
newCartId
	^ LaggedFibonacciRandom new next.! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 11:29:42'!
verifyItExists: aCartId
	carts at: aCartId  ifAbsent: [self error: RestInterface invalidCartIdErrorMessage].
	^ carts at: aCartId.! !

!RestInterface methodsFor: 'as yet unclassified' stamp: 'LJ 11/4/2017 11:04:49'!
verifyUser: aUser withPassword: aPassword
	users at: aUser ifAbsent: [ self error: RestInterface invalidUserErrorMessage ].
	aPassword = (users at: aUser) ifFalse: [ self error: RestInterface invalidUserErrorMessage ].! !


!RestInterface methodsFor: 'initialization' stamp: 'LJ 11/4/2017 11:36:51'!
withUsers: validUsers andCatalogue: aCatalogue
	users _ validUsers.
	carts _ Dictionary new.
	catalogue _ aCatalogue.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RestInterface class' category: #TusLibros!
RestInterface class
	instanceVariableNames: 'carts'!

!RestInterface class methodsFor: 'Error messages' stamp: 'LJ 11/4/2017 11:11:04'!
invalidCartIdErrorMessage
	^ 'Cart not present'! !

!RestInterface class methodsFor: 'Error messages' stamp: 'kl 11/2/2017 20:43:38'!
invalidUserErrorMessage
	^ 'Invalid user'! !

!RestInterface class methodsFor: 'Error messages' stamp: 'LJ 11/4/2017 11:52:04'!
productNotInCatalogueErrorMessage
	^ Cart productNotInCatalogueErrorMessage.! !


!RestInterface class methodsFor: 'initialization' stamp: 'LJ 11/4/2017 11:35:58'!
withUsers: validUsers andCatalogue: aCatalogue
	^ self new withUsers: validUsers andCatalogue: aCatalogue.! !


!classDefinition: #Ticket category: #TusLibros!
Object subclass: #Ticket
	instanceVariableNames: 'items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Ticket methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 19:12:44'!
initializeWith:	aListOfTicketItems
	items := aListOfTicketItems.! !

!Ticket methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 19:14:25'!
total
	^ (items collect: [:aTicketItem | aTicketItem summarizedAmount]) sum.! !

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

!TicketItem methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 19:17:08'!
for: aProduct withPrice: aPrice withAmount: anAmount
	product := aProduct.
	price := aPrice.
	amount := anAmount.
	! !

!TicketItem methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 19:14:59'!
summarizedAmount
	^ amount * price.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TicketItem class' category: #TusLibros!
TicketItem class
	instanceVariableNames: ''!

!TicketItem class methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 19:16:33'!
for: aProduct withPrice: aPrice withAmount: anAmount
	^ self new for: aProduct withPrice: aPrice withAmount: anAmount.! !
