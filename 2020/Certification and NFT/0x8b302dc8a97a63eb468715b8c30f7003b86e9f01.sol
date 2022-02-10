['pragma solidity ^0.6.0;\n', '\n', 'interface TokenInterface {\n', '    function approve(address, uint256) external;\n', '    function transfer(address, uint) external;\n', '    function transferFrom(address, address, uint) external;\n', '    function deposit() external payable;\n', '    function withdraw(uint) external;\n', '    function balanceOf(address) external view returns (uint);\n', '    function decimals() external view returns (uint);\n', '}\n', '\n', 'interface MemoryInterface {\n', '    function getUint(uint id) external returns (uint num);\n', '    function setUint(uint id, uint val) external;\n', '}\n', '\n', 'interface EventInterface {\n', '    function emitEvent(uint connectorType, uint connectorID, bytes32 eventCode, bytes calldata eventData) external;\n', '}\n', '\n', '\n', 'contract Stores {\n', '\n', '  /**\n', '   * @dev Return ethereum address\n', '   */\n', '  function getEthAddr() internal pure returns (address) {\n', '    return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE; // ETH Address\n', '  }\n', '\n', '  /**\n', '   * @dev Return memory variable address\n', '   */\n', '  function getMemoryAddr() internal pure returns (address) {\n', '    return 0x8a5419CfC711B2343c17a6ABf4B2bAFaBb06957F; // InstaMemory Address\n', '  }\n', '\n', '  /**\n', '   * @dev Return InstaEvent Address.\n', '   */\n', '  function getEventAddr() internal pure returns (address) {\n', '    return 0x2af7ea6Cb911035f3eb1ED895Cb6692C39ecbA97; // InstaEvent Address\n', '  }\n', '\n', '  /**\n', '   * @dev Get Uint value from InstaMemory Contract.\n', '   */\n', '  function getUint(uint getId, uint val) internal returns (uint returnVal) {\n', '    returnVal = getId == 0 ? val : MemoryInterface(getMemoryAddr()).getUint(getId);\n', '  }\n', '\n', '  /**\n', '  * @dev Set Uint value in InstaMemory Contract.\n', '  */\n', '  function setUint(uint setId, uint val) virtual internal {\n', '    if (setId != 0) MemoryInterface(getMemoryAddr()).setUint(setId, val);\n', '  }\n', '\n', '  /**\n', '  * @dev emit event on event contract\n', '  */\n', '  function emitEvent(bytes32 eventCode, bytes memory eventData) virtual internal {\n', '    (uint model, uint id) = connectorID();\n', '    EventInterface(getEventAddr()).emitEvent(model, id, eventCode, eventData);\n', '  }\n', '\n', '  /**\n', '  * @dev Connector Details.\n', '  */\n', '  function connectorID() public view returns(uint model, uint id) {\n', '    (model, id) = (1, 44);\n', '  }\n', '\n', '}\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract DSMath {\n', '  uint constant WAD = 10 ** 18;\n', '  uint constant RAY = 10 ** 27;\n', '\n', '  function add(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(x, y);\n', '  }\n', '\n', '  function sub(uint x, uint y) internal virtual pure returns (uint z) {\n', '    z = SafeMath.sub(x, y);\n', '  }\n', '\n', '  function mul(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.mul(x, y);\n', '  }\n', '\n', '  function div(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.div(x, y);\n', '  }\n', '\n', '  function wmul(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, y), WAD / 2) / WAD;\n', '  }\n', '\n', '  function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, WAD), y / 2) / y;\n', '  }\n', '\n', '  function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, RAY), y / 2) / y;\n', '  }\n', '\n', '  function rmul(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, y), RAY / 2) / RAY;\n', '  }\n', '\n', '}\n', '\n', 'interface ISwerve {\n', '  function underlying_coins(int128 tokenId) external view returns (address token);\n', '  function calc_token_amount(uint256[4] calldata amounts, bool deposit) external returns (uint256 amount);\n', '  function add_liquidity(uint256[4] calldata amounts, uint256 min_mint_amount) external;\n', '  function get_dy(int128 sellTokenId, int128 buyTokenId, uint256 sellTokenAmt) external returns (uint256 buyTokenAmt);\n', '  function exchange(int128 sellTokenId, int128 buyTokenId, uint256 sellTokenAmt, uint256 minBuyToken) external;\n', '  function remove_liquidity_imbalance(uint256[4] calldata amounts, uint256 max_burn_amount) external;\n', '}\n', '\n', 'interface ISwerveZap {\n', '  function calc_withdraw_one_coin(uint256 _token_amount, int128 i) external returns (uint256 amount);\n', '}\n', '\n', '\n', 'contract SwerveHelpers is Stores, DSMath {\n', '  /**\n', '  * @dev Return Swerve Swap Address\n', '  */\n', '  function getSwerveSwapAddr() internal pure returns (address) {\n', '    return 0x329239599afB305DA0A2eC69c58F8a6697F9F88d;\n', '  }\n', '\n', '  /**\n', '  * @dev Return Swerve Token Address\n', '  */\n', '  function getSwerveTokenAddr() internal pure returns (address) {\n', '    return 0x77C6E4a580c0dCE4E5c7a17d0bc077188a83A059;\n', '  }\n', '\n', '  /**\n', '  * @dev Return Swerve Zap Address\n', '  */\n', '  function getSwerveZapAddr() internal pure returns (address) {\n', '    return 0xa746c67eB7915Fa832a4C2076D403D4B68085431;\n', '  }\n', '\n', '  function convert18ToDec(uint _dec, uint256 _amt) internal pure returns (uint256 amt) {\n', '    amt = (_amt / 10 ** (18 - _dec));\n', '  }\n', '\n', '  function convertTo18(uint _dec, uint256 _amt) internal pure returns (uint256 amt) {\n', '    amt = mul(_amt, 10 ** (18 - _dec));\n', '  }\n', '\n', '  function getTokenI(address token) internal pure returns (int128 i) {\n', '    if (token == address(0x6B175474E89094C44Da98b954EedeAC495271d0F)) {\n', '      // DAI Token\n', '      i = 0;\n', '    } else if (token == address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)) {\n', '      // USDC Token\n', '      i = 1;\n', '    } else if (token == address(0xdAC17F958D2ee523a2206206994597C13D831ec7)) {\n', '      // USDT Token\n', '      i = 2;\n', '    } else if (token == address(0x0000000000085d4780B73119b644AE5ecd22b376)) {\n', '      // TUSD Token\n', '      i = 3;\n', '    } else {\n', '      revert("token-not-found.");\n', '    }\n', '  }\n', '}\n', '\n', 'contract SwerveProtocol is SwerveHelpers {\n', '\n', '  event LogSell(\n', '    address indexed buyToken,\n', '    address indexed sellToken,\n', '    uint256 buyAmt,\n', '    uint256 sellAmt,\n', '    uint256 getId,\n', '    uint256 setId\n', '  );\n', '  event LogDeposit(address token, uint256 amt, uint256 mintAmt, uint256 getId, uint256 setId);\n', '  event LogWithdraw(address token, uint256 amt, uint256 burnAmt, uint256 getId,  uint256 setId);\n', '\n', '  /**\n', '    * @dev Sell Stable ERC20_Token.\n', '    * @param buyAddr buying token address.\n', '    * @param sellAddr selling token amount.\n', '    * @param sellAmt selling token amount.\n', '    * @param unitAmt unit amount of buyAmt/sellAmt with slippage.\n', '    * @param getId Get token amount at this ID from `InstaMemory` Contract.\n', '    * @param setId Set token amount at this ID in `InstaMemory` Contract.\n', '  */\n', '  function sell(\n', '    address buyAddr,\n', '    address sellAddr,\n', '    uint sellAmt,\n', '    uint unitAmt,\n', '    uint getId,\n', '    uint setId\n', '  ) external payable {\n', '    uint _sellAmt = getUint(getId, sellAmt);\n', '    ISwerve swerve = ISwerve(getSwerveSwapAddr());\n', '    TokenInterface _buyToken = TokenInterface(buyAddr);\n', '    TokenInterface _sellToken = TokenInterface(sellAddr);\n', '    _sellAmt = _sellAmt == uint(-1) ? _sellToken.balanceOf(address(this)) : _sellAmt;\n', '    _sellToken.approve(address(swerve), _sellAmt);\n', '\n', '    uint _slippageAmt = convert18ToDec(_buyToken.decimals(), wmul(unitAmt, convertTo18(_sellToken.decimals(), _sellAmt)));\n', '\n', '    uint intialBal = _buyToken.balanceOf(address(this));\n', '    swerve.exchange(getTokenI(sellAddr), getTokenI(buyAddr), _sellAmt, _slippageAmt);\n', '    uint finalBal = _buyToken.balanceOf(address(this));\n', '\n', '    uint _buyAmt = sub(finalBal, intialBal);\n', '\n', '    setUint(setId, _buyAmt);\n', '\n', '    emit LogSell(buyAddr, sellAddr, _buyAmt, _sellAmt, getId, setId);\n', '    bytes32 _eventCode = keccak256("LogSell(address,address,uint256,uint256,uint256,uint256)");\n', '    bytes memory _eventParam = abi.encode(buyAddr, sellAddr, _buyAmt, _sellAmt, getId, setId);\n', '    emitEvent(_eventCode, _eventParam);\n', '\n', '  }\n', '\n', '  /**\n', '    * @dev Deposit Token.\n', '    * @param token token address.\n', '    * @param amt token amount.\n', '    * @param unitAmt unit amount of swerve_amt/token_amt with slippage.\n', '    * @param getId Get token amount at this ID from `InstaMemory` Contract.\n', '    * @param setId Set token amount at this ID in `InstaMemory` Contract.\n', '  */\n', '  function deposit(\n', '    address token,\n', '    uint amt,\n', '    uint unitAmt,\n', '    uint getId,\n', '    uint setId\n', '  ) external payable {\n', '    uint256 _amt = getUint(getId, amt);\n', '    TokenInterface tokenContract = TokenInterface(token);\n', '\n', '    _amt = _amt == uint(-1) ? tokenContract.balanceOf(address(this)) : _amt;\n', '    uint[4] memory _amts;\n', '    _amts[uint(getTokenI(token))] = _amt;\n', '\n', '    tokenContract.approve(getSwerveSwapAddr(), _amt);\n', '\n', '    uint _amt18 = convertTo18(tokenContract.decimals(), _amt);\n', '    uint _slippageAmt = wmul(unitAmt, _amt18);\n', '\n', '    TokenInterface swerveTokenContract = TokenInterface(getSwerveTokenAddr());\n', '    uint initialSwerveBal = swerveTokenContract.balanceOf(address(this));\n', '\n', '    ISwerve(getSwerveSwapAddr()).add_liquidity(_amts, _slippageAmt);\n', '\n', '    uint finalSwerveBal = swerveTokenContract.balanceOf(address(this));\n', '\n', '    uint mintAmt = sub(finalSwerveBal, initialSwerveBal);\n', '\n', '    setUint(setId, mintAmt);\n', '\n', '    emit LogDeposit(token, _amt, mintAmt, getId, setId);\n', '    bytes32 _eventCode = keccak256("LogDeposit(address,uint256,uint256,uint256,uint256)");\n', '    bytes memory _eventParam = abi.encode(token, _amt, mintAmt, getId, setId);\n', '    emitEvent(_eventCode, _eventParam);\n', '  }\n', '\n', '  /**\n', '    * @dev Withdraw Token.\n', '    * @param token token address.\n', '    * @param amt token amount.\n', '    * @param unitAmt unit amount of swerve_amt/token_amt with slippage.\n', '    * @param getId Get token amount at this ID from `InstaMemory` Contract.\n', '    * @param setId Set token amount at this ID in `InstaMemory` Contract.\n', '  */\n', '  function withdraw(\n', '    address token,\n', '    uint256 amt,\n', '    uint256 unitAmt,\n', '    uint getId,\n', '    uint setId\n', '  ) external payable {\n', '    uint _amt = getUint(getId, amt);\n', '    int128 tokenId = getTokenI(token);\n', '\n', '    TokenInterface swerveTokenContract = TokenInterface(getSwerveTokenAddr());\n', '    ISwerveZap swerveZap = ISwerveZap(getSwerveZapAddr());\n', '    ISwerve swerveSwap = ISwerve(getSwerveSwapAddr());\n', '\n', '    uint _swerveAmt;\n', '    uint[4] memory _amts;\n', '    if (_amt == uint(-1)) {\n', '      _swerveAmt = swerveTokenContract.balanceOf(address(this));\n', '      _amt = swerveZap.calc_withdraw_one_coin(_swerveAmt, tokenId);\n', '      _amts[uint(tokenId)] = _amt;\n', '    } else {\n', '      _amts[uint(tokenId)] = _amt;\n', '      _swerveAmt = swerveSwap.calc_token_amount(_amts, false);\n', '    }\n', '\n', '\n', '    uint _amt18 = convertTo18(TokenInterface(token).decimals(), _amt);\n', '    uint _slippageAmt = wmul(unitAmt, _amt18);\n', '\n', '    swerveTokenContract.approve(address(swerveSwap), 0);\n', '    swerveTokenContract.approve(address(swerveSwap), _slippageAmt);\n', '\n', '    swerveSwap.remove_liquidity_imbalance(_amts, _slippageAmt);\n', '\n', '    setUint(setId, _amt);\n', '\n', '    emit LogWithdraw(token, _amt, _swerveAmt, getId, setId);\n', '    bytes32 _eventCode = keccak256("LogWithdraw(address,uint256,uint256,uint256,uint256)");\n', '    bytes memory _eventParam = abi.encode(token, _amt, _swerveAmt, getId, setId);\n', '    emitEvent(_eventCode, _eventParam);\n', '  }\n', '\n', '}\n', '\n', 'contract ConnectSwerve is SwerveProtocol {\n', '  string public name = "Swerve-swUSD-v1.0";\n', '}']