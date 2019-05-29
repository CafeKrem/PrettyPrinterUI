Class {
	#name : #BIMockBISettingPreviewer,
	#superclass : #Object,
	#instVars : [
		'methodCall'
	],
	#category : #'MigratePrettyPrinterUI-Tests'
}

{ #category : #initialization }
BIMockBISettingPreviewer >> initialize [
	super initialize.
	methodCall := false.
]

{ #category : #accessing }
BIMockBISettingPreviewer >> methodCall [
	^ methodCall
]

{ #category : #accessing }
BIMockBISettingPreviewer >> methodCall: anObject [
	methodCall := anObject
]

{ #category : #accessing }
BIMockBISettingPreviewer >> methodToPRettyPrint: fourtyTwo [
	methodCall := true
]
