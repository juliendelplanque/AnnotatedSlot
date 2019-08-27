"
I am a slot that can be annotated via SlotAnnotation.

The prefered way to use me is:

#simpleAnnotated annotate: #foo. 
#annotatedWithArguments annotate: #(#foo: 42 #bar: 'yes' ). 
#multipleAnnotations annotate: #(#foo #(#foo: 42 #bar: 'yes' ))
"
Class {
	#name : #AnnotatedSlot,
	#superclass : #InstanceVariableSlot,
	#instVars : [
		'annotations'
	],
	#category : #AnnotatedSlot
}

{ #category : #adding }
AnnotatedSlot >> addAllAnnotations: aCollectionOfAnnotations [
	aCollectionOfAnnotations do: [ :annotation |
		self addAnnotation: annotation ]
]

{ #category : #adding }
AnnotatedSlot >> addAnnotation: annotation [
	annotation slot: self.
	self annotations add: annotation
]

{ #category : #annotating }
AnnotatedSlot >> annotate: aLiteral [
	self addAllAnnotations: (self annotationParser parse: aLiteral) asOrderedCollection
]

{ #category : #accessing }
AnnotatedSlot >> annotationParser [
	^ SlotAnnotationParser new
]

{ #category : #accessing }
AnnotatedSlot >> annotations [
	^ annotations
]

{ #category : #accessing }
AnnotatedSlot >> annotations: anObject [
	annotations := anObject
]

{ #category : #printing }
AnnotatedSlot >> definitionString [
	^ String streamContents: [ :stream |
		self name storeOn: stream.
		stream nextPutAll: ' annotate: '.
		self annotations size = 1
			ifTrue: [ self annotations first asLiteralObject storeOn: stream ]
			ifFalse: [
				stream nextPutAll: '#('.
				self annotations do: [ :annotation |
					annotation asLiteralObject storeOn: stream ].
				stream nextPut: $) ] ]
]

{ #category : #initialization }
AnnotatedSlot >> initialize [
	super initialize.
	self annotations: OrderedCollection new
]
