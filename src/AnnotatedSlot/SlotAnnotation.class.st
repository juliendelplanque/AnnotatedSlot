"
I model extra metadata added to a slot.
I am quite similar to a Pragma but I work with slots instead of methods.

I am partially polymorphic with Pragma and provide class-side methods to gather annotations similar to the ones provided by Pragma class.
"
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

{ #category : #finding }
SlotAnnotation class >> allNamed: aSymbol from: aSubClass to: aSuperClass [
	"Answer a collection of all annotations found in slots of all classes between aSubClass and aSuperClass (inclusive) whose selector is aSymbol."
	
	^ Array streamContents: [ :stream |
		aSubClass withAllSuperclassesDo: [ :class |
			self withAnnotationsIn: class do:  [ :annotation |
				annotation selector = aSymbol
					ifTrue: [ stream nextPut: annotation ] ].
			aSuperClass = class
				ifTrue: [ ^ self ] ] ].
]

{ #category : #finding }
SlotAnnotation class >> allNamed: aSymbol from: aSubClass to: aSuperClass sortedByArgument: anInteger [
	"Answer a collection of all pragmas found in methods of all classes between aSubClass and aSuperClass (inclusive) whose keyword is aSymbol, sorted according to argument anInteger."

	^ self allNamed: aSymbol from: aSubClass to: aSuperClass sortedUsing: [ :a :b | (a argumentAt: anInteger) < (b argumentAt: anInteger) ].
]

{ #category : #finding }
SlotAnnotation class >> allNamed: aSymbol from: aSubClass to: aSuperClass sortedUsing: aSortBlock [
	"Answer a collection of all pragmas found in methods of all classes between aSubClass and aSuperClass (inclusive) whose keyword is aSymbol, sorted according to aSortBlock."
	
	^ (self allNamed: aSymbol from: aSubClass to: aSuperClass) sort: aSortBlock.
]

{ #category : #finding }
SlotAnnotation class >> allNamed: aSymbol in: aClass [
	"Answer a collection of all annotations found in methods of aClass whose selector is aSymbol."
	^ Array streamContents: [ :stream |
		self withAnnotationsIn: aClass do: [ :annotation |
			annotation selector = aSymbol
				ifTrue: [ stream nextPut: annotation ] ] ].
]

{ #category : #finding }
SlotAnnotation class >> allNamed: aSymbol in: aClass sortedByArgument: anInteger [
	"Answer a collection of all annotations found in slots of aClass whose selector is aSymbol, sorted according to argument anInteger."

	^ self allNamed: aSymbol in: aClass sortedUsing: [ :a :b | (a argumentAt: anInteger) < (b argumentAt: anInteger) ].
]

{ #category : #finding }
SlotAnnotation class >> allNamed: aSymbol in: aClass sortedUsing: aSortBlock [
	"Answer a collection of all pragmas found in slots of aClass whose selector is aSymbol, sorted according to aSortBlock."
	
	^ (self allNamed: aSymbol in: aClass) sort: aSortBlock.
]

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

{ #category : #private }
SlotAnnotation class >> withAnnotationsIn: aClass do: aBlock [
	aClass slots do: [ :slot | slot annotations do: aBlock ].
]

{ #category : #comparing }
SlotAnnotation >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ slot = anObject slot
		and: [ arguments = anObject arguments and: [ selector = anObject selector ] ]
]

{ #category : #comparing }
SlotAnnotation >> analogousCodeTo: anObject [ 
	^self class == anObject class
	  and: [self selector == anObject selector
	  and: [arguments = anObject arguments]]
]

{ #category : #'accessing-annotation' }
SlotAnnotation >> argumentAt: anInteger [
	"Answer one of the arguments of the pragma."
	
	^ self arguments at: anInteger.
]

{ #category : #'accessing-annotation' }
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

{ #category : #comparing }
SlotAnnotation >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ slot hash bitXor: (arguments hash bitXor: selector hash)
]

{ #category : #initialization }
SlotAnnotation >> initialize [
	super initialize.
	self arguments: #()
]

{ #category : #accessing }
SlotAnnotation >> key [
	"Answer the keyword of the pragma (the selector of its message pattern).
	 This accessor provides polymorphism with Associations used for properties."
	^ self selector
]

{ #category : #accessing }
SlotAnnotation >> message [
	"Answer the message of the receiving pragma."
	
	^ Message selector: self selector arguments: self arguments. 
]

{ #category : #'accessing-annotation' }
SlotAnnotation >> numArgs [
	"Answer the number of arguments in the pragma."

	^ self arguments size
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
	^ self selector keywords collect: #asSymbol
]

{ #category : #sending }
SlotAnnotation >> sendTo: anObject [
	"Send the pragma selector together with its arguments to anObject and answer the result."
	
	^ anObject perform: self selector withArguments: self arguments
]

{ #category : #accessing }
SlotAnnotation >> slot [
	^ slot
]

{ #category : #accessing }
SlotAnnotation >> slot: anObject [
	slot := anObject
]

{ #category : #'accessing-slot' }
SlotAnnotation >> slotClass [
	^ self slot definingClass
]

{ #category : #'accessing-slot' }
SlotAnnotation >> slotName [
	^ self slot name
]

{ #category : #processing }
SlotAnnotation >> withArgumentsDo: aBlock [
	"Pass the arguments of the receiving pragma into aBlock and answer the result."
	
	^ aBlock valueWithArguments: self arguments
]
