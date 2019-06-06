"
this class is use by the BISettingPreviewer
in this class we have method with bad formating.
those method are use to show how the configuration will be apply.

README 
	if you have to add exemple please put a good name.
	and put into class side 
"
Class {
	#name : #BIMethodProvider,
	#superclass : #Object,
	#category : #MigratePrettyPrinterUI
}

{ #category : #settings }
BIMethodProvider class >> myConfigTest [
	^ BIPrettyPrinterContext new
]

{ #category : #methods }
BIMethodProvider class >> yodaPrettyPrint [
	^ 'Quand 900 ans comme moi tu auras' , 
	
	
	
	
	', moins en forme tu seras. '
]

{ #category : #methods }
BIMethodProvider >> yodaPrettyPrint [
	^ 'Quand 900 ans comme moi tu auras' , 
	
	
	
	
	', moins en forme tu seras. '
]
