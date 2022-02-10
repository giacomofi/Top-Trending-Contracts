['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath\n', '{\n', '    function mul(uint256 a, uint256 b) internal pure\n', '        returns (uint256)\n', '    {\n', '        uint256 c = a * b;\n', '\n', '        assert(a == 0 || c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure\n', '        returns (uint256)\n', '    {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure\n', '        returns (uint256)\n', '    {\n', '        assert(b <= a);\n', '\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure\n', '        returns (uint256)\n', '    {\n', '        uint256 c = a + b;\n', '\n', '        assert(c >= a);\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable\n', '{\n', '    address owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface tokenRecipient\n', '{\n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;\n', '}\n', '\n', 'contract TokenERC20 is Ownable\n', '{\n', '    using SafeMath for uint;\n', '\n', '    // Public variables of the token\n', '    string public name;\n', '    string public symbol;\n', '    uint256 public decimals = 18;\n', '    uint256 DEC = 10 ** uint256(decimals);\n', '    uint256 public totalSupply;\n', '    uint256 public avaliableSupply;\n', '    uint256 public buyPrice = 1000000000000000000 wei;\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    // This generates a public event on the blockchain that will notify clients\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Burn(address indexed from, uint256 value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    /**\n', '     * Constrctor function\n', '     *\n', '     * Initializes contract with initial supply tokens to the creator of the contract\n', '     */\n', '    function TokenERC20(\n', '        uint256 initialSupply,\n', '        string tokenName,\n', '        string tokenSymbol\n', '    ) public\n', '    {\n', '        totalSupply = initialSupply.mul(DEC);  // Update total supply with the decimal amount\n', '        balanceOf[this] = totalSupply;         // Give the creator all initial tokens\n', '        avaliableSupply = balanceOf[this];     // Show how much tokens on contract\n', '        name = tokenName;                      // Set the name for display purposes\n', '        symbol = tokenSymbol;                  // Set the symbol for display purposes\n', '    }\n', '\n', '    /**\n', '     * Internal transfer, only can be called by this contract\n', '     *\n', '     * @param _from - address of the contract\n', '     * @param _to - address of the investor\n', '     * @param _value - tokens for the investor\n', '     */\n', '    function _transfer(address _from, address _to, uint256 _value) internal\n', '    {\n', '        // Prevent transfer to 0x0 address. Use burn() instead\n', '        require(_to != 0x0);\n', '        // Check if the sender has enough\n', '        require(balanceOf[_from] >= _value);\n', '        // Check for overflows\n', '        require(balanceOf[_to].add(_value) > balanceOf[_to]);\n', '        // Save this for an assertion in the future\n', '        uint previousBalances = balanceOf[_from].add(balanceOf[_to]);\n', '        // Subtract from the sender\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        // Add the same to the recipient\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        // Asserts are used to use static analysis to find bugs in your code. They should never fail\n', '        assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens\n', '     *\n', '     * Send `_value` tokens to `_to` from your account\n', '     *\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transfer(address _to, uint256 _value) public\n', '    {\n', '        _transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    /**\n', '     * Transfer tokens from other address\n', '     *\n', '     * Send `_value` tokens to `_to` in behalf of `_from`\n', '     *\n', '     * @param _from The address of the sender\n', '     * @param _to The address of the recipient\n', '     * @param _value the amount to send\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public\n', '        returns (bool success)\n', '    {\n', '        require(_value <= allowance[_from][msg.sender]);     // Check allowance\n', '\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        _transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     */\n', '    function approve(address _spender, uint256 _value) public\n', '        returns (bool success)\n', '    {\n', '        allowance[msg.sender][_spender] = _value;\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Set allowance for other address and notify\n', '     *\n', '     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it\n', '     *\n', '     * @param _spender The address authorized to spend\n', '     * @param _value the max amount they can spend\n', '     * @param _extraData some extra information to send to the approved contract\n', '     */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public onlyOwner\n', '        returns (bool success)\n', '    {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '\n', '            return true;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval (address _spender, uint _addedValue) public\n', '        returns (bool success)\n', '    {\n', '        allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_addedValue);\n', '\n', '        emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) public\n', '        returns (bool success)\n', '    {\n', '        uint oldValue = allowance[msg.sender][_spender];\n', '\n', '        if (_subtractedValue > oldValue) {\n', '            allowance[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '\n', '        emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly\n', '     *\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burn(uint256 _value) public onlyOwner\n', '        returns (bool success)\n', '    {\n', '        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough\n', '\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);  // Subtract from the sender\n', '        totalSupply = totalSupply.sub(_value);                      // Updates totalSupply\n', '        avaliableSupply = avaliableSupply.sub(_value);\n', '\n', '        emit Burn(msg.sender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     *\n', '     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.\n', '     *\n', '     * @param _from the address of the sender\n', '     * @param _value the amount of money to burn\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public onlyOwner\n', '        returns (bool success)\n', '    {\n', '        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowance[_from][msg.sender]);    // Check allowance\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance\n', '        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);    // Subtract from the sender&#39;s allowance\n', '        totalSupply = totalSupply.sub(_value);              // Update totalSupply\n', '        avaliableSupply = avaliableSupply.sub(_value);\n', '\n', '        emit Burn(_from, _value);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract ERC20Extending is TokenERC20\n', '{\n', '    using SafeMath for uint;\n', '\n', '    /**\n', '    * Function for transfer ethereum from contract to any address\n', '    *\n', '    * @param _to - address of the recipient\n', '    * @param amount - ethereum\n', '    */\n', '    function transferEthFromContract(address _to, uint256 amount) public onlyOwner\n', '    {\n', '        _to.transfer(amount);\n', '    }\n', '\n', '    /**\n', '    * Function for transfer tokens from contract to any address\n', '    *\n', '    */\n', '    function transferTokensFromContract(address _to, uint256 _value) public onlyOwner\n', '    {\n', '        avaliableSupply = avaliableSupply.sub(_value);\n', '        _transfer(this, _to, _value);\n', '    }\n', '}\n', '\n', 'contract Pauseble is TokenERC20\n', '{\n', '    event EPause();\n', '    event EUnpause();\n', '\n', '    bool public paused = true;\n', '    uint public startIcoDate = 0;\n', '\n', '    modifier whenNotPaused()\n', '    {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused()\n', '    {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    function pause() public onlyOwner\n', '    {\n', '        paused = true;\n', '        emit EPause();\n', '    }\n', '\n', '    function pauseInternal() internal\n', '    {\n', '        paused = true;\n', '        emit EPause();\n', '    }\n', '\n', '    function unpause() public onlyOwner\n', '    {\n', '        paused = false;\n', '        emit EUnpause();\n', '    }\n', '\n', '    function unpauseInternal() internal\n', '    {\n', '        paused = false;\n', '        emit EUnpause();\n', '    }\n', '}\n', '\n', 'contract StreamityCrowdsale is Pauseble\n', '{\n', '    using SafeMath for uint;\n', '\n', '    uint public stage = 0;\n', '\n', '    event CrowdSaleFinished(string info);\n', '\n', '    struct Ico {\n', '        uint256 tokens;             // Tokens in crowdsale\n', '        uint startDate;             // Date when crowsale will be starting, after its starting that property will be the 0\n', '        uint endDate;               // Date when crowdsale will be stop\n', '        uint8 discount;             // Discount\n', '        uint8 discountFirstDayICO;  // Discount. Only for first stage ico\n', '    }\n', '\n', '    Ico public ICO;\n', '\n', '    /**\n', '    * Expanding of the functionality\n', '    *\n', '    * @param _numerator - Numerator - value (10000)\n', '    * @param _denominator - Denominator - value (10000)\n', '    *\n', '    * example: price 1000 tokens by 1 ether = changeRate(1, 1000)\n', '    */\n', '    function changeRate(uint256 _numerator, uint256 _denominator) public onlyOwner\n', '        returns (bool success)\n', '    {\n', '        if (_numerator == 0) _numerator = 1;\n', '        if (_denominator == 0) _denominator = 1;\n', '\n', '        buyPrice = (_numerator.mul(DEC)).div(_denominator);\n', '\n', '        return true;\n', '    }\n', '\n', '    /*\n', '    * Function show in contract what is now\n', '    *\n', '    */\n', '    function crowdSaleStatus() internal constant\n', '        returns (string)\n', '    {\n', '        if (1 == stage) {\n', '            return "Pre-ICO";\n', '        } else if(2 == stage) {\n', '            return "ICO first stage";\n', '        } else if (3 == stage) {\n', '            return "ICO second stage";\n', '        } else if (4 >= stage) {\n', '            return "feature stage";\n', '        }\n', '\n', '        return "there is no stage at present";\n', '    }\n', '\n', '    /*\n', '    * Function for selling tokens in crowd time.\n', '    *\n', '    */\n', '    function sell(address _investor, uint256 amount) internal\n', '    {\n', '        uint256 _amount = (amount.mul(DEC)).div(buyPrice);\n', '\n', '        if (1 == stage) {\n', '            _amount = _amount.add(withDiscount(_amount, ICO.discount));\n', '        }\n', '        else if (2 == stage)\n', '        {\n', '            if (now <= ICO.startDate + 1 days)\n', '            {\n', '                  if (0 == ICO.discountFirstDayICO) {\n', '                      ICO.discountFirstDayICO = 20;\n', '                  }\n', '\n', '                  _amount = _amount.add(withDiscount(_amount, ICO.discountFirstDayICO));\n', '            } else {\n', '                _amount = _amount.add(withDiscount(_amount, ICO.discount));\n', '            }\n', '        } else if (3 == stage) {\n', '            _amount = _amount.add(withDiscount(_amount, ICO.discount));\n', '        }\n', '\n', '        if (ICO.tokens < _amount)\n', '        {\n', '            emit CrowdSaleFinished(crowdSaleStatus());\n', '            pauseInternal();\n', '\n', '            revert();\n', '        }\n', '\n', '        ICO.tokens = ICO.tokens.sub(_amount);\n', '        avaliableSupply = avaliableSupply.sub(_amount);\n', '\n', '        _transfer(this, _investor, _amount);\n', '    }\n', '\n', '    /*\n', '    * Function for start crowdsale (any)\n', '    *\n', '    * @param _tokens - How much tokens will have the crowdsale - amount humanlike value (10000)\n', '    * @param _startDate - When crowdsale will be start - unix timestamp (1512231703 )\n', '    * @param _endDate - When crowdsale will be end - humanlike value (7) same as 7 days\n', '    * @param _discount - Discount for the crowd - humanlive value (7) same as 7 %\n', '    * @param _discount - Discount for the crowds first day - humanlive value (7) same as 7 %\n', '    */\n', '    function startCrowd(uint256 _tokens, uint _startDate, uint _endDate, uint8 _discount, uint8 _discountFirstDayICO) public onlyOwner\n', '    {\n', '        require(_tokens * DEC <= avaliableSupply);  // require to set correct tokens value for crowd\n', '        startIcoDate = _startDate;\n', '        ICO = Ico (_tokens * DEC, _startDate, _startDate + _endDate * 1 days , _discount, _discountFirstDayICO);\n', '        stage = stage.add(1);\n', '        unpauseInternal();\n', '    }\n', '\n', '    /**\n', '    * Function for web3js, should be call when somebody will buy tokens from website. This function only delegator.\n', '    *\n', '    * @param _investor - address of investor (who payed)\n', '    * @param _amount - ethereum\n', '    */\n', '    function transferWeb3js(address _investor, uint256 _amount) external onlyOwner\n', '    {\n', '        sell(_investor, _amount);\n', '    }\n', '\n', '    /**\n', '    * Function for adding discount\n', '    *\n', '    */\n', '    function withDiscount(uint256 _amount, uint _percent) internal pure\n', '        returns (uint256)\n', '    {\n', '        return (_amount.mul(_percent)).div(100);\n', '    }\n', '}\n', '\n', 'contract StreamityContract is ERC20Extending, StreamityCrowdsale\n', '{\n', '    using SafeMath for uint;\n', '\n', '    uint public weisRaised;  // how many weis was raised on crowdsale\n', '\n', '    /* Streamity tokens Constructor */\n', '    function StreamityContract() public TokenERC20(130000000, "Streamity", "STM") {} //change before send !!!\n', '\n', '    /**\n', '    * Function payments handler\n', '    *\n', '    */\n', '    function () public payable\n', '    {\n', '        assert(msg.value >= 1 ether / 10);\n', '        require(now >= ICO.startDate);\n', '\n', '        if (now >= ICO.endDate) {\n', '            pauseInternal();\n', '            emit CrowdSaleFinished(crowdSaleStatus());\n', '        }\n', '\n', '\n', '        if (0 != startIcoDate) {\n', '            if (now < startIcoDate) {\n', '                revert();\n', '            } else {\n', '                startIcoDate = 0;\n', '            }\n', '        }\n', '\n', '        if (paused == false) {\n', '            sell(msg.sender, msg.value);\n', '            weisRaised = weisRaised.add(msg.value);\n', '        }\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Helps contracts guard agains reentrancy attacks.\n', ' * @author Remco Bloemen <remco@2π.com>\n', ' * @notice If you mark a function `nonReentrant`, you should also\n', ' * mark it `external`.\n', ' */\n', 'contract ReentrancyGuard {\n', '\n', '  /**\n', '   * @dev We use a single lock for the whole contract.\n', '   */\n', '  bool private reentrancy_lock = false;\n', '\n', '  /**\n', '   * @dev Prevents a contract from calling itself, directly or indirectly.\n', '   * @notice If you mark a function `nonReentrant`, you should also\n', '   * mark it `external`. Calling one nonReentrant function from\n', '   * another is not supported. Instead, you can implement a\n', '   * `private` function doing the actual work, and a `external`\n', '   * wrapper marked as `nonReentrant`.\n', '   */\n', '  modifier nonReentrant() {\n', '    require(!reentrancy_lock);\n', '    reentrancy_lock = true;\n', '    _;\n', '    reentrancy_lock = false;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title Eliptic curve signature operations\n', ' *\n', ' * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d\n', ' */\n', '\n', 'library ECRecovery {\n', '\n', '  /**\n', '   * @dev Recover signer address from a message by using his signature\n', '   * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.\n', '   * @param sig bytes signature, the signature is generated using web3.eth.sign()\n', '   */\n', '  function recover(bytes32 hash, bytes sig) public pure returns (address) {\n', '    bytes32 r;\n', '    bytes32 s;\n', '    uint8 v;\n', '\n', '    //Check the signature length\n', '    if (sig.length != 65) {\n', '      return (address(0));\n', '    }\n', '\n', '    // Divide the signature in r, s and v variables\n', '    assembly {\n', '      r := mload(add(sig, 32))\n', '      s := mload(add(sig, 64))\n', '      v := byte(0, mload(add(sig, 96)))\n', '    }\n', '\n', '    // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '    if (v < 27) {\n', '      v += 27;\n', '    }\n', '\n', '    // If the version is correct return the signer address\n', '    if (v != 27 && v != 28) {\n', '      return (address(0));\n', '    } else {\n', '      return ecrecover(hash, v, r, s);\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract ContractToken {\n', '    function transfer(address _to, uint _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success);\n', '    function approve(address _spender, uint _value) public returns (bool success);\n', '}\n', '\n', 'contract StreamityEscrow is Ownable, ReentrancyGuard {\n', '    using SafeMath for uint256;\n', '    using ECRecovery for bytes32;\n', '\n', '    uint8 constant public STATUS_NO_DEAL = 0x0;\n', '    uint8 constant public STATUS_DEAL_WAIT_CONFIRMATION = 0x01;\n', '    uint8 constant public STATUS_DEAL_APPROVE = 0x02;\n', '    uint8 constant public STATUS_DEAL_RELEASE = 0x03;\n', '\n', '    TokenERC20 public streamityContractAddress;\n', '    \n', '    uint256 public availableForWithdrawal;\n', '\n', '    uint32 public requestCancelationTime;\n', '\n', '    mapping(bytes32 => Deal) public streamityTransfers;\n', '\n', '    function StreamityEscrow(address streamityContract) public {\n', '        owner = msg.sender; \n', '        requestCancelationTime = 2 hours;\n', '        streamityContractAddress = TokenERC20(streamityContract);\n', '    }\n', '\n', '    struct Deal {\n', '        uint256 value;\n', '        uint256 cancelTime;\n', '        address seller;\n', '        address buyer;\n', '        uint8 status;\n', '        uint256 commission;\n', '        bool isAltCoin;\n', '    }\n', '\n', '    event StartDealEvent(bytes32 _hashDeal, address _seller, address _buyer);\n', '    event ApproveDealEvent(bytes32 _hashDeal, address _seller, address _buyer);\n', '    event ReleasedEvent(bytes32 _hashDeal, address _seller, address _buyer);\n', '    event SellerCancelEvent(bytes32 _hashDeal, address _seller, address _buyer);\n', '    \n', '    function pay(bytes32 _tradeID, address _seller, address _buyer, uint256 _value, uint256 _commission, bytes _sign) \n', '    external \n', '    payable \n', '    {\n', '        require(msg.value > 0);\n', '        require(msg.value == _value);\n', '        require(msg.value > _commission);\n', '        bytes32 _hashDeal = keccak256(_tradeID, _seller, _buyer, msg.value, _commission);\n', '        verifyDeal(_hashDeal, _sign);\n', '        startDealForUser(_hashDeal, _seller, _buyer, _commission, msg.value, false);\n', '    }\n', '\n', '    function () public payable {\n', '        availableForWithdrawal = availableForWithdrawal.add(msg.value);\n', '    }\n', '\n', '    function payAltCoin(bytes32 _tradeID, address _seller, address _buyer, uint256 _value, uint256 _commission, bytes _sign) \n', '    external \n', '    {\n', '        bytes32 _hashDeal = keccak256(_tradeID, _seller, _buyer, _value, _commission);\n', '        verifyDeal(_hashDeal, _sign);\n', '        bool result = streamityContractAddress.transferFrom(msg.sender, address(this), _value);\n', '        require(result == true);\n', '        startDealForUser(_hashDeal, _seller, _buyer, _commission, _value, true);\n', '    }\n', '\n', '    function verifyDeal(bytes32 _hashDeal, bytes _sign) private view {\n', '        require(_hashDeal.recover(_sign) == owner);\n', '        require(streamityTransfers[_hashDeal].status == STATUS_NO_DEAL); \n', '    }\n', '\n', '    function startDealForUser(bytes32 _hashDeal, address _seller, address _buyer, uint256 _commission, uint256 _value, bool isAltCoin) \n', '    private returns(bytes32) \n', '    {\n', '        Deal storage userDeals = streamityTransfers[_hashDeal];\n', '        userDeals.seller = _seller;\n', '        userDeals.buyer = _buyer;\n', '        userDeals.value = _value; \n', '        userDeals.commission = _commission; \n', '        userDeals.cancelTime = block.timestamp.add(requestCancelationTime); \n', '        userDeals.status = STATUS_DEAL_WAIT_CONFIRMATION;\n', '        userDeals.isAltCoin = isAltCoin;\n', '        emit StartDealEvent(_hashDeal, _seller, _buyer);\n', '        \n', '        return _hashDeal;\n', '    }\n', '\n', '    function withdrawCommisionToAddress(address _to, uint256 _amount) external onlyOwner {\n', '        require(_amount <= availableForWithdrawal); \n', '        availableForWithdrawal = availableForWithdrawal.sub(_amount);\n', '        _to.transfer(_amount);\n', '    }\n', '\n', '    function withdrawCommisionToAddressAltCoin(address _to, uint256 _amount) external onlyOwner {\n', '        streamityContractAddress.transfer(_to, _amount);\n', '    }\n', '\n', '    function getStatusDeal(bytes32 _hashDeal) external view returns (uint8) {\n', '        return streamityTransfers[_hashDeal].status;\n', '    }\n', '    \n', '    // _additionalComission is wei\n', '    uint256 constant GAS_releaseTokens = 60000;\n', '    function releaseTokens(bytes32 _hashDeal, uint256 _additionalGas) \n', '    external \n', '    nonReentrant\n', '    returns(bool) \n', '    {\n', '        Deal storage deal = streamityTransfers[_hashDeal];\n', '\n', '        if (deal.status == STATUS_DEAL_APPROVE) {\n', '            deal.status = STATUS_DEAL_RELEASE; \n', '            bool result = false;\n', '\n', '            if (deal.isAltCoin == false)\n', '                result = transferMinusComission(deal.buyer, deal.value, deal.commission.add((msg.sender == owner ? (GAS_releaseTokens.add(_additionalGas)).mul(tx.gasprice) : 0)));\n', '            else \n', '                result = transferMinusComissionAltCoin(streamityContractAddress, deal.buyer, deal.value, deal.commission);\n', '\n', '            if (result == false) {\n', '                deal.status = STATUS_DEAL_APPROVE; \n', '                return false;   \n', '            }\n', '\n', '            emit ReleasedEvent(_hashDeal, deal.seller, deal.buyer);\n', '            delete streamityTransfers[_hashDeal];\n', '            return true;\n', '        }\n', '        \n', '        return false;\n', '    }\n', '\n', '    function releaseTokensForce(bytes32 _hashDeal) \n', '    external onlyOwner\n', '    nonReentrant\n', '    returns(bool) \n', '    {\n', '        Deal storage deal = streamityTransfers[_hashDeal];\n', '        uint8 prevStatus = deal.status; \n', '        if (deal.status != STATUS_NO_DEAL) {\n', '            deal.status = STATUS_DEAL_RELEASE; \n', '            bool result = false;\n', '\n', '            if (deal.isAltCoin == false)\n', '                result = transferMinusComission(deal.buyer, deal.value, deal.commission);\n', '            else \n', '                result = transferMinusComissionAltCoin(streamityContractAddress, deal.buyer, deal.value, deal.commission);\n', '\n', '            if (result == false) {\n', '                deal.status = prevStatus; \n', '                return false;   \n', '            }\n', '\n', '            emit ReleasedEvent(_hashDeal, deal.seller, deal.buyer);\n', '            delete streamityTransfers[_hashDeal];\n', '            return true;\n', '        }\n', '        \n', '        return false;\n', '    }\n', '\n', '    uint256 constant GAS_cancelSeller = 30000;\n', '    function cancelSeller(bytes32 _hashDeal, uint256 _additionalGas) \n', '    external onlyOwner\n', '    nonReentrant\t\n', '    returns(bool)   \n', '    {\n', '        Deal storage deal = streamityTransfers[_hashDeal];\n', '\n', '        if (deal.cancelTime > block.timestamp)\n', '            return false;\n', '\n', '        if (deal.status == STATUS_DEAL_WAIT_CONFIRMATION) {\n', '            deal.status = STATUS_DEAL_RELEASE; \n', '\n', '            bool result = false;\n', '            if (deal.isAltCoin == false)\n', '                result = transferMinusComission(deal.seller, deal.value, GAS_cancelSeller.add(_additionalGas).mul(tx.gasprice));\n', '            else \n', '                result = transferMinusComissionAltCoin(streamityContractAddress, deal.seller, deal.value, _additionalGas);\n', '\n', '            if (result == false) {\n', '                deal.status = STATUS_DEAL_WAIT_CONFIRMATION; \n', '                return false;   \n', '            }\n', '\n', '            emit SellerCancelEvent(_hashDeal, deal.seller, deal.buyer);\n', '            delete streamityTransfers[_hashDeal];\n', '            return true;\n', '        }\n', '        \n', '        return false;\n', '    }\n', '\n', '    function approveDeal(bytes32 _hashDeal) \n', '    external \n', '    onlyOwner \n', '    nonReentrant\t\n', '    returns(bool) \n', '    {\n', '        Deal storage deal = streamityTransfers[_hashDeal];\n', '        \n', '        if (deal.status == STATUS_DEAL_WAIT_CONFIRMATION) {\n', '            deal.status = STATUS_DEAL_APPROVE;\n', '            emit ApproveDealEvent(_hashDeal, deal.seller, deal.buyer);\n', '            return true;\n', '        }\n', '        \n', '        return false;\n', '    }\n', '\n', '    function transferMinusComission(address _to, uint256 _value, uint256 _commission) \n', '    private returns(bool) \n', '    {\n', '        uint256 _totalComission = _commission; \n', '        \n', '        require(availableForWithdrawal.add(_totalComission) >= availableForWithdrawal); // Check for overflows\n', '\n', '        availableForWithdrawal = availableForWithdrawal.add(_totalComission); \n', '\n', '        _to.transfer(_value.sub(_totalComission));\n', '        return true;\n', '    }\n', '\n', '    function transferMinusComissionAltCoin(TokenERC20 _contract, address _to, uint256 _value, uint256 _commission) \n', '    private returns(bool) \n', '    {\n', '        uint256 _totalComission = _commission; \n', '        _contract.transfer(_to, _value.sub(_totalComission));\n', '        return true;\n', '    }\n', '\n', '    function setStreamityContractAddress(address newAddress) \n', '    external onlyOwner \n', '    {\n', '        streamityContractAddress = TokenERC20(newAddress);\n', '    }\n', '\n', '    // For other Tokens\n', '    function transferToken(ContractToken _tokenContract, address _transferTo, uint256 _value) onlyOwner external {\n', '        _tokenContract.transfer(_transferTo, _value);\n', '    }\n', '    function transferTokenFrom(ContractToken _tokenContract, address _transferTo, address _transferFrom, uint256 _value) onlyOwner external {\n', '        _tokenContract.transferFrom(_transferTo, _transferFrom, _value);\n', '    }\n', '    function approveToken(ContractToken _tokenContract, address _spender, uint256 _value) onlyOwner external {\n', '        _tokenContract.approve(_spender, _value);\n', '    }\n', '}']