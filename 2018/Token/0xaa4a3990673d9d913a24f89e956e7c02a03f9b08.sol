['pragma solidity ^0.4.18;\n', '\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function changeOwner(address _newOwner) public onlyOwner{\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '\n', '// Safe maths, borrowed from OpenZeppelin\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '\n', '  function mul(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'contract tokenRecipient {\n', '  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;\n', '}\n', '\n', 'contract ERC20Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract limitedFactor {\n', '    using SafeMath for uint;\n', '    \n', '    uint256 public totalSupply = 0;\n', '    uint256 public topTotalSupply = 18*10**8*10**6;\n', '    uint256 public teamSupply = percent(15);\n', '    uint256 public teamAlloacting = 0;\n', '    uint256 internal teamReleasetokenEachMonth = 5 * teamSupply / 100;\n', '    uint256 public creationInvestmentSupply = percent(15);\n', '    uint256 public creationInvestmenting = 0;\n', '    uint256 public ICOtotalSupply = percent(30);\n', '    uint256 public ICOSupply = 0;\n', '    uint256 public communitySupply = percent(20);\n', '    uint256 public communityAllocating = 0;\n', '    uint256 public angelWheelFinanceSupply = percent(20);\n', '    uint256 public angelWheelFinancing = 0;\n', '    address public walletAddress;\n', '    uint256 public teamAddressFreezeTime = startTimeRoundOne;\n', '    address public teamAddress;\n', '    uint256 internal teamAddressTransfer = 0;\n', '    uint256 public exchangeRateRoundOne = 16000;\n', '    uint256 public exchangeRateRoundTwo = 10000;\n', '    uint256 internal startTimeRoundOne = 1526313600;\n', '    uint256 internal stopTimeRoundOne =  1528991999;\n', '    \n', '    modifier teamAccountNeedFreeze18Months(address _address) {\n', '        if(_address == teamAddress) {\n', '            require(now >= teamAddressFreezeTime + 1.5 years);\n', '        }\n', '        _;\n', '    }\n', '    \n', '    modifier releaseToken (address _user, uint256 _time, uint256 _value) {\n', '        if (_user == teamAddress){\n', '            require (teamAddressTransfer + _value <= calcReleaseToken(_time)); \n', '        }\n', '        _;\n', '    }\n', '    \n', '    function calcReleaseToken (uint256 _time) internal view returns (uint256) {\n', '        uint256 _timeDifference = _time - (teamAddressFreezeTime + 1.5 years);\n', '        return _timeDifference / (3600 * 24 * 30) * teamReleasetokenEachMonth;\n', '    } \n', '    \n', '     /// @dev calcute the tokens\n', '    function percent(uint256 percentage) internal view returns (uint256) {\n', '        return percentage.mul(topTotalSupply).div(100);\n', '    }\n', '\n', '}\n', '\n', 'contract standardToken is ERC20Token, limitedFactor {\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowances;\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /* Transfers tokens from your address to other */\n', '    function transfer(address _to, uint256 _value) \n', '        public \n', '        teamAccountNeedFreeze18Months(msg.sender) \n', '        releaseToken(msg.sender, now, _value)\n', '        returns (bool success) \n', '    {\n', '        require (balances[msg.sender] >= _value);           // Throw if sender has insufficient balance\n', '        require (balances[_to] + _value >= balances[_to]);  // Throw if owerflow detected\n', '        balances[msg.sender] -= _value;                     // Deduct senders balance\n', '        balances[_to] += _value;                            // Add recivers blaance\n', '        if (msg.sender == teamAddress) {\n', '            teamAddressTransfer += _value;\n', '        }\n', '        emit Transfer(msg.sender, _to, _value);                  // Raise Transfer event\n', '        return true;\n', '    }\n', '\n', '    /* Approve other address to spend tokens on your account */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);\n', '        allowances[msg.sender][_spender] = _value;          // Set allowance\n', '        emit Approval(msg.sender, _spender, _value);             // Raise Approval event\n', '        return true;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);              // Cast spender to tokenRecipient contract\n', '        approve(_spender, _value);                                      // Set approval to contract for _value\n', '        spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract\n', '        return true;\n', '    }\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require (balances[_from] >= _value);                // Throw if sender does not have enough balance\n', '        require (balances[_to] + _value >= balances[_to]);  // Throw if overflow detected\n', '        require (_value <= allowances[_from][msg.sender]);  // Throw if you do not have allowance\n', '        balances[_from] -= _value;                          // Deduct senders balance\n', '        balances[_to] += _value;                            // Add recipient blaance\n', '        allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address\n', '        emit Transfer(_from, _to, _value);                       // Raise Transfer event\n', '        return true;\n', '    }\n', '\n', '    /* Get the amount of allowed tokens to spend */\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '        return allowances[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', 'contract MMONToken is standardToken,Owned {\n', '    using SafeMath for uint;\n', '\n', '    string constant public name="MONEY MONSTER";\n', '    string constant public symbol="MMON";\n', '    uint256 constant public decimals=6;\n', '    \n', '    bool public ICOStart;\n', '    \n', '    /// @dev Fallback to calling deposit when ether is sent directly to contract.\n', '    function() public payable {\n', '        require (ICOStart);\n', '        depositToken(msg.value);\n', '    }\n', '    \n', '    /// @dev initial function\n', '    function MMONToken() public {\n', '        owner=msg.sender;\n', '        ICOStart = true;\n', '    }\n', '    \n', '    /// @dev Buys tokens with Ether.\n', '    function depositToken(uint256 _value) internal {\n', '        uint256 tokenAlloc = buyPriceAt(getTime()) * _value;\n', '        require(tokenAlloc != 0);\n', '        ICOSupply = ICOSupply.add(tokenAlloc);\n', '        require (ICOSupply <= ICOtotalSupply);\n', '        mintTokens(msg.sender, tokenAlloc);\n', '        forwardFunds();\n', '    }\n', '    \n', '    /// @dev internal function\n', '    function forwardFunds() internal {\n', '        if (walletAddress != address(0)){\n', '            walletAddress.transfer(msg.value);\n', '        }\n', '    }\n', '    \n', '    /// @dev Issue new tokens\n', '    function mintTokens(address _to, uint256 _amount) internal {\n', '        require (balances[_to] + _amount >= balances[_to]);     // Check for overflows\n', '        balances[_to] = balances[_to].add(_amount);             // Set minted coins to target\n', '        totalSupply = totalSupply.add(_amount);\n', '        require(totalSupply <= topTotalSupply);\n', '        emit Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x\n', '    }\n', '    \n', '    /// @dev Calculate exchange\n', '    function buyPriceAt(uint256 _time) internal constant returns(uint256) {\n', '        if (_time >= startTimeRoundOne && _time <= stopTimeRoundOne) {\n', '            return exchangeRateRoundOne;\n', '        }  else {\n', '            return 0;\n', '        }\n', '    }\n', '    \n', '    /// @dev Get time\n', '    function getTime() internal constant returns(uint256) {\n', '        return now;\n', '    }\n', '    \n', '    /// @dev set initial message\n', '    function setInitialVaribles(address _walletAddress, address _teamAddress) public onlyOwner {\n', '        walletAddress = _walletAddress;\n', '        teamAddress = _teamAddress;\n', '    }\n', '    \n', '    /// @dev withDraw Ether to a Safe Wallet\n', '    function withDraw(address _etherAddress) public payable onlyOwner {\n', '        require (_etherAddress != address(0));\n', '        address contractAddress = this;\n', '        _etherAddress.transfer(contractAddress.balance);\n', '    }\n', '    \n', '    /// @dev allocate Token\n', '    function allocateTokens(address[] _owners, uint256[] _values) public onlyOwner {\n', '        require (_owners.length == _values.length);\n', '        for(uint256 i = 0; i < _owners.length ; i++){\n', '            address owner = _owners[i];\n', '            uint256 value = _values[i];\n', '            mintTokens(owner, value);\n', '        }\n', '    }\n', '    \n', '    /// @dev allocate token for Team Address\n', '    function allocateTeamToken() public onlyOwner {\n', '        require(balances[teamAddress] == 0);\n', '        mintTokens(teamAddress, teamSupply);\n', '        teamAddressFreezeTime = now;\n', '    }\n', '    \n', '    function allocateCommunityToken (address[] _commnityAddress, uint256[] _amount) public onlyOwner {\n', '        communityAllocating = mintMultiToken(_commnityAddress, _amount, communityAllocating);\n', '        require (communityAllocating <= communitySupply);\n', '    }\n', '    /// @dev allocate token for Private Address\n', '    function allocateCreationInvestmentingToken(address[] _creationInvestmentingingAddress, uint256[] _amount) public onlyOwner {\n', '        creationInvestmenting = mintMultiToken(_creationInvestmentingingAddress, _amount, creationInvestmenting);\n', '        require (creationInvestmenting <= creationInvestmentSupply);\n', '    }\n', '    \n', '    /// @dev allocate token for contributors Address\n', '    function allocateAngelWheelFinanceToken(address[] _angelWheelFinancingAddress, uint256[] _amount) public onlyOwner {\n', '        //require(balances[contributorsAddress] == 0);\n', '        angelWheelFinancing = mintMultiToken(_angelWheelFinancingAddress, _amount, angelWheelFinancing);\n', '        require (angelWheelFinancing <= angelWheelFinanceSupply);\n', '    }\n', '    \n', '    function mintMultiToken (address[] _multiAddr, uint256[] _multiAmount, uint256 _target) internal returns (uint256){\n', '        require (_multiAddr.length == _multiAmount.length);\n', '        for(uint256 i = 0; i < _multiAddr.length ; i++){\n', '            address owner = _multiAddr[i];\n', '            uint256 value = _multiAmount[i];\n', '            _target = _target.add(value);\n', '            mintTokens(owner, value);\n', '        }\n', '        return _target;\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function changeOwner(address _newOwner) public onlyOwner{\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '\n', '// Safe maths, borrowed from OpenZeppelin\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '\n', '  function mul(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint a, uint b) internal pure returns (uint) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint a, uint b) internal pure returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint a, uint b) internal pure returns (uint) {\n', '    uint c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '\n', '}\n', '\n', 'contract tokenRecipient {\n', '  function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;\n', '}\n', '\n', 'contract ERC20Token {\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract limitedFactor {\n', '    using SafeMath for uint;\n', '    \n', '    uint256 public totalSupply = 0;\n', '    uint256 public topTotalSupply = 18*10**8*10**6;\n', '    uint256 public teamSupply = percent(15);\n', '    uint256 public teamAlloacting = 0;\n', '    uint256 internal teamReleasetokenEachMonth = 5 * teamSupply / 100;\n', '    uint256 public creationInvestmentSupply = percent(15);\n', '    uint256 public creationInvestmenting = 0;\n', '    uint256 public ICOtotalSupply = percent(30);\n', '    uint256 public ICOSupply = 0;\n', '    uint256 public communitySupply = percent(20);\n', '    uint256 public communityAllocating = 0;\n', '    uint256 public angelWheelFinanceSupply = percent(20);\n', '    uint256 public angelWheelFinancing = 0;\n', '    address public walletAddress;\n', '    uint256 public teamAddressFreezeTime = startTimeRoundOne;\n', '    address public teamAddress;\n', '    uint256 internal teamAddressTransfer = 0;\n', '    uint256 public exchangeRateRoundOne = 16000;\n', '    uint256 public exchangeRateRoundTwo = 10000;\n', '    uint256 internal startTimeRoundOne = 1526313600;\n', '    uint256 internal stopTimeRoundOne =  1528991999;\n', '    \n', '    modifier teamAccountNeedFreeze18Months(address _address) {\n', '        if(_address == teamAddress) {\n', '            require(now >= teamAddressFreezeTime + 1.5 years);\n', '        }\n', '        _;\n', '    }\n', '    \n', '    modifier releaseToken (address _user, uint256 _time, uint256 _value) {\n', '        if (_user == teamAddress){\n', '            require (teamAddressTransfer + _value <= calcReleaseToken(_time)); \n', '        }\n', '        _;\n', '    }\n', '    \n', '    function calcReleaseToken (uint256 _time) internal view returns (uint256) {\n', '        uint256 _timeDifference = _time - (teamAddressFreezeTime + 1.5 years);\n', '        return _timeDifference / (3600 * 24 * 30) * teamReleasetokenEachMonth;\n', '    } \n', '    \n', '     /// @dev calcute the tokens\n', '    function percent(uint256 percentage) internal view returns (uint256) {\n', '        return percentage.mul(topTotalSupply).div(100);\n', '    }\n', '\n', '}\n', '\n', 'contract standardToken is ERC20Token, limitedFactor {\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowances;\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    /* Transfers tokens from your address to other */\n', '    function transfer(address _to, uint256 _value) \n', '        public \n', '        teamAccountNeedFreeze18Months(msg.sender) \n', '        releaseToken(msg.sender, now, _value)\n', '        returns (bool success) \n', '    {\n', '        require (balances[msg.sender] >= _value);           // Throw if sender has insufficient balance\n', '        require (balances[_to] + _value >= balances[_to]);  // Throw if owerflow detected\n', '        balances[msg.sender] -= _value;                     // Deduct senders balance\n', '        balances[_to] += _value;                            // Add recivers blaance\n', '        if (msg.sender == teamAddress) {\n', '            teamAddressTransfer += _value;\n', '        }\n', '        emit Transfer(msg.sender, _to, _value);                  // Raise Transfer event\n', '        return true;\n', '    }\n', '\n', '    /* Approve other address to spend tokens on your account */\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);\n', '        allowances[msg.sender][_spender] = _value;          // Set allowance\n', '        emit Approval(msg.sender, _spender, _value);             // Raise Approval event\n', '        return true;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);              // Cast spender to tokenRecipient contract\n', '        approve(_spender, _value);                                      // Set approval to contract for _value\n', '        spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract\n', '        return true;\n', '    }\n', '\n', '    /* A contract attempts to get the coins */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require (balances[_from] >= _value);                // Throw if sender does not have enough balance\n', '        require (balances[_to] + _value >= balances[_to]);  // Throw if overflow detected\n', '        require (_value <= allowances[_from][msg.sender]);  // Throw if you do not have allowance\n', '        balances[_from] -= _value;                          // Deduct senders balance\n', '        balances[_to] += _value;                            // Add recipient blaance\n', '        allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address\n', '        emit Transfer(_from, _to, _value);                       // Raise Transfer event\n', '        return true;\n', '    }\n', '\n', '    /* Get the amount of allowed tokens to spend */\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {\n', '        return allowances[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', 'contract MMONToken is standardToken,Owned {\n', '    using SafeMath for uint;\n', '\n', '    string constant public name="MONEY MONSTER";\n', '    string constant public symbol="MMON";\n', '    uint256 constant public decimals=6;\n', '    \n', '    bool public ICOStart;\n', '    \n', '    /// @dev Fallback to calling deposit when ether is sent directly to contract.\n', '    function() public payable {\n', '        require (ICOStart);\n', '        depositToken(msg.value);\n', '    }\n', '    \n', '    /// @dev initial function\n', '    function MMONToken() public {\n', '        owner=msg.sender;\n', '        ICOStart = true;\n', '    }\n', '    \n', '    /// @dev Buys tokens with Ether.\n', '    function depositToken(uint256 _value) internal {\n', '        uint256 tokenAlloc = buyPriceAt(getTime()) * _value;\n', '        require(tokenAlloc != 0);\n', '        ICOSupply = ICOSupply.add(tokenAlloc);\n', '        require (ICOSupply <= ICOtotalSupply);\n', '        mintTokens(msg.sender, tokenAlloc);\n', '        forwardFunds();\n', '    }\n', '    \n', '    /// @dev internal function\n', '    function forwardFunds() internal {\n', '        if (walletAddress != address(0)){\n', '            walletAddress.transfer(msg.value);\n', '        }\n', '    }\n', '    \n', '    /// @dev Issue new tokens\n', '    function mintTokens(address _to, uint256 _amount) internal {\n', '        require (balances[_to] + _amount >= balances[_to]);     // Check for overflows\n', '        balances[_to] = balances[_to].add(_amount);             // Set minted coins to target\n', '        totalSupply = totalSupply.add(_amount);\n', '        require(totalSupply <= topTotalSupply);\n', '        emit Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x\n', '    }\n', '    \n', '    /// @dev Calculate exchange\n', '    function buyPriceAt(uint256 _time) internal constant returns(uint256) {\n', '        if (_time >= startTimeRoundOne && _time <= stopTimeRoundOne) {\n', '            return exchangeRateRoundOne;\n', '        }  else {\n', '            return 0;\n', '        }\n', '    }\n', '    \n', '    /// @dev Get time\n', '    function getTime() internal constant returns(uint256) {\n', '        return now;\n', '    }\n', '    \n', '    /// @dev set initial message\n', '    function setInitialVaribles(address _walletAddress, address _teamAddress) public onlyOwner {\n', '        walletAddress = _walletAddress;\n', '        teamAddress = _teamAddress;\n', '    }\n', '    \n', '    /// @dev withDraw Ether to a Safe Wallet\n', '    function withDraw(address _etherAddress) public payable onlyOwner {\n', '        require (_etherAddress != address(0));\n', '        address contractAddress = this;\n', '        _etherAddress.transfer(contractAddress.balance);\n', '    }\n', '    \n', '    /// @dev allocate Token\n', '    function allocateTokens(address[] _owners, uint256[] _values) public onlyOwner {\n', '        require (_owners.length == _values.length);\n', '        for(uint256 i = 0; i < _owners.length ; i++){\n', '            address owner = _owners[i];\n', '            uint256 value = _values[i];\n', '            mintTokens(owner, value);\n', '        }\n', '    }\n', '    \n', '    /// @dev allocate token for Team Address\n', '    function allocateTeamToken() public onlyOwner {\n', '        require(balances[teamAddress] == 0);\n', '        mintTokens(teamAddress, teamSupply);\n', '        teamAddressFreezeTime = now;\n', '    }\n', '    \n', '    function allocateCommunityToken (address[] _commnityAddress, uint256[] _amount) public onlyOwner {\n', '        communityAllocating = mintMultiToken(_commnityAddress, _amount, communityAllocating);\n', '        require (communityAllocating <= communitySupply);\n', '    }\n', '    /// @dev allocate token for Private Address\n', '    function allocateCreationInvestmentingToken(address[] _creationInvestmentingingAddress, uint256[] _amount) public onlyOwner {\n', '        creationInvestmenting = mintMultiToken(_creationInvestmentingingAddress, _amount, creationInvestmenting);\n', '        require (creationInvestmenting <= creationInvestmentSupply);\n', '    }\n', '    \n', '    /// @dev allocate token for contributors Address\n', '    function allocateAngelWheelFinanceToken(address[] _angelWheelFinancingAddress, uint256[] _amount) public onlyOwner {\n', '        //require(balances[contributorsAddress] == 0);\n', '        angelWheelFinancing = mintMultiToken(_angelWheelFinancingAddress, _amount, angelWheelFinancing);\n', '        require (angelWheelFinancing <= angelWheelFinanceSupply);\n', '    }\n', '    \n', '    function mintMultiToken (address[] _multiAddr, uint256[] _multiAmount, uint256 _target) internal returns (uint256){\n', '        require (_multiAddr.length == _multiAmount.length);\n', '        for(uint256 i = 0; i < _multiAddr.length ; i++){\n', '            address owner = _multiAddr[i];\n', '            uint256 value = _multiAmount[i];\n', '            _target = _target.add(value);\n', '            mintTokens(owner, value);\n', '        }\n', '        return _target;\n', '    }\n', '}']