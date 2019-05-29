Class {
	#name : #BISettingPreviewer2,
	#superclass : #ComposablePresenter,
	#instVars : [
		'settingsTree',
		'classSearchField',
		'methodSearchField',
		'formattedCheckBox',
		'sourceCodePane'
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
				add: #classSearchField;
				add: #methodSearchField;
				add: #formattedCheckBox;
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
BISettingPreviewer2 >> buildFormattedCheckBox [
	^ self newCheckBox
		label: 'Formatted';
		state: true;
		whenActivatedDo:
				[ 
			formattedCheckBox toggleState.
			self selectorAndClassAreCorrect
				ifTrue: [ self formatSourceCode ] ];
		whenDeactivatedDo:
				[ 
			formattedCheckBox toggleState.
			self selectorAndClassAreCorrect 
				ifTrue: [ sourceCodePane text: self compiledMethodFromSearchFields sourceCode ] ];
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

{ #category : #accessing }
BISettingPreviewer2 >> classSearchField [
	^ classSearchField
]

{ #category : #accessing }
BISettingPreviewer2 >> compiledMethodFromSearchFields [
	"precondition text represent class and selector"
	1 halt.
	^ (self class environment at: classSearchField text asSymbol)
			>> methodSearchField text asSymbol 
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

{ #category : #accessing }
BISettingPreviewer2 >> formattedCheckBox [
	^ formattedCheckBox
]

{ #category : #api }
BISettingPreviewer2 >> initialExtent [
	^ 1000 @ 700
]

{ #category : #initialization }
BISettingPreviewer2 >> initializeWidgets [
	sourceCodePane := self buildSourceCodePane.
	classSearchField := self buildClassSearchField.
	methodSearchField := self buildMethodSearchField.
	settingsTree := self buildSettingsTreeModel.
	formattedCheckBox := self buildFormattedCheckBox.
	SystemAnnouncer uniqueInstance weak when: BISettingsChanged send: #whenASettingChanged to: self.
	self focusOrder
		add: settingsTree;
		add: classSearchField;
		add: methodSearchField;
		add: formattedCheckBox;
		add: sourceCodePane
]

{ #category : #accessing }
BISettingPreviewer2 >> methodSearchField [
	^ methodSearchField
]

{ #category : #testing }
BISettingPreviewer2 >> selectorAndClassAreCorrect [
	| class |
	methodSearchField text
		ifNotNil:
			[ :method | 
			classSearchField text
				ifNotNil:
					[ 
					class := self class environment at: classSearchField text asSymbol ifAbsent: [ ^ false].
					(class includesSelector: method asSymbol)
								ifTrue: [ ^ true ]]].
	^ false 
]

{ #category : #accessing }
BISettingPreviewer2 >> settingsTree [
	^ settingsTree
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
