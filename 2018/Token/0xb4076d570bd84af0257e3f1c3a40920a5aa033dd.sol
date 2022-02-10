['pragma solidity ^0.4.24;\n', '\n', '/*\n', '  Super Simple Token Subscriptions - https://tokensubscription.com\n', '\n', '  //// Breakin’ Through @ University of Wyoming ////\n', '\n', '  Austin Thomas Griffith - https://austingriffith.com\n', '\n', '  Building on previous works:\n', '    https://github.com/austintgriffith/token-subscription\n', '    https://gist.github.com/androolloyd/0a62ef48887be00a5eff5c17f2be849a\n', '    https://media.consensys.net/subscription-services-on-the-blockchain-erc-948-6ef64b083a36\n', '    https://medium.com/gitcoin/technical-deep-dive-architecture-choices-for-subscriptions-on-the-blockchain-erc948-5fae89cabc7a\n', '    https://github.com/ethereum/EIPs/pull/1337\n', '    https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1077.md\n', '    https://github.com/gnosis/safe-contracts\n', '\n', '  Earlier Meta Transaction Demo:\n', '    https://github.com/austintgriffith/bouncer-proxy\n', '\n', '  Huge thanks, as always, to OpenZeppelin for the rad contracts:\n', ' */\n', '\n', '\n', '\n', '/**\n', ' * @title Elliptic curve signature operations\n', ' * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d\n', ' * TODO Remove this library once solidity supports passing a signature to ecrecover.\n', ' * See https://github.com/ethereum/solidity/issues/864\n', ' */\n', '\n', 'library ECDSA {\n', '\n', '  /**\n', '   * @dev Recover signer address from a message by using their signature\n', '   * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.\n', '   * @param signature bytes signature, the signature is generated using web3.eth.sign()\n', '   */\n', '  function recover(bytes32 hash, bytes signature)\n', '    internal\n', '    pure\n', '    returns (address)\n', '  {\n', '    bytes32 r;\n', '    bytes32 s;\n', '    uint8 v;\n', '\n', '    // Check the signature length\n', '    if (signature.length != 65) {\n', '      return (address(0));\n', '    }\n', '\n', '    // Divide the signature in r, s and v variables\n', '    // ecrecover takes the signature parameters, and the only way to get them\n', '    // currently is to use assembly.\n', '    // solium-disable-next-line security/no-inline-assembly\n', '    assembly {\n', '      r := mload(add(signature, 32))\n', '      s := mload(add(signature, 64))\n', '      v := byte(0, mload(add(signature, 96)))\n', '    }\n', '\n', '    // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '    if (v < 27) {\n', '      v += 27;\n', '    }\n', '\n', '    // If the version is correct return the signer address\n', '    if (v != 27 && v != 28) {\n', '      return (address(0));\n', '    } else {\n', '      // solium-disable-next-line arg-overflow\n', '      return ecrecover(hash, v, r, s);\n', '    }\n', '  }\n', '\n', '  /**\n', '   * toEthSignedMessageHash\n', '   * @dev prefix a bytes32 value with "\\x19Ethereum Signed Message:"\n', '   * and hash the result\n', '   */\n', '  function toEthSignedMessageHash(bytes32 hash)\n', '    internal\n', '    pure\n', '    returns (bytes32)\n', '  {\n', '    // 32 is the length in bytes of hash,\n', '    // enforced by the type signature above\n', '    return keccak256(\n', '      abi.encodePacked("\\x19Ethereum Signed Message:\\n32", hash)\n', '    );\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, reverts on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0); // Solidity only automatically asserts when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, reverts on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '  */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function balanceOf(address who) external view returns (uint256);\n', '\n', '  function allowance(address owner, address spender)\n', '    external view returns (uint256);\n', '\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '\n', '  function approve(address spender, uint256 value)\n', '    external returns (bool);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    external returns (bool);\n', '\n', '  event Transfer(\n', '    address indexed from,\n', '    address indexed to,\n', '    uint256 value\n', '  );\n', '\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md\n', ' * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract ERC20 is IERC20 {\n', '  using SafeMath for uint256;\n', '\n', '  mapping (address => uint256) private _balances;\n', '\n', '  mapping (address => mapping (address => uint256)) private _allowed;\n', '\n', '  uint256 private _totalSupply;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address owner) public view returns (uint256) {\n', '    return _balances[owner];\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param owner address The address which owns the funds.\n', '   * @param spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address owner,\n', '    address spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return _allowed[owner][spender];\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param to The address to transfer to.\n', '  * @param value The amount to be transferred.\n', '  */\n', '  function transfer(address to, uint256 value) public returns (bool) {\n', '    require(value <= _balances[msg.sender]);\n', '    require(to != address(0));\n', '\n', '    _balances[msg.sender] = _balances[msg.sender].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '    emit Transfer(msg.sender, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param spender The address which will spend the funds.\n', '   * @param value The amount of tokens to be spent.\n', '   */\n', '  function approve(address spender, uint256 value) public returns (bool) {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = value;\n', '    emit Approval(msg.sender, spender, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param from address The address which you want to send tokens from\n', '   * @param to address The address which you want to transfer to\n', '   * @param value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(value <= _balances[from]);\n', '    require(value <= _allowed[from][msg.sender]);\n', '    require(to != address(0));\n', '\n', '    _balances[from] = _balances[from].sub(value);\n', '    _balances[to] = _balances[to].add(value);\n', '    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);\n', '    emit Transfer(from, to, value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseAllowance(\n', '    address spender,\n', '    uint256 addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].add(addedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed_[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param spender The address which will spend the funds.\n', '   * @param subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseAllowance(\n', '    address spender,\n', '    uint256 subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(spender != address(0));\n', '\n', '    _allowed[msg.sender][spender] = (\n', '      _allowed[msg.sender][spender].sub(subtractedValue));\n', '    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that mints an amount of the token and assigns it to\n', '   * an account. This encapsulates the modification of balances such that the\n', '   * proper events are emitted.\n', '   * @param account The account that will receive the created tokens.\n', '   * @param amount The amount that will be created.\n', '   */\n', '  function _mint(address account, uint256 amount) internal {\n', '    require(account != 0);\n', '    _totalSupply = _totalSupply.add(amount);\n', '    _balances[account] = _balances[account].add(amount);\n', '    emit Transfer(address(0), account, amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', '   * account.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param amount The amount that will be burnt.\n', '   */\n', '  function _burn(address account, uint256 amount) internal {\n', '    require(account != 0);\n', '    require(amount <= _balances[account]);\n', '\n', '    _totalSupply = _totalSupply.sub(amount);\n', '    _balances[account] = _balances[account].sub(amount);\n', '    emit Transfer(account, address(0), amount);\n', '  }\n', '\n', '  /**\n', '   * @dev Internal function that burns an amount of the token of a given\n', "   * account, deducting from the sender's allowance for said account. Uses the\n", '   * internal burn function.\n', '   * @param account The account whose tokens will be burnt.\n', '   * @param amount The amount that will be burnt.\n', '   */\n', '  function _burnFrom(address account, uint256 amount) internal {\n', '    require(amount <= _allowed[account][msg.sender]);\n', '\n', '    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,\n', '    // this function needs to emit an event with the updated approval.\n', '    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(\n', '      amount);\n', '    _burn(account, amount);\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract Subscription {\n', '    using ECDSA for bytes32;\n', '    using SafeMath for uint256;\n', '\n', '    //who deploys the contract\n', '    address public author;\n', '\n', '    // the publisher may optionally deploy requirements for the subscription\n', '    // so only meta transactions that match the requirements can be relayed\n', '    address public requiredToAddress;\n', '    address public requiredTokenAddress;\n', '    uint256 public requiredTokenAmount;\n', '    uint256 public requiredPeriodSeconds;\n', '    uint256 public requiredGasPrice;\n', '\n', '    // similar to a nonce that avoids replay attacks this allows a single execution\n', '    // every x seconds for a given subscription\n', '    // subscriptionHash  => next valid block number\n', '    mapping(bytes32 => uint256) public nextValidTimestamp;\n', '\n', "    //we'll use a nonce for each from but because transactions can go through\n", '    //multiple times, we allow anything but users can use this as a signal for\n', '    //uniqueness\n', '    mapping(address => uint256) public extraNonce;\n', '\n', '    event ExecuteSubscription(\n', '        address indexed from, //the subscriber\n', '        address indexed to, //the publisher\n', '        address tokenAddress, //the token address paid to the publisher\n', '        uint256 tokenAmount, //the token amount paid to the publisher\n', '        uint256 periodSeconds, //the period in seconds between payments\n', '        uint256 gasPrice, //the amount of tokens to pay relayer (0 for free)\n', '        uint256 nonce // to allow multiple subscriptions with the same parameters\n', '    );\n', '\n', '    constructor(\n', '        address _toAddress,\n', '        address _tokenAddress,\n', '        uint256 _tokenAmount,\n', '        uint256 _periodSeconds,\n', '        uint256 _gasPrice\n', '    ) public {\n', '        requiredToAddress=_toAddress;\n', '        requiredTokenAddress=_tokenAddress;\n', '        requiredTokenAmount=_tokenAmount;\n', '        requiredPeriodSeconds=_periodSeconds;\n', '        requiredGasPrice=_gasPrice;\n', '        author=msg.sender;\n', '    }\n', '\n', '    // this is used by external smart contracts to verify on-chain that a\n', '    // particular subscription is "paid" and "active"\n', '    // there must be a small grace period added to allow the publisher\n', '    // or desktop miner to execute\n', '    function isSubscriptionActive(\n', '        bytes32 subscriptionHash,\n', '        uint256 gracePeriodSeconds\n', '    )\n', '        external\n', '        view\n', '        returns (bool)\n', '    {\n', '        return (block.timestamp <=\n', '                nextValidTimestamp[subscriptionHash].add(gracePeriodSeconds)\n', '        );\n', '    }\n', '\n', '    // given the subscription details, generate a hash and try to kind of follow\n', '    // the eip-191 standard and eip-1077 standard from my dude @avsa\n', '    function getSubscriptionHash(\n', '        address from, //the subscriber\n', '        address to, //the publisher\n', '        address tokenAddress, //the token address paid to the publisher\n', '        uint256 tokenAmount, //the token amount paid to the publisher\n', '        uint256 periodSeconds, //the period in seconds between payments\n', '        uint256 gasPrice, //the amount of tokens or eth to pay relayer (0 for free)\n', '        uint256 nonce // to allow multiple subscriptions with the same parameters\n', '    )\n', '        public\n', '        view\n', '        returns (bytes32)\n', '    {\n', '        return keccak256(\n', '            abi.encodePacked(\n', '                byte(0x19),\n', '                byte(0),\n', '                address(this),\n', '                from,\n', '                to,\n', '                tokenAddress,\n', '                tokenAmount,\n', '                periodSeconds,\n', '                gasPrice,\n', '                nonce\n', '        ));\n', '    }\n', '\n', '    //ecrecover the signer from hash and the signature\n', '    function getSubscriptionSigner(\n', '        bytes32 subscriptionHash, //hash of subscription\n', '        bytes signature //proof the subscriber signed the meta trasaction\n', '    )\n', '        public\n', '        pure\n', '        returns (address)\n', '    {\n', '        return subscriptionHash.toEthSignedMessageHash().recover(signature);\n', '    }\n', '\n', '    //check if a subscription is signed correctly and the timestamp is ready for\n', '    // the next execution to happen\n', '    function isSubscriptionReady(\n', '        address from, //the subscriber\n', '        address to, //the publisher\n', '        address tokenAddress, //the token address paid to the publisher\n', '        uint256 tokenAmount, //the token amount paid to the publisher\n', '        uint256 periodSeconds, //the period in seconds between payments\n', '        uint256 gasPrice, //the amount of the token to incentivize the relay network\n', '        uint256 nonce,// to allow multiple subscriptions with the same parameters\n', '        bytes signature //proof the subscriber signed the meta trasaction\n', '    )\n', '        external\n', '        view\n', '        returns (bool)\n', '    {\n', '        bytes32 subscriptionHash = getSubscriptionHash(\n', '            from, to, tokenAddress, tokenAmount, periodSeconds, gasPrice, nonce\n', '        );\n', '        address signer = getSubscriptionSigner(subscriptionHash, signature);\n', '        uint256 allowance = ERC20(tokenAddress).allowance(from, address(this));\n', '        uint256 balance = ERC20(tokenAddress).balanceOf(from);\n', '        return (\n', '            signer == from &&\n', '            from != to &&\n', '            block.timestamp >= nextValidTimestamp[subscriptionHash] &&\n', '            allowance >= tokenAmount.add(gasPrice) &&\n', '            balance >= tokenAmount.add(gasPrice)\n', '        );\n', '    }\n', '\n', "    // you don't really need this if you are using the approve/transferFrom method\n", '    // because you control the flow of tokens by approving this contract address,\n', "    // but to make the contract an extensible example for later user I'll add this\n", '    function cancelSubscription(\n', '        address from, //the subscriber\n', '        address to, //the publisher\n', '        address tokenAddress, //the token address paid to the publisher\n', '        uint256 tokenAmount, //the token amount paid to the publisher\n', '        uint256 periodSeconds, //the period in seconds between payments\n', '        uint256 gasPrice, //the amount of tokens or eth to pay relayer (0 for free)\n', '        uint256 nonce, //to allow multiple subscriptions with the same parameters\n', '        bytes signature //proof the subscriber signed the meta trasaction\n', '    )\n', '        external\n', '        returns (bool success)\n', '    {\n', '        bytes32 subscriptionHash = getSubscriptionHash(\n', '            from, to, tokenAddress, tokenAmount, periodSeconds, gasPrice, nonce\n', '        );\n', '        address signer = getSubscriptionSigner(subscriptionHash, signature);\n', '\n', '        //the signature must be valid\n', '        require(signer == from, "Invalid Signature for subscription cancellation");\n', '\n', '        //nextValidTimestamp should be a timestamp that will never\n', '        //be reached during the brief window human existence\n', '        nextValidTimestamp[subscriptionHash]=uint256(-1);\n', '\n', '        return true;\n', '    }\n', '\n', '    // execute the transferFrom to pay the publisher from the subscriber\n', '    // the subscriber has full control by approving this contract an allowance\n', '    function executeSubscription(\n', '        address from, //the subscriber\n', '        address to, //the publisher\n', '        address tokenAddress, //the token address paid to the publisher\n', '        uint256 tokenAmount, //the token amount paid to the publisher\n', '        uint256 periodSeconds, //the period in seconds between payments\n', '        uint256 gasPrice, //the amount of tokens or eth to pay relayer (0 for free)\n', '        uint256 nonce, // to allow multiple subscriptions with the same parameters\n', '        bytes signature //proof the subscriber signed the meta trasaction\n', '    )\n', '        public\n', '        returns (bool success)\n', '    {\n', '        // make sure the subscription is valid and ready\n', '        // pulled this out so I have the hash, should be exact code as "isSubscriptionReady"\n', '        bytes32 subscriptionHash = getSubscriptionHash(\n', '            from, to, tokenAddress, tokenAmount, periodSeconds, gasPrice, nonce\n', '        );\n', '        address signer = getSubscriptionSigner(subscriptionHash, signature);\n', '\n', "        //make sure they aren't sending to themselves\n", '        require(to != from, "Can not send to the from address");\n', '        //the signature must be valid\n', '        require(signer == from, "Invalid Signature");\n', '        //timestamp must be equal to or past the next period\n', '        require(\n', '            block.timestamp >= nextValidTimestamp[subscriptionHash],\n', '            "Subscription is not ready"\n', '        );\n', '\n', "        // if there are requirements from the deployer, let's make sure\n", '        // those are met exactly\n', '        require( requiredToAddress == address(0) || to == requiredToAddress );\n', '        require( requiredTokenAddress == address(0) || tokenAddress == requiredTokenAddress );\n', '        require( requiredTokenAmount == 0 || tokenAmount == requiredTokenAmount );\n', '        require( requiredPeriodSeconds == 0 || periodSeconds == requiredPeriodSeconds );\n', '        require( requiredGasPrice == 0 || gasPrice == requiredGasPrice );\n', '\n', '        //increment the timestamp by the period so it wont be valid until then\n', '        nextValidTimestamp[subscriptionHash] = block.timestamp.add(periodSeconds);\n', '\n', "        //check to see if this nonce is larger than the current count and we'll set that for this 'from'\n", '        if(nonce > extraNonce[from]){\n', '          extraNonce[from] = nonce;\n', '        }\n', '\n', '        // now, let make the transfer from the subscriber to the publisher\n', '        ERC20(tokenAddress).transferFrom(from,to,tokenAmount);\n', '        require(\n', '            checkSuccess(),\n', '            "Subscription::executeSubscription TransferFrom failed"\n', '        );\n', '\n', '        emit ExecuteSubscription(\n', '            from, to, tokenAddress, tokenAmount, periodSeconds, gasPrice, nonce\n', '        );\n', '\n', '        // it is possible for the subscription execution to be run by a third party\n', '        // incentivized in the terms of the subscription with a gasPrice of the tokens\n', '        //  - pay that out now...\n', '        if (gasPrice > 0) {\n', '            //the relayer is incentivized by a little of the same token from\n', '            // the subscriber ... as far as the subscriber knows, they are\n', '            // just sending X tokens to the publisher, but the publisher can\n', '            // choose to send Y of those X to a relayer to run their transactions\n', '            // the publisher will receive X - Y tokens\n', '            // this must all be setup in the constructor\n', '            // if not, the subscriber chooses all the params including what goes\n', '            // to the publisher and what goes to the relayer\n', '            ERC20(tokenAddress).transferFrom(from, msg.sender, gasPrice);\n', '            require(\n', '                checkSuccess(),\n', '                "Subscription::executeSubscription Failed to pay gas as from account"\n', '            );\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    // because of issues with non-standard erc20s the transferFrom can always return false\n', '    // to fix this we run it and then check the return of the previous function:\n', '    //    https://github.com/ethereum/solidity/issues/4116\n', '    /**\n', '     * Checks the return value of the previous function. Returns true if the previous function\n', '     * function returned 32 non-zero bytes or returned zero bytes.\n', '     */\n', '    function checkSuccess(\n', '    )\n', '        private\n', '        pure\n', '        returns (bool)\n', '    {\n', '        uint256 returnValue = 0;\n', '\n', '        /* solium-disable-next-line security/no-inline-assembly */\n', '        assembly {\n', '            // check number of bytes returned from last function call\n', '            switch returndatasize\n', '\n', '            // no bytes returned: assume success\n', '            case 0x0 {\n', '                returnValue := 1\n', '            }\n', '\n', '            // 32 bytes returned: check if non-zero\n', '            case 0x20 {\n', '                // copy 32 bytes into scratch space\n', '                returndatacopy(0x0, 0x0, 0x20)\n', '\n', '                // load those bytes into returnValue\n', '                returnValue := mload(0x0)\n', '            }\n', '\n', '            // not sure what was returned: dont mark as success\n', '            default { }\n', '        }\n', '\n', '        return returnValue != 0;\n', '    }\n', '}']