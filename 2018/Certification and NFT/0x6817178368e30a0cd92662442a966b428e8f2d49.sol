['pragma solidity ^0.4.0;\n', 'contract theCyberGatekeeper {\n', '  function enter(bytes32 _passcode, bytes8 _gateKey) public {}\n', '}\n', '\n', 'contract GateProxy {\n', '    function enter(bytes32 _passcode, bytes8 _gateKey) public {\n', '        theCyberGatekeeper(0x44919b8026f38D70437A8eB3BE47B06aB1c3E4Bf).enter.gas(81910)(_passcode, _gateKey);\n', '    }\n', '}']
['pragma solidity ^0.4.0;\n', 'contract theCyberGatekeeper {\n', '  function enter(bytes32 _passcode, bytes8 _gateKey) public {}\n', '}\n', '\n', 'contract GateProxy {\n', '    function enter(bytes32 _passcode, bytes8 _gateKey) public {\n', '        theCyberGatekeeper(0x44919b8026f38D70437A8eB3BE47B06aB1c3E4Bf).enter.gas(81910)(_passcode, _gateKey);\n', '    }\n', '}']
