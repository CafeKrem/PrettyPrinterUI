Class {
	#name : #BISettingPreviewerTest,
	#superclass : #TestCase,
	#instVars : [
		'biSettingPreviewer'
	],
	#category : #'MigratePrettyPrinterUI-Tests'
}

{ #category : #tests }
BISettingPreviewerTest >> selectClassNamed: aName FromUI:biChooseMethod [
	biChooseMethod classList
		selectIndex:
			(biChooseMethod classList items
				indexOf:
					(biChooseMethod classList items
						detect:
							[ :class | class name = aName ]))
]

{ #category : #tests }
BISettingPreviewerTest >> selectPackageNamed: aName FromUI: biChooseMethod [
	biChooseMethod packageList
		selectIndex:
			(biChooseMethod packageList items
				indexOf:
					(biChooseMethod packageList items
						detect:
							[ :package | package name = aName ]))
]

{ #category : #running }
BISettingPreviewerTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	biSettingPreviewer := BISettingPreviewer2 open: BIUseForTest.
	
	
]

{ #category : #running }
BISettingPreviewerTest >> tearDown [ 
	biSettingPreviewer delete.
	biSettingPreviewer application close.
	super tearDown
]

{ #category : #tests }
BISettingPreviewerTest >> testClickChooseMethodButtonAndAcceptWithNotNilMethodShouldFillBeforePrettyPrinterCodePresenter [
	| chooseMethodUI |
	chooseMethodUI := BIChooseMethodUI new.
	self
		selectPackageNamed: BIUseForTestWithMethod package name
		FromUI: chooseMethodUI.
	self
		selectClassNamed: BIUseForTestWithMethod name
		FromUI: chooseMethodUI.
	biSettingPreviewer acceptAction: chooseMethodUI.
	self
		assert: biSettingPreviewer beforePrettyPrintTextPresenter text
		equals: chooseMethodUI methodList selection selectedItem sourceCode
]

{ #category : #tests }
BISettingPreviewerTest >> testClickOnRemoveMethodButtonShouldRemoveTheFromMethodDropList [
	[ BIUseForTest  
		compile: 'myMethodTestazert ' , String cr , '^ klm'.
		(BIUseForTest   >> #myMethodTestazert) protocol: 'methods'.
	biSettingPreviewer := BISettingPreviewer2 open: BIUseForTest.
	biSettingPreviewer methodDropList
		selectedIndex:
			(biSettingPreviewer methodDropList listItems indexOf: (BIUseForTest>>#myMethodTestazert)).
	biSettingPreviewer removeMethodButton click.
	self
		deny:
			(biSettingPreviewer methodDropList listItems
				contains: [ :item | item selector = #myMethodTestazert ]) ]
		ensure: [ [ (BIUseForTest >> #myMethodTestazert) removeFromSystem ]
				on: KeyNotFound
				do: [  ] ]
]

{ #category : #tests }
BISettingPreviewerTest >> testClickOnSaveMethodButtonShouldAddToMethodDropListAndToTheMethodProviderClass [
	[ biSettingPreviewer beforePrettyPrintTextPresenter
		text: 'myMethodTestazert ' , String cr , '^ klm'.
	biSettingPreviewer saveMethodButton click.
	self
		assert:
			(biSettingPreviewer methodDropList listItems
				anySatisfy: [ :item | item selector = #myMethodTestazert ]).
	self
		assert: biSettingPreviewer methodDropList selectedItem
		equals: BIUseForTest >> #myMethodTestazert.
	self
		assert: (BIUseForTest >> #myMethodTestazert) category
		equals: 'methods' ]
		ensure: [ [ (BIUseForTest >> #myMethodTestazert) removeFromSystem ]
				on: KeyNotFound
				do: [ self fail ] ]
]

{ #category : #initialization }
BISettingPreviewerTest >> testDropListSelectedIndexShouldBeEqualsToOne [
	self assert: biSettingPreviewer methodDropList selectedIndex equals: 1.
]

{ #category : #initialization }
BISettingPreviewerTest >> testInitializeAfterPrettyShouldFillWithTheSelectedItemOfDropListPresenter [
	self flag:'pretyPrinter error'.
	self
		assert: biSettingPreviewer afterPrettyPrintTextPresenter text
		equals: (biSettingPreviewer formaterPrettyPrinter format: biSettingPreviewer  methodDropList selectedItem ast)
]

{ #category : #initialization }
BISettingPreviewerTest >> testInitializeBeforePrettyShouldFillWithTheSelectedItemOfDropListPresenter [
	self
		assert: biSettingPreviewer beforePrettyPrintTextPresenter text
		equals: biSettingPreviewer methodDropList selectedItem sourceCode
]

{ #category : #initialization }
BISettingPreviewerTest >> testWhenClickOnRemoveSettingButtonShouldRemoveItFromSettingDropListAndFromProvideMethodClass [
	[ | codePresenterUI|
	codePresenterUI := BIInputPresenterUI openOn: biSettingPreviewer.
	codePresenterUI presenter codePresenter text:'myConfigForTest'.
	codePresenterUI triggerOkAction.
	codePresenterUI delete.
	biSettingPreviewer := BISettingPreviewer2 open: BIUseForTest.
	biSettingPreviewer settingsDropList
		selectedIndex:
			(biSettingPreviewer settingsDropList listItems
				indexOf: BIUseForTest class >> #myConfigForTest).
	biSettingPreviewer removeSettingButton click.
	self
		deny:
			(biSettingPreviewer settingsDropList listItems
				anySatisfy: [ :item | item selector = #myConfigForTest ]).
	self
		deny:
			(BIUseForTest class methods
				anySatisfy: [ :item | item selector = #myConfigForTest ]) ]
		ensure: [ [ (BIUseForTest class >> #myConfigForTest) removeFromSystem ]
				on: KeyNotFound
				do: [  ] ]
]

{ #category : #initialization }
BISettingPreviewerTest >> testWhenClickOnSaveSettingButtonShouldCreateMethodClassSideWithProcolSettingsAndAddToSettingsDropList [
	| codePresenterUI |
	[ codePresenterUI := BIInputPresenterUI openOn: biSettingPreviewer.
	codePresenterUI presenter codePresenter text: 'myConfigTest'.
	codePresenterUI triggerOkAction.
	self
		assert: [ biSettingPreviewer settingsDropList listItems
				anySatisfy: [ :item | item selector = #myConfigTest ] ].
	self
		assert: biSettingPreviewer settingsDropList selectedIndex
		equals: 1.
	self
		assert:
			(biSettingPreviewer methodProvider class methods
				anySatisfy: [ :item | item selector = #myConfigTest ]) ]
		ensure: [ (biSettingPreviewer methodProvider class >> #myConfigTest)
				removeFromSystem.
				 ]
]

{ #category : #tests }
BISettingPreviewerTest >> testWhenDropListSelectionChangedShouldBeforePrettyContainTheSelectedMethod [
	biSettingPreviewer methodDropList selectedIndex: 2.
	self assert: biSettingPreviewer beforePrettyPrintTextPresenter text 
	equals: biSettingPreviewer methodDropList selectedItem sourceCode
]

{ #category : #initialization }
BISettingPreviewerTest >> testWhenSettingsDropListSelectionShouldChangeTheContextOfPrettyPrinter [
	biSettingPreviewer settingsDropList
		selectedIndex:
			(biSettingPreviewer settingsDropList listItems
				indexOf: biSettingPreviewer methodProvider class >> #myConfigTest2).
	self
		deny: biSettingPreviewer afterPrettyPrintTextPresenter text
		equals: biSettingPreviewer formatPrettyPrint
]

{ #category : #tests }
BISettingPreviewerTest >> testWhenWeCreatAMethodInBrowserWithTheGoodTagShouldAddThisOneToMethodDropList [
	[BIUseForTest
		compile: 'myMethodForTestingAnnouncement' , String cr , '^ ''klmklm'' '.
	self
		assert:
			(biSettingPreviewer methodDropList listItems
				contains:  [:methodItem |methodItem selector = #myMethodForTestingAnnouncement])]
			ensure: [(BIUseForTest >>#myMethodForTestingAnnouncement ) removeFromSystem] 
]

{ #category : #tests }
BISettingPreviewerTest >> testWhenWeDelateAMethodInBrowserShouldRemoveThisOneFromMethodDropList [
	[ (BIUseForTest >> #useForTestWillBeRemove) removeFromSystem.
	self
		deny:
			(biSettingPreviewer methodDropList listItems
				contains: [ :methodItem | methodItem selector = #useForTestWillBeRemove ])
	]
		ensure: [ BIUseForTest
				compile: 'useForTestWillBeRemove' , String cr , '^ ''klmklm'' '
			]
]
