['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-06\n', '*/\n', '\n', '//SPDX-License-Identifier: Unlicense\n', '\n', '// ----------------------------------------------------------------------------\n', "// 'EthereumUnicorn' token contract\n", '//\n', '// Symbol      : ETHU 🦄\n', '// Name        : Ethereum Unicorn\n', '// Total supply: 100000000000000\n', '// Decimals    : 18\n', '//\n', '// TOTAL SUPPLY 1,000,000,000,000,000\n', '// 50% Burned\n', '// ----------------------------------------------------------------------------\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', 'contract Owned {\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    address owner;\n', '    address newOwner;\n', '    function changeOwner(address payable _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        if (msg.sender == newOwner) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    mapping (address=>uint256) balances;\n', '    mapping (address=>mapping (address=>uint256)) allowed;\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    \n', '    function balanceOf(address _owner) view public returns (uint256 balance) {return balances[_owner];}\n', '    \n', '    function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '        require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);\n', '        balances[msg.sender]-=_amount;\n', '        balances[_to]+=_amount;\n', '        emit Transfer(msg.sender,_to,_amount);\n', '        return true;\n', '    }\n', '    function transferFrom(address _from,address _to,uint256 _amount) public returns (bool success) {\n', '        require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);\n', '        balances[_from]-=_amount;\n', '        allowed[_from][msg.sender]-=_amount;\n', '        balances[_to]+=_amount;\n', '        emit Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '    function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '        allowed[msg.sender][_spender]=_amount;\n', '        emit Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '    function allowance(address _owner, address _spender) view public returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract EthereumUnicorn is Owned,ERC20{\n', '    uint256 public maxSupply;\n', '\n', '    constructor(address _owner) {\n', '        symbol = unicode"ETHU 🦄";\n', '        name = "Ethereum Unicorn";\n', '        decimals = 18;\n', '        totalSupply = 1000000000000000*10**uint256(decimals);\n', '        maxSupply = 1000000000000000*10**uint256(decimals);\n', '        owner = _owner;\n', '        balances[owner] = totalSupply;\n', '    }\n', '    \n', '    receive() external payable {\n', '        revert();\n', '    }\n', '}']