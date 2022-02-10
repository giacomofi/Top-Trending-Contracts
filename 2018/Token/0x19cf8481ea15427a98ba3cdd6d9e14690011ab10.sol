['//DAO Polska Token deployment\n', 'pragma solidity ^0.4.11;\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', '\n', '// title Migration Agent interface\n', 'contract MigrationAgent {\n', '    function migrateFrom(address _from, uint256 _value);\n', '}\n', '\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', ' *\n', ' * Based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '  /* Token supply got increased and a new owner received these tokens */\n', '  event Minted(address receiver, uint amount);\n', '\n', '  /* Actual balances of token holders */\n', '  mapping(address => uint) balances;\n', '  // what exaclt ether was sent\n', '  mapping(address => uint) balancesRAW;\n', '  /* approve() allowances */\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  /* Interface declaration */\n', '  function isToken() public constant returns (bool weAre) {\n', '    return true;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) returns (bool success) {\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '    uint _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  \n', '  \n', '}\n', '\n', '\n', '//  daoPOLSKAtokens\n', 'contract daoPOLSKAtokens{\n', '\n', '    string public name = "DAO POLSKA TOKEN version 1";\n', '    string public symbol = "DPL";\n', '    uint8 public constant decimals = 18;  // 18 decimal places, the same as ETC/ETH/HEE.\n', '\n', '    // Receives \n', '    address public owner;\n', '    address public migrationMaster;\t\n', '    // The current total token supply.\n', '\n', '    uint256 public otherchainstotalsupply =1.0 ether;\n', '    uint256 public supplylimit      = 10000.0 ether;\n', '\t//totalSupply   \n', '   uint256 public  totalSupply      = 0.0 ether;\n', '\t//chains:\n', '\taddress public Chain1 = 0x0;\n', '\taddress public Chain2 = 0x0;\n', '\taddress public Chain3 = 0x0;\n', '\taddress public Chain4 = 0x0;\n', '\n', '\taddress public migrationAgent=0x8585D5A25b1FA2A0E6c3BcfC098195bac9789BE2;\n', '    uint256 public totalMigrated;\n', '\n', '\n', '    event Migrate(address indexed _from, address indexed _to, uint256 _value);\n', '    event Refund(address indexed _from, uint256 _value);\n', '\n', '\t\n', '\tstruct sendTokenAway{\n', '\t\tStandardToken coinContract;\n', '\t\tuint amount;\n', '\t\taddress recipient;\n', '\t}\n', '\tmapping(uint => sendTokenAway) transfers;\n', '\tuint numTransfers=0;\n', '\t\n', '  mapping (address => uint256) balances;\n', 'mapping (address => uint256) balancesRAW;\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\tevent UpdatedTokenInformation(string newName, string newSymbol);\t\n', ' \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\tevent receivedEther(address indexed _from,uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '      // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '  //tokenCreationCap\n', '  bool public supplylimitset = false;\n', '  bool public otherchainstotalset = false;\n', '   \n', '  function daoPOLSKAtokens() {\n', 'owner=msg.sender;\n', 'migrationMaster=msg.sender;\n', '}\n', '\n', 'function  setSupply(uint256 supplyLOCKER) public {\n', '    \t   if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '\t\t    \t   if (supplylimitset != false) {\n', '      throw;\n', '    }\n', '\tsupplylimitset = true;\n', '  \n', '\tsupplylimit = supplyLOCKER ** uint256(decimals);\n', '//balances[owner]=supplylimit;\n', '  } \n', 'function setotherchainstotalsupply(uint256 supplyLOCKER) public {\n', '    \t   if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '\t    \t   if (supplylimitset != false) {\n', '      throw;\n', '    }\n', '\n', '\totherchainstotalset = true;\n', '\totherchainstotalsupply = supplyLOCKER ** uint256(decimals);\n', '\t\n', '  } \n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '        balances[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balances[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowed[_from][msg.sender]);    // Check allowance\n', '        balances[_from] -= _value;                         // Subtract from the targeted balance\n', '        allowed[_from][msg.sender] -= _value;             // Subtract from the sender&#39;s allowance\n', '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '  \n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', '    //Default assumes totalSupply can&#39;t be over max (2^256 - 1).\n', '    //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.\n', '    //Replace the if with this one instead.\n', '    if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '    //if (balances[msg.sender] >= _value && _value > 0) {\n', '      balances[msg.sender] -= _value;\n', '      balances[_to] += _value;\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '    //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '    if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '    //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '      balances[_to] += _value;\n', '      balances[_from] -= _value;\n', '      allowed[_from][msg.sender] -= _value;\n', '      Transfer(_from, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) returns (bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '\n', '\t\n', '\t    function () payable  public {\n', '\t\t if(funding){ \n', '        receivedEther(msg.sender, msg.value);\n', '\t\tbalances[msg.sender]=balances[msg.sender]+msg.value;\n', '\t\t} else throw;\n', '\t\t\n', '    }\n', '   \n', '\n', '\n', '\n', '\t\n', '  function setTokenInformation(string _name, string _symbol) {\n', '    \n', '\t   if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '\tname = _name;\n', '    symbol = _symbol;\n', '\n', '    UpdatedTokenInformation(name, symbol);\n', '  }\n', '\n', 'function setChainsAddresses(address chainAd, int chainnumber) {\n', '    \n', '\t   if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '\tif(chainnumber==1){Chain1=chainAd;}\n', '\tif(chainnumber==2){Chain2=chainAd;}\n', '\tif(chainnumber==3){Chain3=chainAd;}\n', '\tif(chainnumber==4){Chain4=chainAd;}\t\t\n', '  } \n', '\n', '  function DAOPolskaTokenICOregulations() external returns(string wow) {\n', '\treturn &#39;Regulations of preICO and ICO are present at website  DAO Polska Token.network and by using this smartcontract and blockchains you commit that you accept and will follow those rules&#39;;\n', '}\n', '// if accidentally other token was donated to Project Dev\n', '\n', '\n', '\tfunction sendTokenAw(address StandardTokenAddress, address receiver, uint amount){\n', '\t\tif (msg.sender != owner) {\n', '\t\tthrow;\n', '\t\t}\n', '\t\tsendTokenAway t = transfers[numTransfers];\n', '\t\tt.coinContract = StandardToken(StandardTokenAddress);\n', '\t\tt.amount = amount;\n', '\t\tt.recipient = receiver;\n', '\t\tt.coinContract.transfer(receiver, amount);\n', '\t\tnumTransfers++;\n', '\t}\n', '\n', '     // Crowdfunding:\n', 'uint public tokenCreationRate=1000;\n', 'uint public bonusCreationRate=1000;\n', 'uint public CreationRate=1761;\n', '   uint256 public constant oneweek = 36000;\n', 'uint256 public fundingEndBlock = 5433616;\n', 'bool public funding = true;\n', 'bool public refundstate = false;\n', 'bool public migratestate= false;\n', '        function createDaoPOLSKAtokens(address holder) payable {\n', '\n', '        if (!funding) throw;\n', '\n', '        // Do not allow creating 0 or more than the cap tokens.\n', '        if (msg.value == 0) throw;\n', '\t\t// check the maximum token creation cap\n', '        if (msg.value > (supplylimit - totalSupply) / CreationRate)\n', '          throw;\n', '\t\t\n', '\t\t//bonus structure\n', '// in early stage there is about 100% more details in ico regulations on website\n', '// price and converstion rate in tabled to PLN not ether, and is updated daily\n', '\n', '\n', '\n', '\t var numTokensRAW = msg.value;\n', '\n', '        var numTokens = msg.value * CreationRate;\n', '        totalSupply += numTokens;\n', '\n', '        // Assign new tokens to the sender\n', '        balances[holder] += numTokens;\n', '        balancesRAW[holder] += numTokensRAW;\n', '        // Log token creation event\n', '        Transfer(0, holder, numTokens);\n', '\t\t\n', '\t\t// Create additional Dao Tokens for the community and developers around 12%\n', '        uint256 percentOfTotal = 12;\n', '        uint256 additionalTokens = \tnumTokens * percentOfTotal / (100);\n', '\n', '        totalSupply += additionalTokens;\n', '\n', '        balances[migrationMaster] += additionalTokens;\n', '        Transfer(0, migrationMaster, additionalTokens);\n', '\t\n', '\t}\n', '\tfunction setBonusCreationRate(uint newRate){\n', '\tif(msg.sender == owner) {\n', '\tbonusCreationRate=newRate;\n', '\tCreationRate=tokenCreationRate+bonusCreationRate;\n', '\t}\n', '\t}\n', '\n', '    function FundsTransfer() external {\n', '\tif(funding==true) throw;\n', '\t\t \tif (!owner.send(this.balance)) throw;\n', '    }\n', '\t\n', '    function PartialFundsTransfer(uint SubX) external {\n', '\t      if (msg.sender != owner) throw;\n', '        owner.send(this.balance - SubX);\n', '\t}\n', '\tfunction turnrefund() external {\n', '\t      if (msg.sender != owner) throw;\n', '\trefundstate=!refundstate;\n', '        }\n', '\t\t\n', '\t\t\tfunction fundingState() external {\n', '\t      if (msg.sender != owner) throw;\n', '\tfunding=!funding;\n', '        }\n', '    function turnmigrate() external {\n', '\t      if (msg.sender != migrationMaster) throw;\n', '\tmigratestate=!migratestate;\n', '}\n', '\n', '    // notice Finalize crowdfunding clossing funding options\n', '\t\n', 'function finalize() external {\n', '        if (block.number <= fundingEndBlock+8*oneweek) throw;\n', '        // Switch to Operational state. This is the only place this can happen.\n', '        funding = false;\t\n', '\t\trefundstate=!refundstate;\n', '        // Transfer ETH to theDAO Polska Token network Storage address.\n', '        if (msg.sender==owner)\n', '\t\towner.send(this.balance);\n', '    }\n', '    function migrate(uint256 _value) external {\n', '        // Abort if not in Operational Migration state.\n', '        if (migratestate) throw;\n', '\n', '\n', '        // Validate input value.\n', '        if (_value == 0) throw;\n', '        if (_value > balances[msg.sender]) throw;\n', '\n', '        balances[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        totalMigrated += _value;\n', '        MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);\n', '        Migrate(msg.sender, migrationAgent, _value);\n', '    }\n', '\t\n', 'function refundTRA() external {\n', '        // Abort if not in Funding Failure state.\n', '        if (funding) throw;\n', '        if (!refundstate) throw;\n', '\n', '        var DAOPLTokenValue = balances[msg.sender];\n', '        var ETHValue = balancesRAW[msg.sender];\n', '        if (ETHValue == 0) throw;\n', '        balancesRAW[msg.sender] = 0;\n', '        totalSupply -= DAOPLTokenValue;\n', '         \n', '        Refund(msg.sender, ETHValue);\n', '        msg.sender.transfer(ETHValue);\n', '}\n', '\n', 'function preICOregulations() external returns(string wow) {\n', '\treturn &#39;Regulations of preICO are present at website  daopolska.pl and by using this smartcontract you commit that you accept and will follow those rules&#39;;\n', '}\n', '\n', '\n', '}\n', '\n', '\n', '//------------------------------------------------------']
['//DAO Polska Token deployment\n', 'pragma solidity ^0.4.11;\n', 'interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }\n', '\n', '\n', '// title Migration Agent interface\n', 'contract MigrationAgent {\n', '    function migrateFrom(address _from, uint256 _value);\n', '}\n', '\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) constant returns (uint);\n', '  function allowance(address owner, address spender) constant returns (uint);\n', '\n', '  function transfer(address to, uint value) returns (bool ok);\n', '  function transferFrom(address from, address to, uint value) returns (bool ok);\n', '  function approve(address spender, uint value) returns (bool ok);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Math operations with safety checks\n', ' */\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.\n', ' *\n', ' * Based on code by FirstBlood:\n', ' * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, SafeMath {\n', '\n', '  /* Token supply got increased and a new owner received these tokens */\n', '  event Minted(address receiver, uint amount);\n', '\n', '  /* Actual balances of token holders */\n', '  mapping(address => uint) balances;\n', '  // what exaclt ether was sent\n', '  mapping(address => uint) balancesRAW;\n', '  /* approve() allowances */\n', '  mapping (address => mapping (address => uint)) allowed;\n', '\n', '  /* Interface declaration */\n', '  function isToken() public constant returns (bool weAre) {\n', '    return true;\n', '  }\n', '\n', '  function transfer(address _to, uint _value) returns (bool success) {\n', '    balances[msg.sender] = safeSub(balances[msg.sender], _value);\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint _value) returns (bool success) {\n', '    uint _allowance = allowed[_from][msg.sender];\n', '\n', '    balances[_to] = safeAdd(balances[_to], _value);\n', '    balances[_from] = safeSub(balances[_from], _value);\n', '    allowed[_from][msg.sender] = safeSub(_allowance, _value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint _value) returns (bool success) {\n', '\n', '    // To change the approve amount you first have to reduce the addresses`\n', '    //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '    //  already 0 to mitigate the race condition described here:\n', '    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;\n', '\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  \n', '  \n', '}\n', '\n', '\n', '//  daoPOLSKAtokens\n', 'contract daoPOLSKAtokens{\n', '\n', '    string public name = "DAO POLSKA TOKEN version 1";\n', '    string public symbol = "DPL";\n', '    uint8 public constant decimals = 18;  // 18 decimal places, the same as ETC/ETH/HEE.\n', '\n', '    // Receives \n', '    address public owner;\n', '    address public migrationMaster;\t\n', '    // The current total token supply.\n', '\n', '    uint256 public otherchainstotalsupply =1.0 ether;\n', '    uint256 public supplylimit      = 10000.0 ether;\n', '\t//totalSupply   \n', '   uint256 public  totalSupply      = 0.0 ether;\n', '\t//chains:\n', '\taddress public Chain1 = 0x0;\n', '\taddress public Chain2 = 0x0;\n', '\taddress public Chain3 = 0x0;\n', '\taddress public Chain4 = 0x0;\n', '\n', '\taddress public migrationAgent=0x8585D5A25b1FA2A0E6c3BcfC098195bac9789BE2;\n', '    uint256 public totalMigrated;\n', '\n', '\n', '    event Migrate(address indexed _from, address indexed _to, uint256 _value);\n', '    event Refund(address indexed _from, uint256 _value);\n', '\n', '\t\n', '\tstruct sendTokenAway{\n', '\t\tStandardToken coinContract;\n', '\t\tuint amount;\n', '\t\taddress recipient;\n', '\t}\n', '\tmapping(uint => sendTokenAway) transfers;\n', '\tuint numTransfers=0;\n', '\t\n', '  mapping (address => uint256) balances;\n', 'mapping (address => uint256) balancesRAW;\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\tevent UpdatedTokenInformation(string newName, string newSymbol);\t\n', ' \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '\tevent receivedEther(address indexed _from,uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '      // This notifies clients about the amount burnt\n', '    event Burn(address indexed from, uint256 value);\n', '  //tokenCreationCap\n', '  bool public supplylimitset = false;\n', '  bool public otherchainstotalset = false;\n', '   \n', '  function daoPOLSKAtokens() {\n', 'owner=msg.sender;\n', 'migrationMaster=msg.sender;\n', '}\n', '\n', 'function  setSupply(uint256 supplyLOCKER) public {\n', '    \t   if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '\t\t    \t   if (supplylimitset != false) {\n', '      throw;\n', '    }\n', '\tsupplylimitset = true;\n', '  \n', '\tsupplylimit = supplyLOCKER ** uint256(decimals);\n', '//balances[owner]=supplylimit;\n', '  } \n', 'function setotherchainstotalsupply(uint256 supplyLOCKER) public {\n', '    \t   if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '\t    \t   if (supplylimitset != false) {\n', '      throw;\n', '    }\n', '\n', '\totherchainstotalset = true;\n', '\totherchainstotalsupply = supplyLOCKER ** uint256(decimals);\n', '\t\n', '  } \n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData)\n', '        public\n', '        returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '        balances[msg.sender] -= _value;            // Subtract from the sender\n', '        totalSupply -= _value;                      // Updates totalSupply\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balances[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowed[_from][msg.sender]);    // Check allowance\n', '        balances[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        totalSupply -= _value;                              // Update totalSupply\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '  \n', '  function transfer(address _to, uint256 _value) returns (bool success) {\n', "    //Default assumes totalSupply can't be over max (2^256 - 1).\n", "    //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '    //Replace the if with this one instead.\n', '    if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '    //if (balances[msg.sender] >= _value && _value > 0) {\n', '      balances[msg.sender] -= _value;\n', '      balances[_to] += _value;\n', '      Transfer(msg.sender, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '    //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '    if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '    //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '      balances[_to] += _value;\n', '      balances[_from] -= _value;\n', '      allowed[_from][msg.sender] -= _value;\n', '      Transfer(_from, _to, _value);\n', '      return true;\n', '    } else { return false; }\n', '  }\n', '\n', '  function balanceOf(address _owner) constant returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) returns (bool success) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '\n', '\t\n', '\t    function () payable  public {\n', '\t\t if(funding){ \n', '        receivedEther(msg.sender, msg.value);\n', '\t\tbalances[msg.sender]=balances[msg.sender]+msg.value;\n', '\t\t} else throw;\n', '\t\t\n', '    }\n', '   \n', '\n', '\n', '\n', '\t\n', '  function setTokenInformation(string _name, string _symbol) {\n', '    \n', '\t   if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '\tname = _name;\n', '    symbol = _symbol;\n', '\n', '    UpdatedTokenInformation(name, symbol);\n', '  }\n', '\n', 'function setChainsAddresses(address chainAd, int chainnumber) {\n', '    \n', '\t   if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '\tif(chainnumber==1){Chain1=chainAd;}\n', '\tif(chainnumber==2){Chain2=chainAd;}\n', '\tif(chainnumber==3){Chain3=chainAd;}\n', '\tif(chainnumber==4){Chain4=chainAd;}\t\t\n', '  } \n', '\n', '  function DAOPolskaTokenICOregulations() external returns(string wow) {\n', "\treturn 'Regulations of preICO and ICO are present at website  DAO Polska Token.network and by using this smartcontract and blockchains you commit that you accept and will follow those rules';\n", '}\n', '// if accidentally other token was donated to Project Dev\n', '\n', '\n', '\tfunction sendTokenAw(address StandardTokenAddress, address receiver, uint amount){\n', '\t\tif (msg.sender != owner) {\n', '\t\tthrow;\n', '\t\t}\n', '\t\tsendTokenAway t = transfers[numTransfers];\n', '\t\tt.coinContract = StandardToken(StandardTokenAddress);\n', '\t\tt.amount = amount;\n', '\t\tt.recipient = receiver;\n', '\t\tt.coinContract.transfer(receiver, amount);\n', '\t\tnumTransfers++;\n', '\t}\n', '\n', '     // Crowdfunding:\n', 'uint public tokenCreationRate=1000;\n', 'uint public bonusCreationRate=1000;\n', 'uint public CreationRate=1761;\n', '   uint256 public constant oneweek = 36000;\n', 'uint256 public fundingEndBlock = 5433616;\n', 'bool public funding = true;\n', 'bool public refundstate = false;\n', 'bool public migratestate= false;\n', '        function createDaoPOLSKAtokens(address holder) payable {\n', '\n', '        if (!funding) throw;\n', '\n', '        // Do not allow creating 0 or more than the cap tokens.\n', '        if (msg.value == 0) throw;\n', '\t\t// check the maximum token creation cap\n', '        if (msg.value > (supplylimit - totalSupply) / CreationRate)\n', '          throw;\n', '\t\t\n', '\t\t//bonus structure\n', '// in early stage there is about 100% more details in ico regulations on website\n', '// price and converstion rate in tabled to PLN not ether, and is updated daily\n', '\n', '\n', '\n', '\t var numTokensRAW = msg.value;\n', '\n', '        var numTokens = msg.value * CreationRate;\n', '        totalSupply += numTokens;\n', '\n', '        // Assign new tokens to the sender\n', '        balances[holder] += numTokens;\n', '        balancesRAW[holder] += numTokensRAW;\n', '        // Log token creation event\n', '        Transfer(0, holder, numTokens);\n', '\t\t\n', '\t\t// Create additional Dao Tokens for the community and developers around 12%\n', '        uint256 percentOfTotal = 12;\n', '        uint256 additionalTokens = \tnumTokens * percentOfTotal / (100);\n', '\n', '        totalSupply += additionalTokens;\n', '\n', '        balances[migrationMaster] += additionalTokens;\n', '        Transfer(0, migrationMaster, additionalTokens);\n', '\t\n', '\t}\n', '\tfunction setBonusCreationRate(uint newRate){\n', '\tif(msg.sender == owner) {\n', '\tbonusCreationRate=newRate;\n', '\tCreationRate=tokenCreationRate+bonusCreationRate;\n', '\t}\n', '\t}\n', '\n', '    function FundsTransfer() external {\n', '\tif(funding==true) throw;\n', '\t\t \tif (!owner.send(this.balance)) throw;\n', '    }\n', '\t\n', '    function PartialFundsTransfer(uint SubX) external {\n', '\t      if (msg.sender != owner) throw;\n', '        owner.send(this.balance - SubX);\n', '\t}\n', '\tfunction turnrefund() external {\n', '\t      if (msg.sender != owner) throw;\n', '\trefundstate=!refundstate;\n', '        }\n', '\t\t\n', '\t\t\tfunction fundingState() external {\n', '\t      if (msg.sender != owner) throw;\n', '\tfunding=!funding;\n', '        }\n', '    function turnmigrate() external {\n', '\t      if (msg.sender != migrationMaster) throw;\n', '\tmigratestate=!migratestate;\n', '}\n', '\n', '    // notice Finalize crowdfunding clossing funding options\n', '\t\n', 'function finalize() external {\n', '        if (block.number <= fundingEndBlock+8*oneweek) throw;\n', '        // Switch to Operational state. This is the only place this can happen.\n', '        funding = false;\t\n', '\t\trefundstate=!refundstate;\n', '        // Transfer ETH to theDAO Polska Token network Storage address.\n', '        if (msg.sender==owner)\n', '\t\towner.send(this.balance);\n', '    }\n', '    function migrate(uint256 _value) external {\n', '        // Abort if not in Operational Migration state.\n', '        if (migratestate) throw;\n', '\n', '\n', '        // Validate input value.\n', '        if (_value == 0) throw;\n', '        if (_value > balances[msg.sender]) throw;\n', '\n', '        balances[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        totalMigrated += _value;\n', '        MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);\n', '        Migrate(msg.sender, migrationAgent, _value);\n', '    }\n', '\t\n', 'function refundTRA() external {\n', '        // Abort if not in Funding Failure state.\n', '        if (funding) throw;\n', '        if (!refundstate) throw;\n', '\n', '        var DAOPLTokenValue = balances[msg.sender];\n', '        var ETHValue = balancesRAW[msg.sender];\n', '        if (ETHValue == 0) throw;\n', '        balancesRAW[msg.sender] = 0;\n', '        totalSupply -= DAOPLTokenValue;\n', '         \n', '        Refund(msg.sender, ETHValue);\n', '        msg.sender.transfer(ETHValue);\n', '}\n', '\n', 'function preICOregulations() external returns(string wow) {\n', "\treturn 'Regulations of preICO are present at website  daopolska.pl and by using this smartcontract you commit that you accept and will follow those rules';\n", '}\n', '\n', '\n', '}\n', '\n', '\n', '//------------------------------------------------------']