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
false ifTrue: [
"enable and edit this block when it's necessary to customize how 
 MetacelloPreview is loaded ... during development only..."
      (Smalltalk at: #Metacello) new
        configuration: 'MetacelloPreview';
        repository: 'github://dalehenrich/metacello-work:config_dev';
        get.
      (Smalltalk at: #Metacello) new
        configuration: 'MetacelloPreview';
        version: #stable;
        repository: 'github://dalehenrich/metacello-work:config_dev';
        load 
] ifFalse: [
      (Smalltalk at: #Metacello) new
        configuration: 'MetacelloPreview';
        repository: 'github://dalehenrich/metacello-work:configuration';
        get.
      (Smalltalk at: #Metacello) new
        configuration: 'MetacelloPreview';
        version: #'stable'; 
        repository: 'github://dalehenrich/metacello-work:configuration';
        load 
]]] 
    on: Warning
    do: [:ex |
	Transcript cr; show: 'Warning: ', ex description.
	ex resume: true].

