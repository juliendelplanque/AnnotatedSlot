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
