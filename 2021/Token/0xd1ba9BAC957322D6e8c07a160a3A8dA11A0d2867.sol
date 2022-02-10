['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-16\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.2;\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'interface HMTokenInterface {\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return balance The balance\n', '    function balanceOf(address _owner) external view returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return success Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return success Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);\n', '\n', '    function transferBulk(address[] calldata _tos, uint256[] calldata _values, uint256 _txId) external returns (uint256 _bulkCount);\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of tokens to be approved for transfer\n', '    /// @return success Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) external returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return remaining Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) external view returns (uint256 remaining);\n', '}\n', '\n', 'contract HMToken is HMTokenInterface {\n', '    using SafeMath for uint256;\n', '\n', '    /* This is a slight change to the ERC20 base standard.\n', '    function totalSupply() constant returns (uint256 supply);\n', '    is replaced with:\n', '    uint256 public totalSupply;\n', '    This automatically creates a getter function for the totalSupply.\n', '    This is moved to the base contract since public getter functions are not\n', '    currently recognised as an implementation of the matching abstract\n', '    function by the compiler.\n', '    */\n', '    /// total amount of tokens\n', '    uint256 public totalSupply;\n', '\n', '    uint256 private constant MAX_UINT256 = ~uint256(0);\n', '    uint256 private constant BULK_MAX_VALUE = 1000000000 * (10 ** 18);\n', '    uint32  private constant BULK_MAX_COUNT = 100;\n', '\n', '    event BulkTransfer(uint256 indexed _txId, uint256 _bulkCount);\n', '    event BulkApproval(uint256 indexed _txId, uint256 _bulkCount);\n', '\n', '    mapping (address => uint256) private balances;\n', '    mapping (address => mapping (address => uint256)) private allowed;\n', '\n', '    string public name;\n', '    uint8 public decimals;\n', '    string public symbol;\n', '\n', '    constructor(uint256 _totalSupply, string memory _name, uint8 _decimals, string memory _symbol) public {\n', '        totalSupply = _totalSupply * (10 ** uint256(_decimals));\n', '        name = _name;\n', '        decimals = _decimals;\n', '        symbol = _symbol;\n', '        balances[msg.sender] = totalSupply;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public override returns (bool success) {\n', '        success = transferQuiet(_to, _value);\n', '        require(success, "Transfer didn\'t succeed");\n', '        return success;\n', '    }\n', '\n', '    function transferFrom(address _spender, address _to, uint256 _value) public override returns (bool success) {\n', '        uint256 _allowance = allowed[_spender][msg.sender];\n', '        require(_allowance >= _value, "Spender allowance too low");\n', '        require(_to != address(0), "Can\'t send tokens to uninitialized address");\n', '\n', '        balances[_spender] = balances[_spender].sub(_value, "Spender balance too low");\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        if (_allowance != MAX_UINT256) { // Special case to approve unlimited transfers\n', '            allowed[_spender][msg.sender] = allowed[_spender][msg.sender].sub(_value);\n', '        }\n', '\n', '        emit Transfer(_spender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view override returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public override returns (bool success) {\n', '        require(_spender != address(0), "Token spender is an uninitialized address");\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars\n', '        return true;\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _delta) public returns (bool success) {\n', '        require(_spender != address(0), "Token spender is an uninitialized address");\n', '\n', '        uint _oldValue = allowed[msg.sender][_spender];\n', '        if (_oldValue.add(_delta) < _oldValue || _oldValue.add(_delta) >= MAX_UINT256) { // Truncate upon overflow.\n', '            allowed[msg.sender][_spender] = MAX_UINT256.sub(1);\n', '        } else {\n', '            allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_delta);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _delta) public returns (bool success) {\n', '        require(_spender != address(0), "Token spender is an uninitialized address");\n', '\n', '        uint _oldValue = allowed[msg.sender][_spender];\n', '        if (_delta > _oldValue) { // Truncate upon overflow.\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_delta);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view override returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function transferBulk(address[] memory _tos, uint256[] memory _values, uint256 _txId) public override returns (uint256 _bulkCount) {\n', '        require(_tos.length == _values.length, "Amount of recipients and values don\'t match");\n', '        require(_tos.length < BULK_MAX_COUNT, "Too many recipients");\n', '\n', '        uint256 _bulkValue = 0;\n', '        for (uint j = 0; j < _tos.length; ++j) {\n', '            _bulkValue = _bulkValue.add(_values[j]);\n', '        }\n', '        require(_bulkValue < BULK_MAX_VALUE, "Bulk value too high");\n', '\n', '        bool _success;\n', '        for (uint i = 0; i < _tos.length; ++i) {\n', '            _success = transferQuiet(_tos[i], _values[i]);\n', '            if (_success) {\n', '                _bulkCount = _bulkCount.add(1);\n', '            }\n', '        }\n', '        emit BulkTransfer(_txId, _bulkCount);\n', '        return _bulkCount;\n', '    }\n', '\n', '    function approveBulk(address[] memory _spenders, uint256[] memory _values, uint256 _txId) public returns (uint256 _bulkCount) {\n', '        require(_spenders.length == _values.length, "Amount of spenders and values don\'t match");\n', '        require(_spenders.length < BULK_MAX_COUNT, "Too many spenders");\n', '\n', '        uint256 _bulkValue = 0;\n', '        for (uint j = 0; j < _spenders.length; ++j) {\n', '            _bulkValue = _bulkValue.add(_values[j]);\n', '        }\n', '        require(_bulkValue < BULK_MAX_VALUE, "Bulk value too high");\n', '\n', '        bool _success;\n', '        for (uint i = 0; i < _spenders.length; ++i) {\n', '            _success = increaseApproval(_spenders[i], _values[i]);\n', '            if (_success) {\n', '                _bulkCount = _bulkCount.add(1);\n', '            }\n', '        }\n', '        emit BulkApproval(_txId, _bulkCount);\n', '        return _bulkCount;\n', '    }\n', '\n', '    // Like transfer, but fails quietly.\n', '    function transferQuiet(address _to, uint256 _value) internal returns (bool success) {\n', '        if (_to == address(0)) return false; // Preclude burning tokens to uninitialized address.\n', '        if (_to == address(this)) return false; // Preclude sending tokens to the contract.\n', '        if (balances[msg.sender] < _value) return false;\n', '\n', '        balances[msg.sender] = balances[msg.sender] - _value;\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '}']