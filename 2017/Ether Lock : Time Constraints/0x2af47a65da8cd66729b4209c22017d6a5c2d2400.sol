['pragma solidity ^0.4.18;\n', 'contract Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) returns (bool success) {\n', "        //Default assumes totalSupply can't be over max (2^256 - 1).\n", "        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.\n", '        //Replace the if with this one instead.\n', '        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {\n', '        //same as above. Replace this line with the following if you want to protect against wrapping uints.\n', '        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '}\n', 'contract HumanStandardToken is StandardToken {\n', '\n', '    /* Public variables of the token */\n', '\n', '    /*\n', '    NOTE:\n', '    The following variables are OPTIONAL vanities. One does not have to include them.\n', '    They allow one to customise the token contract & in no way influences the core functionality.\n', '    Some wallets/interfaces might not even bother to look at this information.\n', '    */\n', '    string public name;                   //fancy name: eg Simon Bucks\n', "    uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.\n", '    string public symbol;                 //An identifier: eg SBX\n', "    string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.\n", '\n', '    function HumanStandardToken(\n', '        uint256 _initialAmount,\n', '        string _tokenName,\n', '        uint8 _decimalUnits,\n', '        string _tokenSymbol\n', '        ) {\n', '        balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens\n', '        totalSupply = _initialAmount;                        // Update total supply\n', '        name = _tokenName;                                   // Set the name for display purposes\n', '        decimals = _decimalUnits;                            // Amount of decimals for display purposes\n', '        symbol = _tokenSymbol;                               // Set the symbol for display purposes\n', '    }\n', '\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '\n', "        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.\n", '        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)\n', '        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.\n', '        require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract StandardBounties {\n', '\n', '  /*\n', '   * Events\n', '   */\n', '  event BountyIssued(uint bountyId);\n', '  event BountyActivated(uint bountyId, address issuer);\n', '  event BountyFulfilled(uint bountyId, address indexed fulfiller, uint256 indexed _fulfillmentId);\n', '  event FulfillmentUpdated(uint _bountyId, uint _fulfillmentId);\n', '  event FulfillmentAccepted(uint bountyId, address indexed fulfiller, uint256 indexed _fulfillmentId);\n', '  event BountyKilled(uint bountyId, address indexed issuer);\n', '  event ContributionAdded(uint bountyId, address indexed contributor, uint256 value);\n', '  event DeadlineExtended(uint bountyId, uint newDeadline);\n', '  event BountyChanged(uint bountyId);\n', '  event IssuerTransferred(uint _bountyId, address indexed _newIssuer);\n', '  event PayoutIncreased(uint _bountyId, uint _newFulfillmentAmount);\n', '\n', '\n', '  /*\n', '   * Storage\n', '   */\n', '\n', '  address public owner;\n', '\n', '  Bounty[] public bounties;\n', '\n', '  mapping(uint=>Fulfillment[]) fulfillments;\n', '  mapping(uint=>uint) numAccepted;\n', '  mapping(uint=>HumanStandardToken) tokenContracts;\n', '\n', '  /*\n', '   * Enums\n', '   */\n', '\n', '  enum BountyStages {\n', '      Draft,\n', '      Active,\n', '      Dead\n', '  }\n', '\n', '  /*\n', '   * Structs\n', '   */\n', '\n', '  struct Bounty {\n', '      address issuer;\n', '      uint deadline;\n', '      string data;\n', '      uint fulfillmentAmount;\n', '      address arbiter;\n', '      bool paysTokens;\n', '      BountyStages bountyStage;\n', '      uint balance;\n', '  }\n', '\n', '  struct Fulfillment {\n', '      bool accepted;\n', '      address fulfiller;\n', '      string data;\n', '  }\n', '\n', '  /*\n', '   * Modifiers\n', '   */\n', '\n', '  modifier validateNotTooManyBounties(){\n', '    require((bounties.length + 1) > bounties.length);\n', '    _;\n', '  }\n', '\n', '  modifier validateNotTooManyFulfillments(uint _bountyId){\n', '    require((fulfillments[_bountyId].length + 1) > fulfillments[_bountyId].length);\n', '    _;\n', '  }\n', '\n', '  modifier validateBountyArrayIndex(uint _bountyId){\n', '    require(_bountyId < bounties.length);\n', '    _;\n', '  }\n', '\n', '  modifier onlyIssuer(uint _bountyId) {\n', '      require(msg.sender == bounties[_bountyId].issuer);\n', '      _;\n', '  }\n', '\n', '  modifier onlyFulfiller(uint _bountyId, uint _fulfillmentId) {\n', '      require(msg.sender == fulfillments[_bountyId][_fulfillmentId].fulfiller);\n', '      _;\n', '  }\n', '\n', '  modifier amountIsNotZero(uint _amount) {\n', '      require(_amount != 0);\n', '      _;\n', '  }\n', '\n', '  modifier transferredAmountEqualsValue(uint _bountyId, uint _amount) {\n', '      if (bounties[_bountyId].paysTokens){\n', '        require(msg.value == 0);\n', '        uint oldBalance = tokenContracts[_bountyId].balanceOf(this);\n', '        if (_amount != 0){\n', '          require(tokenContracts[_bountyId].transferFrom(msg.sender, this, _amount));\n', '        }\n', '        require((tokenContracts[_bountyId].balanceOf(this) - oldBalance) == _amount);\n', '\n', '      } else {\n', '        require((_amount * 1 wei) == msg.value);\n', '      }\n', '      _;\n', '  }\n', '\n', '  modifier isBeforeDeadline(uint _bountyId) {\n', '      require(now < bounties[_bountyId].deadline);\n', '      _;\n', '  }\n', '\n', '  modifier validateDeadline(uint _newDeadline) {\n', '      require(_newDeadline > now);\n', '      _;\n', '  }\n', '\n', '  modifier isAtStage(uint _bountyId, BountyStages _desiredStage) {\n', '      require(bounties[_bountyId].bountyStage == _desiredStage);\n', '      _;\n', '  }\n', '\n', '  modifier validateFulfillmentArrayIndex(uint _bountyId, uint _index) {\n', '      require(_index < fulfillments[_bountyId].length);\n', '      _;\n', '  }\n', '\n', '  modifier notYetAccepted(uint _bountyId, uint _fulfillmentId){\n', '      require(fulfillments[_bountyId][_fulfillmentId].accepted == false);\n', '      _;\n', '  }\n', '\n', '  /*\n', '   * Public functions\n', '   */\n', '\n', '\n', '  /// @dev StandardBounties(): instantiates\n', '  /// @param _owner the issuer of the standardbounties contract, who has the\n', '  /// ability to remove bounties\n', '  function StandardBounties(address _owner)\n', '      public\n', '  {\n', '      owner = _owner;\n', '  }\n', '\n', '  /// @dev issueBounty(): instantiates a new draft bounty\n', '  /// @param _issuer the address of the intended issuer of the bounty\n', '  /// @param _deadline the unix timestamp after which fulfillments will no longer be accepted\n', '  /// @param _data the requirements of the bounty\n', '  /// @param _fulfillmentAmount the amount of wei to be paid out for each successful fulfillment\n', '  /// @param _arbiter the address of the arbiter who can mediate claims\n', '  /// @param _paysTokens whether the bounty pays in tokens or in ETH\n', '  /// @param _tokenContract the address of the contract if _paysTokens is true\n', '  function issueBounty(\n', '      address _issuer,\n', '      uint _deadline,\n', '      string _data,\n', '      uint256 _fulfillmentAmount,\n', '      address _arbiter,\n', '      bool _paysTokens,\n', '      address _tokenContract\n', '  )\n', '      public\n', '      validateDeadline(_deadline)\n', '      amountIsNotZero(_fulfillmentAmount)\n', '      validateNotTooManyBounties\n', '      returns (uint)\n', '  {\n', '      bounties.push(Bounty(_issuer, _deadline, _data, _fulfillmentAmount, _arbiter, _paysTokens, BountyStages.Draft, 0));\n', '      if (_paysTokens){\n', '        tokenContracts[bounties.length - 1] = HumanStandardToken(_tokenContract);\n', '      }\n', '      BountyIssued(bounties.length - 1);\n', '      return (bounties.length - 1);\n', '  }\n', '\n', '  /// @dev issueAndActivateBounty(): instantiates a new draft bounty\n', '  /// @param _issuer the address of the intended issuer of the bounty\n', '  /// @param _deadline the unix timestamp after which fulfillments will no longer be accepted\n', '  /// @param _data the requirements of the bounty\n', '  /// @param _fulfillmentAmount the amount of wei to be paid out for each successful fulfillment\n', '  /// @param _arbiter the address of the arbiter who can mediate claims\n', '  /// @param _paysTokens whether the bounty pays in tokens or in ETH\n', '  /// @param _tokenContract the address of the contract if _paysTokens is true\n', '  /// @param _value the total number of tokens being deposited upon activation\n', '  function issueAndActivateBounty(\n', '      address _issuer,\n', '      uint _deadline,\n', '      string _data,\n', '      uint256 _fulfillmentAmount,\n', '      address _arbiter,\n', '      bool _paysTokens,\n', '      address _tokenContract,\n', '      uint256 _value\n', '  )\n', '      public\n', '      payable\n', '      validateDeadline(_deadline)\n', '      amountIsNotZero(_fulfillmentAmount)\n', '      validateNotTooManyBounties\n', '      returns (uint)\n', '  {\n', '      require (_value >= _fulfillmentAmount);\n', '      if (_paysTokens){\n', '        require(msg.value == 0);\n', '        tokenContracts[bounties.length] = HumanStandardToken(_tokenContract);\n', '        require(tokenContracts[bounties.length].transferFrom(msg.sender, this, _value));\n', '      } else {\n', '        require((_value * 1 wei) == msg.value);\n', '      }\n', '      bounties.push(Bounty(_issuer,\n', '                            _deadline,\n', '                            _data,\n', '                            _fulfillmentAmount,\n', '                            _arbiter,\n', '                            _paysTokens,\n', '                            BountyStages.Active,\n', '                            _value));\n', '      BountyIssued(bounties.length - 1);\n', '      ContributionAdded(bounties.length - 1, msg.sender, _value);\n', '      BountyActivated(bounties.length - 1, msg.sender);\n', '      return (bounties.length - 1);\n', '  }\n', '\n', '  modifier isNotDead(uint _bountyId) {\n', '      require(bounties[_bountyId].bountyStage != BountyStages.Dead);\n', '      _;\n', '  }\n', '\n', '  /// @dev contribute(): a function allowing anyone to contribute tokens to a\n', "  /// bounty, as long as it is still before its deadline. Shouldn't keep\n", "  /// them by accident (hence 'value').\n", '  /// @param _bountyId the index of the bounty\n', '  /// @param _value the amount being contributed in ether to prevent accidental deposits\n', '  /// @notice Please note you funds will be at the mercy of the issuer\n', '  ///  and can be drained at any moment. Be careful!\n', '  function contribute (uint _bountyId, uint _value)\n', '      payable\n', '      public\n', '      validateBountyArrayIndex(_bountyId)\n', '      isBeforeDeadline(_bountyId)\n', '      isNotDead(_bountyId)\n', '      amountIsNotZero(_value)\n', '      transferredAmountEqualsValue(_bountyId, _value)\n', '  {\n', '      bounties[_bountyId].balance += _value;\n', '\n', '      ContributionAdded(_bountyId, msg.sender, _value);\n', '  }\n', '\n', '  /// @notice Send funds to activate the bug bounty\n', '  /// @dev activateBounty(): activate a bounty so it may pay out\n', '  /// @param _bountyId the index of the bounty\n', '  /// @param _value the amount being contributed in ether to prevent\n', '  /// accidental deposits\n', '  function activateBounty(uint _bountyId, uint _value)\n', '      payable\n', '      public\n', '      validateBountyArrayIndex(_bountyId)\n', '      isBeforeDeadline(_bountyId)\n', '      onlyIssuer(_bountyId)\n', '      transferredAmountEqualsValue(_bountyId, _value)\n', '  {\n', '      bounties[_bountyId].balance += _value;\n', '      require (bounties[_bountyId].balance >= bounties[_bountyId].fulfillmentAmount);\n', '      transitionToState(_bountyId, BountyStages.Active);\n', '\n', '      ContributionAdded(_bountyId, msg.sender, _value);\n', '      BountyActivated(_bountyId, msg.sender);\n', '  }\n', '\n', '  modifier notIssuerOrArbiter(uint _bountyId) {\n', '      require(msg.sender != bounties[_bountyId].issuer && msg.sender != bounties[_bountyId].arbiter);\n', '      _;\n', '  }\n', '\n', '  /// @dev fulfillBounty(): submit a fulfillment for the given bounty\n', '  /// @param _bountyId the index of the bounty\n', '  /// @param _data the data artifacts representing the fulfillment of the bounty\n', '  function fulfillBounty(uint _bountyId, string _data)\n', '      public\n', '      validateBountyArrayIndex(_bountyId)\n', '      validateNotTooManyFulfillments(_bountyId)\n', '      isAtStage(_bountyId, BountyStages.Active)\n', '      isBeforeDeadline(_bountyId)\n', '      notIssuerOrArbiter(_bountyId)\n', '  {\n', '      fulfillments[_bountyId].push(Fulfillment(false, msg.sender, _data));\n', '\n', '      BountyFulfilled(_bountyId, msg.sender, (fulfillments[_bountyId].length - 1));\n', '  }\n', '\n', '  /// @dev updateFulfillment(): Submit updated data for a given fulfillment\n', '  /// @param _bountyId the index of the bounty\n', '  /// @param _fulfillmentId the index of the fulfillment\n', '  /// @param _data the new data being submitted\n', '  function updateFulfillment(uint _bountyId, uint _fulfillmentId, string _data)\n', '      public\n', '      validateBountyArrayIndex(_bountyId)\n', '      validateFulfillmentArrayIndex(_bountyId, _fulfillmentId)\n', '      onlyFulfiller(_bountyId, _fulfillmentId)\n', '      notYetAccepted(_bountyId, _fulfillmentId)\n', '  {\n', '      fulfillments[_bountyId][_fulfillmentId].data = _data;\n', '      FulfillmentUpdated(_bountyId, _fulfillmentId);\n', '  }\n', '\n', '  modifier onlyIssuerOrArbiter(uint _bountyId) {\n', '      require(msg.sender == bounties[_bountyId].issuer ||\n', '         (msg.sender == bounties[_bountyId].arbiter && bounties[_bountyId].arbiter != address(0)));\n', '      _;\n', '  }\n', '\n', '  modifier fulfillmentNotYetAccepted(uint _bountyId, uint _fulfillmentId) {\n', '      require(fulfillments[_bountyId][_fulfillmentId].accepted == false);\n', '      _;\n', '  }\n', '\n', '  modifier enoughFundsToPay(uint _bountyId) {\n', '      require(bounties[_bountyId].balance >= bounties[_bountyId].fulfillmentAmount);\n', '      _;\n', '  }\n', '\n', '  /// @dev acceptFulfillment(): accept a given fulfillment\n', '  /// @param _bountyId the index of the bounty\n', '  /// @param _fulfillmentId the index of the fulfillment being accepted\n', '  function acceptFulfillment(uint _bountyId, uint _fulfillmentId)\n', '      public\n', '      validateBountyArrayIndex(_bountyId)\n', '      validateFulfillmentArrayIndex(_bountyId, _fulfillmentId)\n', '      onlyIssuerOrArbiter(_bountyId)\n', '      isAtStage(_bountyId, BountyStages.Active)\n', '      fulfillmentNotYetAccepted(_bountyId, _fulfillmentId)\n', '      enoughFundsToPay(_bountyId)\n', '  {\n', '      fulfillments[_bountyId][_fulfillmentId].accepted = true;\n', '      numAccepted[_bountyId]++;\n', '      bounties[_bountyId].balance -= bounties[_bountyId].fulfillmentAmount;\n', '      if (bounties[_bountyId].paysTokens){\n', '        require(tokenContracts[_bountyId].transfer(fulfillments[_bountyId][_fulfillmentId].fulfiller, bounties[_bountyId].fulfillmentAmount));\n', '      } else {\n', '        fulfillments[_bountyId][_fulfillmentId].fulfiller.transfer(bounties[_bountyId].fulfillmentAmount);\n', '      }\n', '      FulfillmentAccepted(_bountyId, msg.sender, _fulfillmentId);\n', '  }\n', '\n', "  /// @dev killBounty(): drains the contract of it's remaining\n", '  /// funds, and moves the bounty into stage 3 (dead) since it was\n', '  /// either killed in draft stage, or never accepted any fulfillments\n', '  /// @param _bountyId the index of the bounty\n', '  function killBounty(uint _bountyId)\n', '      public\n', '      validateBountyArrayIndex(_bountyId)\n', '      onlyIssuer(_bountyId)\n', '  {\n', '      transitionToState(_bountyId, BountyStages.Dead);\n', '      uint oldBalance = bounties[_bountyId].balance;\n', '      bounties[_bountyId].balance = 0;\n', '      if (oldBalance > 0){\n', '        if (bounties[_bountyId].paysTokens){\n', '          require(tokenContracts[_bountyId].transfer(bounties[_bountyId].issuer, oldBalance));\n', '        } else {\n', '          bounties[_bountyId].issuer.transfer(oldBalance);\n', '        }\n', '      }\n', '      BountyKilled(_bountyId, msg.sender);\n', '  }\n', '\n', '  modifier newDeadlineIsValid(uint _bountyId, uint _newDeadline) {\n', '      require(_newDeadline > bounties[_bountyId].deadline);\n', '      _;\n', '  }\n', '\n', '  /// @dev extendDeadline(): allows the issuer to add more time to the\n', '  /// bounty, allowing it to continue accepting fulfillments\n', '  /// @param _bountyId the index of the bounty\n', '  /// @param _newDeadline the new deadline in timestamp format\n', '  function extendDeadline(uint _bountyId, uint _newDeadline)\n', '      public\n', '      validateBountyArrayIndex(_bountyId)\n', '      onlyIssuer(_bountyId)\n', '      newDeadlineIsValid(_bountyId, _newDeadline)\n', '  {\n', '      bounties[_bountyId].deadline = _newDeadline;\n', '\n', '      DeadlineExtended(_bountyId, _newDeadline);\n', '  }\n', '\n', '  /// @dev transferIssuer(): allows the issuer to transfer ownership of the\n', '  /// bounty to some new address\n', '  /// @param _bountyId the index of the bounty\n', '  /// @param _newIssuer the address of the new issuer\n', '  function transferIssuer(uint _bountyId, address _newIssuer)\n', '      public\n', '      validateBountyArrayIndex(_bountyId)\n', '      onlyIssuer(_bountyId)\n', '  {\n', '      bounties[_bountyId].issuer = _newIssuer;\n', '      IssuerTransferred(_bountyId, _newIssuer);\n', '  }\n', '\n', '\n', "  /// @dev changeBountyDeadline(): allows the issuer to change a bounty's deadline\n", '  /// @param _bountyId the index of the bounty\n', '  /// @param _newDeadline the new deadline for the bounty\n', '  function changeBountyDeadline(uint _bountyId, uint _newDeadline)\n', '      public\n', '      validateBountyArrayIndex(_bountyId)\n', '      onlyIssuer(_bountyId)\n', '      validateDeadline(_newDeadline)\n', '      isAtStage(_bountyId, BountyStages.Draft)\n', '  {\n', '      bounties[_bountyId].deadline = _newDeadline;\n', '      BountyChanged(_bountyId);\n', '  }\n', '\n', "  /// @dev changeData(): allows the issuer to change a bounty's data\n", '  /// @param _bountyId the index of the bounty\n', '  /// @param _newData the new requirements of the bounty\n', '  function changeBountyData(uint _bountyId, string _newData)\n', '      public\n', '      validateBountyArrayIndex(_bountyId)\n', '      onlyIssuer(_bountyId)\n', '      isAtStage(_bountyId, BountyStages.Draft)\n', '  {\n', '      bounties[_bountyId].data = _newData;\n', '      BountyChanged(_bountyId);\n', '  }\n', '\n', "  /// @dev changeBountyfulfillmentAmount(): allows the issuer to change a bounty's fulfillment amount\n", '  /// @param _bountyId the index of the bounty\n', '  /// @param _newFulfillmentAmount the new fulfillment amount\n', '  function changeBountyFulfillmentAmount(uint _bountyId, uint _newFulfillmentAmount)\n', '      public\n', '      validateBountyArrayIndex(_bountyId)\n', '      onlyIssuer(_bountyId)\n', '      isAtStage(_bountyId, BountyStages.Draft)\n', '  {\n', '      bounties[_bountyId].fulfillmentAmount = _newFulfillmentAmount;\n', '      BountyChanged(_bountyId);\n', '  }\n', '\n', "  /// @dev changeBountyArbiter(): allows the issuer to change a bounty's arbiter\n", '  /// @param _bountyId the index of the bounty\n', '  /// @param _newArbiter the new address of the arbiter\n', '  function changeBountyArbiter(uint _bountyId, address _newArbiter)\n', '      public\n', '      validateBountyArrayIndex(_bountyId)\n', '      onlyIssuer(_bountyId)\n', '      isAtStage(_bountyId, BountyStages.Draft)\n', '  {\n', '      bounties[_bountyId].arbiter = _newArbiter;\n', '      BountyChanged(_bountyId);\n', '  }\n', '\n', '  modifier newFulfillmentAmountIsIncrease(uint _bountyId, uint _newFulfillmentAmount) {\n', '      require(bounties[_bountyId].fulfillmentAmount < _newFulfillmentAmount);\n', '      _;\n', '  }\n', '\n', '  /// @dev increasePayout(): allows the issuer to increase a given fulfillment\n', '  /// amount in the active stage\n', '  /// @param _bountyId the index of the bounty\n', '  /// @param _newFulfillmentAmount the new fulfillment amount\n', '  /// @param _value the value of the additional deposit being added\n', '  function increasePayout(uint _bountyId, uint _newFulfillmentAmount, uint _value)\n', '      public\n', '      payable\n', '      validateBountyArrayIndex(_bountyId)\n', '      onlyIssuer(_bountyId)\n', '      newFulfillmentAmountIsIncrease(_bountyId, _newFulfillmentAmount)\n', '      transferredAmountEqualsValue(_bountyId, _value)\n', '  {\n', '      bounties[_bountyId].balance += _value;\n', '      require(bounties[_bountyId].balance >= _newFulfillmentAmount);\n', '      bounties[_bountyId].fulfillmentAmount = _newFulfillmentAmount;\n', '      PayoutIncreased(_bountyId, _newFulfillmentAmount);\n', '  }\n', '\n', '  /// @dev getFulfillment(): Returns the fulfillment at a given index\n', '  /// @param _bountyId the index of the bounty\n', '  /// @param _fulfillmentId the index of the fulfillment to return\n', '  /// @return Returns a tuple for the fulfillment\n', '  function getFulfillment(uint _bountyId, uint _fulfillmentId)\n', '      public\n', '      constant\n', '      validateBountyArrayIndex(_bountyId)\n', '      validateFulfillmentArrayIndex(_bountyId, _fulfillmentId)\n', '      returns (bool, address, string)\n', '  {\n', '      return (fulfillments[_bountyId][_fulfillmentId].accepted,\n', '              fulfillments[_bountyId][_fulfillmentId].fulfiller,\n', '              fulfillments[_bountyId][_fulfillmentId].data);\n', '  }\n', '\n', '  /// @dev getBounty(): Returns the details of the bounty\n', '  /// @param _bountyId the index of the bounty\n', '  /// @return Returns a tuple for the bounty\n', '  function getBounty(uint _bountyId)\n', '      public\n', '      constant\n', '      validateBountyArrayIndex(_bountyId)\n', '      returns (address, uint, uint, bool, uint, uint)\n', '  {\n', '      return (bounties[_bountyId].issuer,\n', '              bounties[_bountyId].deadline,\n', '              bounties[_bountyId].fulfillmentAmount,\n', '              bounties[_bountyId].paysTokens,\n', '              uint(bounties[_bountyId].bountyStage),\n', '              bounties[_bountyId].balance);\n', '  }\n', '\n', '  /// @dev getBountyArbiter(): Returns the arbiter of the bounty\n', '  /// @param _bountyId the index of the bounty\n', '  /// @return Returns an address for the arbiter of the bounty\n', '  function getBountyArbiter(uint _bountyId)\n', '      public\n', '      constant\n', '      validateBountyArrayIndex(_bountyId)\n', '      returns (address)\n', '  {\n', '      return (bounties[_bountyId].arbiter);\n', '  }\n', '\n', '  /// @dev getBountyData(): Returns the data of the bounty\n', '  /// @param _bountyId the index of the bounty\n', '  /// @return Returns a string for the bounty data\n', '  function getBountyData(uint _bountyId)\n', '      public\n', '      constant\n', '      validateBountyArrayIndex(_bountyId)\n', '      returns (string)\n', '  {\n', '      return (bounties[_bountyId].data);\n', '  }\n', '\n', '  /// @dev getBountyToken(): Returns the token contract of the bounty\n', '  /// @param _bountyId the index of the bounty\n', '  /// @return Returns an address for the token that the bounty uses\n', '  function getBountyToken(uint _bountyId)\n', '      public\n', '      constant\n', '      validateBountyArrayIndex(_bountyId)\n', '      returns (address)\n', '  {\n', '      return (tokenContracts[_bountyId]);\n', '  }\n', '\n', '  /// @dev getNumBounties() returns the number of bounties in the registry\n', '  /// @return Returns the number of bounties\n', '  function getNumBounties()\n', '      public\n', '      constant\n', '      returns (uint)\n', '  {\n', '      return bounties.length;\n', '  }\n', '\n', '  /// @dev getNumFulfillments() returns the number of fulfillments for a given milestone\n', '  /// @param _bountyId the index of the bounty\n', '  /// @return Returns the number of fulfillments\n', '  function getNumFulfillments(uint _bountyId)\n', '      public\n', '      constant\n', '      validateBountyArrayIndex(_bountyId)\n', '      returns (uint)\n', '  {\n', '      return fulfillments[_bountyId].length;\n', '  }\n', '\n', '  /*\n', '   * Internal functions\n', '   */\n', '\n', '  /// @dev transitionToState(): transitions the contract to the\n', '  /// state passed in the parameter `_newStage` given the\n', '  /// conditions stated in the body of the function\n', '  /// @param _bountyId the index of the bounty\n', '  /// @param _newStage the new stage to transition to\n', '  function transitionToState(uint _bountyId, BountyStages _newStage)\n', '      internal\n', '  {\n', '      bounties[_bountyId].bountyStage = _newStage;\n', '  }\n', '}']