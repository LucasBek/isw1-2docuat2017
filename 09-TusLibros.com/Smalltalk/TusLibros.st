!classDefinition: #TestTusLibros category: #TusLibros!
TestCase subclass: #TestTusLibros
	instanceVariableNames: 'cart book anotherEditorialBook catalogue secondBook cashier expiredCreditCard creditCard valuator'
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

!TestTusLibros methodsFor: 'Cart' stamp: 'LJ 10/28/2017 17:31:19'!
test06CartListOfProductsEqualsBooksAdded
	|expected|
	cart add: book times: 10.
	cart add: secondBook.
	cart add: book.
	expected := cart products.
	self assert: (expected occurrencesOf: book) equals: 11.
	self assert: (expected occurrencesOf: secondBook) equals: 1.
	self assert: expected size equals: 12.! !

!TestTusLibros methodsFor: 'Cart' stamp: 'LJ 10/29/2017 16:13:47'!
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


!TestTusLibros methodsFor: 'Setup' stamp: 'LJ 10/29/2017 15:56:41'!
setUp
	book _'1'.
	secondBook _ '2'.
	anotherEditorialBook _ '3'.
	catalogue _ Set with: book with: secondBook.
	cart _ Cart withCatalogue: catalogue.
	expiredCreditCard _ CreditCard for: 'Pepe' withNumber: 1 andExpirationDate: (GregorianMonthOfYear mayOf: 1995).
	creditCard _ CreditCard for: 'Pepe' withNumber: 1 andExpirationDate: (GregorianMonthOfYear mayOf: 1996).
	
	valuator _ Dictionary newFromPairs: {book . 10 . secondBook . 5 .}.
	cashier _ Cashier with: valuator.! !


!TestTusLibros methodsFor: 'Cashier' stamp: 'LJ 10/29/2017 16:25:39'!
test08WhenCheckingOutEmptyCartErrorMessageIsThrown
	self
		should: [cashier charge: cart to: creditCard on: (GregorianMonthOfYear mayOf: 1995)]
		raise: Error
		withExceptionDo: [:anError | 
			self assert: (anError messageText) equals: Cashier emptyCartErrorMessage.
			self assert: cart isEmpty.
		]! !

!TestTusLibros methodsFor: 'Cashier' stamp: 'LJ 10/29/2017 16:36:59'!
test09WhenCheckingOutCartToExpiredCardErrorMessageIsThrown
	cart add: book.
	self
		should: [cashier charge: cart to: expiredCreditCard on: (GregorianMonthOfYear mayOf: 1996)]
		raise: Error
		withExceptionDo: [:anError | 
			self assert: (anError messageText) equals: Cashier expiratedCreditCardErrorMessage.
			self assert: cart size equals: 1.
		]! !

!TestTusLibros methodsFor: 'Cashier' stamp: 'LJ 10/28/2017 18:18:07'!
test10WhenAskingCashierCartAmountIsCorrect
	cart add: book times: 3.
	cart add: secondBook times: 5. 
	self assert: (cashier valuate: cart) equals: ((3 * valuator at: book) + (5 * valuator at: secondBook)).! !


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

!Cart methodsFor: 'as yet unclassified' stamp: 'kl 10/26/2017 21:07:02'!
products	
	^ products copy.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'kl 10/26/2017 21:06:27'!
size
	^ products size.! !

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
	instanceVariableNames: 'valuator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'as yet unclassified' stamp: 'LJ 10/29/2017 16:25:13'!
charge: aCart to: aCreditCard
	self charge: aCart to: aCreditCard on: GregorianMonthOfYear current.! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'LJ 10/29/2017 16:34:33'!
charge: aCart to: aCreditCard on: aDate
	aCart isEmpty ifTrue: [self error: Cashier emptyCartErrorMessage].
	aCreditCard expirationDate < aDate ifTrue: [self error: Cashier expiratedCreditCardErrorMessage.]! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'LJ 10/28/2017 18:21:47'!
initializeWith: aValuator
	valuator := aValuator.! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'LJ 10/28/2017 18:24:28'!
valuate: aCart 
	^ (aCart products collect: [:aProduct | valuator at: aProduct ]) sum.! !

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

!Cashier class methodsFor: 'error handling' stamp: 'LJ 10/28/2017 18:21:22'!
with: aValuator
	^ self new initializeWith: aValuator.! !


!classDefinition: #CreditCard category: #TusLibros!
Object subclass: #CreditCard
	instanceVariableNames: 'person number expirationDate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'as yet unclassified' stamp: 'LJ 10/28/2017 18:10:57'!
expirationDate
	^ expirationDate.! !

!CreditCard methodsFor: 'as yet unclassified' stamp: 'LJ 10/28/2017 18:10:18'!
for: aPerson withNumber: aNumber andExpirationDate: anExpirationDate 
	person := aPerson.
	number := aNumber.
	expirationDate := anExpirationDate.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: #TusLibros!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'class initialization' stamp: 'LJ 10/28/2017 18:09:34'!
for: aPerson withNumber: aNumber andExpirationDate: anExpirationDate 
	^ self new for: aPerson withNumber: aNumber andExpirationDate: anExpirationDate.! !
