Class {
	#name : #BISettingPreviewerTest,
	#superclass : #TestCase,
	#instVars : [
		'biSettingPreviewer',
		'biSetingPreviewWindow'
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
	biSettingPreviewer := BISettingPreviewer2 new.
	biSetingPreviewWindow := biSettingPreviewer openWithSpec
	
]

{ #category : #running }
BISettingPreviewerTest >> tearDown [ 
	biSetingPreviewWindow close.
	biSettingPreviewer delete.
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
	[ biSettingPreviewer := BISettingPreviewer2 open: BIUseForTest.
	biSettingPreviewer beforePrettyPrintTextPresenter
		text: 'myMethodTestazert ' , String cr , '^ klm'.
	biSettingPreviewer saveMethodButton click.
	self
		assert:
			(biSettingPreviewer methodDropList listItems
				contains: [ :item | item selector = #myMethodTestazert ]).
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
	self fail.
	self
		assert: biSettingPreviewer afterPrettyPrintTextPresenter
		equals: biSettingPreviewer methodDropList selectedItem sourceCode
]

{ #category : #initialization }
BISettingPreviewerTest >> testInitializeBeforePrettyShouldFillWithTheSelectedItemOfDropListPresenter [
	self
		assert: biSettingPreviewer beforePrettyPrintTextPresenter text
		equals: biSettingPreviewer methodDropList selectedItem sourceCode
]

{ #category : #tests }
BISettingPreviewerTest >> testWhenDropListSelectionChangedShouldBeforePrettyContainTheSelectedMethod [
	biSettingPreviewer methodDropList selectedIndex: 2.
	self assert: biSettingPreviewer beforePrettyPrintTextPresenter text 
	equals: biSettingPreviewer methodDropList selectedItem sourceCode
]