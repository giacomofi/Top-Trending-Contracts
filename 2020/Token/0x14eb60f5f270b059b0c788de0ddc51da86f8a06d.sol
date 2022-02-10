['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.7.0;\n', '\n', 'abstract contract Pausable {\n', '    /**\n', '     * @dev Emitted when the pause is triggered by `account`.\n', '     */\n', '    event Paused(address account);\n', '\n', '    /**\n', '     * @dev Emitted when the pause is lifted by `account`.\n', '     */\n', '    event Unpaused(address account);\n', '\n', '    bool private _paused;\n', '\n', '    /**\n', '     * @dev Initializes the contract in unpaused state.\n', '     */\n', '    constructor () {\n', '        _paused = false;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the contract is paused, and false otherwise.\n', '     */\n', '    function paused() public view returns (bool) {\n', '        return _paused;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!_paused, "Pausable: paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(_paused, "Pausable: not paused");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Triggers stopped state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must not be paused.\n', '     */\n', '    function _pause() internal virtual whenNotPaused {\n', '        _paused = true;\n', '        emit Paused(msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns to normal state.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The contract must be paused.\n', '     */\n', '    function _unpause() internal virtual whenPaused {\n', '        _paused = false;\n', '        emit Unpaused(msg.sender);\n', '    }\n', '}\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract PhantasmaToken is Pausable {\n', '\n', '\tusing SafeMath for uint256;\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    uint256 constant private MAX_UINT256 = 2**256 - 1;\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '    mapping(address => bool) private _burnAddresses;\n', '\t\n', '\tuint256 private _totalSupply;\n', '    address private _producer;\n', '\t\n', '\tfunction name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\t\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    constructor (string memory name_, string memory symbol_, uint8 decimals_) {\n', '        _name = name_;\n', '        _symbol = symbol_;\n', '        _decimals = decimals_;\n', '        _totalSupply = 0;                        \n', '\t\t_producer = msg.sender;\n', '\t\taddNodeAddress(msg.sender);\n', '    }\n', '\t\n', '    function addNodeAddress(address _address) public {\n', '\t\trequire(msg.sender == _producer);\n', '\t\trequire(!_burnAddresses[msg.sender]);\n', '        _burnAddresses[_address] = true;\n', '    }\n', '\n', '    function deleteNodeAddress(address _address) public {\n', '\t\trequire(msg.sender == _producer);\n', '        require(_burnAddresses[_address]);\n', '        _burnAddresses[_address] = true;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(!paused(), "transfer while paused" );\n', '        require(_balances[msg.sender] >= _value);\n', '\n', '        if (_burnAddresses[_to]) {\n', '\n', '           return swapOut(msg.sender, _to, _value);\n', '\n', '        } else {\n', '\n', '            _balances[msg.sender] = _balances[msg.sender].sub(_value);\n', '            _balances[_to] = _balances[_to].add(_value);\n', '            emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars\n', '            return true;\n', '\n', '        }\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(!paused(), "transferFrom while paused");\n', '\n', '        uint256 allowance = _allowances[_from][msg.sender];\n', '        require(_balances[_from] >= _value && allowance >= _value);\n', '\n', '        _balances[_to] = _balances[_to].add(_value);\n', '        _balances[_from] = _balances[_from].sub(_value);\n', '\n', '        if (allowance < MAX_UINT256) {\n', '            _allowances[_from][msg.sender] -= _value;\n', '        }\n', '\n', '        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        _allowances[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        require(!paused(), "allowance while paused");\n', '        return _allowances[_owner][_spender];\n', '    }\n', '\t\n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function swapInit(address newProducer) public returns (bool success) {\n', '\t\trequire(msg.sender == _producer);\n', '\t\t_burnAddresses[_producer] = false;\n', '\t\t_producer = newProducer;\n', '\t\t_burnAddresses[newProducer] = true;\n', '\t\temit SwapInit(msg.sender, newProducer);\n', '\t\treturn true;\n', '    }\n', '\n', '    function swapIn(address source, address target, uint256 amount) public returns (bool success) {\n', '        require(!paused(), "swapIn while paused" );\n', '\t\trequire(msg.sender == _producer); // only called by Spook\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[target] = _balances[target].add(amount);\n', '        emit Transfer(source, target, amount);\n', '\t\treturn true;\n', '    }\n', '\n', '    function swapOut(address source, address target, uint256 amount) private returns (bool success) {\n', '\t\trequire(msg.sender == source, "sender != source");\n', '\t\trequire(_balances[source] >= amount);\n', '\t\trequire(_totalSupply >= amount);\n', '\t\t\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        _balances[source] = _balances[source].sub(amount);\n', '        emit Transfer(source, target, amount);\n', '\t\treturn true;\n', '    }\n', '\n', '    function pause() public {\n', '\t\trequire(msg.sender == _producer);\n', '        _pause();\n', '    }\n', '\n', '    function unpause() public {\n', '\t\trequire(msg.sender == _producer);\n', '        _unpause();\n', '    }\n', '\n', '    \n', '    // solhint-disable-next-line no-simple-event-func-name\n', '    event SwapInit(address indexed _from, address indexed _to);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\t\n', '}']