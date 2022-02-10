['/**\n', ' *Submitted for verification at Etherscan.io on 2019-07-08\n', '*/\n', '\n', '/**this is the Smart Contract for Distributing QOB Bonus to SuperNodes Family & LightNodes team:\n', ' * 1. SuperNodes & their family members;\n', ' * 2. LightNodes & their direct referees;\n', ' * 3. At the end of each session;\n', ' * 4. For QOB Bonus;\n', '*/\n', '\n', 'pragma solidity ^0.4.18;\n', '\n', 'contract Owned {\n', '    address public owner;\n', '\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface Token {\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '}\n', '\n', 'contract SendBonus is Owned {\n', '\n', '    function batchSend(address _tokenAddr, address[] _to, uint256[] _value) returns (bool _success) {\n', '        require(_to.length == _value.length);\n', '        require(_to.length <= 200);\n', '        \n', '        for (uint8 i = 0; i < _to.length; i++) {\n', '            (Token(_tokenAddr).transfer(_to[i], _value[i]));\n', '        }\n', '        \n', '        return true;\n', '    }\n', '}']