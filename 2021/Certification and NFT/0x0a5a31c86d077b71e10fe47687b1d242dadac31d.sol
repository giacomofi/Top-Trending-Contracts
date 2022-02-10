['pragma solidity =0.6.6;\n', '\n', 'import "./libraries/SafeMath.sol";\n', 'import "./interfaces/IImx.sol";\n', 'import "./interfaces/IClaimable.sol";\n', '\n', 'abstract contract Distributor is IClaimable {\n', '\tusing SafeMath for uint;\n', '\n', '\taddress public immutable imx;\n', '\taddress public immutable claimable;\n', '\n', '\tstruct Recipient {\n', '\t\tuint shares;\n', '\t\tuint lastShareIndex;\n', '\t\tuint credit;\n', '\t}\n', '\tmapping(address => Recipient) public recipients;\n', '\t\n', '\tuint public totalShares;\n', '\tuint public shareIndex;\n', '\t\n', '\tevent UpdateShareIndex(uint shareIndex);\n', '\tevent UpdateCredit(address indexed account, uint lastShareIndex, uint credit);\n', '\tevent Claim(address indexed account, uint amount);\n', '\tevent EditRecipient(address indexed account, uint shares, uint totalShares);\n', '\n', '\tconstructor (\n', '\t\taddress imx_,\n', '\t\taddress claimable_\n', '\t) public {\n', '\t\timx = imx_;\n', '\t\tclaimable = claimable_;\n', '\t}\n', '\t\n', '\tfunction updateShareIndex() public virtual nonReentrant returns (uint _shareIndex) {\n', '\t\tif (totalShares == 0) return shareIndex;\n', '\t\tuint amount = IClaimable(claimable).claim();\n', '\t\tif (amount == 0) return shareIndex;\n', '\t\t_shareIndex = amount.mul(2**160).div(totalShares).add(shareIndex);\n', '\t\tshareIndex = _shareIndex;\n', '\t\temit UpdateShareIndex(_shareIndex);\n', '\t}\n', '\t\n', '\tfunction updateCredit(address account) public returns (uint credit) {\n', '\t\tuint _shareIndex = updateShareIndex();\n', '\t\tif (_shareIndex == 0) return 0;\n', '\t\tRecipient storage recipient = recipients[account];\n', '\t\tcredit = recipient.credit + _shareIndex.sub(recipient.lastShareIndex).mul(recipient.shares) / 2**160;\n', '\t\trecipient.lastShareIndex = _shareIndex;\n', '\t\trecipient.credit = credit;\n', '\t\temit UpdateCredit(account, _shareIndex, credit);\n', '\t}\n', '\n', '\tfunction claimInternal(address account) internal virtual returns (uint amount) {\n', '\t\tamount = updateCredit(account);\n', '\t\tif (amount > 0) {\n', '\t\t\trecipients[account].credit = 0;\n', '\t\t\tIImx(imx).transfer(account, amount);\n', '\t\t\temit Claim(account, amount);\n', '\t\t}\n', '\t}\n', '\n', '\tfunction claim() external virtual override returns (uint amount) {\n', '\t\treturn claimInternal(msg.sender);\n', '\t}\n', '\t\n', '\tfunction editRecipientInternal(address account, uint shares) internal {\n', '\t\tupdateCredit(account);\n', '\t\tRecipient storage recipient = recipients[account];\n', '\t\tuint prevShares = recipient.shares;\n', '\t\tuint _totalShares = shares > prevShares ? \n', '\t\t\ttotalShares.add(shares - prevShares) : \n', '\t\t\ttotalShares.sub(prevShares - shares);\n', '\t\ttotalShares = _totalShares;\n', '\t\trecipient.shares = shares;\n', '\t\temit EditRecipient(account, shares, _totalShares);\n', '\t}\n', '\t\n', '\t// Prevents a contract from calling itself, directly or indirectly.\n', '\tbool internal _notEntered = true;\n', '\tmodifier nonReentrant() {\n', '\t\trequire(_notEntered, "Distributor: REENTERED");\n', '\t\t_notEntered = false;\n', '\t\t_;\n', '\t\t_notEntered = true;\n', '\t}\n', '}\n', '\n', 'pragma solidity =0.6.6;\n', '\n', 'import "./Distributor.sol";\n', 'import "./interfaces/IBorrowTracker.sol";\n', 'import "./interfaces/IVester.sol";\n', 'import "./libraries/Math.sol";\n', '\n', '// ASSUMTPIONS:\n', '// - advance is called at least once for each epoch\n', '// - farmingPool shares edits are effective starting from the next epoch\n', '\n', 'contract FarmingPool is IBorrowTracker, Distributor {\n', '\n', '\taddress public immutable borrowable;\n', '\n', '\tuint public immutable vestingBegin;\n', '\tuint public immutable segmentLength;\n', '\t\n', '\tuint public epochBegin;\n', '\tuint public epochAmount;\n', '\tuint public lastUpdate;\n', '\t\n', '\tevent UpdateShareIndex(uint shareIndex);\n', '\tevent Advance(uint epochBegin, uint epochAmount);\n', '\t\n', '\tconstructor (\n', '\t\taddress imx_,\n', '\t\taddress claimable_,\n', '\t\taddress borrowable_,\n', '\t\taddress vester_\n', '\t) public Distributor(imx_, claimable_) {\n', '\t\tborrowable = borrowable_;\n', '\t\tuint _vestingBegin = IVester(vester_).vestingBegin();\n', '\t\tvestingBegin = _vestingBegin;\n', '\t\tsegmentLength = IVester(vester_).vestingEnd().sub(_vestingBegin).div(IVester(vester_).segments());\n', '\t}\n', '\t\n', '\tfunction updateShareIndex() public virtual override returns (uint _shareIndex) {\n', '\t\tif (totalShares == 0) return shareIndex;\n', '\t\tif (epochBegin == 0) return shareIndex;\n', '\t\tuint epochEnd = epochBegin + segmentLength;\n', '\t\tuint blockTimestamp = getBlockTimestamp();\n', '\t\tuint timestamp = Math.min(blockTimestamp, epochEnd);\n', '\t\tuint timeElapsed = timestamp - lastUpdate;\n', '\t\tassert(timeElapsed <= segmentLength);\n', '\t\tif (timeElapsed == 0) return shareIndex;\n', '\t\t\n', '\t\tuint amount =  epochAmount.mul(timeElapsed).div(segmentLength);\n', '\t\t_shareIndex = amount.mul(2**160).div(totalShares).add(shareIndex);\n', '\t\tshareIndex = _shareIndex;\n', '\t\tlastUpdate = timestamp;\n', '\t\temit UpdateShareIndex(_shareIndex);\n', '\t}\n', '\t\n', '\tfunction advance() public nonReentrant {\n', '\t\tuint blockTimestamp = getBlockTimestamp();\n', '\t\tif (blockTimestamp < vestingBegin) return;\n', '\t\tuint _epochBegin = epochBegin;\n', '\t\tif (_epochBegin != 0 && blockTimestamp < _epochBegin + segmentLength) return;\n', '\t\tuint amount = IClaimable(claimable).claim();\n', '\t\tif (amount == 0) return;\n', '\t\tupdateShareIndex();\t\t\n', '\t\tuint timeSinceBeginning = blockTimestamp - vestingBegin;\n', '\t\tepochBegin = blockTimestamp.sub(timeSinceBeginning.mod(segmentLength));\n', '\t\tepochAmount = amount;\n', '\t\tlastUpdate = epochBegin;\n', '\t\temit Advance(epochBegin, epochAmount);\n', '\t}\n', '\n', '\tfunction claimInternal(address account) internal override returns (uint amount) {\n', '\t\tadvance();\n', '\t\treturn super.claimInternal(account);\n', '\t}\n', '\t\n', '\tfunction claimAccount(address account) external returns (uint amount) {\n', '\t\treturn claimInternal(account);\n', '\t}\n', '\t\n', '\tfunction trackBorrow(address borrower, uint borrowBalance, uint borrowIndex) external override {\n', '\t\trequire(msg.sender == borrowable, "FarmingPool: UNAUTHORIZED");\n', '\t\tuint newShares = borrowBalance.mul(2**96).div(borrowIndex);\n', '\t\teditRecipientInternal(borrower, newShares);\n', '\t}\n', '\t\n', '\tfunction getBlockTimestamp() public virtual view returns (uint) {\n', '\t\treturn block.timestamp;\n', '\t}\n', '}\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IBorrowTracker {\n', '\tfunction trackBorrow(address borrower, uint borrowBalance, uint borrowIndex) external;\n', '}\n', '\n', 'pragma solidity =0.6.6;\n', '\n', 'interface IClaimable {\n', '\tfunction claim() external returns (uint amount);\n', '\tevent Claim(address indexed account, uint amount);\n', '}\n', '\n', 'pragma solidity =0.6.6;\n', '//IERC20?\n', 'interface IImx {\n', '    function balanceOf(address account) external view returns (uint);\n', '    function transfer(address dst, uint rawAmount) external returns (bool);\n', '}\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IVester {\n', '\tfunction segments() external pure returns (uint);\n', '\tfunction vestingAmount() external pure returns (uint);\n', '\tfunction vestingBegin() external pure returns (uint);\n', '\tfunction vestingEnd() external pure returns (uint);\n', '}\n', '\n', 'pragma solidity =0.6.6;\n', '\n', '// a library for performing various math operations\n', '// forked from: https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/libraries/Math.sol\n', '\n', 'library Math {\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        z = x < y ? x : y;\n', '    }\n', '\n', '    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)\n', '    function sqrt(uint y) internal pure returns (uint z) {\n', '        if (y > 3) {\n', '            z = y;\n', '            uint x = y / 2 + 1;\n', '            while (x < z) {\n', '                z = x;\n', '                x = (y / x + x) / 2;\n', '            }\n', '        } else if (y != 0) {\n', '            z = 1;\n', '        }\n', '    }\n', '}\n', '\n', 'pragma solidity =0.6.6;\n', '\n', '// From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol\n', '// Subject to the MIT license.\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, errorMessage);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot underflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction underflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot underflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, errorMessage);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers.\n', '     * Reverts on division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers.\n', '     * Reverts with custom message on division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '{\n', '  "remappings": [],\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 999999\n', '  },\n', '  "evmVersion": "istanbul",\n', '  "libraries": {},\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']