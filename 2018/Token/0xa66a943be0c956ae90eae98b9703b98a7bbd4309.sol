['pragma solidity ^0.4.9;\n', '\n', 'contract Originstamp {\n', '\n', '    address public owner;\n', '\n', '    event Submitted(bytes32 indexed pHash);\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function Originstamp() public {\n', '\towner = msg.sender;\n', '    }\n', '\n', '    function submitHash(bytes32 pHash) public onlyOwner() {\n', '        Submitted(pHash);\n', '    }\n', '}']