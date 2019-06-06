Class {
	#name : #BIInputPresenterUI,
	#superclass : #ComposablePresenter,
	#instVars : [
		'uiReceiver',
		'codePresenter'
	],
	#category : #MigratePrettyPrinterUI
}

{ #category : #specs }
BIInputPresenterUI class >> defaultSpec [
	^ SpecBoxLayout newHorizontal 
		add: #codePresenter; yourself
]

{ #category : #'instance creation' }
BIInputPresenterUI class >> openOn: aUIReceiver [
	| biCodePresenter |
	biCodePresenter := self new.
	biCodePresenter uiReceiver: aUIReceiver.
	^ biCodePresenter openDialogWithSpec
]

{ #category : #accessing }
BIInputPresenterUI >> codePresenter [
	^ codePresenter
]

{ #category : #initialization }
BIInputPresenterUI >> initializeDialogWindow: aDialog [
	super initializeDialogWindow: aDialog.
	aDialog okAction: [ :presenter | uiReceiver acceptActionSBICodePresenter: self  ]
]

{ #category : #initialization }
BIInputPresenterUI >> initializeWidgets [ 
	codePresenter := self instantiate: TextInputFieldPresenter.
	codePresenter placeholder: 'write the name of you configuration'
]

{ #category : #accessing }
BIInputPresenterUI >> uiReceiver [
	^ uiReceiver
]

{ #category : #accessing }
BIInputPresenterUI >> uiReceiver: anUI [
	uiReceiver := anUI
]
