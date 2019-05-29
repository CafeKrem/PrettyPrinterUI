Class {
	#name : #BIChooseMethodUI,
	#superclass : #ComposablePresenter,
	#instVars : [
		'packageList',
		'classList',
		'methodList',
		'radioButtonInstanceSide',
		'radioButtonClassSide',
		'isInstanceButtonSelected'
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
		^ self new openDialogWithSpec.
]

{ #category : #accessing }
BIChooseMethodUI >> classList [
	^ classList
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
				ifNotNil: [ selectedClass methods asOrderedCollection ]
				ifNil: [ {} asOrderedCollection ] ]
		postTransmission: [ :destination | 
			destination items isEmpty
				ifTrue: [ destination selectIndex: 0 ]
				ifFalse: [ destination selectIndex: 1 ] ].
	radioButtonClassSide
		whenActivatedDo: [ isInstanceButtonSelected := false ].
	radioButtonInstanceSide
		whenActivatedDo: [ isInstanceButtonSelected := true ]
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
	classList items: (packageList selection selectedItem classes) asOrderedCollection.
	classList selectIndex: 1
]

{ #category : #'initialize-widgets' }
BIChooseMethodUI >> setupMethodList [
	methodList items: classList selection selectedItem methods.
	methodList selectIndex: 1
]

{ #category : #'initialize-widgets' }
BIChooseMethodUI >> setupPackageList [
	packageList items: RPackageOrganizer default packages.
	packageList selectIndex: 1
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