['pragma solidity ^0.4.8;\n', '\n', 'contract SafeMath {\n', '\n', '    function assert(bool assertion) internal {\n', '        if (!assertion) {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x + y;\n', '        assert((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', '\n', '    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {\n', '        assert(x >= y);\n', '        uint256 z = x - y;\n', '        return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x * y;\n', '        assert((x == 0)||(z/x == y));\n', '        return z;\n', '    }\n', '\n', '}\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/*  ERC 20 token */\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '      if (balances[msg.sender] >= _value && _value > 0) {\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', '\n', '/*  ERC 20 token */\n', 'contract LeeroyPremiumToken is StandardToken, SafeMath {\n', '    address public owner;\n', '\n', '    string public constant name = "Leeroy Premium Token";\n', '    string public constant symbol = "LPT";\n', '    uint256 public constant decimals = 18;\n', '    string public version = "1.0";\n', '\n', '    bool public isFinalized;\n', '    uint256 public fundingStartBlock = 3965525;\n', '    uint256 public fundingEndBlock = 4115525;\n', '    uint256 public constant reservedLPT = 375 * (10**6) * 10**decimals;\n', '    uint256 public constant tokenExchangeRate = 32000;\n', '    uint256 public constant tokenCreationCap =  2000 * (10**6) * 10**decimals;\n', '    uint256 public constant tokenCreationMin =  775 * (10**6) * 10**decimals;\n', '\n', '    // events\n', '    event LogRefund(address indexed _to, uint256 _value);\n', '    event CreateLPT(address indexed _to, uint256 _value);\n', '\n', '    function LeeroyPremiumToken() {\n', '        owner = msg.sender;\n', '        totalSupply = reservedLPT;\n', '        balances[owner] = reservedLPT;\n', '        CreateLPT(owner, reservedLPT);\n', '    }\n', '\n', '    function () payable {\n', '        createTokens();\n', '    }\n', '\n', '    function createTokens() payable {\n', '      if (isFinalized) throw;\n', '      if (block.number < fundingStartBlock) throw;\n', '      if (block.number > fundingEndBlock) throw;\n', '      if (msg.value == 0) throw;\n', '\n', '      uint256 tokens = safeMult(msg.value, tokenExchangeRate);\n', '      uint256 checkedSupply = safeAdd(totalSupply, tokens);\n', '\n', '      if (tokenCreationCap < checkedSupply) throw;\n', '\n', '      totalSupply = checkedSupply;\n', '      balances[msg.sender] += tokens;\n', '      CreateLPT(msg.sender, tokens);\n', '    }\n', '\n', '    function finalize() external {\n', '      if (isFinalized) throw;\n', '      if(totalSupply < tokenCreationMin) throw;\n', '      if(block.number <= fundingEndBlock && totalSupply != tokenCreationCap) throw;\n', '      isFinalized = true;\n', '      if(!owner.send(this.balance)) throw;\n', '    }\n', '\n', '    function refund() external {\n', '      if(isFinalized) throw;\n', '      if (block.number <= fundingEndBlock) throw;\n', '      if(totalSupply >= tokenCreationMin) throw;\n', '      uint256 LPTVal = balances[msg.sender];\n', '      if (LPTVal == 0) throw;\n', '      balances[msg.sender] = 0;\n', '      totalSupply = safeSubtract(totalSupply, LPTVal);\n', '      uint256 ethVal = LPTVal / tokenExchangeRate;\n', '      LogRefund(msg.sender, ethVal);\n', '      if (!msg.sender.send(ethVal)) throw;\n', '    }\n', '}']
['pragma solidity ^0.4.8;\n', '\n', 'contract SafeMath {\n', '\n', '    function assert(bool assertion) internal {\n', '        if (!assertion) {\n', '            throw;\n', '        }\n', '    }\n', '\n', '    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x + y;\n', '        assert((z >= x) && (z >= y));\n', '        return z;\n', '    }\n', '\n', '    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {\n', '        assert(x >= y);\n', '        uint256 z = x - y;\n', '        return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '        uint256 z = x * y;\n', '        assert((x == 0)||(z/x == y));\n', '        return z;\n', '    }\n', '\n', '}\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/*  ERC 20 token */\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '      if (balances[msg.sender] >= _value && _value > 0) {\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', '\n', '/*  ERC 20 token */\n', 'contract LeeroyPremiumToken is StandardToken, SafeMath {\n', '    address public owner;\n', '\n', '    string public constant name = "Leeroy Premium Token";\n', '    string public constant symbol = "LPT";\n', '    uint256 public constant decimals = 18;\n', '    string public version = "1.0";\n', '\n', '    bool public isFinalized;\n', '    uint256 public fundingStartBlock = 3965525;\n', '    uint256 public fundingEndBlock = 4115525;\n', '    uint256 public constant reservedLPT = 375 * (10**6) * 10**decimals;\n', '    uint256 public constant tokenExchangeRate = 32000;\n', '    uint256 public constant tokenCreationCap =  2000 * (10**6) * 10**decimals;\n', '    uint256 public constant tokenCreationMin =  775 * (10**6) * 10**decimals;\n', '\n', '    // events\n', '    event LogRefund(address indexed _to, uint256 _value);\n', '    event CreateLPT(address indexed _to, uint256 _value);\n', '\n', '    function LeeroyPremiumToken() {\n', '        owner = msg.sender;\n', '        totalSupply = reservedLPT;\n', '        balances[owner] = reservedLPT;\n', '        CreateLPT(owner, reservedLPT);\n', '    }\n', '\n', '    function () payable {\n', '        createTokens();\n', '    }\n', '\n', '    function createTokens() payable {\n', '      if (isFinalized) throw;\n', '      if (block.number < fundingStartBlock) throw;\n', '      if (block.number > fundingEndBlock) throw;\n', '      if (msg.value == 0) throw;\n', '\n', '      uint256 tokens = safeMult(msg.value, tokenExchangeRate);\n', '      uint256 checkedSupply = safeAdd(totalSupply, tokens);\n', '\n', '      if (tokenCreationCap < checkedSupply) throw;\n', '\n', '      totalSupply = checkedSupply;\n', '      balances[msg.sender] += tokens;\n', '      CreateLPT(msg.sender, tokens);\n', '    }\n', '\n', '    function finalize() external {\n', '      if (isFinalized) throw;\n', '      if(totalSupply < tokenCreationMin) throw;\n', '      if(block.number <= fundingEndBlock && totalSupply != tokenCreationCap) throw;\n', '      isFinalized = true;\n', '      if(!owner.send(this.balance)) throw;\n', '    }\n', '\n', '    function refund() external {\n', '      if(isFinalized) throw;\n', '      if (block.number <= fundingEndBlock) throw;\n', '      if(totalSupply >= tokenCreationMin) throw;\n', '      uint256 LPTVal = balances[msg.sender];\n', '      if (LPTVal == 0) throw;\n', '      balances[msg.sender] = 0;\n', '      totalSupply = safeSubtract(totalSupply, LPTVal);\n', '      uint256 ethVal = LPTVal / tokenExchangeRate;\n', '      LogRefund(msg.sender, ethVal);\n', '      if (!msg.sender.send(ethVal)) throw;\n', '    }\n', '}']