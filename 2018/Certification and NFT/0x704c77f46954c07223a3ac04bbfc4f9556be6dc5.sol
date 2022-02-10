['/**\n', ' * @title SafeMath\n', ' * @dev Math operations that are safe for uint256 against overflow and negative values\n', ' * @dev https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', ' */\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Moderated\n', ' * @dev restricts execution of &#39;onlyModerator&#39; modified functions to the contract moderator\n', ' * @dev restricts execution of &#39;ifUnrestricted&#39; modified functions to when unrestricted\n', ' *      boolean state is true\n', ' * @dev allows for the extraction of ether or other ERC20 tokens mistakenly sent to this address\n', ' */\n', 'contract Moderated {\n', '\n', '    address public moderator;\n', '\n', '    bool public unrestricted;\n', '\n', '    modifier onlyModerator {\n', '        require(msg.sender == moderator);\n', '        _;\n', '    }\n', '\n', '    modifier ifUnrestricted {\n', '        require(unrestricted);\n', '        _;\n', '    }\n', '\n', '    modifier onlyPayloadSize(uint numWords) {\n', '        assert(msg.data.length >= numWords * 32 + 4);\n', '        _;\n', '    }\n', '\n', '    function Moderated() public {\n', '        moderator = msg.sender;\n', '        unrestricted = true;\n', '    }\n', '\n', '    function reassignModerator(address newModerator) public onlyModerator {\n', '        moderator = newModerator;\n', '    }\n', '\n', '    function restrict() public onlyModerator {\n', '        unrestricted = false;\n', '    }\n', '\n', '    function unrestrict() public onlyModerator {\n', '        unrestricted = true;\n', '    }\n', '\n', '    /// This method can be used to extract tokens mistakenly sent to this contract.\n', '    /// @param _token The address of the token contract that you want to recover\n', '    function extract(address _token) public returns (bool) {\n', '        require(_token != address(0x0));\n', '        Token token = Token(_token);\n', '        uint256 balance = token.balanceOf(this);\n', '        return token.transfer(moderator, balance);\n', '    }\n', '\n', '    function isContract(address _addr) internal view returns (bool) {\n', '        uint256 size;\n', '        assembly { size := extcodesize(_addr) }\n', '        return (size > 0);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract Token {\n', '\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '}\n', '\n', '// @dev Assign moderation of contract to CrowdSale\n', '\n', 'contract Touch is Moderated {\n', '\tusing SafeMath for uint256;\n', '\n', '\t\tstring public name = "Touch. Token";\n', '\t\tstring public symbol = "TST";\n', '\t\tuint8 public decimals = 18;\n', '\n', '        uint256 public maximumTokenIssue = 1000000000 * 10**18;\n', '\n', '\t\tmapping(address => uint256) internal balances;\n', '\t\tmapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\t\tuint256 internal totalSupply_;\n', '\n', '\t\tevent Approval(address indexed owner, address indexed spender, uint256 value);\n', '\t\tevent Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\t\t/**\n', '\t\t* @dev total number of tokens in existence\n', '\t\t*/\n', '\t\tfunction totalSupply() public view returns (uint256) {\n', '\t\t\treturn totalSupply_;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev transfer token for a specified address\n', '\t\t* @param _to The address to transfer to.\n', '\t\t* @param _value The amount to be transferred.\n', '\t\t*/\n', '\t\tfunction transfer(address _to, uint256 _value) public ifUnrestricted onlyPayloadSize(2) returns (bool) {\n', '\t\t    return _transfer(msg.sender, _to, _value);\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Transfer tokens from one address to another\n', '\t\t* @param _from address The address which you want to send tokens from\n', '\t\t* @param _to address The address which you want to transfer to\n', '\t\t* @param _value uint256 the amount of tokens to be transferred\n', '\t\t*/\n', '\t\tfunction transferFrom(address _from, address _to, uint256 _value) public ifUnrestricted onlyPayloadSize(3) returns (bool) {\n', '\t\t    require(_value <= allowed[_from][msg.sender]);\n', '\t\t    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\t\t    return _transfer(_from, _to, _value);\n', '\t\t}\n', '\n', '\t\tfunction _transfer(address _from, address _to, uint256 _value) internal returns (bool) {\n', '\t\t\t// Do not allow transfers to 0x0 or to this contract\n', '\t\t\trequire(_to != address(0x0) && _to != address(this));\n', '\t\t\t// Do not allow transfer of value greater than sender&#39;s current balance\n', '\t\t\trequire(_value <= balances[_from]);\n', '\t\t\t// Update balance of sending address\n', '\t\t\tbalances[_from] = balances[_from].sub(_value);\n', '\t\t\t// Update balance of receiving address\n', '\t\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\t\t// An event to make the transfer easy to find on the blockchain\n', '\t\t\tTransfer(_from, _to, _value);\n', '\t\t\treturn true;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Gets the balance of the specified address.\n', '\t\t* @param _owner The address to query the the balance of.\n', '\t\t* @return An uint256 representing the amount owned by the passed address.\n', '\t\t*/\n', '\t\tfunction balanceOf(address _owner) public view returns (uint256) {\n', '\t\t\treturn balances[_owner];\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '\t\t*\n', '\t\t* Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '\t\t* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '\t\t* race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '\t\t* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\t\t* @param _spender The address which will spend the funds.\n', '\t\t* @param _value The amount of tokens to be spent.\n', '\t\t*/\n', '\t\tfunction approve(address _spender, uint256 _value) public ifUnrestricted onlyPayloadSize(2) returns (bool sucess) {\n', '\t\t\t// Can only approve when value has not already been set or is zero\n', '\t\t\trequire(allowed[msg.sender][_spender] == 0 || _value == 0);\n', '\t\t\tallowed[msg.sender][_spender] = _value;\n', '\t\t\tApproval(msg.sender, _spender, _value);\n', '\t\t\treturn true;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '\t\t* @param _owner address The address which owns the funds.\n', '\t\t* @param _spender address The address which will spend the funds.\n', '\t\t* @return A uint256 specifying the amount of tokens still available for the spender.\n', '\t\t*/\n', '\t\tfunction allowance(address _owner, address _spender) public view returns (uint256) {\n', '\t\t\treturn allowed[_owner][_spender];\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Increase the amount of tokens that an owner allowed to a spender.\n', '\t\t*\n', '\t\t* approve should be called when allowed[_spender] == 0. To increment\n', '\t\t* allowed value is better to use this function to avoid 2 calls (and wait until\n', '\t\t* the first transaction is mined)\n', '\t\t* From MonolithDAO Token.sol\n', '\t\t* @param _spender The address which will spend the funds.\n', '\t\t* @param _addedValue The amount of tokens to increase the allowance by.\n', '\t\t*/\n', '\t\tfunction increaseApproval(address _spender, uint256 _addedValue) public ifUnrestricted onlyPayloadSize(2) returns (bool) {\n', '\t\t\trequire(_addedValue > 0);\n', '\t\t\tallowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '\t\t\tApproval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\t\t\treturn true;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '\t\t*\n', '\t\t* approve should be called when allowed[_spender] == 0. To decrement\n', '\t\t* allowed value is better to use this function to avoid 2 calls (and wait until\n', '\t\t* the first transaction is mined)\n', '\t\t* From MonolithDAO Token.sol\n', '\t\t* @param _spender The address which will spend the funds.\n', '\t\t* @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '\t\t*/\n', '\t\tfunction decreaseApproval(address _spender, uint256 _subtractedValue) public ifUnrestricted onlyPayloadSize(2) returns (bool) {\n', '\t\t\tuint256 oldValue = allowed[msg.sender][_spender];\n', '\t\t\trequire(_subtractedValue > 0);\n', '\t\t\tif (_subtractedValue > oldValue) {\n', '\t\t\t\tallowed[msg.sender][_spender] = 0;\n', '\t\t\t} else {\n', '\t\t\t\tallowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '\t\t\t}\n', '\t\t\tApproval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\t\t\treturn true;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Function to mint tokens\n', '\t\t* @param _to The address that will receive the minted tokens.\n', '\t\t* @param _amount The amount of tokens to mint.\n', '\t\t* @return A boolean that indicates if the operation was successful.\n', '\t\t*/\n', '\t\tfunction generateTokens(address _to, uint _amount) internal returns (bool) {\n', '\t\t\ttotalSupply_ = totalSupply_.add(_amount);\n', '\t\t\tbalances[_to] = balances[_to].add(_amount);\n', '\t\t\tTransfer(address(0x0), _to, _amount);\n', '\t\t\treturn true;\n', '\t\t}\n', '\t\t/**\n', '\t\t* @dev fallback function - reverts transaction\n', '\t\t*/\n', '    \tfunction () external payable {\n', '    \t    revert();\n', '    \t}\n', '\n', '    \tfunction Touch () public {\n', '    \t\tgenerateTokens(msg.sender, maximumTokenIssue);\n', '    \t}\n', '\n', '}\n', '\n', 'contract CrowdSale is Moderated {\n', '\tusing SafeMath for uint256;\n', '\n', '        address public recipient1 = 0x375D7f6bf5109E8e7d27d880EC4E7F362f77D275; // @TODO: replace this!\n', '        address public recipient2 = 0x2D438367B806537a76B97F50B94086898aE5C518; // @TODO: replace this!\n', '        address public recipient3 = 0xd198258038b2f96F8d81Bb04e1ccbfC2B3c46760; // @TODO: replace this!\n', '        uint public percentageRecipient1 = 35;\n', '        uint public percentageRecipient2 = 35;\n', '        uint public percentageRecipient3 = 30;\n', '\n', '\t// Touch ERC20 smart contract\n', '\tTouch public tokenContract;\n', '\n', '    uint256 public startDate;\n', '\n', '    uint256 public endDate;\n', '\n', '    // crowdsale aims to sell 100 Million TST\n', '    uint256 public constant crowdsaleTarget = 22289 ether;\n', '    // running total of tokens sold\n', '    uint256 public etherRaised;\n', '\n', '    // address to receive accumulated ether given a successful crowdsale\n', '\taddress public etherVault;\n', '\n', '    // minimum of 0.005 ether to participate in crowdsale\n', '\tuint256 constant purchaseThreshold = 5 finney;\n', '\n', '    // boolean to indicate crowdsale finalized state\n', '\tbool public isFinalized = false;\n', '\n', '\tbool public active = false;\n', '\n', '\t// finalization event\n', '\tevent Finalized();\n', '\n', '\t// purchase event\n', '\tevent Purchased(address indexed purchaser, uint256 indexed tokens);\n', '\n', '    // checks that crowd sale is live\n', '    modifier onlyWhileActive {\n', '        require(now >= startDate && now <= endDate && active);\n', '        _;\n', '    }\n', '\n', '    function CrowdSale( address _tokenAddr,\n', '                        uint256 start,\n', '                        uint256 end) public {\n', '        require(_tokenAddr != address(0x0));\n', '        require(now < start && start < end);\n', '        // the Touch token contract\n', '        tokenContract = Touch(_tokenAddr);\n', '\n', '        etherVault = msg.sender;\n', '\n', '        startDate = start;\n', '        endDate = end;\n', '    }\n', '\n', '\t// fallback function invokes buyTokens method\n', '\tfunction () external payable {\n', '\t    buyTokens(msg.sender);\n', '\t}\n', '\n', '\tfunction buyTokens(address _purchaser) public payable ifUnrestricted onlyWhileActive returns (bool) {\n', '\t    require(!targetReached());\n', '\t    require(msg.value > purchaseThreshold);\n', '\t   // etherVault.transfer(msg.value);\n', '\t   splitPayment();\n', '\n', '\t    uint256 _tokens = calculate(msg.value);\n', '        // approve CrowdSale to spend 100 000 000 tokens on behalf of moderator\n', '        require(tokenContract.transferFrom(moderator,_purchaser,_tokens));\n', '\t\t//require(tokenContract.generateTokens(_purchaser, _tokens));\n', '        Purchased(_purchaser, _tokens);\n', '        return true;\n', '\t}\n', '\n', '\tfunction calculate(uint256 weiAmount) internal returns(uint256) {\n', '\t    uint256 excess;\n', '\t    uint256 numTokens;\n', '\t    uint256 excessTokens;\n', '        if(etherRaised < 5572 ether) {\n', '            etherRaised = etherRaised.add(weiAmount);\n', '            if(etherRaised > 5572 ether) {\n', '                excess = etherRaised.sub(5572 ether);\n', '                numTokens = weiAmount.sub(excess).mul(5608);\n', '                etherRaised = etherRaised.sub(excess);\n', '                excessTokens = calculate(excess);\n', '                return numTokens + excessTokens;\n', '            } else {\n', '                return weiAmount.mul(5608);\n', '            }\n', '        } else if(etherRaised < 11144 ether) {\n', '            etherRaised = etherRaised.add(weiAmount);\n', '            if(etherRaised > 11144 ether) {\n', '                excess = etherRaised.sub(11144 ether);\n', '                numTokens = weiAmount.sub(excess).mul(4807);\n', '                etherRaised = etherRaised.sub(excess);\n', '                excessTokens = calculate(excess);\n', '                return numTokens + excessTokens;\n', '            } else {\n', '                return weiAmount.mul(4807);\n', '            }\n', '        } else if(etherRaised < 16716 ether) {\n', '            etherRaised = etherRaised.add(weiAmount);\n', '            if(etherRaised > 16716 ether) {\n', '                excess = etherRaised.sub(16716 ether);\n', '                numTokens = weiAmount.sub(excess).mul(4206);\n', '                etherRaised = etherRaised.sub(excess);\n', '                excessTokens = calculate(excess);\n', '                return numTokens + excessTokens;\n', '            } else {\n', '                return weiAmount.mul(4206);\n', '            }\n', '        } else if(etherRaised < 22289 ether) {\n', '            etherRaised = etherRaised.add(weiAmount);\n', '            if(etherRaised > 22289 ether) {\n', '                excess = etherRaised.sub(22289 ether);\n', '                numTokens = weiAmount.sub(excess).mul(3738);\n', '                etherRaised = etherRaised.sub(excess);\n', '                excessTokens = calculate(excess);\n', '                return numTokens + excessTokens;\n', '            } else {\n', '                return weiAmount.mul(3738);\n', '            }\n', '        } else {\n', '            etherRaised = etherRaised.add(weiAmount);\n', '            return weiAmount.mul(3738);\n', '        }\n', '\t}\n', '\n', '\n', '    function changeEtherVault(address newEtherVault) public onlyModerator {\n', '        require(newEtherVault != address(0x0));\n', '        etherVault = newEtherVault;\n', '\n', '}\n', '\n', '\n', '    function initialize() public onlyModerator {\n', '        // assign Touch moderator to this contract address\n', '        // assign moderator of this contract to crowdsale manager address\n', '        require(tokenContract.allowance(moderator, address(this)) == 102306549000000000000000000);\n', '        active = true;\n', '        // send approve from moderator account allowing for 100 million tokens\n', '        // spendable by this contract\n', '    }\n', '\n', '\t// activates end of crowdsale state\n', '    function finalize() public onlyModerator {\n', '        // cannot have been invoked before\n', '        require(!isFinalized);\n', '        // can only be invoked after end date or if target has been reached\n', '        require(hasEnded() || targetReached());\n', '\n', '        active = false;\n', '\n', '        // emit Finalized event\n', '        Finalized();\n', '        // set isFinalized boolean to true\n', '        isFinalized = true;\n', '    }\n', '\n', '\t// checks if end date of crowdsale is passed\n', '    function hasEnded() internal view returns (bool) {\n', '        return (now > endDate);\n', '    }\n', '\n', '    // checks if crowdsale target is reached\n', '    function targetReached() internal view returns (bool) {\n', '        return (etherRaised >= crowdsaleTarget);\n', '    }\n', '    function splitPayment() internal {\n', '        recipient1.transfer(msg.value * percentageRecipient1 / 100);\n', '        recipient2.transfer(msg.value * percentageRecipient2 / 100);\n', '        recipient3.transfer(msg.value * percentageRecipient3 / 100);\n', '    }\n', '\n', '}']
['/**\n', ' * @title SafeMath\n', ' * @dev Math operations that are safe for uint256 against overflow and negative values\n', ' * @dev https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol\n', ' */\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Moderated\n', " * @dev restricts execution of 'onlyModerator' modified functions to the contract moderator\n", " * @dev restricts execution of 'ifUnrestricted' modified functions to when unrestricted\n", ' *      boolean state is true\n', ' * @dev allows for the extraction of ether or other ERC20 tokens mistakenly sent to this address\n', ' */\n', 'contract Moderated {\n', '\n', '    address public moderator;\n', '\n', '    bool public unrestricted;\n', '\n', '    modifier onlyModerator {\n', '        require(msg.sender == moderator);\n', '        _;\n', '    }\n', '\n', '    modifier ifUnrestricted {\n', '        require(unrestricted);\n', '        _;\n', '    }\n', '\n', '    modifier onlyPayloadSize(uint numWords) {\n', '        assert(msg.data.length >= numWords * 32 + 4);\n', '        _;\n', '    }\n', '\n', '    function Moderated() public {\n', '        moderator = msg.sender;\n', '        unrestricted = true;\n', '    }\n', '\n', '    function reassignModerator(address newModerator) public onlyModerator {\n', '        moderator = newModerator;\n', '    }\n', '\n', '    function restrict() public onlyModerator {\n', '        unrestricted = false;\n', '    }\n', '\n', '    function unrestrict() public onlyModerator {\n', '        unrestricted = true;\n', '    }\n', '\n', '    /// This method can be used to extract tokens mistakenly sent to this contract.\n', '    /// @param _token The address of the token contract that you want to recover\n', '    function extract(address _token) public returns (bool) {\n', '        require(_token != address(0x0));\n', '        Token token = Token(_token);\n', '        uint256 balance = token.balanceOf(this);\n', '        return token.transfer(moderator, balance);\n', '    }\n', '\n', '    function isContract(address _addr) internal view returns (bool) {\n', '        uint256 size;\n', '        assembly { size := extcodesize(_addr) }\n', '        return (size > 0);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract Token {\n', '\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '}\n', '\n', '// @dev Assign moderation of contract to CrowdSale\n', '\n', 'contract Touch is Moderated {\n', '\tusing SafeMath for uint256;\n', '\n', '\t\tstring public name = "Touch. Token";\n', '\t\tstring public symbol = "TST";\n', '\t\tuint8 public decimals = 18;\n', '\n', '        uint256 public maximumTokenIssue = 1000000000 * 10**18;\n', '\n', '\t\tmapping(address => uint256) internal balances;\n', '\t\tmapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\t\tuint256 internal totalSupply_;\n', '\n', '\t\tevent Approval(address indexed owner, address indexed spender, uint256 value);\n', '\t\tevent Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '\t\t/**\n', '\t\t* @dev total number of tokens in existence\n', '\t\t*/\n', '\t\tfunction totalSupply() public view returns (uint256) {\n', '\t\t\treturn totalSupply_;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev transfer token for a specified address\n', '\t\t* @param _to The address to transfer to.\n', '\t\t* @param _value The amount to be transferred.\n', '\t\t*/\n', '\t\tfunction transfer(address _to, uint256 _value) public ifUnrestricted onlyPayloadSize(2) returns (bool) {\n', '\t\t    return _transfer(msg.sender, _to, _value);\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Transfer tokens from one address to another\n', '\t\t* @param _from address The address which you want to send tokens from\n', '\t\t* @param _to address The address which you want to transfer to\n', '\t\t* @param _value uint256 the amount of tokens to be transferred\n', '\t\t*/\n', '\t\tfunction transferFrom(address _from, address _to, uint256 _value) public ifUnrestricted onlyPayloadSize(3) returns (bool) {\n', '\t\t    require(_value <= allowed[_from][msg.sender]);\n', '\t\t    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\t\t    return _transfer(_from, _to, _value);\n', '\t\t}\n', '\n', '\t\tfunction _transfer(address _from, address _to, uint256 _value) internal returns (bool) {\n', '\t\t\t// Do not allow transfers to 0x0 or to this contract\n', '\t\t\trequire(_to != address(0x0) && _to != address(this));\n', "\t\t\t// Do not allow transfer of value greater than sender's current balance\n", '\t\t\trequire(_value <= balances[_from]);\n', '\t\t\t// Update balance of sending address\n', '\t\t\tbalances[_from] = balances[_from].sub(_value);\n', '\t\t\t// Update balance of receiving address\n', '\t\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\t\t// An event to make the transfer easy to find on the blockchain\n', '\t\t\tTransfer(_from, _to, _value);\n', '\t\t\treturn true;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Gets the balance of the specified address.\n', '\t\t* @param _owner The address to query the the balance of.\n', '\t\t* @return An uint256 representing the amount owned by the passed address.\n', '\t\t*/\n', '\t\tfunction balanceOf(address _owner) public view returns (uint256) {\n', '\t\t\treturn balances[_owner];\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '\t\t*\n', '\t\t* Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '\t\t* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "\t\t* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '\t\t* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '\t\t* @param _spender The address which will spend the funds.\n', '\t\t* @param _value The amount of tokens to be spent.\n', '\t\t*/\n', '\t\tfunction approve(address _spender, uint256 _value) public ifUnrestricted onlyPayloadSize(2) returns (bool sucess) {\n', '\t\t\t// Can only approve when value has not already been set or is zero\n', '\t\t\trequire(allowed[msg.sender][_spender] == 0 || _value == 0);\n', '\t\t\tallowed[msg.sender][_spender] = _value;\n', '\t\t\tApproval(msg.sender, _spender, _value);\n', '\t\t\treturn true;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '\t\t* @param _owner address The address which owns the funds.\n', '\t\t* @param _spender address The address which will spend the funds.\n', '\t\t* @return A uint256 specifying the amount of tokens still available for the spender.\n', '\t\t*/\n', '\t\tfunction allowance(address _owner, address _spender) public view returns (uint256) {\n', '\t\t\treturn allowed[_owner][_spender];\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Increase the amount of tokens that an owner allowed to a spender.\n', '\t\t*\n', '\t\t* approve should be called when allowed[_spender] == 0. To increment\n', '\t\t* allowed value is better to use this function to avoid 2 calls (and wait until\n', '\t\t* the first transaction is mined)\n', '\t\t* From MonolithDAO Token.sol\n', '\t\t* @param _spender The address which will spend the funds.\n', '\t\t* @param _addedValue The amount of tokens to increase the allowance by.\n', '\t\t*/\n', '\t\tfunction increaseApproval(address _spender, uint256 _addedValue) public ifUnrestricted onlyPayloadSize(2) returns (bool) {\n', '\t\t\trequire(_addedValue > 0);\n', '\t\t\tallowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '\t\t\tApproval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\t\t\treturn true;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '\t\t*\n', '\t\t* approve should be called when allowed[_spender] == 0. To decrement\n', '\t\t* allowed value is better to use this function to avoid 2 calls (and wait until\n', '\t\t* the first transaction is mined)\n', '\t\t* From MonolithDAO Token.sol\n', '\t\t* @param _spender The address which will spend the funds.\n', '\t\t* @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '\t\t*/\n', '\t\tfunction decreaseApproval(address _spender, uint256 _subtractedValue) public ifUnrestricted onlyPayloadSize(2) returns (bool) {\n', '\t\t\tuint256 oldValue = allowed[msg.sender][_spender];\n', '\t\t\trequire(_subtractedValue > 0);\n', '\t\t\tif (_subtractedValue > oldValue) {\n', '\t\t\t\tallowed[msg.sender][_spender] = 0;\n', '\t\t\t} else {\n', '\t\t\t\tallowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '\t\t\t}\n', '\t\t\tApproval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '\t\t\treturn true;\n', '\t\t}\n', '\n', '\t\t/**\n', '\t\t* @dev Function to mint tokens\n', '\t\t* @param _to The address that will receive the minted tokens.\n', '\t\t* @param _amount The amount of tokens to mint.\n', '\t\t* @return A boolean that indicates if the operation was successful.\n', '\t\t*/\n', '\t\tfunction generateTokens(address _to, uint _amount) internal returns (bool) {\n', '\t\t\ttotalSupply_ = totalSupply_.add(_amount);\n', '\t\t\tbalances[_to] = balances[_to].add(_amount);\n', '\t\t\tTransfer(address(0x0), _to, _amount);\n', '\t\t\treturn true;\n', '\t\t}\n', '\t\t/**\n', '\t\t* @dev fallback function - reverts transaction\n', '\t\t*/\n', '    \tfunction () external payable {\n', '    \t    revert();\n', '    \t}\n', '\n', '    \tfunction Touch () public {\n', '    \t\tgenerateTokens(msg.sender, maximumTokenIssue);\n', '    \t}\n', '\n', '}\n', '\n', 'contract CrowdSale is Moderated {\n', '\tusing SafeMath for uint256;\n', '\n', '        address public recipient1 = 0x375D7f6bf5109E8e7d27d880EC4E7F362f77D275; // @TODO: replace this!\n', '        address public recipient2 = 0x2D438367B806537a76B97F50B94086898aE5C518; // @TODO: replace this!\n', '        address public recipient3 = 0xd198258038b2f96F8d81Bb04e1ccbfC2B3c46760; // @TODO: replace this!\n', '        uint public percentageRecipient1 = 35;\n', '        uint public percentageRecipient2 = 35;\n', '        uint public percentageRecipient3 = 30;\n', '\n', '\t// Touch ERC20 smart contract\n', '\tTouch public tokenContract;\n', '\n', '    uint256 public startDate;\n', '\n', '    uint256 public endDate;\n', '\n', '    // crowdsale aims to sell 100 Million TST\n', '    uint256 public constant crowdsaleTarget = 22289 ether;\n', '    // running total of tokens sold\n', '    uint256 public etherRaised;\n', '\n', '    // address to receive accumulated ether given a successful crowdsale\n', '\taddress public etherVault;\n', '\n', '    // minimum of 0.005 ether to participate in crowdsale\n', '\tuint256 constant purchaseThreshold = 5 finney;\n', '\n', '    // boolean to indicate crowdsale finalized state\n', '\tbool public isFinalized = false;\n', '\n', '\tbool public active = false;\n', '\n', '\t// finalization event\n', '\tevent Finalized();\n', '\n', '\t// purchase event\n', '\tevent Purchased(address indexed purchaser, uint256 indexed tokens);\n', '\n', '    // checks that crowd sale is live\n', '    modifier onlyWhileActive {\n', '        require(now >= startDate && now <= endDate && active);\n', '        _;\n', '    }\n', '\n', '    function CrowdSale( address _tokenAddr,\n', '                        uint256 start,\n', '                        uint256 end) public {\n', '        require(_tokenAddr != address(0x0));\n', '        require(now < start && start < end);\n', '        // the Touch token contract\n', '        tokenContract = Touch(_tokenAddr);\n', '\n', '        etherVault = msg.sender;\n', '\n', '        startDate = start;\n', '        endDate = end;\n', '    }\n', '\n', '\t// fallback function invokes buyTokens method\n', '\tfunction () external payable {\n', '\t    buyTokens(msg.sender);\n', '\t}\n', '\n', '\tfunction buyTokens(address _purchaser) public payable ifUnrestricted onlyWhileActive returns (bool) {\n', '\t    require(!targetReached());\n', '\t    require(msg.value > purchaseThreshold);\n', '\t   // etherVault.transfer(msg.value);\n', '\t   splitPayment();\n', '\n', '\t    uint256 _tokens = calculate(msg.value);\n', '        // approve CrowdSale to spend 100 000 000 tokens on behalf of moderator\n', '        require(tokenContract.transferFrom(moderator,_purchaser,_tokens));\n', '\t\t//require(tokenContract.generateTokens(_purchaser, _tokens));\n', '        Purchased(_purchaser, _tokens);\n', '        return true;\n', '\t}\n', '\n', '\tfunction calculate(uint256 weiAmount) internal returns(uint256) {\n', '\t    uint256 excess;\n', '\t    uint256 numTokens;\n', '\t    uint256 excessTokens;\n', '        if(etherRaised < 5572 ether) {\n', '            etherRaised = etherRaised.add(weiAmount);\n', '            if(etherRaised > 5572 ether) {\n', '                excess = etherRaised.sub(5572 ether);\n', '                numTokens = weiAmount.sub(excess).mul(5608);\n', '                etherRaised = etherRaised.sub(excess);\n', '                excessTokens = calculate(excess);\n', '                return numTokens + excessTokens;\n', '            } else {\n', '                return weiAmount.mul(5608);\n', '            }\n', '        } else if(etherRaised < 11144 ether) {\n', '            etherRaised = etherRaised.add(weiAmount);\n', '            if(etherRaised > 11144 ether) {\n', '                excess = etherRaised.sub(11144 ether);\n', '                numTokens = weiAmount.sub(excess).mul(4807);\n', '                etherRaised = etherRaised.sub(excess);\n', '                excessTokens = calculate(excess);\n', '                return numTokens + excessTokens;\n', '            } else {\n', '                return weiAmount.mul(4807);\n', '            }\n', '        } else if(etherRaised < 16716 ether) {\n', '            etherRaised = etherRaised.add(weiAmount);\n', '            if(etherRaised > 16716 ether) {\n', '                excess = etherRaised.sub(16716 ether);\n', '                numTokens = weiAmount.sub(excess).mul(4206);\n', '                etherRaised = etherRaised.sub(excess);\n', '                excessTokens = calculate(excess);\n', '                return numTokens + excessTokens;\n', '            } else {\n', '                return weiAmount.mul(4206);\n', '            }\n', '        } else if(etherRaised < 22289 ether) {\n', '            etherRaised = etherRaised.add(weiAmount);\n', '            if(etherRaised > 22289 ether) {\n', '                excess = etherRaised.sub(22289 ether);\n', '                numTokens = weiAmount.sub(excess).mul(3738);\n', '                etherRaised = etherRaised.sub(excess);\n', '                excessTokens = calculate(excess);\n', '                return numTokens + excessTokens;\n', '            } else {\n', '                return weiAmount.mul(3738);\n', '            }\n', '        } else {\n', '            etherRaised = etherRaised.add(weiAmount);\n', '            return weiAmount.mul(3738);\n', '        }\n', '\t}\n', '\n', '\n', '    function changeEtherVault(address newEtherVault) public onlyModerator {\n', '        require(newEtherVault != address(0x0));\n', '        etherVault = newEtherVault;\n', '\n', '}\n', '\n', '\n', '    function initialize() public onlyModerator {\n', '        // assign Touch moderator to this contract address\n', '        // assign moderator of this contract to crowdsale manager address\n', '        require(tokenContract.allowance(moderator, address(this)) == 102306549000000000000000000);\n', '        active = true;\n', '        // send approve from moderator account allowing for 100 million tokens\n', '        // spendable by this contract\n', '    }\n', '\n', '\t// activates end of crowdsale state\n', '    function finalize() public onlyModerator {\n', '        // cannot have been invoked before\n', '        require(!isFinalized);\n', '        // can only be invoked after end date or if target has been reached\n', '        require(hasEnded() || targetReached());\n', '\n', '        active = false;\n', '\n', '        // emit Finalized event\n', '        Finalized();\n', '        // set isFinalized boolean to true\n', '        isFinalized = true;\n', '    }\n', '\n', '\t// checks if end date of crowdsale is passed\n', '    function hasEnded() internal view returns (bool) {\n', '        return (now > endDate);\n', '    }\n', '\n', '    // checks if crowdsale target is reached\n', '    function targetReached() internal view returns (bool) {\n', '        return (etherRaised >= crowdsaleTarget);\n', '    }\n', '    function splitPayment() internal {\n', '        recipient1.transfer(msg.value * percentageRecipient1 / 100);\n', '        recipient2.transfer(msg.value * percentageRecipient2 / 100);\n', '        recipient3.transfer(msg.value * percentageRecipient3 / 100);\n', '    }\n', '\n', '}']
