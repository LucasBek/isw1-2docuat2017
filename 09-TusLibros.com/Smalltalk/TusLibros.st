!classDefinition: #TestTusLibros category: #TusLibros!
TestCase subclass: #TestTusLibros
	instanceVariableNames: 'cart book anotherEditorialBook catalogue secondBook cashier expiredCreditCard creditCard valuator currentMonthYear salesBook merchantProcessorClosure'
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


!TestTusLibros methodsFor: 'Setup' stamp: 'kl 10/30/2017 21:47:22'!
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
	
	cashier _ Cashier with: valuator on: (salesBook) withMerchantProcessor: self.
	
	merchantProcessorClosure _ [].! !


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

!TestTusLibros methodsFor: 'Cashier' stamp: 'kl 10/30/2017 21:20:31'!
test11OnCartCheckoutSaleIsStoredInSalesBook
	| ticket |
	cart add: secondBook times: 5. 
	ticket _ cashier charge: cart to: creditCard.
	self assert: (salesBook includes: ticket).
	
	"Stolen card"
	"Card with no credit"
	"Transaction ok"
	"When there is a problem with the credit card, there was no comunication"
	! !


!TestTusLibros methodsFor: 'MerchantProcessorInterface' stamp: 'kl 10/30/2017 21:47:43'!
test12CantCheckoutWithStolenCreditCard
	cart add: secondBook times: 5.
	
	self changeMerchantProcessorClosure: [self error: 'Stolen Credit Card'].
	
	self should: [cashier charge: cart to: creditCard.] 
		 raise: Error
		withExceptionDo: [:anError |
			self assert: (anError messageText) equals: 'Stolen Credit Card'
		].
			
	
	! !


!TestTusLibros methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 21:43:48'!
changeMerchantProcessorClosure: aBlockClosure 
	merchantProcessorClosure _ aBlockClosure .! !

!TestTusLibros methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 21:44:29'!
debit: anAmount to: aCreditCard
	merchantProcessorClosure value.! !


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

!Cashier methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 21:42:28'!
charge: aCart to: aCreditCard
	| ticket |
	aCart isEmpty ifTrue: [self error: Cashier emptyCartErrorMessage].
	(aCreditCard isExpiredOn: GregorianMonthOfYear current) ifTrue: [self error: Cashier expiratedCreditCardErrorMessage.].
	ticket _ self makeTicketFor: aCart.
	merchantProcessor debit: (ticket total) to: aCreditCard.
	^ salesBook add: ticket.
	! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 19:20:22'!
makeTicketFor: aCart 
	^ Ticket with: ( (aCart uniqueProducts collect: [:aProduct | TicketItem for: aProduct withPrice: (valuator at: aProduct) withAmount: (aCart occurrencesOf: aProduct)])).! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'kl 10/30/2017 21:41:17'!
with: aValuator on: aSalesBook
	valuator := aValuator.
	salesBook _ aSalesBook.
	merchantProcessor _ self.! !

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

!Cashier class methodsFor: 'error handling' stamp: 'kl 10/30/2017 20:46:13'!
with: aValuator on: aSalesBook
	^ self new with: aValuator on: aSalesBook.! !

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