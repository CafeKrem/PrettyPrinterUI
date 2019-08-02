"
i'm an UI to select a method , package , class 

HOW TO USE in your UI:
1 - use BIChooseMethodUi class method openOn: 
2 - you will have to define the method 'acceptAction: aReferenceOfBIChooseMethod' , this method use the pattern visitor , in this method you will define the action of okButton 
	for example you can use to select a class 

 
Internal Representation and Key Implementation Points.

    Instance Variables
	classList:		<ListPresenter>
	isInstanceButtonSelected:		<Boolean>
	methodList:		<ListPresenter>
	packageList:		<ListPresenter>
	radioButtonClassSide:		<RadioButtonPresenter>
	radioButtonInstanceSide:		<RadioButtonPresenter>
	uiReceiver:		<subClassOfComposablePresenter> a reference to a UI


    Implementation Points
"
Class {
	#name : #BIChooseMethodUI,
	#superclass : #SpPresenter,
	#instVars : [
		'packageList',
		'classList',
		'methodList',
		'radioButtonInstanceSide',
		'radioButtonClassSide',
		'isInstanceButtonSelected',
		'uiReceiver'
	],
	#category : #MigratePrettyPrinterUI
}

{ #category : #specs }
BIChooseMethodUI class >> defaultSpec [
	<spec>
	^ SpecBoxLayout newHorizontal
		add: #packageList;
		add: #classList;
		add:
			(SpecBoxLayout newVertical
				add: #methodList;
				add:
					(SpecBoxLayout newHorizontal
						add: #radioButtonInstanceSide;
						add: #radioButtonClassSide;
						yourself)  withConstraints: [:contraint  |contraint height: 20] ;
				yourself);
		yourself
]

{ #category : #examples }
BIChooseMethodUI class >> main [ 
	<example>
		^ self openOn: nil .
]

{ #category : #'as yet unclassified' }
BIChooseMethodUI class >> open: aWindowPresenter withExtent: aPoint [ 
	aWindowPresenter extent: aPoint.
]

{ #category : #'instance creation' }
BIChooseMethodUI class >> openOn: aUI [
	| window |
	window := self new
		uiReceiver: aUI;
		yourself.
	self open: window openDialogWithSpec withExtent: 550@350.
	^ window
]

{ #category : #specs }
BIChooseMethodUI class >> title [
	^ 'method chooser'
]

{ #category : #accessing }
BIChooseMethodUI >> classList [
	^ classList
]

{ #category : #util }
BIChooseMethodUI >> classMethodsOfSelectedClassItem: selectedClass [
	^ selectedClass class methods asOrderedCollection
]

{ #category : #initialization }
BIChooseMethodUI >> initializeDialogWindow: aDialog [
	super initializeDialogWindow: aDialog.
	aDialog okAction: [ :presenter | uiReceiver acceptActionBIChooseMethod: self  ]
]

{ #category : #initialization }
BIChooseMethodUI >> initializePresenter [
	packageList
		transmitTo: classList
		transform: [ :selectedPacakge | selectedPacakge classes asOrderedCollection ]
		postTransmission: [ classList items isEmpty
				ifTrue: [ classList selectIndex: 0 ]
				ifFalse: [ classList selectIndex: 1 ] ].
	classList
		transmitTo: methodList
		transform: [ :selectedClass | 
			selectedClass
				ifNotNil: [ isInstanceButtonSelected
						ifTrue: [ self instanceMethodsOfSelectedClassItem: selectedClass ]
						ifFalse: [ self classMethodsOfSelectedClassItem: selectedClass ] ]
				ifNil: [ {} asOrderedCollection ] ]
		postTransmission: [ :destination | 
			destination items isEmpty
				ifTrue: [ destination selectIndex: 0 ]
				ifFalse: [ destination selectIndex: 1 ] ].
	radioButtonClassSide
		whenActivatedDo: [ isInstanceButtonSelected := false.
			methodList
				items:
					(self
						classMethodsOfSelectedClassItem: classList selection selectedItem) ].
	radioButtonInstanceSide
		whenActivatedDo: [ isInstanceButtonSelected := true.
			methodList
				items:
					(self
						instanceMethodsOfSelectedClassItem: classList selection selectedItem) ]
]

{ #category : #initialization }
BIChooseMethodUI >> initializeWidgets [
	packageList := self newList.
	classList := self newList.
	methodList := self newList.
	radioButtonClassSide := self newRadioButton.
	radioButtonInstanceSide := self newRadioButton.
	self setupPackageList.
	self setupClassList.
	self setupMethodList.
	self setupRadioButtons.
	self focusOrder
		add: packageList;
		add: classList;
		add: methodList
]

{ #category : #util }
BIChooseMethodUI >> instanceMethodsOfSelectedClassItem: selectedClass [
	^ selectedClass methods asOrderedCollection
]

{ #category : #accessing }
BIChooseMethodUI >> isInstanceButtonSelected [
	^ isInstanceButtonSelected
]

{ #category : #accessing }
BIChooseMethodUI >> methodList [
	^ methodList
]

{ #category : #accessing }
BIChooseMethodUI >> packageList [
	^ packageList
]

{ #category : #accessing }
BIChooseMethodUI >> radioButtonClassSide [
	^ radioButtonClassSide
]

{ #category : #accessing }
BIChooseMethodUI >> radioButtonInstanceSide [
	^ radioButtonInstanceSide
]

{ #category : #'initialize-widgets' }
BIChooseMethodUI >> setupClassList [
	classList
		items: (packageList selection selectedItem classes asOrderedCollection sort: [:a :b |a name < b name]);
		icons: [:item |self iconNamed: #system  ];
		selectIndex: 1
]

{ #category : #'initialize-widgets' }
BIChooseMethodUI >> setupMethodList [
	methodList
		items: (classList selection selectedItem methods sort: [:a :b |a selector < b selector]);
		displayBlock: [ :item | item selector ];
		selectIndex: 1
]

{ #category : #'initialize-widgets' }
BIChooseMethodUI >> setupPackageList [
	
	packageList
		items: (RPackageOrganizer default packages sort: [:a :b | a name < b name]);
		icons: [:item |self iconNamed: #package];
		displayBlock: [ :item | item name ];
		selectIndex: 1
]

{ #category : #'initialize-widgets' }
BIChooseMethodUI >> setupRadioButtons [
	radioButtonClassSide
		label: 'class side';
		associatedRadioButtons: radioButtonInstanceSide asOrderedCollection.
	radioButtonInstanceSide
		label: 'instance side';
		associatedRadioButtons: radioButtonClassSide asOrderedCollection.
	"instance radioButton is selected at initialisation"
	isInstanceButtonSelected := true.
]

{ #category : #accessing }
BIChooseMethodUI >> uiReceiver [
	^ uiReceiver
]

{ #category : #accessing }
BIChooseMethodUI >> uiReceiver: anObject [
	uiReceiver := anObject
]
