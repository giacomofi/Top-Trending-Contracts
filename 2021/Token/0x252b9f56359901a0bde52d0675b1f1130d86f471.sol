['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-16\n', '*/\n', '\n', '/**\n', ' * PANDO token \n', ' * \n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.5.9;\n', '\n', 'library SafeMath\n', '{\n', '  \tfunction mul(uint256 a, uint256 b) internal pure returns (uint256)\n', '    \t{\n', '\t\tuint256 c = a * b;\n', '\t\tassert(a == 0 || c / a == b);\n', '\n', '\t\treturn c;\n', '  \t}\n', '\n', '  \tfunction div(uint256 a, uint256 b) internal pure returns (uint256)\n', '\t{\n', '\t\tuint256 c = a / b;\n', '\n', '\t\treturn c;\n', '  \t}\n', '\n', '  \tfunction sub(uint256 a, uint256 b) internal pure returns (uint256)\n', '\t{\n', '\t\tassert(b <= a);\n', '\n', '\t\treturn a - b;\n', '  \t}\n', '\n', '  \tfunction add(uint256 a, uint256 b) internal pure returns (uint256)\n', '\t{\n', '\t\tuint256 c = a + b;\n', '\t\tassert(c >= a);\n', '\n', '\t\treturn c;\n', '  \t}\n', '}\n', '\n', 'contract OwnerHelper\n', '{\n', '  \taddress public owner;\n', '\n', '  \tevent ChangeOwner(address indexed _from, address indexed _to);\n', '\n', '  \tmodifier onlyOwner\n', '\t{\n', '\t\trequire(msg.sender == owner);\n', '\t\t_;\n', '  \t}\n', '  \t\n', '  \tconstructor() public\n', '\t{\n', '\t\towner = msg.sender;\n', '  \t}\n', '  \t\n', '  \tfunction transferOwnership(address _to) onlyOwner public\n', '  \t{\n', '    \trequire(_to != owner);\n', '    \trequire(_to != address(0x0));\n', '\n', '        address from = owner;\n', '      \towner = _to;\n', '  \t    \n', '      \temit ChangeOwner(from, _to);\n', '  \t}\n', '}\n', '\n', '\n', 'contract ERC20Interface\n', '{\n', '    event Transfer( address indexed _from, address indexed _to, uint _value);\n', '    event Approval( address indexed _owner, address indexed _spender, uint _value);\n', '    \n', '    function totalSupply() view public returns (uint _supply);\n', '    function balanceOf( address _who ) public view returns (uint _value);\n', '    function transfer( address _to, uint _value) public returns (bool _success);\n', '    function approve( address _spender, uint _value ) public returns (bool _success);\n', '    function allowance( address _owner, address _spender ) public view returns (uint _allowance);\n', '    function transferFrom( address _from, address _to, uint _value) public returns (bool _success);\n', '}\n', '\n', 'contract PandoToken is ERC20Interface, OwnerHelper\n', '{\n', '    using SafeMath for uint;\n', '    \n', '    string public name;\n', '    uint public decimals;\n', '    string public symbol;\n', '\n', '    // Founder\n', '    address private founder;\n', '    \n', '    // Total\n', '    uint public totalTokenSupply;\n', '    uint public burnTokenSupply;\n', '\n', '    mapping (address => uint) public balances;\n', '    mapping (address => mapping ( address => uint )) public approvals;\n', '    mapping (address => bool) private blackAddress; // unLock : false, Lock : true\n', '    \n', '    bool public tokenLock = false;\n', '\n', '    // Token Total\n', '    uint constant private E18 = 1000000000000000000;\n', '\n', '    event Burn(address indexed _from, uint _tokens);\n', '    event TokenUnlock(address indexed _to, uint _tokens);\n', '\n', '    constructor(string memory _name, string memory _symbol, address _founder, uint _totalTokenSupply) public {\n', '        name        = _name;\n', '        decimals    = 18;\n', '        symbol      = _symbol;\n', '\n', '        founder = _founder;\n', '        totalTokenSupply  = _totalTokenSupply * E18;\n', '        burnTokenSupply     = 0;\n', '\n', '        balances[founder] = totalTokenSupply;\n', '        emit Transfer(address(0), founder, totalTokenSupply);\n', '    }\n', '\n', '    // ERC - 20 Interface -----\n', '    modifier notLocked {\n', '        require(isTransferable() == true);\n', '        _;\n', '    }\n', '\n', '    function lock(address who) onlyOwner public {\n', '        \n', '        blackAddress[who] = true;\n', '    }\n', '    \n', '    function unlock(address who) onlyOwner public {\n', '        \n', '        blackAddress[who] = false;\n', '    }\n', '    \n', '    function isLocked(address who) public view returns(bool) {\n', '        \n', '        return blackAddress[who];\n', '    }\n', '\n', '    function totalSupply() view public returns (uint) \n', '    {\n', '        return totalTokenSupply;\n', '    }\n', '    \n', '    function balanceOf(address _who) view public returns (uint) \n', '    {\n', '        return balances[_who];\n', '    }\n', '    \n', '    function transfer(address _to, uint _value) notLocked public returns (bool) \n', '    {\n', '        require(balances[msg.sender] >= _value);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        \n', '        emit Transfer(msg.sender, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    function approve(address _spender, uint _value) notLocked public returns (bool)\n', '    {\n', '        require(balances[msg.sender] >= _value);\n', '        \n', '        approvals[msg.sender][_spender] = _value;\n', '        \n', '        emit Approval(msg.sender, _spender, _value);\n', '        \n', '        return true; \n', '    }\n', '    \n', '    function allowance(address _owner, address _spender) view public returns (uint) \n', '    {\n', '        return approvals[_owner][_spender];\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint _value) notLocked public returns (bool) \n', '    {\n', '        require(balances[_from] >= _value);\n', '        require(approvals[_from][msg.sender] >= _value);\n', '        \n', '        approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to]  = balances[_to].add(_value);\n', '        \n', '        emit Transfer(_from, _to, _value);\n', '        \n', '        return true;\n', '    }\n', '    \n', '    // Lock Function -----\n', '    \n', '    function isTransferable() private view returns (bool)\n', '    {\n', '        if(tokenLock == false) {\n', '\n', '            if (blackAddress[msg.sender]) // true is Locked\n', '            {\n', '                return false;\n', '            } else {\n', '                return true;\n', '            }\n', '        }\n', '        else if(msg.sender == owner)\n', '        {\n', '            return true;\n', '        }\n', '        \n', '        return false;\n', '    }\n', '    \n', '    function setTokenUnlock() onlyOwner public\n', '    {\n', '        require(tokenLock == true);\n', '        \n', '        tokenLock = false;\n', '    }\n', '    \n', '    function setTokenLock() onlyOwner public\n', '    {\n', '        require(tokenLock == false);\n', '        \n', '        tokenLock = true;\n', '    }\n', '\n', '    function withdrawTokens(address _contract, uint _value) onlyOwner public\n', '    {\n', '\n', '        if(_contract == address(0x0))\n', '        {\n', '            uint eth = _value.mul(10 ** decimals);\n', '            msg.sender.transfer(eth);\n', '        }\n', '        else\n', '        {\n', '            uint tokens = _value.mul(10 ** decimals);\n', '            ERC20Interface(_contract).transfer(msg.sender, tokens);\n', '            \n', '            emit Transfer(address(0x0), msg.sender, tokens);\n', '        }\n', '    }\n', '\n', '    function burnToken(uint _value) onlyOwner public\n', '    {\n', '        uint tokens = _value.mul(10 ** decimals);\n', '        \n', '        require(balances[msg.sender] >= tokens);\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        \n', '        burnTokenSupply = burnTokenSupply.add(tokens);\n', '        totalTokenSupply = totalTokenSupply.sub(tokens);\n', '        \n', '        emit Burn(msg.sender, tokens);\n', '    }    \n', '    \n', '    function close() onlyOwner public\n', '    {\n', '        selfdestruct(msg.sender);\n', '    }\n', '    \n', '}']