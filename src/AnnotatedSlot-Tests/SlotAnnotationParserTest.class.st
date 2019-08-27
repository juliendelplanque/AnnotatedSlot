"
A SlotAnnotationParserTest is a test class for testing the behavior of SlotAnnotationParser
"
Class {
	#name : #SlotAnnotationParserTest,
	#superclass : #TestCase,
	#category : #'AnnotatedSlot-Tests'
}

{ #category : #tests }
SlotAnnotationParserTest >> testParseAnnotationWithArguments [
	| parser annotation |
	parser := SlotAnnotationParser new.
	annotation := parser parse: #(my: 1 pragma: 2 with: 3 args: 4).
	
	self assert: annotation selector equals: #my:pragma:with:args:.
	self assert: annotation arguments equals: #(1 2 3 4).
]

{ #category : #tests }
SlotAnnotationParserTest >> testParseMultipleSingleAnnotation [
	| parser annotations |
	parser := SlotAnnotationParser new.
	annotations := parser parse: #(#multiple #pragmas).
	
	self assert: annotations size equals: 2.
	self assert: annotations first selector equals: #multiple.
	self assert: annotations first arguments equals: #().
	self assert: annotations second selector equals: #pragmas.
	self assert: annotations second arguments equals: #().
]

{ #category : #tests }
SlotAnnotationParserTest >> testParseMultipleVariousAnnotation [
	| parser annotations |
	parser := SlotAnnotationParser new.
	annotations := parser parse: #((my: 1 pragma: 2 with: 3 args: 4) #and #(#other: #pragma)).
	
	self assert: annotations size equals: 3.
	self assert: annotations first selector equals: #my:pragma:with:args:.
	self assert: annotations first arguments equals: #(1 2 3 4).
	self assert: annotations second selector equals: #and.
	self assert: annotations second arguments equals: #().
	self assert: annotations third selector equals: #other:.
	self assert: annotations third arguments equals: #(pragma).
]

{ #category : #tests }
SlotAnnotationParserTest >> testParseSingleAnnotation [
	| parser annotation |
	parser := SlotAnnotationParser new.
	annotation := parser parse: #mypragma.
	
	self assert: annotation selector equals: #mypragma.
	self assert: annotation arguments equals: #().
]
