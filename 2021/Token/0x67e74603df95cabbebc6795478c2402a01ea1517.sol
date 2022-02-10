['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-27\n', '*/\n', '\n', '//SPDX-License-Identifier: Apache-2.0;\n', 'pragma solidity ^0.7.6;\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP. Does not include\n', ' * the optional functions; to access them see {ERC20Detailed}.\n', ' */\n', 'interface ERC20Interface {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'abstract contract ERC20Base is ERC20Interface {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) public _balances;\n', '    mapping (address => mapping (address => uint256)) public _allowances;\n', '    uint256 public _totalSupply;\n', '\n', '    function transfer(address _to, uint256 _value) public override returns (bool success) {\n', '        if (_balances[msg.sender] >= _value && _balances[_to].add(_value) > _balances[_to]) {\n', '            _balances[msg.sender] = _balances[msg.sender].sub(_value);\n', '            _balances[_to] = _balances[_to].add(_value);\n', '            emit Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        }\n', '        \n', '        return false;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {\n', '        if (_balances[_from] >= _value && _allowances[_from][msg.sender] >= _value && _balances[_to].add(_value) > _balances[_to]) {\n', '            _balances[_to] = _balances[_to].add(_value);\n', '            _balances[_from] = _balances[_from].sub(_value);\n', '            _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(_value);\n', '            emit Transfer(_from, _to, _value);\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function balanceOf(address _owner) public override view returns (uint256 balance) {\n', '        return _balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public override returns (bool success) {\n', '        _allowances[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public override view returns (uint256 remaining) {\n', '      return _allowances[_owner][_spender];\n', '    }\n', '    \n', '    function totalSupply() public override view returns (uint256 total) {\n', '        return _totalSupply;\n', '    }\n', '}\n', '\n', 'contract WurstcoinNG is ERC20Base {\n', '    \n', '    using SafeMath for uint256;\n', '    \n', '    uint256 constant SUPPLY = 10000000;\n', '    address immutable owner = msg.sender;\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '\n', '    \n', '    constructor () payable {\n', '        require(SUPPLY > 0, "SUPPLY has to be greater than 0");\n', '        \n', '        _name = "Wurstcoin";\n', '        _symbol = "WURST";\n', '        _decimals = uint8(18);\n', '        _totalSupply = SUPPLY.mul(10 ** uint256(decimals()));\n', '        _balances[msg.sender] = _totalSupply;\n', '        emit Transfer(0x0000000000000000000000000000000000000000, msg.sender, _totalSupply);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the symbol of the token, usually a shorter version of the\n', '     * name.\n', '     */\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of decimals used to get its user representation.\n', '     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n', '     * be displayed to a user as `5,05` (`505 / 10 ** 2`).\n', '     *\n', '     * Tokens usually opt for a value of 18, imitating the relationship between\n', '     * Ether and Wei.\n', '     *\n', '     * NOTE: This information is only used for _display_ purposes: it in\n', '     * no way affects any of the arithmetic of the contract, including\n', '     * {IERC20-balanceOf} and {IERC20-transfer}.\n', '     */\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '}']