Class {
	#name : #BISettingPreviewerTest,
	#superclass : #TestCase,
	#instVars : [
		'biSettingPreviewer'
	],
	#category : #'MigratePrettyPrinterUI-Tests'
}

{ #category : #running }
BISettingPreviewerTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	biSettingPreviewer := BISettingPreviewer2 new.
]

{ #category : #initialization }
BISettingPreviewerTest >> testDropListSelectedIndexShouldBeEqualsToOne [
	self assert: biSettingPreviewer methodDropList selectedIndex equals: 1.
]
