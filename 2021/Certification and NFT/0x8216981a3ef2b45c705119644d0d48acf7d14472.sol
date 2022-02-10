['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-10\n', '*/\n', '\n', '// hevm: flattened sources of contracts/PolkaPetAdaptorAuthority.sol\n', '\n', 'pragma solidity >=0.4.24 <0.5.0;\n', '\n', '////// contracts/PolkaPetAdaptorAuthority.sol\n', '/* pragma solidity ^0.4.24; */\n', '\n', 'contract PolkaPetAdaptorAuthority {\n', '    mapping (address => bool) public whiteList;\n', '\n', '    constructor(address[] _whitelists) public {\n', '        for (uint i = 0; i < _whitelists.length; i++) {\n', '            whiteList[_whitelists[i]] = true;\n', '        }\n', '    }\n', '\n', '    function canCall(\n', '        address _src, address /*_dst*/, bytes4 _sig\n', '    ) public view returns (bool) {\n', '        return  whiteList[_src] && _sig == bytes4(keccak256("toMirrorTokenIdAndIncrease(uint256)"));\n', '    }\n', '}']