['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-08\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Roles\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' */\n', 'library Roles {\n', '    struct Role {\n', '        mapping (address => bool) bearer;\n', '    }\n', '\n', '    /**\n', '     * @dev give an account access to this role\n', '     */\n', '    function add(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(!has(role, account));\n', '\n', '        role.bearer[account] = true;\n', '    }\n', '\n', '    /**\n', "     * @dev remove an account's access to this role\n", '     */\n', '    function remove(Role storage role, address account) internal {\n', '        require(account != address(0));\n', '        require(has(role, account));\n', '\n', '        role.bearer[account] = false;\n', '    }\n', '\n', '    /**\n', '     * @dev check if an account has this role\n', '     * @return bool\n', '     */\n', '    function has(Role storage role, address account) internal view returns (bool) {\n', '        require(account != address(0));\n', '        return role.bearer[account];\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title WhitelistAdminRole\n', ' * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.\n', ' */\n', 'contract WhitelistAdminRole {\n', '    using Roles for Roles.Role;\n', '\n', '    event WhitelistAdminAdded(address indexed account);\n', '    event WhitelistAdminRemoved(address indexed account);\n', '\n', '    Roles.Role private _whitelistAdmins;\n', '\n', '    constructor () internal {\n', '        _addWhitelistAdmin(msg.sender);\n', '    }\n', '\n', '    modifier onlyWhitelistAdmin() {\n', '        require(isWhitelistAdmin(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isWhitelistAdmin(address account) public view returns (bool) {\n', '        return _whitelistAdmins.has(account);\n', '    }\n', '\n', '    function addWhitelistAdmin(address account) public onlyWhitelistAdmin {\n', '        _addWhitelistAdmin(account);\n', '    }\n', '\n', '    function renounceWhitelistAdmin() public {\n', '        _removeWhitelistAdmin(msg.sender);\n', '    }\n', '\n', '    function _addWhitelistAdmin(address account) internal {\n', '        _whitelistAdmins.add(account);\n', '        emit WhitelistAdminAdded(account);\n', '    }\n', '\n', '    function _removeWhitelistAdmin(address account) internal {\n', '        _whitelistAdmins.remove(account);\n', '        emit WhitelistAdminRemoved(account);\n', '    }\n', '}\n', '\n', '\n', 'interface ERC20fraction {\n', '  function decimals() external view returns (uint8);\n', '}\n', '\n', 'interface AggregatorFraction {\n', '  function decimals() external view returns (uint8);\n', '  function latestAnswer() external view returns (int256);\n', '  function latestTimestamp() external view returns (uint256);\n', '}\n', '\n', '\n', '/**\n', ' * @title ChainlinkConversionPath\n', ' *\n', ' * @notice ChainlinkConversionPath is a contract allowing to compute conversion rate from a Chainlink aggretators\n', ' */\n', 'contract ChainlinkConversionPath is WhitelistAdminRole {\n', '  using SafeMath for uint256;\n', '\n', '  uint constant DECIMALS = 1e18;\n', '\n', '  // Mapping of Chainlink aggregators (input currency => output currency => contract address)\n', '  // input & output currencies are the addresses of the ERC20 contracts OR the sha3("currency code")\n', '  mapping(address => mapping(address => address)) public allAggregators;\n', '\n', '  // declare a new aggregator\n', '  event AggregatorUpdated(address _input, address _output, address _aggregator);\n', '\n', '  /**\n', '    * @notice Update an aggregator\n', '    * @param _input address representing the input currency\n', '    * @param _output address representing the output currency\n', '    * @param _aggregator address of the aggregator contract\n', '  */\n', '  function updateAggregator(address _input, address _output, address _aggregator)\n', '    external\n', '    onlyWhitelistAdmin\n', '  {\n', '    allAggregators[_input][_output] = _aggregator;\n', '    emit AggregatorUpdated(_input, _output, _aggregator);\n', '  }\n', '\n', '  /**\n', '    * @notice Update a list of aggregators\n', '    * @param _inputs list of addresses representing the input currencies\n', '    * @param _outputs list of addresses representing the output currencies\n', '    * @param _aggregators list of addresses of the aggregator contracts\n', '  */\n', '  function updateAggregatorsList(address[] calldata _inputs, address[] calldata _outputs, address[] calldata _aggregators)\n', '    external\n', '    onlyWhitelistAdmin\n', '  {\n', '    require(_inputs.length == _outputs.length, "arrays must have the same length");\n', '    require(_inputs.length == _aggregators.length, "arrays must have the same length");\n', '\n', '    // For every conversions of the path\n', '    for (uint i; i < _inputs.length; i++) {\n', '      allAggregators[_inputs[i]][_outputs[i]] = _aggregators[i];\n', '      emit AggregatorUpdated(_inputs[i], _outputs[i], _aggregators[i]);\n', '    }\n', '  }\n', '\n', '  /**\n', '  * @notice Computes the conversion from an amount through a list of conversion\n', '  * @param _amountIn Amount to convert\n', '  * @param _path List of addresses representing the currencies for the conversions\n', '  * @return result the result after all the conversion\n', '  * @return oldestRateTimestamp he oldest timestamp of the path\n', '  */\n', '  function getConversion(\n', '    uint256 _amountIn,\n', '    address[] calldata _path\n', '  )\n', '    external\n', '    view\n', '    returns (uint256 result, uint256 oldestRateTimestamp)\n', '  {\n', '    (uint256 rate, uint256 timestamp, uint256 decimals) = getRate(_path);\n', '\n', '    // initialize the result\n', '    result = _amountIn.mul(rate).div(decimals);\n', '\n', '    oldestRateTimestamp = timestamp;\n', '  }\n', '\n', '  /**\n', '  * @notice Computes the rate from a list of conversion\n', '  * @param _path List of addresses representing the currencies for the conversions\n', '  * @return rate the rate\n', '  * @return oldestRateTimestamp he oldest timestamp of the path\n', '  * @return decimals of the conversion rate\n', '  */\n', '  function getRate(\n', '    address[] memory _path\n', '  )\n', '    public\n', '    view\n', '    returns (uint256 rate, uint256 oldestRateTimestamp, uint256 decimals)\n', '  {\n', '    // initialize the result with 1e18 decimals (for more precision)\n', '    rate = DECIMALS;\n', '    decimals = DECIMALS;\n', '    oldestRateTimestamp = block.timestamp;\n', '\n', '    // For every conversions of the path\n', '    for (uint i; i < _path.length - 1; i++) {\n', '      (AggregatorFraction aggregator, bool reverseAggregator, uint256 decimalsInput, uint256 decimalsOutput) = getAggregatorAndDecimals(_path[i], _path[i + 1]);\n', '\n', '      // store the latest timestamp of the path\n', '      uint256 currentTimestamp = aggregator.latestTimestamp();\n', '      if (currentTimestamp < oldestRateTimestamp) {\n', '        oldestRateTimestamp = currentTimestamp;\n', '      }\n', '\n', '      // get the rate of the current step\n', '      uint256 currentRate = uint256(aggregator.latestAnswer());\n', '      // get the number of decimal of the current rate\n', '      uint256 decimalsAggregator = uint256(aggregator.decimals());\n', '\n', '      // mul with the difference of decimals before the current rate computation (for more precision)\n', '      if (decimalsAggregator > decimalsInput) {\n', '        rate = rate.mul(10**(decimalsAggregator-decimalsInput));\n', '      }\n', '      if (decimalsAggregator < decimalsOutput) {\n', '        rate = rate.mul(10**(decimalsOutput-decimalsAggregator));\n', '      }\n', '\n', '      // Apply the current rate (if path uses an aggregator in the reverse way, div instead of mul)\n', '      if (reverseAggregator) {\n', '        rate = rate.mul(10**decimalsAggregator).div(currentRate);\n', '      } else {\n', '        rate = rate.mul(currentRate).div(10**decimalsAggregator);\n', '      }\n', '\n', '      // div with the difference of decimals AFTER the current rate computation (for more precision)\n', '      if (decimalsAggregator < decimalsInput) {\n', '        rate = rate.div(10**(decimalsInput-decimalsAggregator));\n', '      }\n', '      if (decimalsAggregator > decimalsOutput) {\n', '        rate = rate.div(10**(decimalsAggregator-decimalsOutput));\n', '      }\n', '    }\n', '  }\n', '\n', '  /**\n', '  * @notice Gets aggregators and decimals of two currencies\n', '  * @param _input input Address\n', '  * @param _output output Address\n', '  * @return aggregator to get the rate between the two currencies\n', '  * @return reverseAggregator true if the aggregator returned give the rate from _output to _input\n', '  * @return decimalsInput decimals of _input\n', '  * @return decimalsOutput decimals of _output\n', '  */\n', '  function getAggregatorAndDecimals(address _input, address _output)\n', '    private\n', '    view\n', '    returns (AggregatorFraction aggregator, bool reverseAggregator, uint256 decimalsInput, uint256 decimalsOutput)\n', '  {\n', '    // Try to get the right aggregator for the conversion\n', '    aggregator = AggregatorFraction(allAggregators[_input][_output]);\n', '    reverseAggregator = false;\n', '\n', '    // if no aggregator found we try to find an aggregator in the reverse way\n', '    if (address(aggregator) == address(0x00)) {\n', '      aggregator = AggregatorFraction(allAggregators[_output][_input]);\n', '      reverseAggregator = true;\n', '    }\n', '\n', '    require(address(aggregator) != address(0x00), "No aggregator found");\n', '\n', '    // get the decimals for the two currencies\n', '    decimalsInput = getDecimals(_input);\n', '    decimalsOutput = getDecimals(_output);\n', '  }\n', '\n', '  /**\n', '  * @notice Gets decimals from an address currency\n', '  * @param _addr address to check\n', '  * @return number of decimals\n', '  */\n', '  function getDecimals(address _addr)\n', '    private\n', '    view\n', '    returns (uint256 decimals)\n', '  {\n', '    // by default we assume it is FIAT so 8 decimals\n', '    decimals = 8;\n', "    // if address is 0, then it's ETH\n", '    if (_addr == address(0x0)) {\n', '      decimals = 18;\n', '    } else if (isContract(_addr)) {\n', '      // otherwise, we get the decimals from the erc20 directly\n', '      decimals = ERC20fraction(_addr).decimals();\n', '    }\n', '  }\n', '\n', '  /**\n', '  * @notice Checks if an address is a contract\n', '  * @param _addr Address to check\n', '  * @return true if the address host a contract, false otherwise\n', '  */\n', '  function isContract(address _addr)\n', '    private\n', '    view\n', '    returns (bool)\n', '  {\n', '    uint32 size;\n', '    // solium-disable security/no-inline-assembly\n', '    assembly {\n', '      size := extcodesize(_addr)\n', '    }\n', '    return (size > 0);\n', '  }\n', '}\n', '\n', 'interface IERC20FeeProxy {\n', '  event TransferWithReferenceAndFee(\n', '    address tokenAddress,\n', '    address to,\n', '    uint256 amount,\n', '    bytes indexed paymentReference,\n', '    uint256 feeAmount,\n', '    address feeAddress\n', '  );\n', '\n', '  function transferFromWithReferenceAndFee(\n', '    address _tokenAddress,\n', '    address _to,\n', '    uint256 _amount,\n', '    bytes calldata _paymentReference,\n', '    uint256 _feeAmount,\n', '    address _feeAddress\n', '    ) external;\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20ConversionProxy\n', ' */\n', 'contract ERC20ConversionProxy {\n', '  using SafeMath for uint256;\n', '\n', '  address public paymentProxy;\n', '  ChainlinkConversionPath public chainlinkConversionPath;\n', '\n', '  constructor(address _paymentProxyAddress, address _chainlinkConversionPathAddress) public {\n', '    paymentProxy = _paymentProxyAddress;\n', '    chainlinkConversionPath = ChainlinkConversionPath(_chainlinkConversionPathAddress);\n', '  }\n', '\n', '  // Event to declare a transfer with a reference\n', '  event TransferWithConversionAndReference(\n', '    uint256 amount,\n', '    address currency,\n', '    bytes indexed paymentReference,\n', '    uint256 feeAmount,\n', '    uint256 maxRateTimespan\n', '  );\n', '\n', '  /**\n', '   * @notice Performs an ERC20 token transfer with a reference computing the amount based on a fiat amount\n', '   * @param _to Transfer recipient\n', '   * @param _requestAmount request amount\n', '   * @param _path conversion path\n', '   * @param _paymentReference Reference of the payment related\n', '   * @param _feeAmount The amount of the payment fee\n', '   * @param _feeAddress The fee recipient\n', '   * @param _maxToSpend amount max that we can spend on the behalf of the user\n', '   * @param _maxRateTimespan max time span with the oldestrate, ignored if zero\n', '   */\n', '  function transferFromWithReferenceAndFee(\n', '    address _to,\n', '    uint256 _requestAmount,\n', '    address[] calldata _path,\n', '    bytes calldata _paymentReference,\n', '    uint256 _feeAmount,\n', '    address _feeAddress,\n', '    uint256 _maxToSpend,\n', '    uint256 _maxRateTimespan\n', '  ) external\n', '  {\n', '    (uint256 amountToPay, uint256 amountToPayInFees) = getConversions(_path, _requestAmount, _feeAmount, _maxRateTimespan);\n', '\n', '    require(amountToPay.add(amountToPayInFees) <= _maxToSpend, "Amount to pay is over the user limit");\n', '\n', '    // Pay the request and fees\n', '    (bool status, ) = paymentProxy.delegatecall(\n', '      abi.encodeWithSignature(\n', '        "transferFromWithReferenceAndFee(address,address,uint256,bytes,uint256,address)",\n', '        // payment currency\n', '        _path[_path.length - 1],\n', '        _to,\n', '        amountToPay,\n', '        _paymentReference,\n', '        amountToPayInFees,\n', '        _feeAddress\n', '      )\n', '    );\n', '    require(status, "transferFromWithReferenceAndFee failed");\n', '\n', '    // Event to declare a transfer with a reference\n', '    emit TransferWithConversionAndReference(\n', '      _requestAmount,\n', '      // request currency\n', '      _path[0],\n', '      _paymentReference,\n', '      _feeAmount,\n', '      _maxRateTimespan\n', '    );\n', '  }\n', '\n', '  function getConversions(\n', '    address[] memory _path,\n', '    uint256 _requestAmount,\n', '    uint256 _feeAmount,\n', '    uint256 _maxRateTimespan\n', '  ) internal\n', '    returns (uint256 amountToPay, uint256 amountToPayInFees)\n', '  {\n', '    (uint256 rate, uint256 oldestTimestampRate, uint256 decimals) = chainlinkConversionPath.getRate(_path);\n', '\n', '    // Check rate timespan\n', '    require(_maxRateTimespan == 0 || block.timestamp.sub(oldestTimestampRate) <= _maxRateTimespan, "aggregator rate is outdated");\n', '    \n', '    // Get the amount to pay in the crypto currency chosen\n', '    amountToPay = _requestAmount.mul(rate).div(decimals);\n', '    amountToPayInFees = _feeAmount.mul(rate).div(decimals);\n', '  }\n', '}']