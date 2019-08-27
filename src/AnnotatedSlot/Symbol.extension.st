Extension { #name : #Symbol }

{ #category : #'*AnnotatedSlot' }
Symbol >> annotate: aLiteralObject [
	^ self => AnnotatedSlot annotate: aLiteralObject
]

{ #category : #'*AnnotatedSlot' }
Symbol >> getParsedForAnnotatedSlotWith: anAnnotationParser [
	^ SlotAnnotation selector: self
]
