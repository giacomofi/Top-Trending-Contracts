['//SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'import "@openzeppelin/contracts/math/SafeMath.sol";\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '\n', '/**\n', ' * @title A Presale contract made with ❤️ for the AGM folks.\n', ' * @dev   Enable whitelisted investors to contribute to the AGM presale.\n', ' */\n', 'contract AGMPresale {\n', '    using SafeMath for uint256;\n', '\n', '    uint256 constant ETH_PRICE_BASE = 1 ether;\n', '    string constant ERROR_ADDRESS = "AGM > Invalid address";\n', '    string constant ERROR_PRICE = "AGM > Invalid price";\n', '    string constant ERROR_CAP = "AGM > Invalid cap";\n', '    string constant ERROR_ARRAY = "AGM > Invalid array [too long]";\n', '    string constant ERROR_OPENED = "AGM > Presale opened";\n', '    string constant ERROR_NOT_OPENED = "AGM > Presale not opened yet";\n', '    string constant ERROR_OVER = "AGM > Presale over";\n', '    string constant ERROR_NOT_OVER = "AGM > Presale not over yet";\n', '    string constant ERROR_NOT_WHITELISTED = "AGM > Address not whitelisted";\n', '    string constant ERROR_ALREADY_WHITELISTED =\n', '        "AGM > Address already whitelisted";\n', '    string constant ERROR_GLOBAL_CAP = "AGM > Global cap reached";\n', '    string constant ERROR_INDIVIDUAL_CAP = "AGM > Individual cap reached";\n', '    string constant ERROR_ERC20_TRANSFER = "AGM > ERC20 transfer failed";\n', '\n', '    uint256 public ETH_PRICE; // in $ per ETH\n', '    uint256 public TOKEN_PRICE; // in token wei per wei\n', '    uint256 public GLOBAL_CAP; // in wei\n', '    uint256 public INDIVIDUAL_CAP; // in wei\n', '    address public admin;\n', '    address payable public bank;\n', '    IERC20 public token;\n', '    bool public isOpen;\n', '    bool public isClosed;\n', '    uint256 public raised;\n', '    mapping(address => bool) public isWhitelisted;\n', '    mapping(address => uint256) public invested;\n', '\n', '    event Open();\n', '    event Close();\n', '    event Whitelist(address indexed investor);\n', '    event Unwhitelist(address indexed investor);\n', '    event Invest(\n', '        address indexed investor,\n', '        uint256 value,\n', '        uint256 investment,\n', '        uint256 amount\n', '    );\n', '\n', '    modifier protected() {\n', '        require(msg.sender == admin, "AGM > Protected operation");\n', '        _;\n', '    }\n', '\n', '    modifier isPending() {\n', '        require(!isOpen, ERROR_OPENED);\n', '        _;\n', '    }\n', '\n', '    modifier isRunning() {\n', '        require(isOpen, ERROR_NOT_OPENED);\n', '        require(!isClosed, ERROR_OVER);\n', '        _;\n', '    }\n', '\n', '    modifier isOver() {\n', '        require(isClosed, ERROR_NOT_OVER);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev          Deploy and initialize the AGM presale contract.\n', '     * @param _admin The address of the admin allowed to perform protected operations.\n', '     * @param _bank  The address to which received ETH and remaining AGM tokens are gonna be sent once the presale closes.\n', '     * @param _token The address of the AGM token.\n', '     * @param _price The price of ETH [in $ per ETH, e.g. $350 per ETH].\n', '     */\n', '    constructor(\n', '        address _admin,\n', '        address payable _bank,\n', '        address _token,\n', '        uint256 _price\n', '    ) public {\n', '        require(_admin != address(0), ERROR_ADDRESS);\n', '        require(_bank != address(0), ERROR_ADDRESS);\n', '        require(_token != address(0), ERROR_ADDRESS);\n', '        require(_price != uint256(0), ERROR_PRICE);\n', '\n', '        admin = _admin;\n', '        bank = _bank;\n', '        token = IERC20(_token);\n', '        _setPrice(_price);\n', '    }\n', '\n', '    /* 1.  protected operations */\n', '\n', '    /* 1.1 protected operations that can be performed any time */\n', '\n', '    /**\n', '     * @dev          Update admin address.\n', '     * @param _admin The ethereum address of the new admin.\n', '     */\n', '    function updateAdmin(address _admin) external protected {\n', '        require(_admin != address(0), ERROR_ADDRESS);\n', '        require(_admin != admin, ERROR_ADDRESS);\n', '\n', '        admin = _admin;\n', '    }\n', '\n', '    /**\n', '     * @dev              Whitelist investors.\n', '     * @param _investors An array of investors ethereum addresses to be whitelisted.\n', '     */\n', '    function whitelist(address[] calldata _investors) external protected {\n', '        require(_investors.length <= 20, ERROR_ARRAY);\n', '\n', '        for (uint256 i = 0; i < _investors.length; i++) {\n', '            require(_investors[i] != address(0), ERROR_ADDRESS);\n', '            require(!isWhitelisted[_investors[i]], ERROR_ALREADY_WHITELISTED);\n', '\n', '            isWhitelisted[_investors[i]] = true;\n', '            emit Whitelist(_investors[i]);\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev              Un-whitelist investors.\n', '     * @param _investors An array of investors ethereum addresses to be un-whitelisted.\n', '     */\n', '    function unwhitelist(address[] calldata _investors) external protected {\n', '        require(_investors.length <= 20, ERROR_ARRAY);\n', '\n', '        for (uint256 i = 0; i < _investors.length; i++) {\n', '            require(isWhitelisted[_investors[i]], ERROR_NOT_WHITELISTED);\n', '\n', '            isWhitelisted[_investors[i]] = false;\n', '            emit Unwhitelist(_investors[i]);\n', '        }\n', '    }\n', '\n', '    /* 1.2 protected operations that can only be performed before presale opens */\n', '\n', '    /**\n', '     * @dev         Update bank address.\n', '     * @param _bank The ethereum address of the new bank.\n', '     */\n', '    function updateBank(address payable _bank) external protected isPending {\n', '        require(_bank != address(0), ERROR_ADDRESS);\n', '        require(_bank != bank, ERROR_ADDRESS);\n', '\n', '        bank = _bank;\n', '    }\n', '\n', '    /**\n', '     * @dev          Update pricing operations based on ETH price.\n', '     * @param _price The ETH price [in $ per ETH, e.g. $340 per ETH] [no decimals allowed]\n', '     */\n', '    function updateETHPrice(uint256 _price) external protected {\n', '        require(_price != uint256(0), ERROR_PRICE);\n', '\n', '        _setPrice(_price);\n', '    }\n', '\n', '    /**\n', '     * @dev Open the presale. Open buys and close whitelisting and pricing operations.\n', '     */\n', '    function open() external protected isPending {\n', '        isOpen = true;\n', '\n', '        emit Open();\n', '    }\n', '\n', '    /* 1.3 protected operations that can only be performed while the presale is running */\n', '\n', '    /**\n', '     * @dev Close the presale. Close buys and open whithdrawal operations. Withdraw received ETH and remaining AGM tokens.\n', '     */\n', '    function close() external protected isRunning {\n', '        isClosed = true;\n', '\n', '        withdraw();\n', '        withdrawETH();\n', '\n', '        emit Close();\n', '    }\n', '\n', '    /* 1.4 protected operations that can only be performed after the presale closes */\n', '\n', '    /**\n', '     * @dev Transfer any remaining AGM tokens hold by this contract to the bank.\n', '     */\n', '    function withdraw() public protected isOver {\n', '        require(\n', '            token.transfer(bank, token.balanceOf(address(this))),\n', '            ERROR_ERC20_TRANSFER\n', '        );\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer any remaining ETH hold by this contract to the bank [though it should not be possible for this contract to receive ETH after the presale is closed].\n', '     */\n', '    function withdrawETH() public protected isOver {\n', '        bank.transfer(address(this).balance);\n', '    }\n', '\n', '    /* payment fallback function */\n', '\n', '    receive() external payable isRunning {\n', '        require(isWhitelisted[msg.sender], ERROR_NOT_WHITELISTED);\n', '        require(raised < GLOBAL_CAP, ERROR_GLOBAL_CAP);\n', '        require(invested[msg.sender] < INDIVIDUAL_CAP, ERROR_INDIVIDUAL_CAP);\n', '\n', '        uint256 investment =\n', '            invested[msg.sender].add(msg.value) <= INDIVIDUAL_CAP\n', '                ? msg.value\n', '                : INDIVIDUAL_CAP.sub(invested[msg.sender]);\n', '        uint256 remains = msg.value.sub(investment);\n', '        uint256 amount = _ETHToTokens(investment);\n', '        // update state\n', '        invested[msg.sender] = invested[msg.sender].add(investment);\n', '        raised = raised.add(investment);\n', '        // assess state consistency\n', '        require(raised <= GLOBAL_CAP, ERROR_GLOBAL_CAP);\n', '        require(invested[msg.sender] <= INDIVIDUAL_CAP, ERROR_INDIVIDUAL_CAP);\n', '        // transfer token\n', '        // PLEASE MAKE SURE AGM ERC20 returns true on success.\n', '        require(token.transfer(msg.sender, amount), ERROR_ERC20_TRANSFER);\n', '        // send remaining ETH back if needed\n', '        if (remains > 0) {\n', '            address payable investor = msg.sender;\n', '            investor.transfer(remains);\n', '        }\n', '\n', '        emit Invest(msg.sender, msg.value, investment, amount);\n', '    }\n', '\n', '    /* private helpers functions */\n', '\n', '   function _setPrice(uint256 _ETHPrice) private {\n', '        ETH_PRICE = _ETHPrice;\n', '        TOKEN_PRICE = _ETHPrice.mul(ETH_PRICE_BASE).mul(uint256(100)).div(\n', '            uint256(3)\n', '        );\n', '        GLOBAL_CAP = uint256(150000).mul(ETH_PRICE_BASE).div(_ETHPrice);\n', '        INDIVIDUAL_CAP = uint256(1500).mul(ETH_PRICE_BASE).div(_ETHPrice);\n', '    }\n', '\n', '    function _ETHToTokens(uint256 _value) private view returns (uint256) {\n', '        return _value.mul(TOKEN_PRICE).div(ETH_PRICE_BASE);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        uint256 c = a + b;\n', '        if (c < a) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the substraction of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b > a) return (false, 0);\n', '        return (true, a - b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) return (true, 0);\n', '        uint256 c = a * b;\n', '        if (c / a != b) return (false, 0);\n', '        return (true, c);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the division of two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a / b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.\n', '     *\n', '     * _Available since v3.4._\n', '     */\n', '    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {\n', '        if (b == 0) return (false, 0);\n', '        return (true, a % b);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) return 0;\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: division by zero");\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0, "SafeMath: modulo by zero");\n', '        return a % b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {trySub}.\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers, reverting with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryDiv}.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * reverting with custom message when dividing by zero.\n', '     *\n', '     * CAUTION: This function is deprecated because it requires allocating memory for the error\n', '     * message unnecessarily. For custom revert reasons use {tryMod}.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 1000\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "metadata": {\n', '    "useLiteralContent": true\n', '  },\n', '  "libraries": {}\n', '}']