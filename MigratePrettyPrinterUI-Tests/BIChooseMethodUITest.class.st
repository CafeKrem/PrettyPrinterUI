"
A BIChooseMethodUITest is a test class for testing the behavior of BIChooseMethodUI
"
Class {
	#name : #BIChooseMethodUITest,
	#superclass : #TestCase,
	#instVars : [
		'biChooseMethod'
	],
	#category : #'MigratePrettyPrinterUI-Tests'
}

{ #category : #'as yet unclassified' }
BIChooseMethodUITest >> selectClassNamed: aName [
	biChooseMethod classList
		selectIndex:
			(biChooseMethod classList items
				indexOf:
					(biChooseMethod classList items
						detect:
							[ :class | class name = aName ]))
]

{ #category : #initialize }
BIChooseMethodUITest >> selectPackageNamed: aName [
	biChooseMethod packageList
		selectIndex:
			(biChooseMethod packageList items
				indexOf:
					(biChooseMethod packageList items
						detect:
							[ :package | package name = aName ]))
]

{ #category : #running }
BIChooseMethodUITest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	biChooseMethod := BIChooseMethodUI new.
]

{ #category : #tests }
BIChooseMethodUITest >> testClickOnAnOtherItemClassShouldTransmitToMethodListHisClasssMethodAndSelectTheFirstOne [
	| itemListBefore |
	itemListBefore := biChooseMethod methodList  items.
	self selectPackageNamed: BIUseForTestWithMethod package name.
	self selectClassNamed: BIUseForTestWithMethod name.
	self deny: biChooseMethod methodList items isEmpty.
	self assert: biChooseMethod methodList selection selectedIndex equals: 1 .
	self deny: (itemListBefore = biChooseMethod methodList items)
]

{ #category : #initialize }
BIChooseMethodUITest >> testClickOnAnOtherItemPackageShouldTransmitToClassListHisPackageClassesAndSelectTheFirstOne [
	| itemListBefore |
	itemListBefore := biChooseMethod classList items.
	self selectPackageNamed: 'Kernel'.
	self deny: biChooseMethod classList items isEmpty.
	self assert: biChooseMethod classList selection selectedIndex equals: 1.
	self deny: (itemListBefore = biChooseMethod classList items)
]

{ #category : #tests }
BIChooseMethodUITest >> testClickOnAnOtherItemPackageWhoClassesAreEmptyShouldTransmitToClassListEmptyCollectionAndSetIndexTo0 [
	self selectPackageNamed: 'MigratePrettyPrinterUI-Tests-environementEmpty'.
	self assert: biChooseMethod classList items isEmpty.
	self assert: biChooseMethod classList selection selectedItem isNil
]

{ #category : #initialize }
BIChooseMethodUITest >> testInitializeClassListShouldBeSelectTheFistItem [
	self
		assert: biChooseMethod classList selection selectedIndex
		equals: 1
]

{ #category : #initialize }
BIChooseMethodUITest >> testInitializeMethodListShouldBeSelectTheFistItem [
	self
		assert: biChooseMethod methodList selection selectedIndex
		equals: 1
]

{ #category : #initialize }
BIChooseMethodUITest >> testInitializePackageListShouldBeSelectTheFistItem [
	self
		assert: biChooseMethod packageList selection selectedIndex
		equals: 1
]
