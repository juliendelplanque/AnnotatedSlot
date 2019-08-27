Class {
	#name : #MockObjectWithAnnotatedSlot,
	#superclass : #Object,
	#instVars : [
		'#simpleAnnotated annotate: #foo',
		'#annotatedWithArguments annotate: #(#foo: 42 #bar: \'yes\' )',
		'#multipleAnnotations annotate: #(#foo#(#foo: 42 #bar: \'yes\' ))'
	],
	#category : #'AnnotatedSlot-Tests'
}
