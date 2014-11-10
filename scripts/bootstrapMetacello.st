Transcript cr; show: 'travis---->bootstrapMetacello.st'.

"Bootstrap Metacello-Base to simulate conditions when it's included in base images"
[(Smalltalk
  at: #'MetacelloProject'
  ifAbsent: []) 
    ifNil: [
      "Metacello not pre-installed install Metacello-Base"
      Transcript cr; show: 'Metacello not pre-installed install Metacello-Base'.
      MetacelloBuilderTravisCI fileIn: 'Metacello-Base.st'.

      "ensure that Gofer is available on Squeak"
      MetacelloBuilderTravisCI retry: [
        (Smalltalk at: #ConfigurationOf) 
          ensureGoferVersion: 'Gofer-Core-lr.115' 
          repositoryUrl: 'http://seaside.gemtalksystems.com/ss/metacello'. ]]
    ifNotNil: [
      "MetacelloProject already installed, install Metacello Preview"
      Smalltalk 
        at: #Metacello
        ifAbsent: [
          "Metacello class not present, so let's bootstrap the Metacello Preview"
          Transcript cr; show: 'Metacello pre-installed bootstrap Metacello Preview'.
          MetacelloBuilderTravisCI retry: [
            (Smalltalk at: #Gofer) new
              url: 'http://seaside.gemtalksystems.com/ss/metacello';
              package: 'ConfigurationOfMetacello';
              load ].
          ((Smalltalk at: #ConfigurationOfMetacello) project 
            version: #'previewBootstrap') load ].
      Transcript cr; show: 'Install stable version of Metacello Preview'.
true ifTrue: [
"Issue #72: bootstrap using baseline and explicit commit until we get bugs ironed out and can release Metacello Preview 1.0.0-beta.32.17"
      (Smalltalk at: #Metacello) new
        baseline: 'Metacello';
        repository: 'github://dalehenrich/metacello-work:76e29e6d8c82d9eecf3456cee9a658efc9914824/repository';
        get.
      (Smalltalk at: #Metacello) new
         baseline: 'Metacello';
        repository: 'github://dalehenrich/metacello-work:76e29e6d8c82d9eecf3456cee9a658efc9914824/repository';
        load 
] ifFalse: [
      (Smalltalk at: #Metacello) new
        configuration: 'MetacelloPreview';
        version: #'stable'; 
        repository: 'github://dalehenrich/metacello-work:configuration';
        get.
      (Smalltalk at: #Metacello) new
        configuration: 'MetacelloPreview';
        version: #'stable'; 
        repository: 'github://dalehenrich/metacello-work:configuration';
        load 
].
]] 
	on: Warning
	do: [:ex |
		Transcript cr; show: 'Warning: ', ex description.
		ex resume: true].

