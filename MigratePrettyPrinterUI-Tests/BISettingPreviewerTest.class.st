Class {
	#name : #BISettingPreviewerTest,
	#superclass : #TestCase,
	#instVars : [
		'biSettingPreviewer',
		'biSetingPreviewWindow'
	],
	#category : #'MigratePrettyPrinterUI-Tests'
}

{ #category : #running }
BISettingPreviewerTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	biSettingPreviewer := BISettingPreviewer2 new.
	biSetingPreviewWindow := biSettingPreviewer openWithSpec
	
]

{ #category : #running }
BISettingPreviewerTest >> tearDown [ 
	biSetingPreviewWindow close.
]

{ #category : #initialization }
BISettingPreviewerTest >> testDropListSelectedIndexShouldBeEqualsToOne [
	self assert: biSettingPreviewer methodDropList selectedIndex equals: 1.
]

{ #category : #tests }
BISettingPreviewerTest >> testWhenDropListSelectionChangedShouldBeforePrettyContainTheSelectedMethod [
	biSettingPreviewer methodDropList selectedIndex: 2.
	self assert: biSettingPreviewer beforePrettyPrintTextPresenter text 
	equals: biSettingPreviewer methodDropList selectedItem sourceCode
]
