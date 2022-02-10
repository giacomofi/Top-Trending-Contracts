['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-04\n', '*/\n', '\n', '// Dependency file: @openzeppelin/contracts/math/SafeMath.sol\n', '\n', '// pragma solidity ^0.5.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     *\n', '     * _Available since v2.4.0._\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '\n', '// Dependency file: contracts/interfaces/IMineParam.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'interface IMineParam {\n', '    function minePrice() external view returns (uint256);\n', '    function getMinePrice() external view returns (uint256);\n', '    function mineIncomePerTPerSecInWei() external view returns(uint256);\n', '    function incomePerTPerSecInWei() external view returns(uint256);\n', '    function setIncomePerTPerSecInWeiAndUpdateMinePrice(uint256 _incomePerTPerSecInWei) external;\n', '    function updateMinePrice() external;\n', '    function paramSetter() external view returns(address);\n', '    function addListener(address _listener) external;\n', '    function removeListener(address _listener) external returns(bool);\n', '}\n', '\n', '// Dependency file: contracts/modules/Ownable.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', "        require(msg.sender == owner, 'Ownable: FORBIDDEN');\n", '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        require(newOwner != address(0), "new owner is the zero address");\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', '\n', '// Dependency file: contracts/modules/Paramable.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', "// import 'contracts/modules/Ownable.sol';\n", '\n', 'contract Paramable is Ownable {\n', '    address public paramSetter;\n', '\n', '    event ParamSetterChanged(address indexed previousSetter, address indexed newSetter);\n', '\n', '    constructor() public {\n', '        paramSetter = msg.sender;\n', '    }\n', '\n', '    modifier onlyParamSetter() {\n', '        require(msg.sender == owner || msg.sender == paramSetter, "!paramSetter");\n', '        _;\n', '    }\n', '\n', '    function setParamSetter(address _paramSetter) external onlyOwner {\n', '        require(_paramSetter != address(0), "param setter is the zero address");\n', '        emit ParamSetterChanged(paramSetter, _paramSetter);\n', '        paramSetter = _paramSetter;\n', '    }\n', '\n', '}\n', '\n', '\n', '// Root file: contracts/MineParamSetter.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', '// import "@openzeppelin/contracts/math/SafeMath.sol";\n', "// import 'contracts/interfaces/IMineParam.sol';\n", "// import 'contracts/modules/Paramable.sol';\n", '\n', 'interface IPOWToken {\n', '    function mineParam() external returns (address);\n', '}\n', '\n', 'contract MineParamSetter is Paramable {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 public minIncomeRate;\n', '    uint256 public maxIncomeRate;\n', '    uint256 public minPriceRate;\n', '    uint256 public maxPriceRate;\n', '\n', '    function setRate(uint256 _minIncomeRate, uint256 _maxIncomeRate, uint256 _minPriceRate, uint256 _maxPriceRate) public onlyParamSetter {\n', '        minIncomeRate = _minIncomeRate;\n', '        maxIncomeRate = _maxIncomeRate;\n', '        minPriceRate = _minPriceRate;\n', '        maxPriceRate = _maxPriceRate;\n', '    }\n', '\n', '    // return >9 is pass\n', '    function checkWithCode (address[] memory params, uint256[] memory values) public view returns (uint256) {\n', '        if(params.length != values.length) {\n', '            return 1;\n', '        }\n', '        for(uint256 i; i<params.length; i++) {\n', '            if(IMineParam(params[i]).paramSetter() != address(this)) {\n', '                return 2;\n', '            }\n', '            uint256 oldIncomePer = IMineParam(params[i]).incomePerTPerSecInWei();\n', '            uint256 oldPrice = IMineParam(params[i]).minePrice();\n', '            uint256 _incomePerTPerSecInWei = values[i];\n', '            \n', '            if(oldIncomePer == 0 || oldPrice == 0) {\n', '                return 10;\n', '            } else {\n', '                uint256 rate;\n', '                if(_incomePerTPerSecInWei > oldIncomePer) {\n', '                    rate = _incomePerTPerSecInWei.sub(oldIncomePer).mul(10000).div(oldIncomePer);\n', '                } else {\n', '                    rate = oldIncomePer.sub(_incomePerTPerSecInWei).mul(10000).div(oldIncomePer);\n', '                }\n', '                if(rate >= minIncomeRate && rate <= maxIncomeRate) {\n', '                    return 11;\n', '                }\n', '\n', '                uint256 currentPrice = IMineParam(params[i]).getMinePrice();\n', '                rate = 0;\n', '                if(currentPrice > oldPrice) {\n', '                    rate = currentPrice.sub(oldPrice).mul(10000).div(oldPrice);\n', '                } else {\n', '                    rate = oldPrice.sub(currentPrice).mul(10000).div(oldPrice);\n', '                }\n', '                if(rate >= minIncomeRate && rate <= maxIncomeRate) {\n', '                    return 12;\n', '                }\n', '            }\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function check (address[] memory params, uint256[] memory values) public view returns (bool) {\n', '        uint256 result = checkWithCode(params, values);\n', '        if(result > 9)\n', '            return true;\n', '        return false;\n', '    }\n', '\n', '    function update (address[] memory params, uint256[] memory values) public onlyParamSetter {\n', "        require(params.length == values.length, 'invalid parameters');\n", '        for(uint256 i; i<params.length; i++) {\n', '            bool isUpdate;\n', '            uint256 oldIncomePer = IMineParam(params[i]).incomePerTPerSecInWei();\n', '            uint256 oldPrice = IMineParam(params[i]).minePrice();\n', '            uint256 _incomePerTPerSecInWei = values[i];\n', '\n', '            if(oldIncomePer == 0 || oldPrice == 0) {\n', '                isUpdate = true;\n', '            } else {\n', '                uint256 rate;\n', '                if(_incomePerTPerSecInWei > oldIncomePer) {\n', '                    rate = _incomePerTPerSecInWei.sub(oldIncomePer).mul(10000).div(oldIncomePer);\n', '                } else {\n', '                    rate = oldIncomePer.sub(_incomePerTPerSecInWei).mul(10000).div(oldIncomePer);\n', '                }\n', '                if(rate >= minIncomeRate && rate <= maxIncomeRate) {\n', '                    isUpdate = true;\n', '                }\n', '\n', '                if(!isUpdate) {\n', '                    uint256 currentPrice = IMineParam(params[i]).getMinePrice();\n', '                    if(currentPrice > oldPrice) {\n', '                        rate = currentPrice.sub(oldPrice).mul(10000).div(oldPrice);\n', '                    } else {\n', '                        rate = oldPrice.sub(currentPrice).mul(10000).div(oldPrice);\n', '                    }\n', '                    if(rate >= minIncomeRate && rate <= maxIncomeRate) {\n', '                        isUpdate = true;\n', '                    }\n', '                }\n', '            }\n', '            if(isUpdate) {\n', '                updateOne(params[i], _incomePerTPerSecInWei);\n', '            }\n', '        }\n', '    }\n', '\n', '    function updateOne (address param, uint256 _incomePerTPerSecInWei) public onlyParamSetter {\n', '        IMineParam(param).setIncomePerTPerSecInWeiAndUpdateMinePrice(_incomePerTPerSecInWei);\n', '    }\n', '\n', '    function updateMinePrice(address param) external onlyParamSetter {\n', '        IMineParam(param).updateMinePrice();\n', '    }\n', '\n', '    function addListener(address param, address _listener) external onlyParamSetter {\n', '        IMineParam(param).addListener(_listener);\n', '    }\n', '\n', '    function removeListener(address param, address _listener) external onlyParamSetter returns(bool){\n', '        return IMineParam(param).removeListener(_listener);\n', '    }\n', '\n', '    function setHashTokenMineParam(address hashToken) public onlyParamSetter {\n', '        IMineParam(IPOWToken(hashToken).mineParam()).addListener(hashToken);\n', '    }\n', '\n', '    function setHashTokenMineParams(address[] memory hashTokens) public onlyParamSetter {\n', '        for(uint256 i; i<hashTokens.length; i++) {\n', '            setHashTokenMineParam(hashTokens[i]);\n', '        }\n', '    }\n', '    \n', '}']