"
this class is use by the BISettingPreviewer
in this class we have method with bad formating.
those method are use to show how the configuration will be apply.

README 
	if you have to add exemple please put a good name.
	and put into class side 
"
Class {
	#name : #BIUseByPrettyPrintConfig,
	#superclass : #Object,
	#category : #MigratePrettyPrinterUI
}

{ #category : #methods }
BIUseByPrettyPrintConfig class >> cascadeExample [ OrderedCollection new add: 1; add: 2
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> formatCommentWithStatementsExample [
	1+1 "We do an addition".
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> indentStringExample [
	"aComment" 
		1 to: 10 do: 
			[:i | Transcript show:i .i to: 10 do:
			[:j | Transcript show:j; cr;cr ]]
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> indentsForKeywordsExample [
	"depend of the setting numberOfArgumentsForMultiLine"

	'foo bar arg1: 1 arg2: 2 arg3: 3 arg4:4 arg5:5 arg6:6'
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> indentsForKeywordsExample:a1 arg2:a2 arg3:a3 arg4:a4 arg5:a5 [
	"depend of the setting numberOfArgumentsForMultiLine"
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> keepBlockInMessageExample [
	1 to: 4 do: [ :i | 
		Transcript
			show: i;
			cr;
			cr ]
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> lineUpBlockBracketsExample [ 1 to: 4 do:[:i | Transcript show: i;cr;cr]
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> maxLineLengthExample [
{1. 2. 3. 4. 5. 6. 7. 8. 9. 10. 11. 12. 13. 14. 15. 16. 17. 18}
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> methodSignatureOnMultipleLinesExample:arg1 foo:arg2 bar:arg3 [
"depend of the setting selectorAndArgumentCombinedMaxSize"
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> minimumNewLinesBetweenStatementsExample [ | a | a:= 1. ^a
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> multiLineMessagesExample [
	true
		ifTrue: [ ^ 0 ]
		ifFalse: [ ^ 1 ]
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> newLineBeforeFirstKeywordExample: aNumber [ ^ aNumber between: 0 and:5
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> newLinesAfterMethodCommentExample [ "aComment" ^true
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> newLinesAfterMethodPatternExample [ ^true
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> newLinesAfterTemporariesExample [ | a | a:=1.
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> numberOfArgumentsForMultiLineExample [ | a | a:=1.
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> periodsAtEndOfBlockExample [ 1 to:10 do: [:i | i+1.]
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> periodsAtEndOfMethodExample [ | a | a := 1. ^ a.
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> retainBlankLinesBeforeCommentsExample [
	' | d 
	
	
	"comment" e |'
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> retainBlankLinesBetweenStatementsExample [
	| a |



	a := 1.

	^ a.
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> selectorAndArgumentCombinedMaxSizeExample: arg1 k2: a2 k3:a3 k4:a4 k5:a5 k6:a6 [	
"depend of the setting methodSignatureOnMultipleLines"
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> stringFollowingReturnExample [ ^true
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> stringInsideBlocksExample [
	[ :i | i + 1 ]
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> stringInsideParenthesesExample [
	(1 + 1) *10
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> useBasicCommentFormatExample [
	"      aaa      "
]

{ #category : #methods }
BIUseByPrettyPrintConfig class >> useTraditionalBinaryPrecedenceForParenthesesExample [
	
	true | false & true.
	true | false = false.
	(true | false) = false.
	2 + 3 * 5.
	(2 + 3) * 5.
	2 + 3 + 5.
	2 + 3 * 4 - 5 * 2.
	((2 + 3) * 4 - 5) * 2
]

{ #category : #'as yet unclassified' }
BIUseByPrettyPrintConfig class >> yodaPrettyPrint [
	^ 'Quand 900 ans comme moi tu auras' , 
	
	
	
	
	', moins en forme tu seras. '
]
