['pragma solidity 0.4.21;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev The constructor sets the original owner of the contract to the sender account.\n', '   */\n', '  function Ownable() public {\n', '    setOwner(msg.sender);\n', '  }\n', '\n', '  /**\n', '   * @dev Sets a new owner address\n', '   */\n', '  function setOwner(address newOwner) internal {\n', '    owner = newOwner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    setOwner(newOwner);\n', '  }\n', '}\n', '\n', 'contract ERC820Registry {\n', '    function getManager(address addr) public view returns(address);\n', '    function setManager(address addr, address newManager) public;\n', '    function getInterfaceImplementer(address addr, bytes32 iHash) public constant returns (address);\n', '    function setInterfaceImplementer(address addr, bytes32 iHash, address implementer) public;\n', '}\n', '\n', 'contract ERC820Implementer {\n', '    ERC820Registry erc820Registry = ERC820Registry(0x991a1bcb077599290d7305493c9A630c20f8b798);\n', '\n', '    function setInterfaceImplementation(string ifaceLabel, address impl) internal {\n', '        bytes32 ifaceHash = keccak256(ifaceLabel);\n', '        erc820Registry.setInterfaceImplementer(this, ifaceHash, impl);\n', '    }\n', '\n', '    function interfaceAddr(address addr, string ifaceLabel) internal constant returns(address) {\n', '        bytes32 ifaceHash = keccak256(ifaceLabel);\n', '        return erc820Registry.getInterfaceImplementer(addr, ifaceHash);\n', '    }\n', '\n', '    function delegateManagement(address newManager) internal {\n', '        erc820Registry.setManager(this, newManager);\n', '    }\n', '}\n', '\n', 'interface ERC777TokensSender {\n', '    function tokensToSend(address operator, address from, address to, uint amount, bytes userData,bytes operatorData) external;\n', '}\n', '\n', '\n', 'interface ERC777TokensRecipient {\n', '    function tokensReceived(address operator, address from, address to, uint amount, bytes userData, bytes operatorData) external;\n', '}\n', '\n', 'contract JaroCoinToken is Ownable, ERC820Implementer {\n', '    using SafeMath for uint256;\n', '\n', '    string public constant name = "JaroCoin";\n', '    string public constant symbol = "JARO";\n', '    uint8 public constant decimals = 18;\n', '    uint256 public constant granularity = 1e10;   // Token has 8 digits after comma\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => bool)) public isOperatorFor;\n', '    mapping (address => mapping (uint256 => bool)) private usedNonces;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Sent(address indexed operator, address indexed from, address indexed to, uint256 amount, bytes userData, bytes operatorData);\n', '    event Minted(address indexed operator, address indexed to, uint256 amount, bytes operatorData);\n', '    event Burned(address indexed operator, address indexed from, uint256 amount, bytes userData, bytes operatorData);\n', '    event AuthorizedOperator(address indexed operator, address indexed tokenHolder);\n', '    event RevokedOperator(address indexed operator, address indexed tokenHolder);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    uint256 public totalSupply = 0;\n', '    uint256 public constant maxSupply = 21000000e18;\n', '\n', '\n', '    // ------- ERC777/ERC965 Implementation ----------\n', '\n', '    /**\n', '    * @notice Send `_amount` of tokens to address `_to` passing `_userData` to the recipient\n', '    * @param _to The address of the recipient\n', '    * @param _amount The number of tokens to be sent\n', '    * @param _userData Data generated by the user to be sent to the recipient\n', '    */\n', '    function send(address _to, uint256 _amount, bytes _userData) public {\n', '        doSend(msg.sender, _to, _amount, _userData, msg.sender, "", true);\n', '    }\n', '\n', '    /**\n', '    * @dev transfer token for a specified address via cheque\n', '    * @param _to The address to transfer to\n', '    * @param _amount The amount to be transferred\n', '    * @param _userData The data to be executed\n', '    * @param _nonce Unique nonce to avoid double spendings\n', '    */\n', '    function sendByCheque(address _to, uint256 _amount, bytes _userData, uint256 _nonce, uint8 v, bytes32 r, bytes32 s) public {\n', '        require(_to != address(this));\n', '\n', '        // Check if signature is valid, get signer&#39;s address and mark this cheque as used.\n', '        bytes memory prefix = "\\x19Ethereum Signed Message:\\n32";\n', '        bytes32 hash = keccak256(prefix, keccak256(_to, _amount, _userData, _nonce));\n', '        // bytes32 hash = keccak256(_to, _amount, _userData, _nonce);\n', '\n', '        address signer = ecrecover(hash, v, r, s);\n', '        require (signer != 0);\n', '        require (!usedNonces[signer][_nonce]);\n', '        usedNonces[signer][_nonce] = true;\n', '\n', '        // Transfer tokens\n', '        doSend(signer, _to, _amount, _userData, signer, "", true);\n', '    }\n', '\n', '    /**\n', '    * @notice Authorize a third party `_operator` to manage (send) `msg.sender`&#39;s tokens.\n', '    * @param _operator The operator that wants to be Authorized\n', '    */\n', '    function authorizeOperator(address _operator) public {\n', '        require(_operator != msg.sender);\n', '        isOperatorFor[_operator][msg.sender] = true;\n', '        emit AuthorizedOperator(_operator, msg.sender);\n', '    }\n', '\n', '    /**\n', '    * @notice Revoke a third party `_operator`&#39;s rights to manage (send) `msg.sender`&#39;s tokens.\n', '    * @param _operator The operator that wants to be Revoked\n', '    */\n', '    function revokeOperator(address _operator) public {\n', '        require(_operator != msg.sender);\n', '        isOperatorFor[_operator][msg.sender] = false;\n', '        emit RevokedOperator(_operator, msg.sender);\n', '    }\n', '\n', '    /**\n', '    * @notice Send `_amount` of tokens on behalf of the address `from` to the address `to`.\n', '    * @param _from The address holding the tokens being sent\n', '    * @param _to The address of the recipient\n', '    * @param _amount The number of tokens to be sent\n', '    * @param _userData Data generated by the user to be sent to the recipient\n', '    * @param _operatorData Data generated by the operator to be sent to the recipient\n', '    */\n', '    function operatorSend(address _from, address _to, uint256 _amount, bytes _userData, bytes _operatorData) public {\n', '        require(isOperatorFor[msg.sender][_from]);\n', '        doSend(_from, _to, _amount, _userData, msg.sender, _operatorData, true);\n', '    }\n', '\n', '    /* -- Helper Functions -- */\n', '    /**\n', '    * @notice Internal function that ensures `_amount` is multiple of the granularity\n', '    * @param _amount The quantity that want&#39;s to be checked\n', '    */\n', '    function requireMultiple(uint256 _amount) internal pure {\n', '        require(_amount.div(granularity).mul(granularity) == _amount);\n', '    }\n', '\n', '    /**\n', '    * @notice Check whether an address is a regular address or not.\n', '    * @param _addr Address of the contract that has to be checked\n', '    * @return `true` if `_addr` is a regular address (not a contract)\n', '    */\n', '    function isRegularAddress(address _addr) internal constant returns(bool) {\n', '        if (_addr == 0) { return false; }\n', '        uint size;\n', '        assembly { size := extcodesize(_addr) } // solhint-disable-line no-inline-assembly\n', '        return size == 0;\n', '    }\n', '\n', '    /**\n', '    * @notice Helper function that checks for ERC777TokensSender on the sender and calls it.\n', '    *  May throw according to `_preventLocking`\n', '    * @param _from The address holding the tokens being sent\n', '    * @param _to The address of the recipient\n', '    * @param _amount The amount of tokens to be sent\n', '    * @param _userData Data generated by the user to be passed to the recipient\n', '    * @param _operatorData Data generated by the operator to be passed to the recipient\n', '    *  implementing `ERC777TokensSender`.\n', '    *  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer\n', '    *  functions SHOULD set this parameter to `false`.\n', '    */\n', '    function callSender(\n', '        address _operator,\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount,\n', '        bytes _userData,\n', '        bytes _operatorData\n', '    ) private {\n', '        address senderImplementation = interfaceAddr(_from, "ERC777TokensSender");\n', '        if (senderImplementation != 0) {\n', '            ERC777TokensSender(senderImplementation).tokensToSend(\n', '                _operator, _from, _to, _amount, _userData, _operatorData);\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @notice Helper function that checks for ERC777TokensRecipient on the recipient and calls it.\n', '    *  May throw according to `_preventLocking`\n', '    * @param _from The address holding the tokens being sent\n', '    * @param _to The address of the recipient\n', '    * @param _amount The number of tokens to be sent\n', '    * @param _userData Data generated by the user to be passed to the recipient\n', '    * @param _operatorData Data generated by the operator to be passed to the recipient\n', '    * @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not\n', '    *  implementing `ERC777TokensRecipient`.\n', '    *  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer\n', '    *  functions SHOULD set this parameter to `false`.\n', '    */\n', '    function callRecipient(\n', '        address _operator,\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount,\n', '        bytes _userData,\n', '        bytes _operatorData,\n', '        bool _preventLocking\n', '    ) private {\n', '        address recipientImplementation = interfaceAddr(_to, "ERC777TokensRecipient");\n', '        if (recipientImplementation != 0) {\n', '            ERC777TokensRecipient(recipientImplementation).tokensReceived(\n', '                _operator, _from, _to, _amount, _userData, _operatorData);\n', '        } else if (_preventLocking) {\n', '            require(isRegularAddress(_to));\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @notice Helper function actually performing the sending of tokens.\n', '    * @param _from The address holding the tokens being sent\n', '    * @param _to The address of the recipient\n', '    * @param _amount The number of tokens to be sent\n', '    * @param _userData Data generated by the user to be passed to the recipient\n', '    * @param _operatorData Data generated by the operator to be passed to the recipient\n', '    * @param _preventLocking `true` if you want this function to throw when tokens are sent to a contract not\n', '    *  implementing `erc777_tokenHolder`.\n', '    *  ERC777 native Send functions MUST set this parameter to `true`, and backwards compatible ERC20 transfer\n', '    *  functions SHOULD set this parameter to `false`.\n', '    */\n', '    function doSend(\n', '        address _from,\n', '        address _to,\n', '        uint256 _amount,\n', '        bytes _userData,\n', '        address _operator,\n', '        bytes _operatorData,\n', '        bool _preventLocking\n', '    )\n', '        private\n', '    {\n', '        requireMultiple(_amount);\n', '\n', '        callSender(_operator, _from, _to, _amount, _userData, _operatorData);\n', '\n', '        require(_to != 0x0);                  // forbid sending to 0x0 (=burning)\n', '        require(balanceOf[_from] >= _amount); // ensure enough funds\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_amount);\n', '        balanceOf[_to] = balanceOf[_to].add(_amount);\n', '\n', '        callRecipient(_operator, _from, _to, _amount, _userData, _operatorData, _preventLocking);\n', '\n', '        emit Sent(_operator, _from, _to, _amount, _userData, _operatorData);\n', '        emit Transfer(_from, _to, _amount);\n', '    }\n', '\n', '    // ------- ERC20 Implementation ----------\n', '\n', '    /**\n', '     * @dev transfer token for a specified address\n', '     * @param _to The address to transfer to.\n', '     * @param _value The amount to be transferred.\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        doSend(msg.sender, _to, _value, "", msg.sender, "", false);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another. Technically this is not ERC20 transferFrom but more ERC777 operatorSend.\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(isOperatorFor[msg.sender][_from]);\n', '        doSend(_from, _to, _value, "", msg.sender, "", true);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '\n', '     * @dev Originally in ERC20 this function to check the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * Function was added purly for backward compatibility with ERC20. Use operator logic from ERC777 instead.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A returning uint256 balanceOf _spender if it&#39;s active operator and 0 if not.\n', '     */\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        if (isOperatorFor[_spender][_owner]) {\n', '            return balanceOf[_owner];\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Approve the passed address to spend tokens on behalf of msg.sender.\n', '     *\n', '     * This function is more authorizeOperator and revokeOperator from ERC777 that Approve from ERC20.\n', '     * Approve concept has several issues (e.g. https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729),\n', '     * so I prefer to use operator concept. If you want to revoke approval, just put 0 into _value.\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value Fake value to be compatible with ERC20 requirements.\n', '     */\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        require(_spender != msg.sender);\n', '\n', '        if (_value > 0) {\n', '            // Authorizing operator\n', '            isOperatorFor[_spender][msg.sender] = true;\n', '            emit AuthorizedOperator(_spender, msg.sender);\n', '        } else {\n', '            // Revoking operator\n', '            isOperatorFor[_spender][msg.sender] = false;\n', '            emit RevokedOperator(_spender, msg.sender);\n', '        }\n', '\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    // ------- Minting and burning ----------\n', '\n', '    /**\n', '    * @dev Function to mint tokens\n', '    * @param _to The address that will receive the minted tokens.\n', '    * @param _amount The amount of tokens to mint.\n', '    * @param _operatorData Data that will be passed to the recipient as a first transfer.\n', '    */\n', '    function mint(address _to, uint256 _amount, bytes _operatorData) public onlyOwner {\n', '        require (totalSupply.add(_amount) <= maxSupply);\n', '        requireMultiple(_amount);\n', '\n', '        totalSupply = totalSupply.add(_amount);\n', '        balanceOf[_to] = balanceOf[_to].add(_amount);\n', '\n', '        callRecipient(msg.sender, 0x0, _to, _amount, "", _operatorData, true);\n', '\n', '        emit Minted(msg.sender, _to, _amount, _operatorData);\n', '        emit Transfer(0x0, _to, _amount);\n', '    }\n', '\n', '    /**\n', '    * @dev Function to burn sender&#39;s tokens\n', '    * @param _amount The amount of tokens to burn.\n', '    * @return A boolean that indicates if the operation was successful.\n', '    */\n', '    function burn(uint256 _amount, bytes _userData) public {\n', '        require (_amount > 0);\n', '        require (balanceOf[msg.sender] >= _amount);\n', '        requireMultiple(_amount);\n', '\n', '        callSender(msg.sender, msg.sender, 0x0, _amount, _userData, "");\n', '\n', '        totalSupply = totalSupply.sub(_amount);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);\n', '\n', '        emit Burned(msg.sender, msg.sender, _amount, _userData, "");\n', '        emit Transfer(msg.sender, 0x0, _amount);\n', '    }\n', '}\n', '\n', 'contract JaroSleep is ERC820Implementer, ERC777TokensRecipient {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public lastBurn;                         // Time of last sleep token burn\n', '    uint256 public dailyTime;                        // Tokens to burn per day\n', '    JaroCoinToken public token;\n', '\n', '    event ReceivedTokens(address operator, address from, address to, uint amount, bytes userData, bytes operatorData);\n', '\n', '    function JaroSleep(address _token, uint256 _dailyTime) public {\n', '        setInterfaceImplementation("ERC777TokensRecipient", this);\n', '        token = JaroCoinToken(_token);\n', '        lastBurn = getNow();\n', '        dailyTime = _dailyTime;\n', '    }\n', '\n', '    // Reject any ethers send to this address\n', '    function () external payable {\n', '        revert();\n', '    }\n', '\n', '    function burnTokens() public returns (uint256) {\n', '        uint256 sec = getNow().sub(lastBurn);\n', '        uint256 tokensToBurn = 0;\n', '\n', '        // // TODO convert into uint64 for saving gas purposes\n', '        if (sec >= 1 days) {\n', '            uint256 d =  sec.div(86400);\n', '            tokensToBurn = d.mul(dailyTime);\n', '            token.burn(tokensToBurn, "");\n', '            lastBurn = lastBurn.add(d.mul(86400));\n', '        }\n', '\n', '        return tokensToBurn;\n', '    }\n', '\n', '    // Function needed for automated testing purposes\n', '    function getNow() internal view returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '    // ERC777 tokens receiver callback\n', '    function tokensReceived(address operator, address from, address to, uint amount, bytes userData, bytes operatorData) external {\n', '        emit ReceivedTokens(operator, from, to, amount, userData, operatorData);\n', '    }\n', '}\n', '\n', 'contract PersonalTime is Ownable, ERC820Implementer, ERC777TokensRecipient {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public lastBurn;                         // Time of last sleep token burn\n', '    uint256 public dailyTime;                        // Tokens to burn per day\n', '    uint256 public debt = 0;                         // Debt which will be not minted during next sale period\n', '    uint256 public protect = 0;                      // Tokens which were transfered in favor of future days\n', '    JaroCoinToken public token;\n', '\n', '    event ReceivedTokens(address operator, address from, address to, uint amount, bytes userData, bytes operatorData);\n', '\n', '    function PersonalTime(address _token, uint256 _dailyTime) public {\n', '        setInterfaceImplementation("ERC777TokensRecipient", this);\n', '        token = JaroCoinToken(_token);\n', '        lastBurn = getNow();\n', '        dailyTime = _dailyTime;\n', '    }\n', '\n', '    // Reject any ethers send to this address\n', '    function () external payable {\n', '        revert();\n', '    }\n', '\n', '    function burnTokens() public returns (uint256) {\n', '        uint256 sec = getNow().sub(lastBurn);\n', '        uint256 tokensToBurn = 0;\n', '\n', '        // // TODO convert into uint64 for saving gas purposes\n', '        if (sec >= 1 days) {\n', '            uint256 d =  sec.div(86400);\n', '            tokensToBurn = d.mul(dailyTime);\n', '\n', '            if (protect >= tokensToBurn) {\n', '                protect = protect.sub(tokensToBurn);\n', '            } else {\n', '                token.burn(tokensToBurn.sub(protect), "");\n', '                protect = 0;\n', '            }\n', '\n', '            lastBurn = lastBurn.add(d.mul(86400));\n', '        }\n', '\n', '        return tokensToBurn;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _amount) public onlyOwner {\n', '        protect = protect.add(_amount);\n', '        debt = debt.add(_amount);\n', '        token.transfer(_to, _amount);\n', '    }\n', '\n', '    // Function needed for automated testing purposes\n', '    function getNow() internal view returns (uint256) {\n', '        return now;\n', '    }\n', '\n', '    // ERC777 tokens receiver callback\n', '    function tokensReceived(address operator, address from, address to, uint amount, bytes userData, bytes operatorData) external {\n', '        require(msg.sender == address(token));\n', '        debt = (debt >= amount ? debt.sub(amount) : 0);\n', '        emit ReceivedTokens(operator, from, to, amount, userData, operatorData);\n', '    }\n', '}\n', '\n', '\n', 'contract JaroCoinCrowdsale is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    address public constant WALLET = 0xefF42c79c0aBea9958432DC82FebC4d65f3d24A3;\n', '\n', '    // Max tokens which can be in circulation\n', '    uint256 public constant MAX_AMOUNT = 21000000e18; // 21 000 000\n', '\n', '    // Amount of raised funds in satoshi\n', '    uint256 public satoshiRaised;\n', '\n', '    uint256 public rate;                              // number of tokens buyer gets per satoshi\n', '    uint256 public conversionRate;                    // wei per satoshi - per ETH => 0.056 ETH/BTC ? wei per satoshi?\n', '\n', '    JaroCoinToken public token;\n', '    JaroSleep public sleepContract;\n', '    PersonalTime public familyContract;\n', '    PersonalTime public personalContract;\n', '\n', '    uint256 public tokensToMint;                      // Amount of tokens left to mint in this sale\n', '    uint256 public saleStartTime;                     // Start time of recent token sale\n', '\n', '    // Indicator of token sale activity.\n', '    bool public isActive = false;\n', '    bool internal initialized = false;\n', '\n', '    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '    event SaleActivated(uint256 startTime, uint256 amount);\n', '    event SaleClosed();\n', '\n', '    modifier canMint() {\n', '        require (isActive);\n', '        require (getNow() > saleStartTime);\n', '        _;\n', '    }\n', '\n', '    function initialize(address _owner, address _token, address _familyOwner, address _personalOwner) public {\n', '        require (!initialized);\n', '\n', '        token = JaroCoinToken(_token);\n', '\n', '        sleepContract = createJaroSleep(_token, 34560e18);       // 9.6 hours per day\n', '        familyContract = createPersonalTime(_token, 21600e18);   // 6 hours per day\n', '        personalContract = createPersonalTime(_token, 12960e18); // 3.6 hours per day\n', '\n', '        familyContract.transferOwnership(_familyOwner);\n', '        personalContract.transferOwnership(_personalOwner);\n', '\n', '        rate = 100000e10;\n', '        conversionRate = 17e10;\n', '        satoshiRaised = 0;\n', '\n', '        setOwner(_owner);\n', '        initialized = true;\n', '    }\n', '\n', '    // fallback function can be used to buy tokens\n', '    function () external canMint payable {\n', '        _buyTokens(msg.sender, msg.value, 0);\n', '    }\n', '\n', '    function coupon(uint256 _timeStamp, uint8 _bonus, uint8 v, bytes32 r, bytes32 s) external canMint payable {\n', '        require(_timeStamp >= getNow());\n', '\n', '        // Check if signature is valid, get signer&#39;s address and mark this cheque as used.\n', '        bytes memory prefix = "\\x19Ethereum Signed Message:\\n32";\n', '        bytes32 hash = keccak256(prefix, keccak256(_timeStamp, _bonus));\n', '\n', '        address signer = ecrecover(hash, v, r, s);\n', '        require(signer == owner);\n', '\n', '        _buyTokens(msg.sender, msg.value, _bonus);\n', '    }\n', '\n', '    function buyTokens(address _beneficiary) public canMint payable {\n', '        _buyTokens(_beneficiary, msg.value, 0);\n', '    }\n', '\n', '    function _buyTokens(address _beneficiary, uint256 _value, uint8 _bonus) internal {\n', '        require (_beneficiary != address(0));\n', '        require (_value > 0);\n', '\n', '        uint256 weiAmount = _value;\n', '        uint256 satoshiAmount = weiAmount.div(conversionRate);\n', '        uint256 tokens = satoshiAmount.mul(rate).mul(100+_bonus).div(100);\n', '\n', '        // Mint tokens and refund not used ethers in case when max amount reached during this minting\n', '        uint256 excess = appendContribution(_beneficiary, tokens);\n', '        uint256 refund = (excess > 0 ? excess.mul(100).div(100+_bonus).mul(conversionRate).div(rate) : 0);\n', '        weiAmount = weiAmount.sub(refund);\n', '        satoshiRaised = satoshiRaised.add(satoshiAmount);\n', '\n', '        // if hard cap reached, no more tokens to mint, refund sender not used ethers\n', '        if (refund > 0) {\n', '            msg.sender.transfer(refund);\n', '        }\n', '\n', '        emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens.sub(excess));\n', '\n', '        // Send ethers into WALLET\n', '        WALLET.transfer(weiAmount);\n', '    }\n', '\n', '    function appendContribution(address _beneficiary, uint256 _tokens) internal returns (uint256) {\n', '        if (_tokens >= tokensToMint) {\n', '            mint(_beneficiary, tokensToMint);\n', '            uint256 excededTokens = _tokens.sub(tokensToMint);\n', '            _closeSale(); // Last tokens minted, lets close token sale\n', '            return excededTokens;\n', '        }\n', '\n', '        tokensToMint = tokensToMint.sub(_tokens);\n', '        mint(_beneficiary, _tokens);\n', '        return 0;\n', '    }\n', '\n', '    /**\n', '     * Owner can start new token sale, to mint missing tokens by using this function,\n', '     * but not more often than once per month.\n', '     * @param _startTime start time for new token sale.\n', '    */\n', '    function startSale(uint256 _startTime) public onlyOwner {\n', '        require (!isActive);\n', '        require (_startTime > getNow());\n', '        require (saleStartTime == 0 || _startTime.sub(saleStartTime) > 30 days);   // Minimum one month between token sales\n', '\n', '        // Burn unburned sleep, family and personal time.\n', '        sleepContract.burnTokens();\n', '        uint256 sleepTokens = token.balanceOf(address(sleepContract));\n', '\n', '        familyContract.burnTokens();\n', '        uint256 familyTokens = token.balanceOf(familyContract).add(familyContract.debt());\n', '\n', '        personalContract.burnTokens();\n', '        uint256 personalTokens = token.balanceOf(personalContract).add(personalContract.debt());\n', '\n', '        uint256 missingSleep = MAX_AMOUNT.div(100).mul(40).sub(sleepTokens);       // sleep and stuff takes 40% of Jaro time\n', '        uint256 missingFamily = MAX_AMOUNT.div(100).mul(25).sub(familyTokens);     // 25% for family\n', '        uint256 missingPersonal = MAX_AMOUNT.div(100).mul(15).sub(personalTokens); // 15% is Jaro personal time\n', '\n', '        mint(address(sleepContract), missingSleep);\n', '        mint(address(familyContract), missingFamily);\n', '        mint(address(personalContract), missingPersonal);\n', '\n', '        tokensToMint = MAX_AMOUNT.sub(token.totalSupply());\n', '        saleStartTime = _startTime;\n', '        isActive = true;\n', '        emit SaleActivated(_startTime, tokensToMint);\n', '    }\n', '\n', '    function _closeSale() internal {\n', '        tokensToMint = 0;\n', '        isActive = false;\n', '        emit SaleClosed();\n', '    }\n', '\n', '    function closeSale() public onlyOwner {\n', '        _closeSale();\n', '    }\n', '\n', '    function updateConvertionRate(uint256 _rate) public onlyOwner {\n', '        require (_rate > 0);\n', '        uint256 one = 1e18;\n', '        conversionRate = one.div(_rate);\n', '    }\n', '\n', '    function mint(address _beneficiary, uint256 _amount) internal {\n', '        if (_amount > 0) {\n', '            token.mint(_beneficiary, _amount, "");\n', '        }\n', '    }\n', '\n', '    // This function created for easier testing purposes\n', '    function createJaroSleep(address _token, uint256 _dailyTime) internal returns (JaroSleep) {\n', '        return new JaroSleep(_token, _dailyTime);\n', '    }\n', '\n', '    function createPersonalTime(address _token, uint256 _dailyTime) internal returns (PersonalTime) {\n', '        return new PersonalTime(_token, _dailyTime);\n', '    }\n', '\n', '    // This function created for easier testing purposes\n', '    function getNow() internal view returns (uint256) {\n', '        return now;\n', '    }\n', '}']