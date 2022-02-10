['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-30\n', '*/\n', '\n', '// File: contracts/ExchangeRegistry.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.8.0;\n', '\n', 'contract ExchangeRegistry {\n', '    address owner;\n', '    // frm asset -> to assets -> contract address\n', '    mapping(address => mapping(address => address)) pairs;\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner, "Only owner allowed");\n', '        _;\n', '    }\n', '\n', '    constructor() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function getPair(address _from, address _to) public view returns (address) {\n', '        return pairs[_from][_to];\n', '    }\n', '\n', '    function setOwner(address _owner) external onlyOwner {\n', '        owner = _owner;\n', '    }\n', '\n', '    function addOrChangePair(\n', '        address _from,\n', '        address _to,\n', '        address _contract\n', '    ) external onlyOwner {\n', '        require(_contract != address(0), "contract address should not be zero");\n', '        pairs[_from][_to] = _contract;\n', '    }\n', '\n', '    function addOrChangePairBulk(\n', '        address[] memory _fromList,\n', '        address[] memory _toList,\n', '        address[] memory _contractList\n', '    ) external onlyOwner {\n', '        for (uint256 i = 0; i < _contractList.length; i++) {\n', '            require(\n', '                _contractList[i] != address(0),\n', '                "contract address should not be zero"\n', '            );\n', '            pairs[_fromList[i]][_toList[i]] = _contractList[i];\n', '        }\n', '    }\n', '\n', '    function removePair(address _from, address _to) external onlyOwner {\n', '        delete pairs[_from][_to];\n', '    }\n', '}']