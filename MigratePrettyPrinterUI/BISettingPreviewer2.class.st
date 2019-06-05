Class {
	#name : #BISettingPreviewer2,
	#superclass : #ComposablePresenter,
	#instVars : [
		'settingsTree',
		'chooseMethodUI',
		'methodDropList',
		'beforePrettyPrintTextPresenter',
		'afterPrettyPrintTextPresenter',
		'settingsDropList',
		'saveMethodButton',
		'removeMethodButton',
		'removeSettingButton',
		'saveSettingButton',
		'methodProvider'
	],
	#category : #MigratePrettyPrinterUI
}

{ #category : #'build ui buttons' }
BISettingPreviewer2 class >> buildOpenBIInspectorButton [
	^ PluggableButtonMorph
		on: self
		getState: #openBIInspectorButtonState
		action: #openBIInspectorButtonAction
		label: #openBIInspectorButtonLabel
]

{ #category : #specs }
BISettingPreviewer2 class >> defaultSpec [
	<spec: #default>
	^ SpecBoxLayout newVertical
		add: #settingsTree; add:
			(SpecPanedLayout newHorizontal
				add:
					(SpecBoxLayout newVertical
						add:
							(SpecBoxLayout newHorizontal
								add: #saveMethodButton; add: #removeMethodButton; add: #chooseMethodUI; 
									yourself)
							withConstraints: [ :contraint | contraint height: 30 ]; add: #methodDropList
							withConstraints: [ :contraint | contraint height: 30 ]; add: #beforePrettyPrintTextPresenter; 
							yourself); add:
					(SpecBoxLayout newVertical
						add:
							(SpecBoxLayout newHorizontal
								add: #saveSettingButton; add: #removeSettingButton; yourself)
							withConstraints: [ :contraint | contraint height: 30 ]; add: #settingsDropList
							withConstraints: [ :contraint | contraint height: 30 ]; add: #afterPrettyPrintTextPresenter; 
							yourself); yourself); yourself
]

{ #category : #settings }
BISettingPreviewer2 class >> dialogOpenBIPreviewer [
	^ Smalltalk ui theme
		newRowIn: World
		for:
			{(Smalltalk ui theme buttonLabelForText: 'Open Blue Ink Setting Previewer ').
			self buildOpenBIInspectorButton}
]

{ #category : #'instance creation' }
BISettingPreviewer2 class >> open [
	<script>
	self new openWithSpec 
]

{ #category : #'instance creation' }
BISettingPreviewer2 class >> open: aClass [
	^ (self new
		methodProvider: aClass ; yourself) openWithSpec
]

{ #category : #'button behavior' }
BISettingPreviewer2 class >> openBIInspectorButtonAction [
	<script>
	BISettingPreviewer new openWithSpec
]

{ #category : #'button behavior' }
BISettingPreviewer2 class >> openBIInspectorButtonLabel [
	^ 'Open'
]

{ #category : #'button behavior' }
BISettingPreviewer2 class >> openBIInspectorButtonState [
	^ true
]

{ #category : #settings }
BISettingPreviewer2 class >> settingsOn: aBuilder [
	<systemsettings>
	(aBuilder group: #blueInkFormatterExtra)
		target: self;
		parent: #blueInkFormatter;
		label: 'BlueInk Formatting Editor';
		description: 'Open the BlueInk setting previewer to edit the formatting options';
		dialog: [ self dialogOpenBIPreviewer ]

	
]

{ #category : #visiting }
BISettingPreviewer2 >> acceptAction: anInstanceOFBIChooseMethodUI [
	self flag: #whenConfigMigrate.
	anInstanceOFBIChooseMethodUI methodList selection selectedItem
		ifNil: [ self inform: 'you have to select a method' ]
		ifNotNil:
			[ :selectedItem | beforePrettyPrintTextPresenter text: selectedItem sourceCode ]
]

{ #category : #accessing }
BISettingPreviewer2 >> afterPrettyPrintTextPresenter [
	^ afterPrettyPrintTextPresenter
]

{ #category : #accessing }
BISettingPreviewer2 >> beforePrettyPrintTextPresenter [
	^ beforePrettyPrintTextPresenter
]

{ #category : #accessing }
BISettingPreviewer2 >> chooseMethodUI [
	^ chooseMethodUI
]

{ #category : #initialization }
BISettingPreviewer2 >> defaultMethodProvider [
	methodProvider := BIMethodProvider 
]

{ #category : #'item creation' }
BISettingPreviewer2 >> displayNodeFor: aNode [
	| nodeMorphLeft nodeMorphRight |
	nodeMorphLeft := StringMorph contents: aNode item label.
	nodeMorphRight := (self theme newRowIn: World for: {aNode settingDeclaration inputWidget})
		clipSubmorphs: true;
		cellInset: 0;
		width: 570;
		left: 400;
		yourself.
	^ PanelMorph new
		addAllMorphs:
			{nodeMorphLeft.
			nodeMorphRight}; 
		color: Smalltalk ui theme lightBackgroundColor;
		hResizing: #shrinkWrap;
		yourself
]

{ #category : #api }
BISettingPreviewer2 >> initialExtent [
	^ 1000 @ 700
]

{ #category : #initialization }
BISettingPreviewer2 >> initializePresenter [
	methodDropList
		transmitTo: beforePrettyPrintTextPresenter
		transform: [ :method |method sourceCode ]
]

{ #category : #initialization }
BISettingPreviewer2 >> initializeWidgets [
	self defaultMethodProvider.
	settingsTree := self newTree.
	methodDropList := self newDropList.
	chooseMethodUI := self newButton.
	beforePrettyPrintTextPresenter := self newCode.
	afterPrettyPrintTextPresenter := self newCode.
	settingsDropList := self newDropList.
	saveMethodButton := self newButton.
	removeMethodButton := self newButton.
	saveSettingButton := self newButton.
	removeSettingButton := self newButton.
	self setupSaveMethoButton.
	self setupRemoveMethodButton.
	self setupRemoveSettingButton.
	self setupSaveSettingButton.
	self setupSettingsDropList.
	self setupSettingsTree.
	self setupMethoDropList.
	self setupChooseMethodUI.
	self setupBeforePrettyPrinterCodePresenter.
	self setupAfterPrettyPrinterCodePresenter.
	SystemAnnouncer uniqueInstance weak
		when: BISettingsChanged
		send: #whenASettingChanged
		to: self.
	self focusOrder
		add: settingsTree; add: chooseMethodUI; add: methodDropList; add: beforePrettyPrintTextPresenter; 
			add: afterPrettyPrintTextPresenter
]

{ #category : #accessing }
BISettingPreviewer2 >> methodDropList [
	^ methodDropList
]

{ #category : #accessing }
BISettingPreviewer2 >> methodProvider [
	^ methodProvider
]

{ #category : #accessing }
BISettingPreviewer2 >> methodProvider: anObject [
	methodProvider := anObject
]

{ #category : #accessing }
BISettingPreviewer2 >> removeMethodButton [
	^ removeMethodButton
]

{ #category : #accessing }
BISettingPreviewer2 >> removeSettingButton [
	^ removeSettingButton
]

{ #category : #accessing }
BISettingPreviewer2 >> saveMethodButton [
	^ saveMethodButton
]

{ #category : #accessing }
BISettingPreviewer2 >> saveSettingButton [
	^ saveSettingButton
]

{ #category : #accessing }
BISettingPreviewer2 >> settingsDropList [
	^ settingsDropList
]

{ #category : #accessing }
BISettingPreviewer2 >> settingsTree [
	^ settingsTree
]

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> setupAfterPrettyPrinterCodePresenter [
	afterPrettyPrintTextPresenter withSyntaxHighlight 
]

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> setupBeforePrettyPrinterCodePresenter [
	beforePrettyPrintTextPresenter withSyntaxHighlight
]

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> setupChooseMethodUI [
	chooseMethodUI
		label: 'choose another method';
		action: [ BIChooseMethodUI openOn: self ]
]

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> setupMethoDropList [
	methodDropList
		items:
			(methodProvider methods , methodProvider class methods
				select: [ :each | each category = 'methods' ]); displayBlock: [ :item | item selector ]
]

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> setupRemoveMethodButton [
	removeMethodButton label: 'remove current Method'
]

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> setupRemoveSettingButton [
	removeSettingButton label: 'remove setting'
]

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> setupSaveMethoButton [
	saveMethodButton label: 'save method';
	action: [ ]
]

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> setupSaveMethodButton [
	saveMethodButton label: 'save'
]

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> setupSaveSettingButton [
	saveSettingButton label: 'save'
]

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> setupSettingsDropList [
	settingsDropList
		items:
			((methodProvider methods , methodProvider class methods) 
				asOrderedCollection select: [ :each | each category = 'settings' ]); 
			displayBlock: [ :each | each selector ]
]

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> setupSettingsTree [
	settingsTree
		roots:
			((SettingTree acceptableKeywords: #(#systemsettings)) nodeList
				select: [ :node | node parentName = #blueInkFormatter ]); 
			displayBlock: [ :node | self displayNodeFor: node ]
]

{ #category : #api }
BISettingPreviewer2 >> title [
	^ 'Blue Ink Setting Previewer'
]

{ #category : #'event handling' }
BISettingPreviewer2 >> whenASettingChanged [
	(self formattedCheckBox state and: [ self selectorAndClassAreCorrect ])
		ifTrue: [ self formatSourceCode ] 
]
