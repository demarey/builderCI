"Initialize Image for batch testing with Metacello"
| fileInBlock resultFileBlock transcriptFileName transcriptStream |
(Deprecation respondsTo: #raiseWarning:)
  ifTrue: [ Deprecation raiseWarning: false ].

"Unconditionally route Transcript output to TravisTranscript.txt ... projects can choose whether or not to display"
transcriptFileName := 'TravisTranscript.txt'.
(Smalltalk at: #FileDirectory ifAbsent: [])
  ifNil: [ 
    fileInBlock := [:fileName | ((Smalltalk at: #FileSystem) workingDirectory / fileName)
      readStreamDo: [:fileStream | fileStream fileIn ] ].
    resultFileBlock := [:resultsFileName :streamBlock |
      ((Smalltalk at: #FileSystem) workingDirectory / resultsFileName)
        readStreamDo: streamBlock ].
     transcriptStream := ((Smalltalk at: #FileSystem) workingDirectory / transcriptFileName) writeStream ]
  ifNotNil: [:fileDirectoryClass | 
    fileInBlock := [:fileName | fileDirectoryClass default 
      fileNamed: fileName
      do: [:fileStream | fileStream fileIn ] ].
    resultFileBlock := [:resultsFileName :streamBlock |
      fileDirectoryClass default
        forceNewFileNamed: resultsFileName
        do: streamBlock ].
    transcriptStream := fileDirectoryClass default newFileNamed: transcriptFileName ].

fileInBlock value: 'FileStream-show.st'.

Smalltalk at: #TravisResultFileBlock put: resultFileBlock.
Smalltalk at: #OLDTranscript put: Transcript.
(Smalltalk globals associationAt: #Transcript) value: transcriptStream.
Transcript file lineEndConvention: #'lf'.
Transcript cr; show: 'travis---->before.st'.

"Bootstrap Metacello-Base to simulate conditions when it's included in base images"
(Smalltalk
  at: #'MetacelloProject'
  ifAbsent: []) 
    ifNil: [
      "Metacello not pre-installed install Metacello-Base"
      fileInBlock value: 'Metacello-Base.st' ]
    ifNotNil: [
      "Metacello already installed, install Preview".
      (Smalltalk at: #Gofer) new
        gemsource: 'metacello';
        package: 'ConfigurationOfMetacello';
        load.
      ((Smalltalk at: #ConfigurationOfMetacello) project 
        version: '1.0-beta.32') load.
      (Smalltalk at: #Metacello) new
        configuration: 'MetacelloPreview';
        version: #stable;
        repository: 'github://dalehenrich/metacello-work:configuration';
        load ].
    
"ensure that Gofer is available on Squeak"
(Smalltalk at: #ConfigurationOf) 
  ensureGoferVersion: 'Gofer-Core-lr.115' 
  repositoryUrl: 'http://seaside.gemstone.com/ss/metacello'.
