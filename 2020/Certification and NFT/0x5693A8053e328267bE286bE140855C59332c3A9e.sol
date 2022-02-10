['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity 0.6.12;\n', '\n', '\n', '// \n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// \n', 'interface IGRAPWine {\n', '    function mint(address _to, uint256 _id, uint256 _quantity, bytes memory _data) external ;\n', '\tfunction totalSupply(uint256 _id) external view returns (uint256);\n', '    function maxSupply(uint256 _id) external view returns (uint256);\n', '    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;\n', '}\n', '\n', '// \n', '/**\n', ' * @title WineTrade\n', ' */\n', 'contract WineTrader {\n', '    using SafeMath for uint256;\n', '    // Wine token.\n', '    IGRAPWine GRAPWine;\n', '    address payable public dev;\n', '\n', '    // Info of each order.\n', '    struct WineOrderInfo {\n', '        address payable owner; // owner\n', '        uint256 price; // price \n', '        uint256 wineID; // wineID\n', '        bool isOpen; // open order\n', '    }\n', '\n', '    // Info of each order list.\n', '    WineOrderInfo[] public orderList;\n', '\n', '    uint256 private _currentOrderID = 0;\n', '\n', '    event Order(uint256 indexed orderID, address indexed user, uint256 indexed wid, uint256 price);\n', '    event Cancel(uint256 indexed orderID, address indexed user, uint256 indexed wid);\n', '    event Buy(uint256 indexed orderID, address indexed user, uint256 indexed wid);\n', '\n', '    constructor(\n', '        IGRAPWine _GRAPWine\n', '    ) public {\n', '        GRAPWine = _GRAPWine;\n', '        dev = msg.sender;\n', '        orderList.push(WineOrderInfo({\n', '            owner: address(0),\n', '            price: 0,\n', '            wineID: 0,\n', '            isOpen: false\n', '        }));\n', '    }\n', '\n', '    function withdrawFee() external {\n', '        require(msg.sender == dev, "only dev");\n', '        dev.transfer(address(this).balance);\n', '    }\n', '\n', '    function orderWine(uint256 _wineID, uint256 _price) external {\n', '        // transferFrom\n', '        GRAPWine.safeTransferFrom(msg.sender, address(this), _wineID, 1, "");\n', '\n', '        orderList.push(WineOrderInfo({\n', '            owner: msg.sender,\n', '            price: _price,\n', '            wineID: _wineID,\n', '            isOpen: true\n', '        }));\n', '\n', '        uint256 _id = _getNextOrderID();\n', '        _incrementOrderId();\n', '\n', '        emit Order(_id, msg.sender, _wineID, _price);\n', '\n', '    }\n', '\n', '    function cancel(uint256 orderID) external {\n', '        WineOrderInfo storage orderInfo = orderList[orderID];\n', '        require(orderInfo.owner == msg.sender, "not your order");\n', '        require(orderInfo.isOpen == true, "only open order can be cancel");\n', '\n', '        orderInfo.isOpen = false;\n', '\n', '        // transferFrom\n', '        GRAPWine.safeTransferFrom(address(this), msg.sender, orderInfo.wineID, 1, "");\n', '\n', '        emit Cancel(orderID, msg.sender, orderInfo.wineID);\n', '\n', '    }\n', '\n', '    function buyWine(uint256 orderID) external payable {\n', '        WineOrderInfo storage orderInfo = orderList[orderID];\n', '        require(orderInfo.owner != address(0),"bad address");\n', '        require(orderInfo.owner != msg.sender, "it is your order");\n', '        require(orderInfo.isOpen == true, "only open order can buy");\n', '        require(msg.value == orderInfo.price, "error price");\n', '\n', '        // 3% fee\n', '        uint256 sellerValue = msg.value.mul(97).div(100);\n', '        orderInfo.isOpen = false;\n', '\n', '        // transferFrom\n', '        GRAPWine.safeTransferFrom(address(this), msg.sender, orderInfo.wineID, 1, "");\n', '        orderInfo.owner.transfer(sellerValue);\n', '        emit Buy(orderID, msg.sender, orderInfo.wineID);\n', '    }\n', '\n', '\tfunction _getNextOrderID() private view returns (uint256) {\n', '\t\treturn _currentOrderID.add(1);\n', '\t}\n', '\tfunction _incrementOrderId() private {\n', '\t\t_currentOrderID++;\n', '\t}\n', '\n', '    function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4){\n', '        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));\n', '    }\n', '}']