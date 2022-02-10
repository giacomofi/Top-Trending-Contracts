['pragma solidity ^0.4.11;\n', '\n', '/* taking ideas from FirstBlood token */\n', 'contract SafeMath {\n', '\n', 'function safeAdd(uint256 x, uint256 y) internal returns(uint256) {\n', 'uint256 z = x + y;\n', '      assert((z >= x) && (z >= y));\n', '      return z;\n', '    }\n', '\n', '    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {\n', '      assert(x >= y);\n', '      uint256 z = x - y;\n', '      return z;\n', '    }\n', '\n', '    function safeMult(uint256 x, uint256 y) internal returns(uint256) {\n', '      uint256 z = x * y;\n', '      assert((x == 0)||(z/x == y));\n', '      return z;\n', '    }\n', '\n', '}\n', '\n', 'contract Token {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '\n', '/*  ERC 20 token */\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', '      if (balances[msg.sender] >= _value && _value > 0) {\n', '        balances[msg.sender] -= _value;\n', '        balances[_to] += _value;\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '        balances[_to] += _value;\n', '        balances[_from] -= _value;\n', '        allowed[_from][msg.sender] -= _value;\n', '        Transfer(_from, _to, _value);\n', '        return true;\n', '      } else {\n', '        return false;\n', '      }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', '\n', 'contract LockChain is StandardToken, SafeMath {\n', '\n', '    // metadata\n', '    string public constant name = "LockChain";\n', '    string public constant symbol = "LOK";\n', '    uint256 public constant decimals = 18;\n', '    string public version = "1.0";\n', '\n', '    // contracts\n', '    address public LockChainFundDeposit;      // deposit address for depositing tokens for owners\n', '    address public account1Address;      // deposit address for depositing tokens for owners\n', '    address public account2Address;\n', '    address public creatorAddress;\n', '\n', '    // crowdsale parameters\n', '    bool public isFinalized;              // switched to true in operational state\n', '    bool public isPreSale;\n', '    bool public isPrePreSale;\n', '    bool public isMainSale;\n', '    uint public preSalePeriod;\n', '    uint public prePreSalePeriod;\n', '    uint256 public tokenExchangeRate = 0; //  LockChain tokens per 1 ETH\n', '    uint256 public constant tokenSaleCap =  155 * (10**6) * 10**decimals;\n', '    uint256 public constant tokenPreSaleCap =  50 * (10**6) * 10**decimals;\n', '\n', '\n', '    // events\n', '    event CreateLOK(address indexed _to, uint256 _value);\n', '\n', '    // constructor\n', '    function LockChain()\n', '    {\n', '      isFinalized = false;                   //controls pre through crowdsale state\n', '      LockChainFundDeposit = &#39;0x013aF31dc76255d3b33d2185A7148300882EbC7a&#39;;\n', '      account1Address = &#39;0xe0F2653e7928e6CB7c6D3206163b3E466a29c7C3&#39;;\n', '      account2Address = &#39;0x25BC70bFda877e1534151cB92D97AC5E69e1F53D&#39;;\n', '      creatorAddress = &#39;0x953ebf6C38C58C934D58b9b17d8f9D0F121218BB&#39;;\n', '      isPrePreSale = false;\n', '      isPreSale = false;\n', '      isMainSale = false;\n', '      totalSupply = 0;\n', '    }\n', '\n', '    /// @dev Accepts ether and creates new LOK tokens.\n', '    function () payable {\n', '      if (isFinalized) throw;\n', '      if (!isPrePreSale && !isPreSale && !isMainSale) throw;\n', '      //if (!saleStarted) throw;\n', '      if (msg.value == 0) throw;\n', '      //create tokens\n', '      uint256 tokens = safeMult(msg.value, tokenExchangeRate); // check that we&#39;re not over totals\n', '      uint256 checkedSupply = safeAdd(totalSupply, tokens);\n', '\n', '      if(!isMainSale){\n', '        if (tokenPreSaleCap < checkedSupply) throw;\n', '      }\n', '\n', '      // return money if something goes wrong\n', '      if (tokenSaleCap < checkedSupply) throw;  // odd fractions won&#39;t be found\n', '      totalSupply = checkedSupply;\n', '      //All good. start the transfer\n', '      balances[msg.sender] += tokens;  // safeAdd not needed\n', '      CreateLOK(msg.sender, tokens);  // logs token creation\n', '    }\n', '\n', '    /// LockChain Ends the funding period and sends the ETH home\n', '    function finalize() external {\n', '      if (isFinalized) throw;\n', '      if (msg.sender != LockChainFundDeposit) throw; // locks finalize to the ultimate ETH owner\n', '        uint256 newTokens = totalSupply;\n', '        uint256 account1Tokens;\n', '        uint256 account2Tokens;\n', '        uint256 creatorTokens = 10000 * 10**decimals;\n', '        uint256 LOKFundTokens;\n', '        uint256 checkedSupply = safeAdd(totalSupply, newTokens);\n', '        totalSupply = checkedSupply;\n', '        if (newTokens % 2 == 0){\n', '          LOKFundTokens = newTokens/2;\n', '          account2Tokens = newTokens/2;\n', '          account1Tokens = LOKFundTokens - creatorTokens;\n', '          balances[account1Address] += account1Tokens;\n', '          balances[account2Address] += account2Tokens;\n', '        }\n', '        else{\n', '          uint256 makeEven = newTokens - 1;\n', '          uint256 halfTokens = makeEven/2;\n', '          LOKFundTokens = halfTokens;\n', '          account2Tokens = halfTokens + 1;\n', '          account1Tokens = LOKFundTokens - creatorTokens;\n', '          balances[account1Address] += account1Tokens;\n', '          balances[account2Address] += account2Tokens;\n', '        }\n', '        balances[creatorAddress] += creatorTokens;\n', '        CreateLOK(creatorAddress, creatorTokens);\n', '        CreateLOK(account1Address, account1Tokens);\n', '        CreateLOK(account2Address, account2Tokens);\n', '      // move to operational\n', '      if(!LockChainFundDeposit.send(this.balance)) throw;\n', '      isFinalized = true;  // send the eth to LockChain\n', '    }\n', '    function switchSaleStage() external {\n', '      if (msg.sender != LockChainFundDeposit) throw; // locks finalize to the ultimate ETH owner\n', '      if(isMainSale) throw;\n', '      if(!isPrePreSale){\n', '        isPrePreSale = true;\n', '        tokenExchangeRate = 1150;\n', '      }\n', '      else if (!isPreSale){\n', '        isPreSale = true;\n', '        tokenExchangeRate = 1000;\n', '      }\n', '      else if (!isMainSale){\n', '        isMainSale = true;\n', '        if (totalSupply < 10 * (10**6) * 10**decimals)\n', '        {\n', '          tokenExchangeRate = 750;\n', '        }\n', '        else if (totalSupply >= 10 * (10**6) * 10**decimals && totalSupply < 20 * (10**6) * 10**decimals)\n', '        {\n', '          tokenExchangeRate = 700;\n', '        }\n', '        else if (totalSupply >= 20 * (10**6) * 10**decimals && totalSupply < 30 * (10**6) * 10**decimals)\n', '        {\n', '          tokenExchangeRate = 650;\n', '        }\n', '        else if (totalSupply >= 30 * (10**6) * 10**decimals && totalSupply < 40 * (10**6) * 10**decimals)\n', '        {\n', '          tokenExchangeRate = 620;\n', '        }\n', '        else if (totalSupply >= 40 * (10**6) * 10**decimals && totalSupply <= 50 * (10**6) * 10**decimals)\n', '        {\n', '          tokenExchangeRate = 600;\n', '        }\n', '\n', '      }\n', '    }\n', '\n', '\n', '}']