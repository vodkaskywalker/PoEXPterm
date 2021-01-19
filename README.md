# PoEXPTrack
sample of Path of Exile Exp Parsing using PoE character API, jq JSON Processor and shell script.

Current Limitation :
- no automatic reload (recommended between 30s to 2mins)

Tested on : OSX 10.15.7

### How To 
- put all files on single folder
- download `jq` binary - https://github.com/stedolan/jq - JSON processor and put it in the same folder as `poe-track.sh` file
- edit poe-track.sh -  fill with your PoE Account name & Character Name (case-sensitive) :

    | Variables | Values  |
    | ------------- | ------------- |
    | accountName  | Path of Exile Account Name |
    | charName  | Path of Exile Character Name  |
    
- run with `./poe-track.sh` or `sh poe-track.sh` from your Terminal.app
