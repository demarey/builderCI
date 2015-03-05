| gitPath gitCache |
Transcript cr; show: 'travis---->travisCI.st'.

"If e.g. your tests change code in the image dynamically, the image will require you to set 
author initials which might fail these tests. So we set some dummy initials here to avoid this."
Utilities setAuthorInitials: 'travisCI'.

gitCache := 'git_cache'.
gitPath := (Smalltalk at: #'FileDirectory' ifAbsent: [  ])
  ifNil: [ ((Smalltalk at: #'FileSystem') workingDirectory / gitCache) pathString ]
  ifNotNil: [:fileDirectoryClass | (fileDirectoryClass default directoryNamed: gitCache ) fullName].

"Sample travisCI.st file:

  Edit the Metacello api and test harness invocation
  using the correct configuration name and repository 
  location.

See https://github.com/dalehenrich/filetree/blob/pharo1.4/tests/travisCI.st for example"

Metacello new
  baseline: '<projectName>';
  repository: 'filetree://', gitPath, '/<projectName>/<path to filetree packages root>';
  get.

Metacello new
  baseline: '<projectName>';
  repository: 'filetree://', gitPath, '/<projectName>/<path to filetree packages root>';
  load: 'TravisCI'.

"Run the tests"
TravisCIHarness
  value: #( '<full baseline name>' )
  value: 'TravisCISuccess.txt' 
  value: 'TravisCIFailure.txt'.

