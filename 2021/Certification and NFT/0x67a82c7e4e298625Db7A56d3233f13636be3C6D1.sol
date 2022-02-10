['// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.5;\n', 'pragma experimental ABIEncoderV2;\n', '\n', "import {IStakedToken} from '../interfaces/IStakedToken.sol';\n", "import {StakeUIHelperI} from './StakeUIHelperI.sol';\n", "import {IERC20WithNonce} from './IERC20WithNonce.sol';\n", "import {IERC20} from '../lib/ERC20.sol';\n", "import {IPriceOracle} from './IPriceOracle.sol';\n", '\n', 'interface BPTPriceFeedI {\n', '  function latestAnswer() external view returns (uint256);\n', '}\n', '\n', 'contract StakeUIHelper is StakeUIHelperI {\n', '  IPriceOracle public immutable PRICE_ORACLE;\n', '  BPTPriceFeedI public immutable BPT_PRICE_FEED;\n', '\n', '  address public immutable AAVE;\n', '  IStakedToken public immutable STAKED_AAVE;\n', '\n', '  address public immutable BPT;\n', '  IStakedToken public immutable STAKED_BPT;\n', '\n', '  uint256 constant SECONDS_PER_YEAR = 365 * 24 * 60 * 60;\n', '  uint256 constant APY_PRECISION = 10000;\n', '  address constant MOCK_USD_ADDRESS = 0x10F7Fc1F91Ba351f9C629c5947AD69bD03C05b96;\n', '  uint256 internal constant RAY = 1e27;\n', '\n', '  constructor(\n', '    IPriceOracle priceOracle,\n', '    BPTPriceFeedI bptPriceFeed,\n', '    address aave,\n', '    IStakedToken stkAave,\n', '    address bpt,\n', '    IStakedToken stkBpt\n', '  ) public {\n', '    PRICE_ORACLE = priceOracle;\n', '    BPT_PRICE_FEED = bptPriceFeed;\n', '\n', '    AAVE = aave;\n', '    STAKED_AAVE = stkAave;\n', '\n', '    BPT = bpt;\n', '    STAKED_BPT = stkBpt;\n', '  }\n', '\n', '  function _getStakedAssetData(\n', '    IStakedToken stakeToken,\n', '    address underlyingToken,\n', '    address user,\n', '    bool isNonceAvailable\n', '  ) internal view returns (AssetUIData memory) {\n', '    AssetUIData memory data;\n', '\n', '    data.stakeTokenTotalSupply = stakeToken.totalSupply();\n', '    data.stakeCooldownSeconds = stakeToken.COOLDOWN_SECONDS();\n', '    data.stakeUnstakeWindow = stakeToken.UNSTAKE_WINDOW();\n', '    data.rewardTokenPriceEth = PRICE_ORACLE.getAssetPrice(AAVE);\n', '    data.distributionEnd = stakeToken.DISTRIBUTION_END();\n', '    if (block.timestamp < data.distributionEnd) {\n', '      data.distributionPerSecond = stakeToken.assets(address(stakeToken)).emissionPerSecond;\n', '    }\n', '\n', '    if (user != address(0)) {\n', '      data.underlyingTokenUserBalance = IERC20(underlyingToken).balanceOf(user);\n', '      data.stakeTokenUserBalance = stakeToken.balanceOf(user);\n', '      data.userIncentivesToClaim = stakeToken.getTotalRewardsBalance(user);\n', '      data.userCooldown = stakeToken.stakersCooldowns(user);\n', '      data.userPermitNonce = isNonceAvailable ? IERC20WithNonce(underlyingToken)._nonces(user) : 0;\n', '    }\n', '    return data;\n', '  }\n', '\n', '  function _calculateApy(uint256 distributionPerSecond, uint256 stakeTokenTotalSupply)\n', '    internal\n', '    pure\n', '    returns (uint256)\n', '  {\n', '    return (distributionPerSecond * SECONDS_PER_YEAR * APY_PRECISION) / stakeTokenTotalSupply;\n', '  }\n', '\n', '  function getStkAaveData(address user) public view override returns (AssetUIData memory) {\n', '    AssetUIData memory data = _getStakedAssetData(STAKED_AAVE, AAVE, user, true);\n', '\n', '    data.stakeTokenPriceEth = data.rewardTokenPriceEth;\n', '    data.stakeApy = _calculateApy(data.distributionPerSecond, data.stakeTokenTotalSupply);\n', '    return data;\n', '  }\n', '\n', '  function getStkBptData(address user) public view override returns (AssetUIData memory) {\n', '    AssetUIData memory data = _getStakedAssetData(STAKED_BPT, BPT, user, false);\n', '\n', '    data.stakeTokenPriceEth = address(BPT_PRICE_FEED) != address(0)\n', '      ? BPT_PRICE_FEED.latestAnswer()\n', '      : PRICE_ORACLE.getAssetPrice(BPT);\n', '    data.stakeApy = _calculateApy(\n', '      data.distributionPerSecond * data.rewardTokenPriceEth,\n', '      data.stakeTokenTotalSupply * data.stakeTokenPriceEth\n', '    );\n', '\n', '    return data;\n', '  }\n', '\n', '  function getUserUIData(address user)\n', '    external\n', '    view\n', '    override\n', '    returns (\n', '      AssetUIData memory,\n', '      AssetUIData memory,\n', '      uint256\n', '    )\n', '  {\n', '    return (\n', '      getStkAaveData(user),\n', '      getStkBptData(user),\n', '      RAY / PRICE_ORACLE.getAssetPrice(MOCK_USD_ADDRESS)\n', '    );\n', '  }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.5;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface IStakedToken {\n', '  struct AssetData {\n', '    uint128 emissionPerSecond;\n', '    uint128 lastUpdateTimestamp;\n', '    uint256 index;\n', '  }\n', '\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  function COOLDOWN_SECONDS() external view returns (uint256);\n', '\n', '  function UNSTAKE_WINDOW() external view returns (uint256);\n', '\n', '  function DISTRIBUTION_END() external view returns (uint256);\n', '\n', '  function assets(address asset) external view returns (AssetData memory);\n', '\n', '  function balanceOf(address user) external view returns (uint256);\n', '\n', '  function getTotalRewardsBalance(address user) external view returns (uint256);\n', '\n', '  function stakersCooldowns(address user) external view returns (uint256);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.5;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface StakeUIHelperI {\n', '  struct AssetUIData {\n', '    uint256 stakeTokenTotalSupply;\n', '    uint256 stakeCooldownSeconds;\n', '    uint256 stakeUnstakeWindow;\n', '    uint256 stakeTokenPriceEth;\n', '    uint256 rewardTokenPriceEth;\n', '    uint256 stakeApy;\n', '    uint128 distributionPerSecond;\n', '    uint256 distributionEnd;\n', '    uint256 stakeTokenUserBalance;\n', '    uint256 underlyingTokenUserBalance;\n', '    uint256 userCooldown;\n', '    uint256 userIncentivesToClaim;\n', '    uint256 userPermitNonce;\n', '  }\n', '\n', '  function getStkAaveData(address user) external view returns (AssetUIData memory);\n', '\n', '  function getStkBptData(address user) external view returns (AssetUIData memory);\n', '\n', '  function getUserUIData(address user)\n', '    external\n', '    view\n', '    returns (\n', '      AssetUIData memory,\n', '      AssetUIData memory,\n', '      uint256\n', '    );\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.5;\n', '\n', "import {IERC20} from '../lib/ERC20.sol';\n", '\n', 'interface IERC20WithNonce is IERC20 {\n', '  function _nonces(address user) external view returns (uint256);\n', '}\n', '\n', '// SPDX-License-Identifier: agpl-3.0\n', 'pragma solidity 0.7.5;\n', '\n', "import {Context} from './Context.sol';\n", "import {IERC20} from '../interfaces/IERC20.sol';\n", "import {IERC20Detailed} from '../interfaces/IERC20Detailed.sol';\n", "import {SafeMath} from './SafeMath.sol';\n", '\n', '/**\n', ' * @title ERC20\n', ' * @notice Basic ERC20 implementation\n', ' * @author Aave\n', ' **/\n', 'contract ERC20 is Context, IERC20, IERC20Detailed {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) private _balances;\n', '  mapping(address => mapping(address => uint256)) private _allowances;\n', '  uint256 private _totalSupply;\n', '  string private _name;\n', '  string private _symbol;\n', '  uint8 private _decimals;\n', '\n', '  constructor(\n', '    string memory name,\n', '    string memory symbol,\n', '    uint8 decimals\n', '  ) public {\n', '    _name = name;\n', '    _symbol = symbol;\n', '    _decimals = decimals;\n', '  }\n', '\n', '  /**\n', '   * @return the name of the token\n', '   **/\n', '  function name() public view override returns (string memory) {\n', '    return _name;\n', '  }\n', '\n', '  /**\n', '   * @return the symbol of the token\n', '   **/\n', '  function symbol() public view override returns (string memory) {\n', '    return _symbol;\n', '  }\n', '\n', '  /**\n', '   * @return the decimals of the token\n', '   **/\n', '  function decimals() public view override returns (uint8) {\n', '    return _decimals;\n', '  }\n', '\n', '  /**\n', '   * @return the total supply of the token\n', '   **/\n', '  function totalSupply() public view override returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '\n', '  /**\n', '   * @return the balance of the token\n', '   **/\n', '  function balanceOf(address account) public view override returns (uint256) {\n', '    return _balances[account];\n', '  }\n', '\n', '  /**\n', '   * @dev executes a transfer of tokens from msg.sender to recipient\n', '   * @param recipient the recipient of the tokens\n', '   * @param amount the amount of tokens being transferred\n', '   * @return true if the transfer succeeds, false otherwise\n', '   **/\n', '  function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '    _transfer(_msgSender(), recipient, amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev returns the allowance of spender on the tokens owned by owner\n', '   * @param owner the owner of the tokens\n', "   * @param spender the user allowed to spend the owner's tokens\n", "   * @return the amount of owner's tokens spender is allowed to spend\n", '   **/\n', '  function allowance(address owner, address spender)\n', '    public\n', '    view\n', '    virtual\n', '    override\n', '    returns (uint256)\n', '  {\n', '    return _allowances[owner][spender];\n', '  }\n', '\n', '  /**\n', '   * @dev allows spender to spend the tokens owned by msg.sender\n', '   * @param spender the user allowed to spend msg.sender tokens\n', '   * @return true\n', '   **/\n', '  function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '    _approve(_msgSender(), spender, amount);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev executes a transfer of token from sender to recipient, if msg.sender is allowed to do so\n', '   * @param sender the owner of the tokens\n', '   * @param recipient the recipient of the tokens\n', '   * @param amount the amount of tokens being transferred\n', '   * @return true if the transfer succeeds, false otherwise\n', '   **/\n', '  function transferFrom(\n', '    address sender,\n', '    address recipient,\n', '    uint256 amount\n', '  ) public virtual override returns (bool) {\n', '    _transfer(sender, recipient, amount);\n', '    _approve(\n', '      sender,\n', '      _msgSender(),\n', "      _allowances[sender][_msgSender()].sub(amount, 'ERC20: transfer amount exceeds allowance')\n", '    );\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev increases the allowance of spender to spend msg.sender tokens\n', '   * @param spender the user allowed to spend on behalf of msg.sender\n', '   * @param addedValue the amount being added to the allowance\n', '   * @return true\n', '   **/\n', '  function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev decreases the allowance of spender to spend msg.sender tokens\n', '   * @param spender the user allowed to spend on behalf of msg.sender\n', '   * @param subtractedValue the amount being subtracted to the allowance\n', '   * @return true\n', '   **/\n', '  function decreaseAllowance(address spender, uint256 subtractedValue)\n', '    public\n', '    virtual\n', '    returns (bool)\n', '  {\n', '    _approve(\n', '      _msgSender(),\n', '      spender,\n', '      _allowances[_msgSender()][spender].sub(\n', '        subtractedValue,\n', "        'ERC20: decreased allowance below zero'\n", '      )\n', '    );\n', '    return true;\n', '  }\n', '\n', '  function _transfer(\n', '    address sender,\n', '    address recipient,\n', '    uint256 amount\n', '  ) internal virtual {\n', "    require(sender != address(0), 'ERC20: transfer from the zero address');\n", "    require(recipient != address(0), 'ERC20: transfer to the zero address');\n", '\n', '    _beforeTokenTransfer(sender, recipient, amount);\n', '\n', "    _balances[sender] = _balances[sender].sub(amount, 'ERC20: transfer amount exceeds balance');\n", '    _balances[recipient] = _balances[recipient].add(amount);\n', '    emit Transfer(sender, recipient, amount);\n', '  }\n', '\n', '  function _mint(address account, uint256 amount) internal virtual {\n', "    require(account != address(0), 'ERC20: mint to the zero address');\n", '\n', '    _beforeTokenTransfer(address(0), account, amount);\n', '\n', '    _totalSupply = _totalSupply.add(amount);\n', '    _balances[account] = _balances[account].add(amount);\n', '    emit Transfer(address(0), account, amount);\n', '  }\n', '\n', '  function _burn(address account, uint256 amount) internal virtual {\n', "    require(account != address(0), 'ERC20: burn from the zero address');\n", '\n', '    _beforeTokenTransfer(account, address(0), amount);\n', '\n', "    _balances[account] = _balances[account].sub(amount, 'ERC20: burn amount exceeds balance');\n", '    _totalSupply = _totalSupply.sub(amount);\n', '    emit Transfer(account, address(0), amount);\n', '  }\n', '\n', '  function _approve(\n', '    address owner,\n', '    address spender,\n', '    uint256 amount\n', '  ) internal virtual {\n', "    require(owner != address(0), 'ERC20: approve from the zero address');\n", "    require(spender != address(0), 'ERC20: approve to the zero address');\n", '\n', '    _allowances[owner][spender] = amount;\n', '    emit Approval(owner, spender, amount);\n', '  }\n', '\n', '  function _setName(string memory newName) internal {\n', '    _name = newName;\n', '  }\n', '\n', '  function _setSymbol(string memory newSymbol) internal {\n', '    _symbol = newSymbol;\n', '  }\n', '\n', '  function _setDecimals(uint8 newDecimals) internal {\n', '    _decimals = newDecimals;\n', '  }\n', '\n', '  function _beforeTokenTransfer(\n', '    address from,\n', '    address to,\n', '    uint256 amount\n', '  ) internal virtual {}\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.5;\n', '\n', 'interface IPriceOracle {\n', '  function getAssetPrice(address asset) external view returns (uint256);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.7.5;\n', '\n', '/**\n', ' * @dev From https://github.com/OpenZeppelin/openzeppelin-contracts\n', ' * Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '  function _msgSender() internal view virtual returns (address payable) {\n', '    return msg.sender;\n', '  }\n', '\n', '  function _msgData() internal view virtual returns (bytes memory) {\n', '    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '    return msg.data;\n', '  }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.5;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' * From https://github.com/OpenZeppelin/openzeppelin-contracts\n', ' */\n', 'interface IERC20 {\n', '  /**\n', '   * @dev Returns the amount of tokens in existence.\n', '   */\n', '  function totalSupply() external view returns (uint256);\n', '\n', '  /**\n', '   * @dev Returns the amount of tokens owned by `account`.\n', '   */\n', '  function balanceOf(address account) external view returns (uint256);\n', '\n', '  /**\n', "   * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '   *\n', '   * Returns a boolean value indicating whether the operation succeeded.\n', '   *\n', '   * Emits a {Transfer} event.\n', '   */\n', '  function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '  /**\n', '   * @dev Returns the remaining number of tokens that `spender` will be\n', '   * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '   * zero by default.\n', '   *\n', '   * This value changes when {approve} or {transferFrom} are called.\n', '   */\n', '  function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '  /**\n', "   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '   *\n', '   * Returns a boolean value indicating whether the operation succeeded.\n', '   *\n', '   * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '   * that someone may use both the old and the new allowance by unfortunate\n', '   * transaction ordering. One possible solution to mitigate this race\n', "   * condition is to first reduce the spender's allowance to 0 and set the\n", '   * desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   *\n', '   * Emits an {Approval} event.\n', '   */\n', '  function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '  /**\n', '   * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "   * allowance mechanism. `amount` is then deducted from the caller's\n", '   * allowance.\n', '   *\n', '   * Returns a boolean value indicating whether the operation succeeded.\n', '   *\n', '   * Emits a {Transfer} event.\n', '   */\n', '  function transferFrom(\n', '    address sender,\n', '    address recipient,\n', '    uint256 amount\n', '  ) external returns (bool);\n', '\n', '  /**\n', '   * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '   * another (`to`).\n', '   *\n', '   * Note that `value` may be zero.\n', '   */\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '  /**\n', '   * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '   * a call to {approve}. `value` is the new allowance.\n', '   */\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: agpl-3.0\n', 'pragma solidity 0.7.5;\n', '\n', "import {IERC20} from './IERC20.sol';\n", '\n', '/**\n', ' * @dev Interface for ERC20 including metadata\n', ' **/\n', 'interface IERC20Detailed is IERC20 {\n', '  function name() external view returns (string memory);\n', '\n', '  function symbol() external view returns (string memory);\n', '\n', '  function decimals() external view returns (uint8);\n', '}\n', '\n', '// SPDX-License-Identifier: agpl-3.0\n', 'pragma solidity 0.7.5;\n', '\n', '/**\n', ' * @dev From https://github.com/OpenZeppelin/openzeppelin-contracts\n', " * Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '  /**\n', '   * @dev Returns the addition of two unsigned integers, reverting on\n', '   * overflow.\n', '   *\n', "   * Counterpart to Solidity's `+` operator.\n", '   *\n', '   * Requirements:\n', '   * - Addition cannot overflow.\n', '   */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', "    require(c >= a, 'SafeMath: addition overflow');\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the subtraction of two unsigned integers, reverting on\n', '   * overflow (when the result is negative).\n', '   *\n', "   * Counterpart to Solidity's `-` operator.\n", '   *\n', '   * Requirements:\n', '   * - Subtraction cannot overflow.\n', '   */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    return sub(a, b, 'SafeMath: subtraction overflow');\n", '  }\n', '\n', '  /**\n', '   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '   * overflow (when the result is negative).\n', '   *\n', "   * Counterpart to Solidity's `-` operator.\n", '   *\n', '   * Requirements:\n', '   * - Subtraction cannot overflow.\n', '   */\n', '  function sub(\n', '    uint256 a,\n', '    uint256 b,\n', '    string memory errorMessage\n', '  ) internal pure returns (uint256) {\n', '    require(b <= a, errorMessage);\n', '    uint256 c = a - b;\n', '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the multiplication of two unsigned integers, reverting on\n', '   * overflow.\n', '   *\n', "   * Counterpart to Solidity's `*` operator.\n", '   *\n', '   * Requirements:\n', '   * - Multiplication cannot overflow.\n', '   */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    uint256 c = a * b;\n', "    require(c / a == b, 'SafeMath: multiplication overflow');\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the integer division of two unsigned integers. Reverts on\n', '   * division by zero. The result is rounded towards zero.\n', '   *\n', "   * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '   * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '   * uses an invalid opcode to revert (consuming all remaining gas).\n', '   *\n', '   * Requirements:\n', '   * - The divisor cannot be zero.\n', '   */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    return div(a, b, 'SafeMath: division by zero');\n", '  }\n', '\n', '  /**\n', '   * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '   * division by zero. The result is rounded towards zero.\n', '   *\n', "   * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '   * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '   * uses an invalid opcode to revert (consuming all remaining gas).\n', '   *\n', '   * Requirements:\n', '   * - The divisor cannot be zero.\n', '   */\n', '  function div(\n', '    uint256 a,\n', '    uint256 b,\n', '    string memory errorMessage\n', '  ) internal pure returns (uint256) {\n', '    // Solidity only automatically asserts when dividing by 0\n', '    require(b > 0, errorMessage);\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '    return c;\n', '  }\n', '\n', '  /**\n', '   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '   * Reverts when dividing by zero.\n', '   *\n', "   * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '   * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '   * invalid opcode to revert (consuming all remaining gas).\n', '   *\n', '   * Requirements:\n', '   * - The divisor cannot be zero.\n', '   */\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', "    return mod(a, b, 'SafeMath: modulo by zero');\n", '  }\n', '\n', '  /**\n', '   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '   * Reverts with custom message when dividing by zero.\n', '   *\n', "   * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '   * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '   * invalid opcode to revert (consuming all remaining gas).\n', '   *\n', '   * Requirements:\n', '   * - The divisor cannot be zero.\n', '   */\n', '  function mod(\n', '    uint256 a,\n', '    uint256 b,\n', '    string memory errorMessage\n', '  ) internal pure returns (uint256) {\n', '    require(b != 0, errorMessage);\n', '    return a % b;\n', '  }\n', '}']