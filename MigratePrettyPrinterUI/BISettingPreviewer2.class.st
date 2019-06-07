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
		'methodProvider',
		'formaterPrettyPrinter'
	],
	#classInstVars : [
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

{ #category : #accessing }
BISettingPreviewer2 class >> methodProvider [
	^ methodProvider
]

{ #category : #'instance creation' }
BISettingPreviewer2 class >> open [
	<script>
	methodProvider := BIMethodProvider.
	self new openWithSpec 
]

{ #category : #'instance creation' }
BISettingPreviewer2 class >> open: aClass [
	| presenter |
	methodProvider := aClass.
	presenter := self new.
	presenter openWithSpec.
	^ presenter
]

{ #category : #'button behavior' }
BISettingPreviewer2 class >> openBIInspectorButtonAction [
	<script>
	self open
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
	anInstanceOFBIChooseMethodUI methodList selection selectedItem
		ifNil: [ self inform: 'you have to select a method' ]
		ifNotNil:
			[ :selectedItem | beforePrettyPrintTextPresenter text: selectedItem sourceCode ]
]

{ #category : #visiting }
BISettingPreviewer2 >> acceptActionSBICodePresenter: aBICodePresenter [
	| string newSettingString newSettingMethod |
	string := String
		streamContents: [ :stream | 
			stream
				nextPutAll: aBICodePresenter codePresenter text; cr; tab; nextPutAll: '^ '. 
					
					(STON
						toStringPretty: BIConfigurableFormatter defaultPrettyPrintContext) storeOn: stream  ].
	newSettingMethod := methodProvider class
		>> (methodProvider class compile: string).
	newSettingMethod protocol: 'settings'.
	settingsDropList
		items:
			(settingsDropList listItems
				add: newSettingMethod; yourself).
	settingsDropList selectedIndex: 1
]

{ #category : #'initialization-actions' }
BISettingPreviewer2 >> actionMethodDropList [
	methodDropList
		transmitTo: beforePrettyPrintTextPresenter
		transform: [ :method | method sourceCode ].
	methodDropList 
		transmitTo: afterPrettyPrintTextPresenter  transform:[:item|self formatPrettyPrint] 
]

{ #category : #'initialization-actions' }
BISettingPreviewer2 >> actionRemoveMethodButton [
	removeMethodButton
		action: [ | selectedItem |
			selectedItem := methodDropList selectedItem.
			methodDropList
				items:
					(methodDropList listItems
						removeAt: methodDropList selectedIndex; yourself).
			selectedItem removeFromSystem.
			methodDropList selectedIndex: 1.
			self updateAllWidgets ]
]

{ #category : #'initialization-actions' }
BISettingPreviewer2 >> actionRemoveSettingButton [
	removeSettingButton
		action: [ settingsDropList selectedItem
				ifNil: [ self inform: 'please select a confguration' ]
				ifNotNil: [ :selectedItem | 
					settingsDropList
						items:
							(settingsDropList listItems asOrderedCollection
								remove: selectedItem; yourself).
					(methodProvider class >> selectedItem selector) removeFromSystem ].
			settingsDropList selectedIndex: 1 ]
]

{ #category : #'initialization-actions' }
BISettingPreviewer2 >> actionSaveMethodButton [
	saveMethodButton
		action: [ | newMethod |
			newMethod := methodProvider
				>> (methodProvider compile: beforePrettyPrintTextPresenter text).
			newMethod protocol: 'methods'.
			methodDropList
				items:
					(methodDropList listItems
						add: newMethod; yourself).
			methodDropList
				selectedIndex: (methodDropList listItems indexOf: newMethod) ]
]

{ #category : #'initialization-actions' }
BISettingPreviewer2 >> actionSaveSettingButton [
	saveSettingButton action: [ BIInputPresenterUI openOn: self ]
]

{ #category : #'initialization-actions' }
BISettingPreviewer2 >> actionSettingDropList [
	settingsDropList
		whenSelectionChangedDo: [ :setting | 
			formaterPrettyPrinter
				installNewContext:
					(STON
						fromString:
							(setting selectedItem model
								valueWithReceiver: methodProvider
								arguments: #())).
			afterPrettyPrintTextPresenter text: self formatPrettyPrint
			]
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
	methodProvider := self class methodProvider 
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

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> formatPrettyPrint [
	^ formaterPrettyPrinter format: methodDropList selectedItem ast
]

{ #category : #accessing }
BISettingPreviewer2 >> formaterPrettyPrinter [
	^ formaterPrettyPrinter
]

{ #category : #api }
BISettingPreviewer2 >> initialExtent [
	^ 1000 @ 700
]

{ #category : #initialization }
BISettingPreviewer2 >> initializePresenter [
	self actionMethodDropList.
	self actionRemoveMethodButton.
	self actionSaveMethodButton.
	self actionRemoveSettingButton.
	self actionSaveSettingButton.
	self actionSettingDropList
]

{ #category : #initialization }
BISettingPreviewer2 >> initializeWidgets [
	self defaultMethodProvider.
	formaterPrettyPrinter := BIConfigurableFormatter new.
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
	self setupSaveMethodButton.
	self setupRemoveMethodButton.
	self setupRemoveSettingButton.
	self setupSaveSettingButton.
	self setupMethodDropList.	
	self setupSettingsDropList.
	self setupSettingsTree.
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

{ #category : #'initialization-actions' }
BISettingPreviewer2 >> sactionMethodDropList [
	methodDropList
		transmitTo: beforePrettyPrintTextPresenter
		transform: [ :method | method sourceCode ].
	methodDropList
		transmitTo: afterPrettyPrintTextPresenter
		transform: [ :item | self format ]
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
	afterPrettyPrintTextPresenter withSyntaxHighlight.
	(methodDropList selectedItem isNil
		or: [ settingsDropList selectedItem isNil ])
		ifTrue: [ ^ self ].
	afterPrettyPrintTextPresenter text: self formatPrettyPrint
]

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> setupBeforePrettyPrinterCodePresenter [
	beforePrettyPrintTextPresenter
		withSyntaxHighlight; autoAccept: true.
	methodDropList selectedItem ifNil: [ ^ self ].
	beforePrettyPrintTextPresenter
		text: methodDropList selectedItem sourceCode
]

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> setupChooseMethodUI [
	chooseMethodUI
		label: 'choose another method';
		action: [ BIChooseMethodUI openOn: self ]
]

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> setupMethodDropList [
	methodDropList
		items:
			(methodProvider methods , methodProvider class methods
				select: [ :each | each category = 'methods' ]) asOrderedCollection; 
			displayBlock: [ :item | item selector ].
	methodDropList listItems ifNil: [ ^ self ].
	methodDropList selectedIndex: 1
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
BISettingPreviewer2 >> setupSaveMethodButton [
	saveMethodButton label: 'save'
]

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> setupSaveSettingButton [
	saveSettingButton label: 'save'
]

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> setupSettingsDropList [
	| selectedSetting |
	settingsDropList
		items:
			((methodProvider methods , methodProvider class methods)
				asOrderedCollection select: [ :each | each category = 'settings' ]); 
			displayBlock: [ :each | each selector ].
	settingsDropList listItems ifNil: [ ^ self ].
	settingsDropList selectedIndex: 1.
	selectedSetting := settingsDropList selectedItem.
	formaterPrettyPrinter
		installNewContext:
			(STON
				fromString:
					(selectedSetting
						valueWithReceiver: selectedSetting origin
						arguments: #()))
]

{ #category : #'initialization widgets' }
BISettingPreviewer2 >> setupSettingsTree [
	settingsTree
		roots:
			((SettingTree acceptableKeywords: #(#systemsettings)) nodeList
				select: [ :node | node parentName = #blueInkFormatter ]) asOrderedCollection; 
			displayBlock: [ :node | self displayNodeFor: node ]
]

{ #category : #api }
BISettingPreviewer2 >> title [
	^ 'Blue Ink Setting Previewer'
]

{ #category : #initialization }
BISettingPreviewer2 >> updateAllWidgets [
	self needRebuild: true.
	^ self buildWithSpec
]

{ #category : #'event handling' }
BISettingPreviewer2 >> whenASettingChanged [
	(self formattedCheckBox state and: [ self selectorAndClassAreCorrect ])
		ifTrue: [ self formatSourceCode ] 
]
