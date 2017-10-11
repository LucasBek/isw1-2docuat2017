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
	state := CabinStopped new.
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

!Cabin methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:51:00'!
openWhenCabinWaitingForPeople! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:15:13'!
openWhenMoving! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:15:26'!
openWhenStopped
	door open.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:08:49'!
startMoving
	door closed.
	state := CabinMoving new.! !

!Cabin methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:23:34'!
stop
	door open.
	state := CabinStopped new.! !

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

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:32:47'!
close
	state handleCloseDoor: self.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:35:06'!
closeWhenOpened
	state := CabinDoorClosing new.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:37:18'!
closed
	state handleClosedDoor: self.
	state := CabinDoorClosed new.! !

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
	state := CabinDoorOpened new.! !

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
	state := CabinDoorOpening new.! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:52:38'!
openWhenClosing
	state := CabinDoorOpening new! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:52:00'!
openWhenOpened
! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:52:16'!
openWhenOpening
! !

!CabinDoor methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:26:31'!
opened
	state := CabinDoorOpened new.! !

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

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:33:58'!
handleCloseDoor: aCabinDoor
	self subclassResponsibility.! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:34:20'!
handleClosedDoor: aCabinDoor
	self subclassResponsibility.! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:34:26'!
handleOpenDoor: aCabinDoor
	self subclassResponsibility.! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:06:49'!
isClosed
	self subclassResponsibility.! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:06:53'!
isClosing
	self subclassResponsibility.! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:06:46'!
isOpened
	self subclassResponsibility.! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:06:57'!
isOpening
	self subclassResponsibility.! !


!classDefinition: #CabinDoorClosed category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorClosed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoorClosed methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:32:38'!
handleCloseDoor: aCabinDoor
	
	! !

!CabinDoorClosed methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:39:45'!
handleClosedDoor: aCabinDoor
	aCabinDoor closedWhenClosed.
	! !

!CabinDoorClosed methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:50:30'!
handleOpenDoor: aCabinDoor
	aCabinDoor openWhenClosed.
	! !

!CabinDoorClosed methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:33:30'!
isClosed
	^ true.! !

!CabinDoorClosed methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:33:37'!
isClosing
	^ false! !

!CabinDoorClosed methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:32:54'!
isOpened
	^ false! !

!CabinDoorClosed methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:32:54'!
isOpening
	^ false! !


!classDefinition: #CabinDoorClosing category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorClosing
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoorClosing methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:33:10'!
handleCloseDoor: aCabinDoor
! !

!CabinDoorClosing methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:40:13'!
handleClosedDoor: aCabinDoor
	aCabinDoor closedWhenClosing.! !

!CabinDoorClosing methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:50:46'!
handleOpenDoor: aCabinDoor
	aCabinDoor openWhenClosing.! !

!CabinDoorClosing methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:31:14'!
isClosed
	^ false.! !

!CabinDoorClosing methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:32:11'!
isClosing
	^ true! !

!CabinDoorClosing methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:31:51'!
isOpened
	^ false! !

!CabinDoorClosing methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:31:36'!
isOpening
	^ false! !


!classDefinition: #CabinDoorOpened category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorOpened
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoorOpened methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:33:26'!
handleCloseDoor: aCabinDoor
	aCabinDoor closeWhenOpened.! !

!CabinDoorOpened methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:40:29'!
handleClosedDoor: aCabinDoor
	aCabinDoor closedWhenOpened.! !

!CabinDoorOpened methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:51:01'!
handleOpenDoor: aCabinDoor
	aCabinDoor openWhenOpened.! !

!CabinDoorOpened methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:32:47'!
isClosed
	^ false.! !

!CabinDoorOpened methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:33:23'!
isClosing
	^ false! !

!CabinDoorOpened methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:33:18'!
isOpened
	^ true! !

!CabinDoorOpened methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:32:47'!
isOpening
	^ false! !


!classDefinition: #CabinDoorOpening category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #CabinDoorOpening
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoorOpening methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:33:36'!
handleCloseDoor: aCabinDoor

! !

!CabinDoorOpening methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:40:48'!
handleClosedDoor: aCabinDoor
	aCabinDoor closedWhenOpening
! !

!CabinDoorOpening methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 20:51:16'!
handleOpenDoor: aCabinDoor
	aCabinDoor openWhenOpening
! !

!CabinDoorOpening methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:32:40'!
isClosed
	^ false.! !

!CabinDoorOpening methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:33:13'!
isClosing
	^ false! !

!CabinDoorOpening methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:32:40'!
isOpened
	^ false! !

!CabinDoorOpening methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:33:07'!
isOpening
	^ true! !


!classDefinition: #CabinState category: #'Elevator-Ejercicio'!
Object subclass: #CabinState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinState methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:37:36'!
handleOpenDoor: aCabin
	self subclassResponsibility.! !

!CabinState methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:25:38'!
isMoving

	self subclassResponsibility.! !

!CabinState methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:36:16'!
isStopped

	self subclassResponsibility.! !


!classDefinition: #CabinMoving category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinMoving
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinMoving methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:14:58'!
handleOpenDoor: aCabin
	aCabin openWhenMoving.! !

!CabinMoving methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:41:08'!
isMoving

	^ true.! !

!CabinMoving methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:36:32'!
isStopped

	^ false.! !


!classDefinition: #CabinStopped category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinStopped
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinStopped methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:14:47'!
handleOpenDoor: aCabin
	aCabin openWhenStopped.! !

!CabinStopped methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:41:24'!
isMoving

	^ false! !

!CabinStopped methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:35:33'!
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

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:24:34'!
cabinDoorOpened
	cabin doorOpened.
	requestsQueue ifEmpty: [self stopWorking]
! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:09:50'!
cabinFloorNumber
	^ cabinFloorNumber! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:24:23'!
cabinOnFloor: floorNumber
	
	(requestsQueue isEmpty or: (cabinFloorNumber - floorNumber) abs > 1  or: [floorNumber < cabinFloorNumber]) ifTrue: [ElevatorEmergency signal: 'Sensor de cabina desincronizado'].

	cabinFloorNumber := floorNumber.	
	
	(requestsQueue includes: floorNumber) ifTrue: [
		cabin stop.
		requestsQueue remove: floorNumber.
	]
	
! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:26:00'!
closeCabinDoor
	state handleCloseDoor.
	
									! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:27:33'!
closeDoorWhenWorking
	cabin closeDoor.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:43:40'!
goUpPushedFromFloor: floorNumber
	state handlePushedButton.
	requestsQueue add: floorNumber
! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:36:08'!
initialize
	cabinFloorNumber := 0.
	cabin := Cabin new.
	requestsQueue := OrderedCollection new.
	state := IdleElevator for: self.! !

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

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:16:56'!
isCabinWaitingForPeople
	^ true.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:42:45'!
isIdle
	^ state isIdle ! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:42:56'!
isWorking
	
	^ state isWorking .! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'LJ 10/2/2017 21:13:10'!
openCabinDoor
	cabin open.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:18:49'!
startWorking
	
	state := WorkingElevator for:self.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:19:57'!
stopWorking
	
	state := IdleElevator for: self.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:20:36'!
waitForPeopleTimedOut
	self closeCabinDoor.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ElevatorController class' category: #'Elevator-Ejercicio'!
ElevatorController class
	instanceVariableNames: ''!

!ElevatorController class methodsFor: 'as yet unclassified' stamp: 'LJ 10/1/2017 18:15:50'!
new
	^ super new initialize! !


!classDefinition: #ElevatorState category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorState
	instanceVariableNames: 'elevator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorState methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:26:16'!
handleCloseDoor
	^ self subclassResponsibility ! !

!ElevatorState methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:43:53'!
handlePushedButton
	^ self subclassResponsibility .! !

!ElevatorState methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:42:19'!
isIdle
	^ self subclassResponsibility ! !

!ElevatorState methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:42:22'!
isWorking
	^ self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ElevatorState class' category: #'Elevator-Ejercicio'!
ElevatorState class
	instanceVariableNames: ''!

!ElevatorState class methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:37:18'!
for: anElevator
	^ self new initializeWith: anElevator .! !


!classDefinition: #IdleElevator category: #'Elevator-Ejercicio'!
ElevatorState subclass: #IdleElevator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!IdleElevator methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:26:35'!
handleCloseDoor! !

!IdleElevator methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:29:46'!
handlePushedButton
	elevator startWorking.
	elevator closeCabinDoor.
! !

!IdleElevator methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:38:28'!
initializeWith: anElevator
	elevator := anElevator ! !

!IdleElevator methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:41:52'!
isIdle
	^ true! !

!IdleElevator methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:41:58'!
isWorking
	^ false! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IdleElevator class' category: #'Elevator-Ejercicio'!
IdleElevator class
	instanceVariableNames: ''!

!IdleElevator class methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:39:13'!
for: anElevator
	^ self new initializeWith: anElevator.! !


!classDefinition: #WorkingElevator category: #'Elevator-Ejercicio'!
ElevatorState subclass: #WorkingElevator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!WorkingElevator methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 19:27:16'!
handleCloseDoor
	elevator closeDoorWhenWorking! !

!WorkingElevator methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:45:27'!
handlePushedButton
! !

!WorkingElevator methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:38:35'!
initializeWith: anElevator
	elevator := anElevator ! !

!WorkingElevator methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:41:35'!
isIdle
	^ false! !

!WorkingElevator methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:41:42'!
isWorking
	^ true! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WorkingElevator class' category: #'Elevator-Ejercicio'!
WorkingElevator class
	instanceVariableNames: ''!

!WorkingElevator class methodsFor: 'as yet unclassified' stamp: 'kl 10/11/2017 18:39:07'!
for: anElevator
	^ self new initializeWith: anElevator.! !
