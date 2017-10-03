!classDefinition: #ElevatorEmergency category: #'Elevator-Ejercicio'!
Error subclass: #ElevatorEmergency
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!


!classDefinition: #ElevatorTest category: #'Elevator-Ejercicio'!
TestCase subclass: #ElevatorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:38'!
test09RequestToGoUpAreEnqueueWhenRequestedWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinWaitingForPeople.
	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test10CabinDoorStartClosingAfterWaitingForPeople

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test11StopsWaitingForPeopleIfCloseDoorIsPressed

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinWaitingForPeople.
	self assert: elevatorController isCabinDoorOpened.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.
! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test12CloseDoorDoesNothingIfIdle

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController closeCabinDoor.

	self assert: elevatorController isIdle.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:40'!
test13CloseDoorDoesNothingWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:40'!
test14CloseDoorDoesNothingWhenOpeningTheDoorToWaitForPeople

	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !


!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:42'!
test15ElevatorHasToEnterEmergencyIfStoppedAndOtherFloorSensorTurnsOn

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [ elevatorController cabinOnFloor:0 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado' ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:47'!
test16ElevatorHasToEnterEmergencyIfFalling

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [ elevatorController cabinOnFloor:0 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:47'!
test17ElevatorHasToEnterEmergencyIfJumpsFloors

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:3.
	elevatorController cabinDoorClosed.
	self 
		should: [ elevatorController cabinOnFloor: 3 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:48'!
test18ElevatorHasToEnterEmergencyIfDoorClosesAutomatically
	| elevatorController |
	elevatorController := ElevatorController new.
	
	self 
		should: [ elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado' ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:48'!
test19ElevatorHasToEnterEmergencyIfDoorClosedSensorTurnsOnWhenClosed

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	self 
		should: [elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:49'!
test20ElevatorHasToEnterEmergencyIfDoorClosesWhenOpening
	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado'.]! !


!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:35'!
test06DoorKeepsOpenedWhenOpeningIsRequested

	| elevatorController |
	elevatorController := ElevatorController new.
	
	self assert: elevatorController isCabinDoorOpened.
	
	elevatorController openCabinDoor.

	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 6/16/2014 13:24'!
test07DoorMustBeOpenedWhenCabinIsStoppedAndClosingDoors

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
		
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.
		
	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.
! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:36'!
test08CanNotOpenDoorWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.

	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:51'!
test09DoorKeepsOpeneingWhenItIsOpeneing

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.

	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !


!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test21CabinHasToStopOnTheFloorsOnItsWay
	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinOnFloor:1.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test22ElevatorCompletesAllTheRequests
	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinOnFloor:1.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:2.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test23CabinHasToStopOnFloorsOnItsWayNoMatterHowTheyWellCalled

	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinOnFloor:1.
		
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:51'!
test24CabinHasToStopAndWaitForPeopleOnFloorsOnItsWayNoMatterHowTheyWellCalled

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinOnFloor:1.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.! !


!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/10/2011 17:33'!
test01ElevatorStartsIdleWithDoorOpenOnFloorZero

	| elevatorController |
		
	elevatorController := ElevatorController new.
		
	self assert: elevatorController isIdle.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpened.
	self assert: elevatorController cabinFloorNumber = 0
! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 17:53'!
test02CabinDoorStartsClosingWhenElevatorGetsCalled

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor: 1.
	
	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.
	
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.
	
	self deny: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self assert: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 17:57'!
test03CabinStartsMovingWhenDoorGetsClosed

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	
	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.

	self deny: elevatorController isCabinStopped.
	self assert: elevatorController isCabinMoving.
	
	self deny: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 18:00'!
test04CabinStopsAndStartsOpeningDoorWhenGetsToDestination

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor: 1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor: 1.

	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.
	
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.
			
	self deny: elevatorController isCabinDoorOpened.
	self assert: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.

	self assert: elevatorController cabinFloorNumber = 1
! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 18:00'!
test05ElevatorGetsIdleWhenDoorGetOpened

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor: 1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor: 1.
	elevatorController cabinDoorOpened.
		
	self assert: elevatorController isIdle.
	self deny: elevatorController isWorking.
		
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.

	self assert: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.
		
	self assert: elevatorController cabinFloorNumber = 1! !


!classDefinition: #Cabin category: #'Elevator-Ejercicio'!
Object subclass: #Cabin
	instanceVariableNames: 'state door'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:25:22'!
closeDoor
	door close.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:26:08'!
doorOpened
	door opened.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:17:59'!
initialize
	state := CabinStopped.
	door := CabinDoor new.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:12:03'!
isDoorClosed
	^ door isClosed.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:12:10'!
isDoorClosing
	^ door isClosing.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:12:33'!
isDoorOpened
	^ door isOpened.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:12:26'!
isDoorOpening
	^ door isOpening.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:02:24'!
isMoving
	^ state isMoving.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:02:18'!
isStopped
	^ state isStopped.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:14:15'!
open
	state handleOpenDoor: self.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:15:13'!
openWhenMoving! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:15:26'!
openWhenStopped
	door open.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:08:49'!
startMoving
	door closed.
	state := CabinMoving.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:23:34'!
stop
	door open.
	state := CabinStopped.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cabin class' category: #'Elevator-Ejercicio'!
Cabin class
	instanceVariableNames: ''!

!Cabin class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:55:12'!
new
	^ super new initialize.! !


!classDefinition: #CabinDoor category: #'Elevator-Ejercicio'!
Object subclass: #CabinDoor
	instanceVariableNames: 'state'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:28:56'!
close
	state := CabinDoorClosing.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:37:18'!
closed
	state handleClosedDoor: self.
	state := CabinDoorClosed.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:41:50'!
closedWhenClosed
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:41:54'!
closedWhenClosing
	! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:41:57'!
closedWhenOpened
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:42:00'!
closedWhenOpening
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:22:03'!
initialize
	state := CabinDoorOpened.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:44:44'!
isClosed
	^ state isClosed.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:45:06'!
isClosing
	^ state isClosing.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:44:55'!
isOpened
	^ state isOpened.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:45:00'!
isOpening
	^ state isOpening.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:50:00'!
open
	state handleOpenDoor: self.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:51:41'!
openWhenClosed
	state := CabinDoorOpening.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:52:38'!
openWhenClosing
	state := CabinDoorOpening ! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:52:00'!
openWhenOpened
! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:52:16'!
openWhenOpening
! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:26:31'!
opened
	state := CabinDoorOpened.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinDoor class' category: #'Elevator-Ejercicio'!
CabinDoor class
	instanceVariableNames: ''!

!CabinDoor class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:46:05'!
new
	^ super new initialize.! !


!classDefinition: #CabinDoorState category: #'Elevator-Ejercicio'!
Object subclass: #CabinDoorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinDoorState class' category: #'Elevator-Ejercicio'!
CabinDoorState class
	instanceVariableNames: ''!

!CabinDoorState class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:41:35'!
handleClosedDoor
	self subclassResponsibility.! !

!CabinDoorState class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:50:14'!
handleOpenDoor
	self subclassResponsibility.! !

!CabinDoorState class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:06:49'!
isClosed
	self subclassResponsibility.! !

!CabinDoorState class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:06:53'!
isClosing
	self subclassResponsibility.! !

!CabinDoorState class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:06:46'!
isOpened
	self subclassResponsibility.! !

!CabinDoorState class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:06:57'!
isOpening
	self subclassResponsibility.! !


!classDefinition: #CabinDoorClosed category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorClosed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinDoorClosed class' category: #'Elevator-Ejercicio'!
CabinDoorClosed class
	instanceVariableNames: ''!

!CabinDoorClosed class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:39:45'!
handleClosedDoor: aCabinDoor
	aCabinDoor closedWhenClosed.
	! !

!CabinDoorClosed class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:50:30'!
handleOpenDoor: aCabinDoor
	aCabinDoor openWhenClosed.
	! !

!CabinDoorClosed class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:33:30'!
isClosed
	^ true.! !

!CabinDoorClosed class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:33:37'!
isClosing
	^ false! !

!CabinDoorClosed class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:32:54'!
isOpened
	^ false! !

!CabinDoorClosed class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:32:54'!
isOpening
	^ false! !


!classDefinition: #CabinDoorClosing category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorClosing
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinDoorClosing class' category: #'Elevator-Ejercicio'!
CabinDoorClosing class
	instanceVariableNames: ''!

!CabinDoorClosing class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:40:13'!
handleClosedDoor: aCabinDoor
	aCabinDoor closedWhenClosing.! !

!CabinDoorClosing class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:50:46'!
handleOpenDoor: aCabinDoor
	aCabinDoor openWhenClosing.! !

!CabinDoorClosing class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:31:14'!
isClosed
	^ false.! !

!CabinDoorClosing class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:32:11'!
isClosing
	^ true! !

!CabinDoorClosing class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:31:51'!
isOpened
	^ false! !

!CabinDoorClosing class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:31:36'!
isOpening
	^ false! !


!classDefinition: #CabinDoorOpened category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorOpened
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinDoorOpened class' category: #'Elevator-Ejercicio'!
CabinDoorOpened class
	instanceVariableNames: ''!

!CabinDoorOpened class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:40:29'!
handleClosedDoor: aCabinDoor
	aCabinDoor closedWhenOpened.! !

!CabinDoorOpened class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:51:01'!
handleOpenDoor: aCabinDoor
	aCabinDoor openWhenOpened.! !

!CabinDoorOpened class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:32:47'!
isClosed
	^ false.! !

!CabinDoorOpened class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:33:23'!
isClosing
	^ false! !

!CabinDoorOpened class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:33:18'!
isOpened
	^ true! !

!CabinDoorOpened class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:32:47'!
isOpening
	^ false! !


!classDefinition: #CabinDoorOpening category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorOpening
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinDoorOpening class' category: #'Elevator-Ejercicio'!
CabinDoorOpening class
	instanceVariableNames: ''!

!CabinDoorOpening class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:40:48'!
handleClosedDoor: aCabinDoor
	aCabinDoor closedWhenOpening
! !

!CabinDoorOpening class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:51:16'!
handleOpenDoor: aCabinDoor
	aCabinDoor openWhenOpening
! !

!CabinDoorOpening class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:32:40'!
isClosed
	^ false.! !

!CabinDoorOpening class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:33:13'!
isClosing
	^ false! !

!CabinDoorOpening class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:32:40'!
isOpened
	^ false! !

!CabinDoorOpening class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:33:07'!
isOpening
	^ true! !


!classDefinition: #CabinState category: #'Elevator-Ejercicio'!
Object subclass: #CabinState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinState class' category: #'Elevator-Ejercicio'!
CabinState class
	instanceVariableNames: ''!

!CabinState class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:36:16'!
isStopped

	self subclassResponsibility.! !


!classDefinition: #CabinMoving category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinMoving
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinMoving class' category: #'Elevator-Ejercicio'!
CabinMoving class
	instanceVariableNames: ''!

!CabinMoving class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:14:58'!
handleOpenDoor: aCabin
	aCabin openWhenMoving.! !

!CabinMoving class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:41:08'!
isMoving

	^ true.! !

!CabinMoving class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:36:32'!
isStopped

	^ false.! !


!classDefinition: #CabinStopped category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinStopped
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CabinStopped class' category: #'Elevator-Ejercicio'!
CabinStopped class
	instanceVariableNames: ''!

!CabinStopped class methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:14:47'!
handleOpenDoor: aCabin
	aCabin openWhenStopped.! !

!CabinStopped class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:41:24'!
isMoving

	^ false! !

!CabinStopped class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:35:33'!
isStopped

	^ true! !


!classDefinition: #ElevatorController category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorController
	instanceVariableNames: 'state cabin cabinFloorNumber floorsToGo requestsQueue goingToFloor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:08:38'!
cabinDoorClosed
	cabin startMoving.	
! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:25:45'!
cabinDoorOpened
	cabin doorOpened.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:09:50'!
cabinFloorNumber
	^ cabinFloorNumber! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:10:02'!
cabinOnFloor: floorNumber
	
	(requestsQueue isEmpty or: (cabinFloorNumber - floorNumber) abs > 1  or: [floorNumber < cabinFloorNumber]) ifTrue: [ElevatorEmergency signal: 'Sensor de cabina desincronizado'].

	cabinFloorNumber := floorNumber.	
	
	(requestsQueue includes: floorNumber) ifTrue: [
		cabin stop.
		requestsQueue remove: floorNumber.
	]
	
! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:36:32'!
closeCabinDoor
	self waitForPeopleTimedOut 
	
									! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:10:35'!
goUpPushedFromFloor: floorNumber
	self isIdle ifTrue: [cabin closeDoor].
	requestsQueue add: floorNumber
! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:11:01'!
initialize
	cabinFloorNumber := 0.
	cabin := Cabin new.
	requestsQueue := OrderedCollection new.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:11:16'!
isCabinDoorClosed
	
	^ cabin isDoorClosed.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:11:25'!
isCabinDoorClosing
	
	^ cabin isDoorClosing.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:11:37'!
isCabinDoorOpened
	
	^ cabin isDoorOpened.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:11:45'!
isCabinDoorOpening
	
	^ cabin isDoorOpening.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:58:16'!
isCabinMoving
	
	^ cabin isMoving.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:58:20'!
isCabinStopped
	
	^ cabin isStopped.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:40:33'!
isCabinWaitingForPeople
	^ (self isCabinStopped) and: (self isCabinDoorOpened and: requestsQueue isEmpty not).! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:31:23'!
isIdle
	
	^ self isCabinStopped and: (self isCabinDoorOpened and: requestsQueue isEmpty).! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:47:50'!
isWorking
	
	^self isIdle not.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:13:10'!
openCabinDoor
	cabin open.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:15:59'!
waitForPeopleTimedOut
	self isCabinWaitingForPeople ifTrue: [cabin closeDoor ].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ElevatorController class' category: #'Elevator-Ejercicio'!
ElevatorController class
	instanceVariableNames: ''!

!ElevatorController class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:15:50'!
new
	^ super new initialize! !
