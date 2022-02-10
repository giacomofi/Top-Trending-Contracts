['// Version 0.1\n', '// This swap contract was created by Attores and released under a GPL license\n', '// Visit attores.com for more contracts and Smart contract as a Service \n', '\n', '// This is the standard token interface\n', 'contract TokenInterface {\n', '\n', '  struct User {\n', '    bool locked;\n', '    uint256 balance;\n', '    uint256 badges;\n', '    mapping (address => uint256) allowed;\n', '  }\n', '\n', '  mapping (address => User) users;\n', '  mapping (address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '  mapping (address => bool) seller;\n', '\n', '  address config;\n', '  address owner;\n', '  address dao;\n', '  bool locked;\n', '\n', '  /// @return total amount of tokens\n', '  uint256 public totalSupply;\n', '  uint256 public totalBadges;\n', '\n', '  /// @param _owner The address from which the balance will be retrieved\n', '  /// @return The balance\n', '  function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '  /// @param _owner The address from which the badge count will be retrieved\n', '  /// @return The badges count\n', '  function badgesOf(address _owner) constant returns (uint256 badge);\n', '\n', '  /// @notice send `_value` tokens to `_to` from `msg.sender`\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of tokens to be transfered\n', '  /// @return Whether the transfer was successful or not\n', '  function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '  /// @notice send `_value` badges to `_to` from `msg.sender`\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of tokens to be transfered\n', '  /// @return Whether the transfer was successful or not\n', '  function sendBadge(address _to, uint256 _value) returns (bool success);\n', '\n', '  /// @notice send `_value` tokens to `_to` from `_from` on the condition it is approved by `_from`\n', '  /// @param _from The address of the sender\n', '  /// @param _to The address of the recipient\n', '  /// @param _value The amount of tokens to be transfered\n', '  /// @return Whether the transfer was successful or not\n', '  function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '  /// @notice `msg.sender` approves `_spender` to spend `_value` tokens on its behalf\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @param _value The amount of tokens to be approved for transfer\n', '  /// @return Whether the approval was successful or not\n', '  function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '  /// @param _owner The address of the account owning tokens\n', '  /// @param _spender The address of the account able to transfer the tokens\n', '  /// @return Amount of remaining tokens of _owner that _spender is allowed to spend\n', '  function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '  /// @notice mint `_amount` of tokens to `_owner`\n', '  /// @param _owner The address of the account receiving the tokens\n', '  /// @param _amount The amount of tokens to mint\n', '  /// @return Whether or not minting was successful\n', '  function mint(address _owner, uint256 _amount) returns (bool success);\n', '\n', '  /// @notice mintBadge Mint `_amount` badges to `_owner`\n', '  /// @param _owner The address of the account receiving the tokens\n', '  /// @param _amount The amount of tokens to mint\n', '  /// @return Whether or not minting was successful\n', '  function mintBadge(address _owner, uint256 _amount) returns (bool success);\n', '\n', '  function registerDao(address _dao) returns (bool success);\n', '\n', '  function registerSeller(address _tokensales) returns (bool success);\n', '\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event SendBadge(address indexed _from, address indexed _to, uint256 _amount);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '// Actual swap contract written by Attores\n', 'contract swap{\n', '    address public beneficiary;\n', '    TokenInterface public tokenObj;\n', '    uint public price_token;\n', '    uint256 public WEI_PER_FINNEY = 1000000000000000;\n', '    uint public BILLION = 1000000000;\n', '    uint public expiryDate;\n', '    \n', '    // Constructor function for this contract. Called during contract creation\n', '    function swap(address sendEtherTo, address adddressOfToken, uint tokenPriceInFinney_1000FinneyIs_1Ether, uint durationInDays){\n', '        beneficiary = sendEtherTo;\n', '        tokenObj = TokenInterface(adddressOfToken);\n', '        price_token = tokenPriceInFinney_1000FinneyIs_1Ether * WEI_PER_FINNEY;\n', '        expiryDate = now + durationInDays * 1 days;\n', '    }\n', '    \n', '    // This function is called every time some one sends ether to this contract\n', '    function(){\n', '        if (now >= expiryDate) throw;\n', '        // Dividing by Billion here to cater for the decimal places\n', '        var tokens_to_send = (msg.value * BILLION) / price_token;\n', '        uint balance = tokenObj.balanceOf(this);\n', '        address payee = msg.sender;\n', '        if (balance >= tokens_to_send){\n', '            tokenObj.transfer(msg.sender, tokens_to_send);\n', '            beneficiary.send(msg.value);    \n', '        } else {\n', '            tokenObj.transfer(msg.sender, balance);\n', '            uint amountReturned = ((tokens_to_send - balance) * price_token) / BILLION;\n', '            payee.send(amountReturned);\n', '            beneficiary.send(msg.value - amountReturned);\n', '        }\n', '    }\n', '    \n', '    modifier afterExpiry() { if (now >= expiryDate) _ }\n', '    \n', '    //This function checks if the expiry date has passed and if it has, then returns the tokens to the beneficiary\n', '    function checkExpiry() afterExpiry{\n', '        uint balance = tokenObj.balanceOf(this);\n', '        tokenObj.transfer(beneficiary, balance);\n', '    }\n', '}']