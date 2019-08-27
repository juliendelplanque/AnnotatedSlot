Class {
	#name : #SlotAnnotation,
	#superclass : #Object,
	#instVars : [
		'selector',
		'arguments',
		'slot'
	],
	#category : #AnnotatedSlot
}

{ #category : #'instance creation' }
SlotAnnotation class >> selector: selector [
	^ self new
		selector: selector;
		yourself
]

{ #category : #'instance creation' }
SlotAnnotation class >> selector: selector arguments: arguments [
	^ self new
		selector: selector;
		arguments: arguments;
		yourself
]

{ #category : #accessing }
SlotAnnotation >> arguments [
	^ arguments
]

{ #category : #accessing }
SlotAnnotation >> arguments: anObject [
	arguments := anObject
]

{ #category : #converting }
SlotAnnotation >> asLiteralObject [
	"Returns an object which is the representation of the annotation
	 as a literal object (Symbol, array of symbols, etc...).
	"
	self hasArguments
		ifFalse: [ ^ self selector ].
		
	^ Array streamContents: [ :stream |
		self selectorKeywords with: self arguments do: [ :keyword :argument |
			stream
				nextPut: keyword;
				nextPut: argument ] ]
]

{ #category : #testing }
SlotAnnotation >> hasArguments [
	^ self arguments isNotEmpty
]

{ #category : #initialization }
SlotAnnotation >> initialize [
	super initialize.
	self arguments: #()
]

{ #category : #printing }
SlotAnnotation >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self arguments 
		ifEmpty: [ aStream nextPutAll: self selector ]
		ifNotEmpty: [
	self selectorKeywords with: self arguments do: [ :keyword :argument |
		aStream nextPutAll: keyword.
		aStream space.
		argument printOn: aStream.
		aStream space. ] ].
	aStream nextPut: $)
]

{ #category : #accessing }
SlotAnnotation >> selector [
	^ selector
]

{ #category : #accessing }
SlotAnnotation >> selector: anObject [
	selector := anObject
]

{ #category : #accessing }
SlotAnnotation >> selectorKeywords [
	^ (self selector splitOn: $:) allButLast collect: [ :s | s asSymbol asMutator ]
]

{ #category : #accessing }
SlotAnnotation >> slot [
	^ slot
]

{ #category : #accessing }
SlotAnnotation >> slot: anObject [
	slot := anObject
]
