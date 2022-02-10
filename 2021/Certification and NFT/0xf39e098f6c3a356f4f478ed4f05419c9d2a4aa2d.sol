['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-14\n', '*/\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', 'interface StandardToken {\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '}\n', '\n', 'interface IStakeAndYield {\n', '    function getRewardToken() external view returns(address);\n', '    function totalSupply(uint256 stakeType) external view returns(uint256);\n', '    function totalYieldWithdrawed() external view returns(uint256);\n', '    function notifyRewardAmount(uint256 reward, uint256 stakeType) external;\n', '}\n', '\n', 'interface IController {\n', '    function withdrawETH(uint256 amount) external;\n', '    function depositTokenForStrategy(uint256 amount, \n', '        address addr, address yearnToken, address yearnVault) external;\n', '\n', '    function buyForStrategy(\n', '        uint256 amount,\n', '        address rewardToken,\n', '        address recipient\n', '    ) external;\n', '\n', '    function withdrawForStrategy(\n', '        uint256 sharesToWithdraw, \n', '        address yearnVault\n', '        ) external;\n', '\n', '    function strategyBalance(address stra) external view returns(uint256);\n', '}\n', '\n', 'interface IYearnVault{\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function withdraw(uint256 amount) external;\n', '    function getPricePerFullShare() external view returns(uint256);\n', '    function deposit(uint256 _amount) external returns(uint256);\n', '}\n', '\n', 'interface IWETH is StandardToken{\n', '    function withdraw(uint256 amount) external returns(uint256);\n', '}\n', '\n', 'interface ICurve{\n', '    function get_virtual_price() external view returns(uint256);\n', '    function add_liquidity(uint256[2] memory amounts, uint256 min_amounts) external payable returns(uint256);\n', '    function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 _min_amount) external returns(uint256);\n', '}\n', '\n', '\n', 'contract YearnCrvAETHStrategy is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '     uint256 public lastEpochTime;\n', '     uint256 public lastBalance;\n', '     uint256 public lastYieldWithdrawed;\n', '\n', '     uint256 public yearnFeesPercent;\n', '\n', '     uint256 public ethPushedToYearn;\n', '\n', '     IStakeAndYield public vault;\n', '\n', '\n', '    IController public controller;\n', '    \n', '    //crvAETH \n', '    address yearnDepositableToken = 0xaA17A236F2bAdc98DDc0Cf999AbB47D47Fc0A6Cf;\n', '\n', '    IYearnVault public yearnVault = IYearnVault(0xE625F5923303f1CE7A43ACFEFd11fd12f30DbcA4);\n', '    \n', '    //IWETH public weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);\n', '    StandardToken crvAETH = StandardToken(0xaA17A236F2bAdc98DDc0Cf999AbB47D47Fc0A6Cf);\n', '\n', '    ICurve curve = ICurve(0xA96A65c051bF88B4095Ee1f2451C2A9d43F53Ae2);\n', '\n', '    address public operator;\n', '\n', '\n', '    uint256 public minRewards = 0.01 ether;\n', '    uint256 public minDepositable = 0.05 ether;\n', '\n', '    modifier onlyOwnerOrOperator(){\n', '        require(\n', '            msg.sender == owner() || msg.sender == operator,\n', '            "!owner"\n', '        );\n', '        _;\n', '    }\n', '\n', '    constructor(\n', '        address _vault,\n', '        address _controller\n', '    ) public{\n', '        vault = IStakeAndYield(_vault);\n', '        controller = IController(_controller);\n', '    }\n', '\n', '    // Since Owner is calling this function, we can pass\n', '    // the ETHPerToken amount\n', '    function epoch(uint256 ETHPerToken) public onlyOwnerOrOperator{\n', '        uint256 balance = pendingBalance();\n', '        //require(balance > 0, "balance is 0");\n', '        uint256 withdrawable = harvest(balance.mul(ETHPerToken).div(1 ether));\n', '        lastEpochTime = block.timestamp;\n', '        lastBalance = lastBalance.add(balance);\n', '\n', '        uint256 currentWithdrawd = vault.totalYieldWithdrawed();\n', '        uint256 withdrawAmountToken = currentWithdrawd.sub(lastYieldWithdrawed);\n', '        if(withdrawAmountToken > 0){\n', '            lastYieldWithdrawed = currentWithdrawd;\n', '            uint256 ethWithdrawed = withdrawAmountToken.mul(\n', '                ETHPerToken\n', '            ).div(1 ether);\n', '            \n', '            withdrawFromYearn(ethWithdrawed.add(withdrawable));\n', '            ethPushedToYearn = ethPushedToYearn.sub(ethWithdrawed);\n', '        }else{\n', '            if(withdrawable > 0){\n', '                withdrawFromYearn(withdrawable);\n', '            }\n', '        }\n', '    }\n', '\n', '    function harvest(uint256 ethBalance) private returns(\n', '        uint256 withdrawable\n', '    ){\n', '        uint256 rewards = calculateRewards();\n', '        uint256 depositable = ethBalance > rewards ? ethBalance.sub(rewards) : 0;\n', '        if(depositable >= minDepositable){\n', '            //deposit to yearn\n', '            controller.depositTokenForStrategy(depositable, address(this), \n', '                yearnDepositableToken, address(yearnVault));\n', '            ethPushedToYearn = ethPushedToYearn.add(\n', '                depositable\n', '            );\n', '        }\n', '\n', '        if(rewards > minRewards){\n', '            withdrawable = rewards > ethBalance ? rewards.sub(ethBalance) : 0;\n', '            // get DEA and send to Vault\n', '            controller.buyForStrategy(\n', '                rewards,\n', '                vault.getRewardToken(),\n', '                address(vault)\n', '            );\n', '        }else{\n', '            withdrawable = 0;\n', '        }\n', '    }\n', '\n', '    function withdrawFromYearn(uint256 ethAmount) private returns(uint256){\n', '        uint256 yShares = controller.strategyBalance(address(this));\n', '\n', '        uint256 sharesToWithdraw = ethAmount.mul(1 ether).div(\n', '            yearnVault.getPricePerFullShare()\n', '        );\n', '\n', '        uint256 curveVirtualPrice = curve.get_virtual_price();\n', '        sharesToWithdraw = sharesToWithdraw.mul(curveVirtualPrice).div(\n', '            1 ether\n', '        );\n', '\n', '        require(yShares >= sharesToWithdraw, "Not enough shares");\n', '\n', '        controller.withdrawForStrategy(\n', '            sharesToWithdraw, \n', '           address(yearnVault)\n', '        );\n', '        return ethAmount;\n', '    }\n', '\n', '    \n', '    function calculateRewards() public view returns(uint256){\n', '        uint256 yShares = controller.strategyBalance(address(this));\n', '        uint256 yETHBalance = yShares.mul(\n', '            yearnVault.getPricePerFullShare()\n', '        ).div(1 ether);\n', '\n', '        uint256 curveVirtualPrice = curve.get_virtual_price();\n', '        yETHBalance = yETHBalance.mul(curveVirtualPrice).div(\n', '            1 ether\n', '        );\n', '\n', '        yETHBalance = yETHBalance.mul(1000 - yearnFeesPercent).div(1000);\n', '        if(yETHBalance > ethPushedToYearn){\n', '            return yETHBalance - ethPushedToYearn;\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function pendingBalance() public view returns(uint256){\n', '        uint256 vaultBalance = vault.totalSupply(2);\n', '        if(vaultBalance < lastBalance){\n', '            return 0;\n', '        }\n', '        return vaultBalance.sub(lastBalance);\n', '    }\n', '\n', '    function getLastEpochTime() public view returns(uint256){\n', '        return lastEpochTime;\n', '    }\n', '\n', '    function setYearnFeesPercent(uint256 _val) public onlyOwner{\n', '        yearnFeesPercent = _val;\n', '    }\n', '\n', '    function setOperator(address _addr) public onlyOwner{\n', '        operator = _addr;\n', '    }\n', '\n', '    function setMinRewards(uint256 _val) public onlyOwner{\n', '        minRewards = _val;\n', '    }\n', '\n', '    function setMinDepositable(uint256 _val) public onlyOwner{\n', '        minDepositable = _val;\n', '    }\n', '\n', '    function setController(address _controller, address _vault) public onlyOwner{\n', '        if(_controller != address(0)){\n', '            controller = IController(_controller);\n', '        }\n', '        if(_vault != address(0)){\n', '            vault = IStakeAndYield(_vault);\n', '        }\n', '    }\n', '\n', '    function emergencyWithdrawETH(uint256 amount, address addr) public onlyOwner{\n', '        require(addr != address(0));\n', '        payable(addr).transfer(amount);\n', '    }\n', '\n', '    function emergencyWithdrawERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {\n', '        StandardToken(_tokenAddr).transfer(_to, _amount);\n', '    }\n', '}']