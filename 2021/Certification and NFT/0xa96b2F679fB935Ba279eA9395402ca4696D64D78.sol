['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-25\n', '*/\n', '\n', '// Sources flattened with hardhat v2.1.1 https://hardhat.org\n', 'pragma solidity ^0.7.0;\n', '\n', '// File @openzeppelin/contracts/math/[email\xa0protected]\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '// File contracts/mainnet/common/math.sol\n', '\n', 'contract DSMath {\n', '  uint constant WAD = 10 ** 18;\n', '  uint constant RAY = 10 ** 27;\n', '\n', '  function add(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(x, y);\n', '  }\n', '\n', '  function sub(uint x, uint y) internal virtual pure returns (uint z) {\n', '    z = SafeMath.sub(x, y);\n', '  }\n', '\n', '  function mul(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.mul(x, y);\n', '  }\n', '\n', '  function div(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.div(x, y);\n', '  }\n', '\n', '  function wmul(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, y), WAD / 2) / WAD;\n', '  }\n', '\n', '  function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, WAD), y / 2) / y;\n', '  }\n', '\n', '  function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, RAY), y / 2) / y;\n', '  }\n', '\n', '  function rmul(uint x, uint y) internal pure returns (uint z) {\n', '    z = SafeMath.add(SafeMath.mul(x, y), RAY / 2) / RAY;\n', '  }\n', '\n', '  function toInt(uint x) internal pure returns (int y) {\n', '    y = int(x);\n', '    require(y >= 0, "int-overflow");\n', '  }\n', '\n', '  function toRad(uint wad) internal pure returns (uint rad) {\n', '    rad = mul(wad, 10 ** 27);\n', '  }\n', '\n', '}\n', '\n', '\n', '// File contracts/mainnet/common/interfaces.sol\n', '\n', 'interface TokenInterface {\n', '    function approve(address, uint256) external;\n', '    function transfer(address, uint) external;\n', '    function transferFrom(address, address, uint) external;\n', '    function deposit() external payable;\n', '    function withdraw(uint) external;\n', '    function balanceOf(address) external view returns (uint);\n', '    function decimals() external view returns (uint);\n', '}\n', '\n', 'interface MemoryInterface {\n', '    function getUint(uint id) external returns (uint num);\n', '    function setUint(uint id, uint val) external;\n', '}\n', '\n', 'interface InstaMapping {\n', '    function cTokenMapping(address) external view returns (address);\n', '    function gemJoinMapping(bytes32) external view returns (address);\n', '}\n', '\n', 'interface AccountInterface {\n', '    function enable(address) external;\n', '    function disable(address) external;\n', '    function isAuth(address) external view returns (bool);\n', '}\n', '\n', '\n', '// File contracts/mainnet/common/stores.sol\n', '\n', 'abstract contract Stores {\n', '\n', '  /**\n', '   * @dev Return ethereum address\n', '   */\n', '  address constant internal ethAddr = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '\n', '  /**\n', '   * @dev Return Wrapped ETH address\n', '   */\n', '  address constant internal wethAddr = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '\n', '  /**\n', '   * @dev Return memory variable address\n', '   */\n', '  MemoryInterface constant internal instaMemory = MemoryInterface(0x8a5419CfC711B2343c17a6ABf4B2bAFaBb06957F);\n', '\n', '  /**\n', '   * @dev Return InstaDApp Mapping Addresses\n', '   */\n', '  InstaMapping constant internal instaMapping = InstaMapping(0xe81F70Cc7C0D46e12d70efc60607F16bbD617E88);\n', '\n', '  /**\n', '   * @dev Get Uint value from InstaMemory Contract.\n', '   */\n', '  function getUint(uint getId, uint val) internal returns (uint returnVal) {\n', '    returnVal = getId == 0 ? val : instaMemory.getUint(getId);\n', '  }\n', '\n', '  /**\n', '  * @dev Set Uint value in InstaMemory Contract.\n', '  */\n', '  function setUint(uint setId, uint val) virtual internal {\n', '    if (setId != 0) instaMemory.setUint(setId, val);\n', '  }\n', '\n', '}\n', '\n', '\n', '// File contracts/mainnet/common/basic.sol\n', '\n', 'abstract contract Basic is DSMath, Stores {\n', '\n', '    function convert18ToDec(uint _dec, uint256 _amt) internal pure returns (uint256 amt) {\n', '        amt = (_amt / 10 ** (18 - _dec));\n', '    }\n', '\n', '    function convertTo18(uint _dec, uint256 _amt) internal pure returns (uint256 amt) {\n', '        amt = mul(_amt, 10 ** (18 - _dec));\n', '    }\n', '\n', '    function getTokenBal(TokenInterface token) internal view returns(uint _amt) {\n', '        _amt = address(token) == ethAddr ? address(this).balance : token.balanceOf(address(this));\n', '    }\n', '\n', '    function getTokensDec(TokenInterface buyAddr, TokenInterface sellAddr) internal view returns(uint buyDec, uint sellDec) {\n', '        buyDec = address(buyAddr) == ethAddr ?  18 : buyAddr.decimals();\n', '        sellDec = address(sellAddr) == ethAddr ?  18 : sellAddr.decimals();\n', '    }\n', '\n', '    function encodeEvent(string memory eventName, bytes memory eventParam) internal pure returns (bytes memory) {\n', '        return abi.encode(eventName, eventParam);\n', '    }\n', '\n', '    function changeEthAddress(address buy, address sell) internal pure returns(TokenInterface _buy, TokenInterface _sell){\n', '        _buy = buy == ethAddr ? TokenInterface(wethAddr) : TokenInterface(buy);\n', '        _sell = sell == ethAddr ? TokenInterface(wethAddr) : TokenInterface(sell);\n', '    }\n', '\n', '    function convertEthToWeth(bool isEth, TokenInterface token, uint amount) internal {\n', '        if(isEth) token.deposit{value: amount}();\n', '    }\n', '\n', '    function convertWethToEth(bool isEth, TokenInterface token, uint amount) internal {\n', '       if(isEth) {\n', '            token.approve(address(token), amount);\n', '            token.withdraw(amount);\n', '        }\n', '    }\n', '}\n', '\n', '\n', '// File contracts/mainnet/connectors/aave/staked-aave/interface.sol\n', 'interface AaveInterface is TokenInterface {\n', '    function delegate(address delegatee) external;\n', '    function delegateByType(address delegatee, uint8 delegationType) external;\n', '    function getDelegateeByType(address delegator, uint8 delegationType) external view returns (address);\n', '}\n', '\n', 'interface StakedAaveInterface is AaveInterface {\n', '    function stake(address onBehalfOf, uint256 amount) external;\n', '    function redeem(address to, uint256 amount) external;\n', '    function cooldown() external;\n', '    function claimRewards(address to, uint256 amount) external;\n', '}\n', '\n', '\n', '// File contracts/mainnet/connectors/aave/staked-aave/helpers.sol\n', '\n', 'abstract contract Helpers is DSMath, Basic {\n', '\n', '    enum DelegationType {VOTING_POWER, PROPOSITION_POWER, BOTH}\n', '\n', '    /**\n', '     * @dev Staked Aave Token\n', '    */\n', '    StakedAaveInterface internal constant stkAave = StakedAaveInterface(0x4da27a545c0c5B758a6BA100e3a049001de870f5);\n', '\n', '    /**\n', '     * @dev Aave Token\n', '    */\n', '    AaveInterface internal constant aave = AaveInterface(0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9);\n', '\n', '    function _delegateAave(address _delegatee, DelegationType _type) internal {\n', '        if (_type == DelegationType.BOTH) {\n', '            require(\n', '                aave.getDelegateeByType(address(this), 0) != _delegatee,\n', '                "already-delegated"\n', '            );\n', '            require(\n', '                aave.getDelegateeByType(address(this), 1) != _delegatee,\n', '                "already-delegated"\n', '            );\n', '\n', '            aave.delegate(_delegatee);\n', '        } else if (_type == DelegationType.VOTING_POWER) {\n', '            require(\n', '                aave.getDelegateeByType(address(this), 0) != _delegatee,\n', '                "already-delegated"\n', '            );\n', '\n', '            aave.delegateByType(_delegatee, 0);\n', '        } else {\n', '            require(\n', '                aave.getDelegateeByType(address(this), 1) != _delegatee,\n', '                "already-delegated"\n', '            );\n', '\n', '            aave.delegateByType(_delegatee, 1);\n', '        }\n', '    }\n', '\n', '    function _delegateStakedAave(address _delegatee, DelegationType _type) internal {\n', '        if (_type == DelegationType.BOTH) {\n', '            require(\n', '                stkAave.getDelegateeByType(address(this), 0) != _delegatee,\n', '                "already-delegated"\n', '            );\n', '            require(\n', '                stkAave.getDelegateeByType(address(this), 1) != _delegatee,\n', '                "already-delegated"\n', '            );\n', '\n', '            stkAave.delegate(_delegatee);\n', '        } else if (_type == DelegationType.VOTING_POWER) {\n', '            require(\n', '                stkAave.getDelegateeByType(address(this), 0) != _delegatee,\n', '                "already-delegated"\n', '            );\n', '\n', '            stkAave.delegateByType(_delegatee, 0);\n', '        } else {\n', '            require(\n', '                stkAave.getDelegateeByType(address(this), 1) != _delegatee,\n', '                "already-delegated"\n', '            );\n', '\n', '            stkAave.delegateByType(_delegatee, 1);\n', '        }\n', '    }\n', '}\n', '\n', '\n', '// File contracts/mainnet/connectors/aave/staked-aave/events.sol\n', '\n', 'contract Events {\n', '    event LogClaim(uint amt, uint getId, uint setId);\n', '    event LogStake(uint amt, uint getId, uint setId);\n', '    event LogCooldown();\n', '    event LogRedeem(uint amt, uint getId, uint setId);\n', '    event LogDelegate(\n', '        address delegatee,\n', '        bool delegateAave,\n', '        bool delegateStkAave,\n', '        uint8 aaveDelegationType,\n', '        uint8 stkAaveDelegationType\n', '    );\n', '}\n', '\n', '\n', '// File contracts/mainnet/connectors/aave/staked-aave/main.sol\n', '\n', 'abstract contract AaveResolver is Helpers, Events {\n', '\n', '    /**\n', '     * @dev Claim Accrued AAVE.\n', '     * @notice Claim Accrued AAVE Token rewards.\n', '     * @param amount The amount of rewards to claim. uint(-1) for max.\n', '     * @param getId ID to retrieve amount.\n', '     * @param setId ID stores the amount of tokens claimed.\n', '    */\n', '    function claim(\n', '        uint256 amount,\n', '        uint256 getId,\n', '        uint256 setId\n', '    ) external payable {\n', '        uint _amt = getUint(getId, amount);\n', '\n', '        uint intialBal = aave.balanceOf(address(this));\n', '        stkAave.claimRewards(address(this), _amt);\n', '        uint finalBal = aave.balanceOf(address(this));\n', '        _amt = sub(finalBal, intialBal);\n', '\n', '        setUint(setId, _amt);\n', '\n', '        emit LogClaim(_amt, getId, setId);\n', '    }\n', '\n', '    /**\n', '     * @dev Stake AAVE Token\n', '     * @notice Stake AAVE Token in Aave security module\n', '     * @param amount The amount of AAVE to stake. uint(-1) for max.\n', '     * @param getId ID to retrieve amount.\n', '     * @param setId ID stores the amount of tokens staked.\n', '    */\n', '    function stake(\n', '        uint256 amount,\n', '        uint256 getId,\n', '        uint256 setId\n', '    ) external payable {\n', '        uint _amt = getUint(getId, amount);\n', '\n', '        _amt = _amt == uint(-1) ? aave.balanceOf(address(this)) : _amt;\n', '        stkAave.stake(address(this), _amt);\n', '\n', '        setUint(setId, _amt);\n', '\n', '        emit LogStake(_amt, getId, setId);\n', '    }\n', '\n', '    /**\n', '     * @dev Initiate cooldown to unstake\n', '     * @notice Initiate cooldown to unstake from Aave security module\n', '    */\n', '    function cooldown() external payable {\n', '        require(stkAave.balanceOf(address(this)) > 0, "no-staking");\n', '\n', '        stkAave.cooldown();\n', '\n', '        emit LogCooldown();\n', '    }\n', '\n', '    /**\n', '     * @dev Redeem tokens from Staked AAVE\n', '     * @notice Redeem AAVE tokens from Staked AAVE after cooldown period is over\n', '     * @param amount The amount of AAVE to redeem. uint(-1) for max.\n', '     * @param getId ID to retrieve amount.\n', '     * @param setId ID stores the amount of tokens redeemed.\n', '    */\n', '    function redeem(\n', '        uint256 amount,\n', '        uint256 getId,\n', '        uint256 setId\n', '    ) external payable {\n', '        uint _amt = getUint(getId, amount);\n', '\n', '        uint intialBal = aave.balanceOf(address(this));\n', '        stkAave.redeem(address(this), _amt);\n', '        uint finalBal = aave.balanceOf(address(this));\n', '        _amt = sub(finalBal, intialBal);\n', '\n', '        setUint(setId, _amt);\n', '\n', '        emit LogRedeem(_amt, getId, setId);\n', '    }\n', '\n', '    /**\n', '     * @dev Delegate AAVE or stkAAVE\n', '     * @notice Delegate AAVE or stkAAVE\n', '     * @param delegatee The address of the delegatee\n', '     * @param delegateAave Whether to delegate Aave balance\n', '     * @param delegateStkAave Whether to delegate Staked Aave balance\n', '     * @param aaveDelegationType Aave delegation type. Voting power - 0, Proposition power - 1, Both - 2\n', '     * @param stkAaveDelegationType Staked Aave delegation type. Values similar to aaveDelegationType\n', '    */\n', '    function delegate(\n', '        address delegatee,\n', '        bool delegateAave,\n', '        bool delegateStkAave,\n', '        uint8 aaveDelegationType,\n', '        uint8 stkAaveDelegationType\n', '    ) external payable {\n', '        require(delegateAave || delegateStkAave, "invalid-delegate");\n', '        require(delegatee != address(0), "invalid-delegatee");\n', '\n', '        if (delegateAave) {\n', '            _delegateAave(delegatee, Helpers.DelegationType(aaveDelegationType));\n', '        }\n', '\n', '        if (delegateStkAave) {\n', '            _delegateStakedAave(delegatee, Helpers.DelegationType(stkAaveDelegationType));\n', '        }\n', '\n', '        emit LogDelegate(delegatee, delegateAave, delegateStkAave, aaveDelegationType, stkAaveDelegationType);\n', '    }\n', '}\n', '\n', '\n', 'contract ConnectAaveStake is AaveResolver {\n', '    /**\n', '    * @dev Connector ID and Type.\n', '    */\n', '    function connectorID() public pure returns(uint _type, uint _id) {\n', '        (_type, _id) = (1, 93);\n', '    }\n', '\n', '    string public constant name = "Aave-Stake-v1";\n', '}']