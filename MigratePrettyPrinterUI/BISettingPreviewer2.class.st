Class {
	#name : #BISettingPreviewer2,
	#superclass : #ComposablePresenter,
	#instVars : [
		'settingsTree',
		'sourceCodePane',
		'methodToPRettyPrint',
		'chooseMethodUI',
		'methodDropList'
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
		add: #settingsTree;
		add:
			(SpecBoxLayout newHorizontal
				add: #chooseMethodUI;
				add: #methodDropList;
				yourself)
			withConstraints: [ :contraint | contraint height: 30 ];
		add: #sourceCodePane;
		yourself
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

{ #category : #'item creation' }
BISettingPreviewer2 >> buildClassSearchField [
	^ self newTextInput
		placeholder: 'Enter the class name...';
		autoAccept: true;
		yourself
]

{ #category : #'item creation' }
BISettingPreviewer2 >> buildMethodSearchField [
	^ self newTextInput
		placeholder: 'Enter the method selector...';
		whenTextIsAcceptedDo: [ self whenSelectorAccepted ];
		yourself
]

{ #category : #'item creation' }
BISettingPreviewer2 >> buildSettingsTreeModel [
	| settingsTreeModel |
	settingsTreeModel := self newTree.
	settingsTreeModel
		roots:
			((SettingTree acceptableKeywords: #(#systemsettings)) nodeList
				select: [ :node | node parentName = #blueInkFormatter ]).
	settingsTreeModel displayBlock: [ :node | self displayNodeFor: node ].
	^ settingsTreeModel
]

{ #category : #'item creation' }
BISettingPreviewer2 >> buildSourceCodePane [
	^ self newText
		aboutToStyle: true;
		yourself
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
BISettingPreviewer2 >> formatSourceCode [
	| source tree formatted |
	source := self compiledMethodFromSearchFields sourceCode.
	tree := RBParser parseMethod: source onError: [ :msg :pos | ^ self ].
	formatted := tree formattedCode.
	sourceCodePane text: formatted
]

{ #category : #api }
BISettingPreviewer2 >> initialExtent [
	^ 1000 @ 700
]

{ #category : #initialization }
BISettingPreviewer2 >> initializeWidgets [
	sourceCodePane := self buildSourceCodePane.
	settingsTree := self buildSettingsTreeModel.
	methodDropList := self newDropList.
	chooseMethodUI := self newButton.
	self setupMethoDropList.
	self setupChooseMethodUI.
	SystemAnnouncer uniqueInstance weak when: BISettingsChanged send: #whenASettingChanged to: self.
	self focusOrder
		add: settingsTree;
		add: sourceCodePane
]

{ #category : #accessing }
BISettingPreviewer2 >> methodToPRettyPrint [
	^ methodToPRettyPrint
]

{ #category : #accessing }
BISettingPreviewer2 >> methodToPRettyPrint: anObject [
	methodToPRettyPrint := anObject
]

{ #category : #accessing }
BISettingPreviewer2 >> settingsTree [
	^ settingsTree
]

{ #category : #initialization }
BISettingPreviewer2 >> setupChooseMethodUI [
	chooseMethodUI
		label: 'choose another method';
		action: [ BIChooseMethodUI openOn: self ]
]

{ #category : #initialization }
BISettingPreviewer2 >> setupMethoDropList [
	methodDropList
		items: BIUseByPrettyPrintConfig class methods;
		displayBlock: [ :item | item selector ]
]

{ #category : #accessing }
BISettingPreviewer2 >> sourceCodePane [
	^ sourceCodePane
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

{ #category : #'event handling' }
BISettingPreviewer2 >> whenSelectorAccepted [
	| compiledMethod |
	self selectorAndClassAreCorrect
		ifTrue:
			[ 
			compiledMethod := self compiledMethodFromSearchFields.
			sourceCodePane behavior: compiledMethod methodClass.
			self formattedCheckBox state
				ifTrue: [ self formatSourceCode ]
				ifFalse: [ sourceCodePane text: compiledMethod sourceCode ]]
		ifFalse: [ 
			sourceCodePane behavior: nil.
			sourceCodePane text: ' ' ]
]
