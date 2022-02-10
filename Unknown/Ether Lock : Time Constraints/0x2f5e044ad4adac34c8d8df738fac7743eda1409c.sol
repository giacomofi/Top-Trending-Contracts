['pragma solidity ^0.4.8;\n', '\n', 'contract ERC20Interface {\n', '  function totalSupply() constant returns (uint256 totalSupply);\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '  function approve(address _spender, uint256 _value) returns (bool success);\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract AgoraToken is ERC20Interface {\n', '\n', '  string public constant name = "Agora";\n', '  string public constant symbol = "AGO";\n', '  uint8  public constant decimals = 18;\n', '\n', '  uint256 constant minimumToRaise = 500 ether;\n', '  uint256 constant icoStartBlock = 4116800;\n', '  uint256 constant icoPremiumEndBlock = icoStartBlock + 78776; // Two weeks\n', '  uint256 constant icoEndBlock = icoStartBlock + 315106; // Two months\n', '\n', '  address owner;\n', '  uint256 raised = 0;\n', '  uint256 created = 0;\n', '\n', '  struct BalanceSnapshot {\n', '    bool initialized;\n', '    uint256 value;\n', '  }\n', '\n', '  mapping(address => uint256) shares;\n', '  mapping(address => uint256) balances;\n', '  mapping(address => mapping (address => uint256)) allowed;\n', '  mapping(uint256 => mapping (address => BalanceSnapshot)) balancesAtBlock;\n', '\n', '  function AgoraToken() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  // ==========================\n', '  // ERC20 Logic Implementation\n', '  // ==========================\n', '\n', '  // Returns the balance of an address.\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  // Make a transfer of AGO between two addresses.\n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', '    // Freeze for dev team\n', '    require(msg.sender != owner && _to != owner);\n', '\n', '    if (balances[msg.sender] >= _value &&\n', '        _value > 0 &&\n', '        balances[_to] + _value > balances[_to]) {\n', '      // We need to register the balance known for the last reference block.\n', '      // That way, we can be sure that when the Claimer wants to check the balance\n', '      // the system can be protected against double-spending AGO tokens claiming.\n', '      uint256 referenceBlockNumber = latestReferenceBlockNumber();\n', '      registerBalanceForReference(msg.sender, referenceBlockNumber);\n', '      registerBalanceForReference(_to, referenceBlockNumber);\n', '\n', '      // Standard transfer stuff\n', '      balances[msg.sender] -= _value;\n', '      balances[_to] += _value;\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '    // Freeze for dev team\n', '    require(_to != owner);\n', '\n', '    if(balances[_from] >= _value &&\n', '       _value > 0 &&\n', '       allowed[_from][msg.sender] >= _value &&\n', '       balances[_to] + _value > balances[_to]) {\n', '      // Same as `transfer` :\n', '      // We need to register the balance known for the last reference block.\n', '      // That way, we can be sure that when the Claimer wants to check the balance\n', '      // the system can be protected against double-spending AGO tokens claiming.\n', '      uint256 referenceBlockNumber = latestReferenceBlockNumber();\n', '      registerBalanceForReference(_from, referenceBlockNumber);\n', '      registerBalanceForReference(_to, referenceBlockNumber);\n', '\n', '      // Standard transferFrom stuff\n', '      balances[_from] -= _value;\n', '      balances[_to] += _value;\n', '      allowed[_from][msg.sender] -= _value;\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  // Approve a payment from msg.sender account to another one.\n', '  function approve(address _spender, uint256 _value) returns (bool success) {\n', '    // Freeze for dev team\n', '    require(msg.sender != owner);\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  // Checks the allowance of an account against another one. (Works with approval).\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  // Returns the total supply of token issued.\n', '  function totalSupply() constant returns (uint256 totalSupply) { return created; }\n', '\n', '  // ========================\n', '  // ICO Logic Implementation\n', '  // ========================\n', '\n', '  // ICO Status overview. Used for Agora landing page\n', '  function icoOverview() constant returns(\n', '    uint256 currentlyRaised,\n', '    uint256 tokensCreated,\n', '    uint256 developersTokens\n', '  ){\n', '    currentlyRaised = raised;\n', '    tokensCreated = created;\n', '    developersTokens = balances[owner];\n', '  }\n', '\n', '  // Get Agora tokens with a Ether payment.\n', '  function buy() payable {\n', '    require(block.number > icoStartBlock && block.number < icoEndBlock && msg.sender != owner);\n', '\n', '    uint256 tokenAmount = msg.value * ((block.number < icoPremiumEndBlock) ? 550 : 500);\n', '\n', '    shares[msg.sender] += msg.value;\n', '    balances[msg.sender] += tokenAmount;\n', '    balances[owner] += tokenAmount / 6;\n', '\n', '    raised += msg.value;\n', '    created += tokenAmount;\n', '  }\n', '\n', '  // Method use by the creators. Requires the ICO to be a success.\n', '  // Used to retrieve the Ethers raised from the ICO.\n', '  // That way, Agora is becoming possible :).\n', '  function withdraw(uint256 amount) {\n', '    require(block.number > icoEndBlock && raised >= minimumToRaise && msg.sender == owner);\n', '    owner.transfer(amount);\n', '  }\n', '\n', '  // Methods use by the ICO investors. Requires the ICO to be a fail.\n', '  function refill() {\n', '    require(block.number > icoEndBlock && raised < minimumToRaise);\n', '    uint256 share = shares[msg.sender];\n', '    shares[msg.sender] = 0;\n', '    msg.sender.transfer(share);\n', '  }\n', '\n', '  // ============================\n', '  // Claimer Logic Implementation\n', '  // ============================\n', '  // This part is used by the claimer.\n', '  // The claimer can ask the balance of an user at a reference block.\n', '  // That way, the claimer is protected against double-spending AGO claimings.\n', '\n', '  // This method is triggered by `transfer` and `transferFrom`.\n', '  // It saves the balance known at a reference block only if there is no balance\n', '  // saved for this block yet.\n', '  // Meaning that this is a the first transaction since the last reference block,\n', '  // so this balance can be uses as the reference.\n', '  function registerBalanceForReference(address _owner, uint256 referenceBlockNumber) private {\n', '    if (balancesAtBlock[referenceBlockNumber][_owner].initialized) { return; }\n', '    balancesAtBlock[referenceBlockNumber][_owner].initialized = true;\n', '    balancesAtBlock[referenceBlockNumber][_owner].value = balances[_owner];\n', '  }\n', '\n', '  // What is the latest reference block number ?\n', '  function latestReferenceBlockNumber() constant returns (uint256 blockNumber) {\n', '    return (block.number - block.number % 157553);\n', '  }\n', '\n', '  // What is the balance of an user at a block ?\n', '  // If the user have made (or received) a transfer of AGO token since the\n', '  // last reference block, its balance will be written in the `balancesAtBlock`\n', '  // mapping. So we can retrieve it from here.\n', '  // Otherwise, if the user havn&#39;t made a transaction since the last reference\n', '  // block, the balance of AGO token is still good.\n', '  function balanceAtBlock(address _owner, uint256 blockNumber) constant returns (uint256 balance) {\n', '    if(balancesAtBlock[blockNumber][_owner].initialized) {\n', '      return balancesAtBlock[blockNumber][_owner].value;\n', '    }\n', '    return balances[_owner];\n', '  }\n', '}']
['pragma solidity ^0.4.8;\n', '\n', 'contract ERC20Interface {\n', '  function totalSupply() constant returns (uint256 totalSupply);\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '  function approve(address _spender, uint256 _value) returns (bool success);\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract AgoraToken is ERC20Interface {\n', '\n', '  string public constant name = "Agora";\n', '  string public constant symbol = "AGO";\n', '  uint8  public constant decimals = 18;\n', '\n', '  uint256 constant minimumToRaise = 500 ether;\n', '  uint256 constant icoStartBlock = 4116800;\n', '  uint256 constant icoPremiumEndBlock = icoStartBlock + 78776; // Two weeks\n', '  uint256 constant icoEndBlock = icoStartBlock + 315106; // Two months\n', '\n', '  address owner;\n', '  uint256 raised = 0;\n', '  uint256 created = 0;\n', '\n', '  struct BalanceSnapshot {\n', '    bool initialized;\n', '    uint256 value;\n', '  }\n', '\n', '  mapping(address => uint256) shares;\n', '  mapping(address => uint256) balances;\n', '  mapping(address => mapping (address => uint256)) allowed;\n', '  mapping(uint256 => mapping (address => BalanceSnapshot)) balancesAtBlock;\n', '\n', '  function AgoraToken() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  // ==========================\n', '  // ERC20 Logic Implementation\n', '  // ==========================\n', '\n', '  // Returns the balance of an address.\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  // Make a transfer of AGO between two addresses.\n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', '    // Freeze for dev team\n', '    require(msg.sender != owner && _to != owner);\n', '\n', '    if (balances[msg.sender] >= _value &&\n', '        _value > 0 &&\n', '        balances[_to] + _value > balances[_to]) {\n', '      // We need to register the balance known for the last reference block.\n', '      // That way, we can be sure that when the Claimer wants to check the balance\n', '      // the system can be protected against double-spending AGO tokens claiming.\n', '      uint256 referenceBlockNumber = latestReferenceBlockNumber();\n', '      registerBalanceForReference(msg.sender, referenceBlockNumber);\n', '      registerBalanceForReference(_to, referenceBlockNumber);\n', '\n', '      // Standard transfer stuff\n', '      balances[msg.sender] -= _value;\n', '      balances[_to] += _value;\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '    // Freeze for dev team\n', '    require(_to != owner);\n', '\n', '    if(balances[_from] >= _value &&\n', '       _value > 0 &&\n', '       allowed[_from][msg.sender] >= _value &&\n', '       balances[_to] + _value > balances[_to]) {\n', '      // Same as `transfer` :\n', '      // We need to register the balance known for the last reference block.\n', '      // That way, we can be sure that when the Claimer wants to check the balance\n', '      // the system can be protected against double-spending AGO tokens claiming.\n', '      uint256 referenceBlockNumber = latestReferenceBlockNumber();\n', '      registerBalanceForReference(_from, referenceBlockNumber);\n', '      registerBalanceForReference(_to, referenceBlockNumber);\n', '\n', '      // Standard transferFrom stuff\n', '      balances[_from] -= _value;\n', '      balances[_to] += _value;\n', '      allowed[_from][msg.sender] -= _value;\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  // Approve a payment from msg.sender account to another one.\n', '  function approve(address _spender, uint256 _value) returns (bool success) {\n', '    // Freeze for dev team\n', '    require(msg.sender != owner);\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  // Checks the allowance of an account against another one. (Works with approval).\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  // Returns the total supply of token issued.\n', '  function totalSupply() constant returns (uint256 totalSupply) { return created; }\n', '\n', '  // ========================\n', '  // ICO Logic Implementation\n', '  // ========================\n', '\n', '  // ICO Status overview. Used for Agora landing page\n', '  function icoOverview() constant returns(\n', '    uint256 currentlyRaised,\n', '    uint256 tokensCreated,\n', '    uint256 developersTokens\n', '  ){\n', '    currentlyRaised = raised;\n', '    tokensCreated = created;\n', '    developersTokens = balances[owner];\n', '  }\n', '\n', '  // Get Agora tokens with a Ether payment.\n', '  function buy() payable {\n', '    require(block.number > icoStartBlock && block.number < icoEndBlock && msg.sender != owner);\n', '\n', '    uint256 tokenAmount = msg.value * ((block.number < icoPremiumEndBlock) ? 550 : 500);\n', '\n', '    shares[msg.sender] += msg.value;\n', '    balances[msg.sender] += tokenAmount;\n', '    balances[owner] += tokenAmount / 6;\n', '\n', '    raised += msg.value;\n', '    created += tokenAmount;\n', '  }\n', '\n', '  // Method use by the creators. Requires the ICO to be a success.\n', '  // Used to retrieve the Ethers raised from the ICO.\n', '  // That way, Agora is becoming possible :).\n', '  function withdraw(uint256 amount) {\n', '    require(block.number > icoEndBlock && raised >= minimumToRaise && msg.sender == owner);\n', '    owner.transfer(amount);\n', '  }\n', '\n', '  // Methods use by the ICO investors. Requires the ICO to be a fail.\n', '  function refill() {\n', '    require(block.number > icoEndBlock && raised < minimumToRaise);\n', '    uint256 share = shares[msg.sender];\n', '    shares[msg.sender] = 0;\n', '    msg.sender.transfer(share);\n', '  }\n', '\n', '  // ============================\n', '  // Claimer Logic Implementation\n', '  // ============================\n', '  // This part is used by the claimer.\n', '  // The claimer can ask the balance of an user at a reference block.\n', '  // That way, the claimer is protected against double-spending AGO claimings.\n', '\n', '  // This method is triggered by `transfer` and `transferFrom`.\n', '  // It saves the balance known at a reference block only if there is no balance\n', '  // saved for this block yet.\n', '  // Meaning that this is a the first transaction since the last reference block,\n', '  // so this balance can be uses as the reference.\n', '  function registerBalanceForReference(address _owner, uint256 referenceBlockNumber) private {\n', '    if (balancesAtBlock[referenceBlockNumber][_owner].initialized) { return; }\n', '    balancesAtBlock[referenceBlockNumber][_owner].initialized = true;\n', '    balancesAtBlock[referenceBlockNumber][_owner].value = balances[_owner];\n', '  }\n', '\n', '  // What is the latest reference block number ?\n', '  function latestReferenceBlockNumber() constant returns (uint256 blockNumber) {\n', '    return (block.number - block.number % 157553);\n', '  }\n', '\n', '  // What is the balance of an user at a block ?\n', '  // If the user have made (or received) a transfer of AGO token since the\n', '  // last reference block, its balance will be written in the `balancesAtBlock`\n', '  // mapping. So we can retrieve it from here.\n', "  // Otherwise, if the user havn't made a transaction since the last reference\n", '  // block, the balance of AGO token is still good.\n', '  function balanceAtBlock(address _owner, uint256 blockNumber) constant returns (uint256 balance) {\n', '    if(balancesAtBlock[blockNumber][_owner].initialized) {\n', '      return balancesAtBlock[blockNumber][_owner].value;\n', '    }\n', '    return balances[_owner];\n', '  }\n', '}']
