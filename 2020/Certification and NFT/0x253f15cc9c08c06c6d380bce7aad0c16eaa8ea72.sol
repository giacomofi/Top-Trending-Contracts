['pragma solidity ^0.6.0;\n', '// SPDX-License-Identifier: UNLICENSED\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address payable public owner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address payable _newOwner) public onlyOwner {\n', '        owner = _newOwner;\n', '        emit OwnershipTransferred(msg.sender, _newOwner);\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// ----------------------------------------------------------------------------\n', 'abstract contract IERC20 {\n', '    function transfer(address to, uint256 tokens) external virtual returns (bool success);\n', '    function transferFrom(address from, address to, uint256 tokens) external virtual returns (bool success);\n', '    function balanceOf(address tokenOwner) public virtual view returns (uint256 balance);\n', '}\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', 'contract Vanilla_ICO is Owned{\n', '    \n', '    using SafeMath for uint256;\n', '    address constant private MYX = 0x2129fF6000b95A973236020BCd2b2006B0D8E019;\n', '    address private VANILLA = address(0);\n', '    \n', '    uint256 constant private SWAP_START = 1603584000; // 25 OCT 2020 GMT 00:00:00\n', '    uint256 constant private SWAP_END = 1603843199; // 27 OCT 2020 GMT 23:59:59\n', '    uint256 constant private ICO_END = 1604707199; // 06 NOV 2020 GMT 23:59:59\n', '    \n', '    event TokensSwapped(address indexed _purchaser, uint256 indexed myx, uint256 indexed vanilla);\n', '    event TokensPurchased(address indexed _purchaser, uint256 indexed weis, uint256 indexed vanilla);\n', '    \n', '    \n', '    address payable constant private assetsReceivingWallet1 = 0xE88820E7b990e25E3265833AB29D00fA6B0593E4;\n', '    address payable constant private assetsReceivingWallet2 = 0x6753bbB687a04AA0eCB59ACB4cdf957432EF82dA;\n', '    address payable constant private assetsReceivingWallet3 = 0xa763502F386D8226a59206a2A6F6393e0D88228f;\n', '    address payable constant private assetsReceivingWallet4 = 0xf37DBd0508bD06Ef9b4701d50b7DA7a9C8369B14;\n', '    \n', '    \n', '    uint256 public ethsReceived;\n', '    uint256 public myxReceived;\n', '    uint256 public vanillaDistributed;\n', '    \n', '    modifier swappingOpen{\n', '        require(block.timestamp >= SWAP_START && block.timestamp <= SWAP_END, "Swap sale is close");\n', '        _;\n', '    }\n', '    \n', '    modifier icoOpen{\n', '        require(block.timestamp > SWAP_END && block.timestamp <= ICO_END, "ICO sale is not open");\n', '        _;\n', '    }\n', '    \n', '    constructor() public {\n', '        owner = 0xFa50b82cbf2942008A097B6289F39b1bb797C5Cd;\n', '    }\n', '    \n', '    function MYX_VANILLA(uint256 tokens) external swappingOpen{\n', '       require(tokens > 0, "myx should not be zero");\n', '       uint256 myxInContract_before = IERC20(MYX).balanceOf(address(this));\n', '       require(IERC20(MYX).transferFrom(msg.sender, address(this), tokens), "Insufficient tokens in user wallet");\n', '       uint256 myxInContract_after = IERC20(MYX).balanceOf(address(this));\n', '       \n', '       uint256 vanilla = tokens.mul(10 ** (18)); // tokens actually sent will used to calculate vanilla in swap\n', '       vanilla = vanilla.div(400);\n', '       vanilla = vanilla.div(10 ** 18);\n', '       \n', '       \n', '       myxInContract_after = myxInContract_after.sub(myxInContract_before);\n', '       \n', '       myxReceived = myxReceived.add(tokens);\n', '       \n', '       vanillaDistributed = vanillaDistributed.add(vanilla);\n', '       \n', '       require(vanillaDistributed <= 200000 * 10 ** 18, "Max 80 million myx swap is allowed");\n', '       require(IERC20(VANILLA).transfer(msg.sender, vanilla), "All tokens sold");\n', '       \n', '       // send the received funds to the 4 owner wallets\n', '       distributeReceivedAssets(true, myxInContract_after);\n', '       \n', '       emit TokensSwapped(msg.sender, tokens, vanilla);\n', '    }\n', '    \n', '    receive() external payable{\n', '       ETH_VANILLA(); \n', '    }\n', '    \n', '    function ETH_VANILLA() public payable icoOpen{\n', '       require(msg.value > 0, "investment should be greater than zero");\n', '       uint256 vanilla = msg.value.mul(1000); // 1 ether = 1000 vanilla\n', '       \n', '       ethsReceived = ethsReceived.add(msg.value);\n', '       vanillaDistributed = vanillaDistributed.add(vanilla);\n', '       \n', '       require(IERC20(VANILLA).transfer(msg.sender, vanilla), "All tokens sold");\n', '       \n', '       // send the received funds to the 4 owner wallets\n', '       distributeReceivedAssets(false, msg.value);\n', '       \n', '       emit TokensPurchased(msg.sender, msg.value, vanilla);\n', '    }\n', '    \n', '    function getUnSoldTokens() external onlyOwner{\n', '        require(block.timestamp > ICO_END, "ICO is not over");\n', '        \n', '        require(IERC20(VANILLA).transfer(owner, IERC20(VANILLA).balanceOf(address(this))), "No tokens in contract");\n', '    }\n', '    \n', '    function setVanillaAddress(address _vanillaContract) external onlyOwner{\n', '        require(VANILLA == address(0), "address already linked");\n', '        VANILLA = _vanillaContract;\n', '    }\n', '    \n', '    function distributeReceivedAssets(bool myx, uint256 amount) private{\n', '        if(myx){\n', '            if(divideAssetByFour(amount) > 0){\n', '                // send the received funds to the 4 owner wallets\n', '                IERC20(MYX).transfer(assetsReceivingWallet1, divideAssetByFour(amount));\n', '                IERC20(MYX).transfer(assetsReceivingWallet2, divideAssetByFour(amount));\n', '                IERC20(MYX).transfer(assetsReceivingWallet3, divideAssetByFour(amount));\n', '                \n', '            }\n', '            IERC20(MYX).transfer(assetsReceivingWallet4, divideAssetByFour(amount).add(getRemainings(amount)));\n', '        }\n', '        else{\n', '            if(divideAssetByFour(amount) > 0){\n', '                // send the received funds to the 4 owner wallets\n', '                assetsReceivingWallet1.transfer(divideAssetByFour(amount));\n', '                assetsReceivingWallet2.transfer(divideAssetByFour(amount));\n', '                assetsReceivingWallet3.transfer(divideAssetByFour(amount));\n', '            }\n', '            assetsReceivingWallet4.transfer(divideAssetByFour(amount).add(getRemainings(amount)));\n', '        }\n', '    }\n', '    \n', '    function divideAssetByFour(uint256 amount) public pure returns(uint256){\n', '        return amount.div(4);\n', '    }\n', '    \n', '    function getRemainings(uint256 amount) public pure returns(uint256){\n', '        return amount.mod(4);\n', '    }\n', '}']