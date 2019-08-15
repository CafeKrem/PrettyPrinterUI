Extension { #name : #BIConfigurableFormatter }

{ #category : #'*MigratePrettyPrinterUI' }
BIConfigurableFormatter class >> defaultPrettyPrintContext [
	^ DefaultPrettyPrintContext
]

{ #category : #'*MigratePrettyPrinterUI' }
BIConfigurableFormatter class >> defaultPrettyPrintContext: aContext [
	DefaultPrettyPrintContext := aContext  
]
