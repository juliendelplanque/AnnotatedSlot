Extension { #name : #Array }

{ #category : #'*AnnotatedSlot' }
Array >> getParsedForAnnotatedSlotWith: anAnnotationParser [
	self ifEmpty: [ ^ self ].

	self size = 1
		ifTrue: [ ^ SlotAnnotation selector: self ].
	
	(self allSatisfy: [ :object | object isSymbol and: [ object endsWithAColon not ] ])
		ifTrue: [ ^ self collect: [ :symbol | symbol getParsedForAnnotatedSlotWith: anAnnotationParser ] ].
	
	(self anySatisfy: [ :object | object isSymbol and: [ object endsWithAColon ] ])
		ifTrue: [ ^ anAnnotationParser parseAnnotationsWithArgumentsDeclaration: self ].
	
	^ anAnnotationParser parseMultipleAnnotationsDeclaration: self
]
