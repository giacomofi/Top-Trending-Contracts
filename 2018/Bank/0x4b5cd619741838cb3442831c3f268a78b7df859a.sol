['pragma solidity ^0.4.13;\n', '\n', 'contract CryptoPeopleName {\n', '    address owner;\n', '    mapping(address => string) private nameOfAddress;\n', '  \n', '    function CryptoPeopleName() public{\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function setName(string name) public {\n', '        nameOfAddress[msg.sender] = name;\n', '    }\n', '    \n', '    function getNameOfAddress(address _address) public view returns(string _name){\n', '        return nameOfAddress[_address];\n', '    }\n', '    \n', '}']
['pragma solidity ^0.4.13;\n', '\n', 'contract CryptoPeopleName {\n', '    address owner;\n', '    mapping(address => string) private nameOfAddress;\n', '  \n', '    function CryptoPeopleName() public{\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function setName(string name) public {\n', '        nameOfAddress[msg.sender] = name;\n', '    }\n', '    \n', '    function getNameOfAddress(address _address) public view returns(string _name){\n', '        return nameOfAddress[_address];\n', '    }\n', '    \n', '}']