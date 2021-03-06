"Filed out from Dolphin Smalltalk X6.2"!

AnonymousKeyedAspect subclass: #BasicKeyedAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BasicKeyedAspect guid: (GUID fromString: '{493BBE17-DE57-4C11-8D61-E0494B76A1F6}')!
BasicKeyedAspect comment: 'Part of the PublishedAspectorInspector framework. BasicKeyedAspect instances are used to describe the published aspects of an object that can be accessed via #basicAt: and #basicAt:put: messages as governed by the BasicKeyedAspectAccessor class'!
!BasicKeyedAspect categoriesForClass!Development! !
!BasicKeyedAspect methodsFor!

getSelector
	"Private - Answers the selector used for getting the aspect value from the subject"

	^#basicAt:
!

putSelector
	^#basicAt:put:!

readFrom: anObject
	^anObject basicAt: self key!

writeInto: subjectObject value: valueObject
	"Private - Set the attribute of subjectObject described by the receiver 
	to valueObject."

	^subjectObject basicAt: self key put: valueObject! !
!BasicKeyedAspect categoriesFor: #getSelector!accessing!private! !
!BasicKeyedAspect categoriesFor: #putSelector!accessing!private! !
!BasicKeyedAspect categoriesFor: #readFrom:!indirect accessing!private! !
!BasicKeyedAspect categoriesFor: #writeInto:value:!indirect accessing!private! !

