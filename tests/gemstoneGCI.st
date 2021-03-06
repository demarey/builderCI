"Load the Server-side support code for gci tests. See testGemStoneGCI.sh"
Transcript cr; show: 'travis---->gemstoneGCI.st'.

"Use the Sample project to verify that Metacello and FileTree are 
 booting correctly"

[Metacello new
  configuration: 'Sample';
  version: '0.9.0';
  repository: 'github://dalehenrich/sample:configuration';
  load: 'Tests' ]
        on: Warning
        do: [:ex |
                Transcript cr; show: 'Warning: ', ex description.
                ex resume: true].

"Run the server-side tests ... clientGCI.st controls client-side load and tests"
TravisCIHarness
  value: #( 'ConfigurationOfSample' )
  value: 'TravisCISuccess.txt' 
  value: 'TravisCIFailure.txt'.
