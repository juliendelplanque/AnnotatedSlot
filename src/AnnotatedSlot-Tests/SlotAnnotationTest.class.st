"
A SlotAnnotationTest is a test class for testing the behavior of SlotAnnotation
"
Class {
	#name : #SlotAnnotationTest,
	#superclass : #TestCase,
	#category : #'AnnotatedSlot-Tests'
}

{ #category : #test }
SlotAnnotationTest >> testAnnotationWithArgumentsAsLiteralObject [
	| annotation |
	annotation := SlotAnnotation selector: #foo:bar: arguments: #(42 #foo).
	
	self assert: annotation asLiteralObject equals: #(#foo: 42 bar: foo)
]

{ #category : #test }
SlotAnnotationTest >> testAsLiteralObject [
	| annotation |
	annotation := SlotAnnotation selector: #foo.
	
	self assert: annotation asLiteralObject equals: #foo
]
