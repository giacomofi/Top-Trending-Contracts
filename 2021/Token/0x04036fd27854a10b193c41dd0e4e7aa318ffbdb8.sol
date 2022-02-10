['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-03\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-03\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-03\n', '*/\n', '\n', 'pragma solidity ^0.6.7;\n', '\n', '   // Telegram: https://t.me/YfUSDC\n', '   // Website : https://YfUSDC.com\n', '   \n', 'contract Owned {\n', '    address payable  internal owner = msg.sender;\n', '    \n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender==owner);\n', '        _;\n', '    }\n', '    address payable newOwner;\n', '    function changeOwner(address payable _newOwner) public onlyOwner {\n', '        require(_newOwner!=address(0));\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        if (msg.sender==newOwner) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '   \n', '}\n', '\n', 'abstract contract ERC20 {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) view public virtual returns (uint256 );\n', '    function transfer(address _to, uint256 _value) public virtual returns (bool );\n', '    function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool );\n', '    function approve(address _spender, uint256 _value) public virtual returns (bool );\n', '    function allowance(address _owner, address _spender) view public virtual returns (uint256 );\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract Token is Owned,  ERC20 {\n', '\n', '    mapping (address=>uint256) balances;\n', '    mapping (address=>mapping (address=>uint256)) allowed;\n', '    \n', '\n', '    function balanceOf(address _owner) view public virtual override returns (uint256 balance) {return balances[_owner];}\n', '    \n', '    function transfer(address _to, uint256 _amount) public virtual override returns (bool success) {\n', '        require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);\n', '        balances[msg.sender]-=_amount;\n', '        balances[_to]+=_amount;\n', '        emit Transfer(msg.sender,_to,_amount);\n', '        return true;\n', '    }\n', '  \n', '    function transferFrom(address _from,address _to,uint256 _amount) public virtual override returns (bool success) {\n', '        require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);\n', '        balances[_from]-=_amount;\n', '        allowed[_from][msg.sender]-=_amount;\n', '        balances[_to]+=_amount;\n', '        emit Transfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '  \n', '    function approve(address _spender, uint256 _amount) public virtual override returns (bool success) {\n', '        allowed[msg.sender][_spender]=_amount;\n', '        emit Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) view public virtual override returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '}\n', '\n', 'contract YfUSDC is Token{\n', '        \n', '        string public symbol = "UDC";\n', '        string public name = "YfUSDC";\n', '        uint8 public decimals = 18;\n', '        \n', ' \n', '      \n', '    constructor() public{\n', '        totalSupply = 51000000000000000000000;  \n', '        owner = msg.sender;\n', '        balances[owner] = totalSupply;\n', '        emit Transfer(address(0),owner, totalSupply);\n', '    }\n', '\n', '\n', '    receive () payable external {\n', '        require(msg.value>0);\n', '        owner.transfer(msg.value);\n', '    }\n', '}']