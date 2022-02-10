['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-14\n', '*/\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'interface StandardToken {\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\tfunction approve(address spender, uint256 amount) external returns (bool);\n', '}\n', '\n', 'interface IUniswapV2Router02 {\n', '    function swapExactTokensForTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    \n', '    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '        \n', '    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '}\n', '\n', 'interface IYearnVault{\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function withdraw(uint256 amount) external;\n', '    function pricePerShare() external view returns(uint256);\n', '    function deposit(uint256 _amount) external;\n', '    //function deposit(uint256 _amount, address recipient) external returns(uint256);\n', '}\n', '\n', 'interface IWETH is StandardToken{\n', '    function withdraw(uint256 amount) external returns(uint256);\n', '    function deposit() external payable;\n', '}\n', '\n', 'interface IStakeAndYield {\n', '    function getRewardToken() external view returns(address);\n', '    function totalSupply(uint256 stakeType) external view returns(uint256);\n', '    function notifyRewardAmount(uint256 reward, uint256 stakeType) external;\n', '}\n', '\n', 'interface IAutomaticMarketMaker {\n', '    function buy(uint256 _tokenAmount) external payable;\n', '    function sell(uint256 tokenAmount, uint256 _etherAmount) external;\n', '    function calculatePurchaseReturn(uint256 etherAmount) external returns (uint256);\n', '    function calculateSaleReturn(uint256 tokenAmount) external returns (uint256);\n', '    function withdrawPayments(address payable payee) external;\n', '}\n', '\n', 'interface ICurve{\n', '    function get_virtual_price() external view returns(uint256);\n', '    function add_liquidity(uint256[2] memory amounts, uint256 min_amounts) external payable returns(uint256);\n', '    function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 _min_amount) external returns(uint256);\n', '}\n', '\n', '\n', 'contract Controller is Ownable {\n', '    using SafeMath for uint256;\n', '    uint256 MAX_INT = type(uint256).max;\n', '    \n', '    IWETH public weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);\n', '    address public DEUS = 0x3b62F3820e0B035cc4aD602dECe6d796BC325325;\n', '    address public AETH = 0xaA17A236F2bAdc98DDc0Cf999AbB47D47Fc0A6Cf;\n', '\n', '    IUniswapV2Router02 public uniswapRouter = IUniswapV2Router02(\n', '    \t0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D\n', '    );\n', '\n', '    IYearnVault public yweth = IYearnVault(0xa9fE4601811213c340e850ea305481afF02f5b28);\n', '    IAutomaticMarketMaker public AMM = IAutomaticMarketMaker(0xD77700fC3C78d1Cb3aCb1a9eAC891ff59bC7946D);\n', '    ICurve curve = ICurve(0xA96A65c051bF88B4095Ee1f2451C2A9d43F53Ae2);\n', '\n', '    // strategy => vault\n', '    mapping (address => address) public strategies;\n', '\n', '    // vault => strategy\n', '    mapping (address => address) public vaults;\n', '\n', '    // vault => exitToken\n', '    mapping (address => address) public exitTokens;\n', '\n', '    // vault => multiplier\n', '    mapping (address => uint256) public multipliers;\n', '\n', '    mapping (address => uint256) public strategyBalances;\n', '\n', '    address public operator;\n', '\n', '    uint256 public minBuyFromAMM = 1 ether;\n', '\n', '\n', '\n', '    modifier onlyOwnerOrOperator(){\n', '        require(\n', '            msg.sender == owner() || msg.sender == operator,\n', '            "!owner"\n', '        );\n', '        _;\n', '    }\n', '\n', '    constructor() public{\n', '   \t\tStandardToken(weth).approve(address(uniswapRouter), MAX_INT);\n', '\t\tStandardToken(weth).approve(address(yweth), MAX_INT);\n', '        StandardToken(DEUS).approve(address(uniswapRouter), MAX_INT);\n', '    }\n', '\n', '    modifier onlyStrategy(){\n', '    \trequire(strategies[msg.sender] != address(0), "!strategy");\n', '    \t_;\n', '    }\n', '\n', '    modifier onlyVault(){\n', '    \trequire(vaults[msg.sender] != address(0), "!vault");\n', '    \t_;\n', '    }\n', '\n', '    modifier onlyExitableVault(){\n', '        require(vaults[msg.sender] != address(0) &&\n', '            exitTokens[msg.sender] != address(0)\n', '            , "!exitable vault");\n', '        _;\n', '    }\n', '\n', '    receive() external payable {\n', '\t}\n', '\n', '    function depositWETH() external payable{\n', '        weth.deposit{value: msg.value}();\n', '    }\n', '\n', '    function depositAETH() external payable{\n', '        curve.add_liquidity{value: msg.value}([msg.value, 0],\n', '            0\n', '        );\n', '    }\n', '\n', '\tfunction addStrategy(address vault, address strategy, \n', '        address exitToken, uint256 multiplier,\n', '        address yearnDepositToken,\n', '        address yearnVault\n', '        ) external onlyOwner{\n', '\t\trequire(vault != address(0) && strategy!=address(0), "0x0");\n', '\t\tstrategies[strategy] = vault;\n', '\t\tvaults[vault] = strategy;\n', '\n', '        exitTokens[vault] = exitToken;\n', '        multipliers[vault] = multiplier;\n', '\n', '        if(yearnDepositToken != address(0)){\n', '\t\t  StandardToken(yearnDepositToken).approve(yearnVault, MAX_INT);\n', '        }\n', '\t}\n', '\n', '\tfunction delStrategy(address vault, address strategy) external onlyOwner{\n', '\t\trequire(vault != address(0) && strategy!=address(0), "0x0");\n', '\t\tstrategies[strategy] = address(0);\n', '\t\tvaults[vault] = address(0);\n', '\t}\n', '\n', '    function setOperator(address _addr) public onlyOwner{\n', '        operator = _addr;\n', '    }\n', '\n', '    function setMultiplier(\n', '        address vault, \n', '        uint256 multiplier\n', '    ) external onlyOwnerOrOperator{\n', '        require(vaults[vault] != address(0), "!vault");\n', '        multipliers[vault] = multiplier;\n', '    }\n', '\n', '\tfunction withdrawETH(uint256 amount) public onlyStrategy{\n', '\t\tmsg.sender.transfer(amount);\n', '\t}\n', '\n', '    function sendExitToken(\n', '        address _user,\n', '        uint256 _amount\n', '    ) public onlyExitableVault{\n', '        uint256 amount = _amount.mul(multipliers[msg.sender]).div(1 ether);\n', '        require(amount > 0, "0 amount");\n', '        StandardToken(exitTokens[msg.sender]).transfer(\n', '            _user, amount\n', '        );\n', '    }\n', '\n', '\tfunction depositTokenForStrategy(\n', '        uint256 amount, \n', '        address yearnVault\n', '    ) public onlyStrategy{\n', '        IYearnVault v = IYearnVault(yearnVault);\n', '        uint256 balanceBefore = v.balanceOf(address(this));\n', '        v.deposit(amount);\n', '        uint256 balance = v.balanceOf(address(this)).sub(\n', '            balanceBefore\n', '        );\n', '        strategyBalances[msg.sender].add(balance);\n', '\t}\n', '\n', '    function withdrawForStrategy(\n', '        uint256 sharesToWithdraw, \n', '        address yearnVault\n', '        ) public onlyStrategy{\n', '\n', '        IYearnVault v = IYearnVault(yearnVault);\n', '        strategyBalances[msg.sender].sub(sharesToWithdraw);   \n', '        v.withdraw(sharesToWithdraw);\n', '    }\n', '\n', '\tfunction buyForStrategy(\n', '\t\tuint256 amount,\n', '        address rewardToken,\n', '        address recipient\n', '    ) public onlyStrategy{\n', '    \taddress[] memory path;\n', '\n', '        uint256[] memory amounts;\n', '        uint256 tokenAmount = amount;\n', '        if(amount < minBuyFromAMM){\n', '            path = new address[](3);\n', '        \tpath[0] = address(weth);\n', '        \tpath[1] = DEUS;\n', '        \tpath[2] = rewardToken;\n', '        }else{\n', '            path = new address[](2);\n', '            path[0] = DEUS;\n', '            path[1] = rewardToken;\n', '\n', '            weth.withdraw(amount);\n', '            tokenAmount = AMM.calculatePurchaseReturn(amount);\n', '            AMM.buy{value: amount}(tokenAmount);\n', '        }\n', '\n', '        amounts = uniswapRouter.swapExactTokensForTokens(\n', '            tokenAmount, 1, path, recipient, block.timestamp\n', '        );\n', '\n', '    \tIStakeAndYield(recipient).notifyRewardAmount(\n', '    \t\tamounts[amounts.length-1], \n', '    \t\t2 // yield\n', '    \t);\n', '\t}\n', '\n', '    function setMinBuyFromAMM(uint256 _val) public onlyOwner{\n', '        minBuyFromAMM = _val;\n', '    }\n', '\n', '\tfunction emergencyWithdrawETH(uint256 amount, address addr) public onlyOwner{\n', '\t\trequire(addr != address(0));\n', '\t\tpayable(addr).transfer(amount);\n', '\t}\n', '\n', '\tfunction emergencyWithdrawERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {\n', '        StandardToken(_tokenAddr).transfer(_to, _amount);\n', '    }\n', '\n', '    function getStrategy(address vault) public view returns(address){\n', '        return vaults[vault];\n', '    }\n', '\n', '    function strategyBalance(address stra) public view returns(uint256){\n', '        return strategyBalances[stra];\n', '    }\n', '}']