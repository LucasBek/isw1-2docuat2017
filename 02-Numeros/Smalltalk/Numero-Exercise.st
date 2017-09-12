!classDefinition: #NumeroTest category: #'Numero-Exercise'!
TestCase subclass: #NumeroTest
	instanceVariableNames: 'zero one two four oneFifth oneHalf five twoFifth twoTwentyfifth fiveHalfs'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:11'!
test01isCeroReturnsTrueWhenAskToZero

	self assert: zero isZero! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:12'!
test02isCeroReturnsFalseWhenAskToOthersButZero

	self deny: one isZero! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:13'!
test03isOneReturnsTrueWhenAskToOne

	self assert: one isOne! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:13'!
test04isOneReturnsFalseWhenAskToOtherThanOne

	self deny: zero isOne! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:14'!
test05EnteroAddsWithEnteroCorrectly

	self assert: one + one equals: two! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:18'!
test06EnteroMultipliesWithEnteroCorrectly

	self assert: two * two equals: four! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:20'!
test07EnteroDividesEnteroCorrectly

	self assert: two / two equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:38'!
test08FraccionAddsWithFraccionCorrectly
"
    La suma de fracciones es:
	 
	a/b + c/d = (a.d + c.b) / (b.d)
	 
	SI ESTAN PENSANDO EN LA REDUCCION DE FRACCIONES NO SE PREOCUPEN!!
	TODAVIA NO SE ESTA TESTEANDO ESE CASO
"
	| sevenTenths |

	sevenTenths := (Entero with: 7) / (Entero with: 10).

	self assert: oneFifth + oneHalf equals: sevenTenths! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:52'!
test09FraccionMultipliesWithFraccionCorrectly
"
    La multiplicacion de fracciones es:
	 
	(a/b) * (c/d) = (a.c) / (b.d)
"

	self assert: oneFifth * twoFifth equals: twoTwentyfifth! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:56'!
test10FraccionDividesFraccionCorrectly
"
    La division de fracciones es:
	 
	(a/b) / (c/d) = (a.d) / (b.c)
"

	self assert: oneHalf / oneFifth equals: fiveHalfs! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:07'!
test11EnteroAddsFraccionCorrectly
"
	Ahora empieza la diversion!!
"

	self assert: one + oneFifth equals: (Entero with: 6) / (Entero with: 5)! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:07'!
test12FraccionAddsEnteroCorrectly

	self assert: oneFifth + one equals: (Entero with: 6) / (Entero with: 5)! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:50'!
test13EnteroMultipliesFraccionCorrectly

	self assert: two * oneFifth equals: twoFifth ! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:52'!
test14FraccionMultipliesEnteroCorrectly

	self assert: oneFifth * two equals: twoFifth ! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:57'!
test15EnteroDividesFraccionCorrectly

	self assert: one / twoFifth equals: fiveHalfs  ! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:59'!
test16FraccionDividesEnteroCorrectly

	self assert: twoFifth / five equals: twoTwentyfifth ! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:38'!
test17AFraccionCanBeEqualToAnEntero

	self assert: two equals: four / two! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:39'!
test18AparentFraccionesAreEqual

	self assert: oneHalf equals: two / four! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:40'!
test19AddingFraccionesCanReturnAnEntero

	self assert: oneHalf + oneHalf equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:42'!
test20MultiplyingFraccionesCanReturnAnEntero

	self assert: (two/five) * (five/two) equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:42'!
test21DividingFraccionesCanReturnAnEntero

	self assert: oneHalf / oneHalf equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:43'!
test22DividingEnterosCanReturnAFraccion

	self assert: two / four equals: oneHalf! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:46'!
test23CanNotDivideEnteroByZero

	self 
		should: [ one / zero ]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Numero canNotDivideByZeroErrorDescription ]
	! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:46'!
test24CanNotDivideFraccionByZero

	self 
		should: [ oneHalf / zero ]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Numero canNotDivideByZeroErrorDescription ]
	! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:50'!
test25AFraccionCanNotBeZero

	self deny: oneHalf isZero! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:50'!
test26AFraccionCanNotBeOne

	self deny: oneHalf isOne! !


!NumeroTest methodsFor: 'setup' stamp: 'HernanWilkinson 5/7/2016 20:56'!
setUp

	zero := Entero with: 0.
	one := Entero with: 1.
	two := Entero with: 2.
	four := Entero with: 4.
	five := Entero with: 5.
	
	oneHalf := one / two.
	oneFifth := one / five.
	twoFifth := two / five.
	twoTwentyfifth := two / (Entero with: 25).
	fiveHalfs := five / two.
	! !


!classDefinition: #Numero category: #'Numero-Exercise'!
Object subclass: #Numero
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Numero methodsFor: 'arithmetic operations' stamp: 'HernanWilkinson 5/7/2016 22:48'!
* aMultiplier

	self subclassResponsibility ! !

!Numero methodsFor: 'arithmetic operations' stamp: 'HernanWilkinson 5/7/2016 22:49'!
+ anAdder

	self subclassResponsibility ! !

!Numero methodsFor: 'arithmetic operations' stamp: 'HernanWilkinson 5/7/2016 22:49'!
/ aDivisor

	self subclassResponsibility ! !

!Numero methodsFor: 'arithmetic operations' stamp: 'HernanWilkinson 5/7/2016 22:48'!
invalidNumberType

	self error: self class invalidNumberTypeErrorDescription! !


!Numero methodsFor: 'testing' stamp: 'HernanWilkinson 5/7/2016 22:49'!
isOne

	self subclassResponsibility ! !

!Numero methodsFor: 'testing' stamp: 'HernanWilkinson 5/7/2016 22:49'!
isZero

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Numero class' category: #'Numero-Exercise'!
Numero class
	instanceVariableNames: ''!

!Numero class methodsFor: 'error descriptions' stamp: 'HernanWilkinson 5/7/2016 22:45'!
canNotDivideByZeroErrorDescription

	^'No se puede dividir por cero'! !

!Numero class methodsFor: 'error descriptions' stamp: 'HernanWilkinson 5/7/2016 22:47'!
invalidNumberTypeErrorDescription
	^ 'Tipo de numero invalido'! !


!classDefinition: #Entero category: #'Numero-Exercise'!
Numero subclass: #Entero
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Entero methodsFor: 'value' stamp: 'HernanWilkinson 5/7/2016 21:02'!
integerValue

	"Usamos integerValue en vez de value para que no haya problemas con el mensaje value implementado en Object - Hernan"
	
	^value! !


!Entero methodsFor: 'testing' stamp: 'asd 9/12/2017 00:24:35'!
isOne
	
	^false! !

!Entero methodsFor: 'testing' stamp: 'asd 9/12/2017 00:24:28'!
isZero
	
	^false! !


!Entero methodsFor: 'comparing' stamp: 'HernanWilkinson 5/7/2016 21:01'!
= anObject

	^(anObject isKindOf: self class) and: [ value = anObject integerValue ]! !

!Entero methodsFor: 'comparing' stamp: 'HernanWilkinson 5/7/2016 20:17'!
hash

	^value hash! !


!Entero methodsFor: 'initialization' stamp: 'HernanWilkinson 5/7/2016 20:09'!
initalizeWith: aValue 
	
	value := aValue! !


!Entero methodsFor: 'arithmetic operations' stamp: 'LJ 9/7/2017 21:32:04'!
* aMultiplier 
	^aMultiplier multiplicarPorEntero: self	! !

!Entero methodsFor: 'arithmetic operations' stamp: 'LJ 9/7/2017 21:19:32'!
+ anAdder 
	^anAdder sumarEntero: self ! !

!Entero methodsFor: 'arithmetic operations' stamp: 'LJ 9/7/2017 21:52:55'!
/ aDivisor
	^ aDivisor actuarComoDenominadorParaUnEntero: self.! !

!Entero methodsFor: 'arithmetic operations' stamp: 'asd 9/12/2017 01:07:10'!
// aDivisor 
	
	^Entero with: value // aDivisor integerValue! !

!Entero methodsFor: 'arithmetic operations' stamp: 'LJ 9/7/2017 21:52:55'!
actuarComoDenominadorParaUnEntero: unEntero
	^ Fraccion
		with: unEntero
		over: self.! !

!Entero methodsFor: 'arithmetic operations' stamp: 'LJ 9/9/2017 10:08:15'!
actuarComoDenominadorParaUnaFraccion: unaFraccion
	^ Fraccion with: unaFraccion numerator over: (unaFraccion denominator * self).! !

!Entero methodsFor: 'arithmetic operations' stamp: 'asd 9/12/2017 01:07:20'!
greatestCommonDivisorWith: anEntero 
	
	^Entero with: (value gcd: anEntero integerValue)! !

!Entero methodsFor: 'arithmetic operations' stamp: 'asd 9/12/2017 01:10:47'!
ifOne: bloque! !

!Entero methodsFor: 'arithmetic operations' stamp: 'asd 9/12/2017 01:10:52'!
ifZero: bloque! !

!Entero methodsFor: 'arithmetic operations' stamp: 'LJ 9/7/2017 21:35:19'!
multiplicarPorFraccion: unaFraccion
	^ unaFraccion multiplicarPorEntero: self! !

!Entero methodsFor: 'arithmetic operations' stamp: 'asd 9/12/2017 01:07:31'!
sumarEntero: unEntero
	^Entero with: (unEntero integerValue + value) ! !

!Entero methodsFor: 'arithmetic operations' stamp: 'LJ 9/7/2017 21:30:18'!
sumarFraccion: fraccion
	^ fraccion sumarEntero: self! !


!Entero methodsFor: 'as yet unclassified' stamp: 'asd 9/12/2017 01:07:53'!
multiplicarPorEntero:  unEntero
	^Entero with: value * unEntero integerValue! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Entero class' category: #'Numero-Exercise'!
Entero class
	instanceVariableNames: ''!

!Entero class methodsFor: 'instance creation' stamp: 'asd 9/12/2017 00:59:30'!
with: aValue 
	
	"Esta verificacion esta puesta por si se equivocan y quieren crear un Entero pasando otra cosa que un Integer - Hernan"
	aValue isInteger ifFalse: [  self error: 'aValue debe ser anInteger' ].	aValue = 0 ifTrue: [^ Cero nuevo].
	aValue = 1 ifTrue: [^ Uno nuevo].
	
	^self new initalizeWith: aValue! !


!classDefinition: #Cero category: #'Numero-Exercise'!
Entero subclass: #Cero
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Cero methodsFor: 'as yet unclassified' stamp: 'asd 9/12/2017 01:09:43'!
ifOne: bloque
	! !

!Cero methodsFor: 'as yet unclassified' stamp: 'asd 9/12/2017 01:09:31'!
ifZero: bloque
	bloque value.! !

!Cero methodsFor: 'as yet unclassified' stamp: 'asd 9/12/2017 01:01:47'!
initialize
	value := 0.! !

!Cero methodsFor: 'as yet unclassified' stamp: 'asd 9/12/2017 00:25:07'!
isOne
	^false.! !

!Cero methodsFor: 'as yet unclassified' stamp: 'asd 9/12/2017 00:24:57'!
isZero
	^true.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cero class' category: #'Numero-Exercise'!
Cero class
	instanceVariableNames: ''!

!Cero class methodsFor: 'as yet unclassified' stamp: 'asd 9/12/2017 01:02:16'!
nuevo
	^ self new initialize.! !


!classDefinition: #Uno category: #'Numero-Exercise'!
Entero subclass: #Uno
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Uno methodsFor: 'as yet unclassified' stamp: 'asd 9/12/2017 01:10:17'!
ifOne: bloque
	bloque value.! !

!Uno methodsFor: 'as yet unclassified' stamp: 'asd 9/12/2017 01:10:26'!
ifZero: bloque ! !

!Uno methodsFor: 'as yet unclassified' stamp: 'asd 9/12/2017 01:02:03'!
initialize
	value := 1.! !

!Uno methodsFor: 'as yet unclassified' stamp: 'asd 9/12/2017 00:25:33'!
isOne
	^true.! !

!Uno methodsFor: 'as yet unclassified' stamp: 'asd 9/12/2017 00:25:24'!
isZero
	^false.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Uno class' category: #'Numero-Exercise'!
Uno class
	instanceVariableNames: ''!

!Uno class methodsFor: 'as yet unclassified' stamp: 'asd 9/12/2017 01:02:10'!
nuevo
	^ self new initialize.! !


!classDefinition: #Fraccion category: #'Numero-Exercise'!
Numero subclass: #Fraccion
	instanceVariableNames: 'numerator denominator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Fraccion methodsFor: 'testing' stamp: 'HernanWilkinson 5/7/2016 22:51'!
isOne
	
	^false! !

!Fraccion methodsFor: 'testing' stamp: 'HernanWilkinson 5/7/2016 22:51'!
isZero
	
	^false! !


!Fraccion methodsFor: 'initialization' stamp: 'asd 9/12/2017 01:13:21'!
initializeWith: aNumerator over: aDenominator

	"Estas precondiciones estan por si se comenten errores en la implementacion - Hernan"
	aNumerator ifZero: [ self error: 'una fraccion no puede ser cero' ].
	aDenominator ifOne: [ self error: 'una fraccion no puede tener denominador 1 porque sino es un entero' ].
	
	numerator := aNumerator.
	denominator := aDenominator ! !


!Fraccion methodsFor: 'comparing' stamp: 'HernanWilkinson 5/7/2016 20:42'!
= anObject

	^(anObject isKindOf: self class) and: [ (numerator * anObject denominator) = (denominator * anObject numerator) ]! !

!Fraccion methodsFor: 'comparing' stamp: 'HernanWilkinson 5/7/2016 20:50'!
hash

	^(numerator hash / denominator hash) hash! !


!Fraccion methodsFor: 'arithmetic operations' stamp: 'LJ 9/7/2017 21:35:58'!
* aMultiplier 
	^ aMultiplier multiplicarPorFraccion: self! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'LJ 9/7/2017 21:28:17'!
+ anAdder 
	^anAdder sumarFraccion: self! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'LJ 9/9/2017 10:05:45'!
/ aDivisor 
	
	^ aDivisor actuarComoDenominadorParaUnaFraccion: self.! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'LJ 9/9/2017 10:05:05'!
actuarComoDenominadorParaUnEntero: unEntero
	^ Fraccion with: ( denominator * unEntero ) over: numerator.! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'LJ 9/9/2017 10:06:52'!
actuarComoDenominadorParaUnaFraccion: unaFraccion
	^ (unaFraccion numerator * denominator) / (unaFraccion denominator * numerator).! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'LJ 9/7/2017 21:36:32'!
multiplicarPorFraccion: unaFraccion 
	^(numerator * unaFraccion numerator) / (denominator * unaFraccion denominator)
	! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'LJ 9/7/2017 21:26:45'!
sumarEntero: unEntero
	^ Fraccion with: numerator + (denominator * unEntero) over: self denominator! !


!Fraccion methodsFor: 'accessing' stamp: 'HernanWilkinson 5/7/2016 21:56'!
denominator

	^ denominator! !

!Fraccion methodsFor: 'accessing' stamp: 'HernanWilkinson 5/7/2016 21:56'!
numerator

	^ numerator! !


!Fraccion methodsFor: 'as yet unclassified' stamp: 'LJ 9/7/2017 21:34:18'!
multiplicarPorEntero: unEntero
	^ Fraccion with: numerator * unEntero over: denominator ! !

!Fraccion methodsFor: 'as yet unclassified' stamp: 'LJ 9/7/2017 21:28:52'!
sumarFraccion: fraccion
	| newNumerator newDenominator |
	
	newNumerator := (numerator * fraccion denominator) + (denominator * fraccion numerator).
	newDenominator := denominator * fraccion denominator.
	
	^newNumerator / newDenominator ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Fraccion class' category: #'Numero-Exercise'!
Fraccion class
	instanceVariableNames: ''!

!Fraccion class methodsFor: 'intance creation' stamp: 'asd 9/12/2017 01:11:40'!
with: aDividend over: aDivisor

	| greatestCommonDivisor numerator denominator |
	
	aDivisor ifZero: [ self error: self canNotDivideByZeroErrorDescription ].
	aDividend ifZero: [ ^aDividend ].
	
	greatestCommonDivisor := aDividend greatestCommonDivisorWith: aDivisor. 
	numerator := aDividend // greatestCommonDivisor.
	denominator := aDivisor // greatestCommonDivisor.
	
	denominator ifOne: [ ^numerator ].

	^self new initializeWith: numerator over: denominator
	! !
