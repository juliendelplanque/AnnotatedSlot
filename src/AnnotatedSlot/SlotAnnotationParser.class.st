"
I am a small parser dealing with annotation arrays in annotated slots declarations.

I read an annotation or collection of annotations encoded in a symbol or an array and I generate a SlotAnnotation or a collection of SlotAnnotation.

Examples:

SlotAnnotationParser parse: #mypragma.
SlotAnnotationParser parse: #(#multiple #pragmas).
SlotAnnotationParser parse: #(my: 1 pragma: 2 with: 3 args: 4).
SlotAnnotationParser parse: #((my: 1 pragma: 2 with: 3 args: 4) #and #(#other: #pragma)).
"
Class {
	#name : #SlotAnnotationParser,
	#superclass : #Object,
	#category : #AnnotatedSlot
}

{ #category : #parsing }
SlotAnnotationParser class >> parse: aLiteral [
	^ self new
		parse: aLiteral
]

{ #category : #parsing }
SlotAnnotationParser >> parse: aLiteral [
	^ aLiteral getParsedForAnnotatedSlotWith: self
]

{ #category : #parsing }
SlotAnnotationParser >> parseAnnotationsWithArgumentsDeclaration: anArray [
	| selectorKeywords |
	anArray size even
		ifFalse: [ self error: 'Bad format for annotation.' ].
		
	selectorKeywords := anArray withIndexSelect: [ :s :i | i odd ].
	(selectorKeywords allSatisfy: #endsWithAColon)
		ifFalse: [ self error: 'Bad format for annotation.' ].
		
	^ SlotAnnotation
		selector: (selectorKeywords joinUsing: String empty)
		arguments: (anArray withIndexSelect: [ :s :i | i even ])
]

{ #category : #parsing }
SlotAnnotationParser >> parseMultipleAnnotationsDeclaration: anArray [
	^ anArray collect: [ :object | object getParsedForAnnotatedSlotWith: self ]
]
