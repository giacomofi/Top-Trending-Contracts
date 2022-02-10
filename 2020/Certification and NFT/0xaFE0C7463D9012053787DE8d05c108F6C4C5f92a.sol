['pragma solidity ^0.6.9;\n', '\n', '// ----------------------------------------------------------------------------\n', "// BokkyPooBah's Fixed Supply Token 👊 + Factory v1.20-pre-release\n", '//\n', '// A factory to conveniently deploy your own source code verified fixed supply\n', '// token contracts\n', '//\n', '// Factory deployment address: 0x{something}\n', '//\n', '// https://github.com/bokkypoobah/FixedSupplyTokenFactory\n', '//\n', '// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2019. The MIT Licence.\n', '// ----------------------------------------------------------------------------\n', '\n', '\n', '/**\n', " * @dev Wrappers over Solidity's arithmetic operations with added overflow\n", ' * checks.\n', ' *\n', ' * Arithmetic operations in Solidity wrap on overflow. This can easily result\n', ' * in bugs, because programmers usually assume that an overflow raises an\n', ' * error, which is the standard behavior in high level programming languages.\n', ' * `SafeMath` restores this intuition by reverting the transaction when an\n', ' * operation overflows.\n', ' *\n', ' * Using this library instead of the unchecked operations eliminates an entire\n', " * class of bugs, so it's recommended to use it always.\n", ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the multiplication of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `*` operator.\n", '     *\n', '     * Requirements:\n', '     *\n', '     * - Multiplication cannot overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts with custom message when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '\n', '    \n', '    function max(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a >= b ? a : b;\n', '    }\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a <= b ? a : b;\n', '    }\n', '}\n', '\n', '\n', '// SPDX-License-Identifier: UNLICENSED\n', '\n', '\n', 'interface IERC20 {\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address owner) external view returns (uint256);\n', '    function transfer(address to, uint256 amount) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 amount) external returns (bool);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 amount);\n', '    event Approval(address indexed owner, address indexed spender, uint256 amount);\n', '}\n', '\n', '\n', '\n', 'contract Owned {\n', '\n', '    address private mOwner;   \n', '    bool private initialised;    \n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    function _initOwned(address _owner) internal {\n', '        require(!initialised);\n', '        mOwner = address(uint160(_owner));\n', '        initialised = true;\n', '        emit OwnershipTransferred(address(0), mOwner);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return mOwner;\n', '    }\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == mOwner;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public {\n', '        require(isOwner());\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(mOwner, newOwner);\n', '        mOwner = address(uint160(newOwner));\n', '        newOwner = address(0);\n', '    }\n', '    function recoverTokens(address token, uint tokens) public {\n', '        require(isOwner());\n', '        if (token == address(0)) {\n', '            payable(mOwner).transfer((tokens == 0 ? address(this).balance : tokens));\n', '        } else {\n', '            IERC20(token).transfer(mOwner, tokens == 0 ? IERC20(token).balanceOf(address(this)) : tokens);\n', '        }\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// ApproveAndCall Fallback\n', '// NOTE for contracts implementing this interface:\n', '// 1. An error must be thrown if there are errors executing `transferFrom(...)`\n', '// 2. The calling token contract must be checked to prevent malicious behaviour\n', '// ----------------------------------------------------------------------------\n', 'interface ApproveAndCallFallback {\n', '    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) external;\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Token Interface = ERC20 + symbol + name + decimals + approveAndCall\n', '// ----------------------------------------------------------------------------\n', 'interface TokenInterface is IERC20 {\n', '    function approveAndCall(address spender, uint tokens, bytes memory data) external returns (bool success);\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// FixedSupplyToken 👊 = ERC20 + symbol + name + decimals + approveAndCall\n', '// ----------------------------------------------------------------------------\n', 'contract FixedSupplyToken is TokenInterface, Owned {\n', '    using SafeMath for uint;\n', '\n', '    string _symbol;\n', '    string  _name;\n', '    uint8 _decimals;\n', '    uint _totalSupply;\n', '\n', '    mapping(address => uint) balances;\n', '    mapping(address => mapping(address => uint)) allowed;\n', '\n', '    function init(address tokenOwner, string memory symbol, string memory name, uint8 decimals, uint fixedSupply) public {\n', '        _initOwned(tokenOwner);\n', '        _symbol = symbol;\n', '        _name = name;\n', '        _decimals = decimals;\n', '        _totalSupply = fixedSupply;\n', '        balances[tokenOwner] = _totalSupply;\n', '        emit Transfer(address(0), tokenOwner, _totalSupply);\n', '    }\n', '    function symbol() public view override returns (string memory) {\n', '        return _symbol;\n', '    }\n', '    function name() public view override returns (string memory) {\n', '        return _name;\n', '    }\n', '    function decimals() public view override returns (uint8) {\n', '        return _decimals;\n', '    }\n', '    function totalSupply() public view override returns (uint) {\n', '        return _totalSupply.sub(balances[address(0)]);\n', '    }\n', '    function balanceOf(address tokenOwner) public view override returns (uint balance) {\n', '        return balances[tokenOwner];\n', '    }\n', '    function transfer(address to, uint tokens) public override returns (bool success) {\n', '        balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(msg.sender, to, tokens);\n', '        return true;\n', '    }\n', '    function approve(address spender, uint tokens) public override returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        return true;\n', '    }\n', '    function transferFrom(address from, address to, uint tokens) public override returns (bool success) {\n', '        balances[from] = balances[from].sub(tokens);\n', '        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '        balances[to] = balances[to].add(tokens);\n', '        emit Transfer(from, to, tokens);\n', '        return true;\n', '    }\n', '    function allowance(address tokenOwner, address spender) public view override returns (uint remaining) {\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '    // NOTE Only use this call with a trusted spender contract\n', '    function approveAndCall(address spender, uint tokens, bytes memory data) public override returns (bool success) {\n', '        allowed[msg.sender][spender] = tokens;\n', '        emit Approval(msg.sender, spender, tokens);\n', '        ApproveAndCallFallback(spender).receiveApproval(msg.sender, tokens, address(this), data);\n', '        return true;\n', '    }\n', '    receive () external payable {\n', '        revert();\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', "// BokkyPooBah's Fixed Supply Token 👊 Factory\n", '//\n', '// Notes:\n', '//   * The `newContractAddress` deprecation is just advisory\n', '//   * A fee equal to or above `minimumFee` must be sent with the\n', '//   `deployTokenContract(...)` call\n', '//\n', '// Execute `deployTokenContract(...)` with the following parameters to deploy\n', '// your very own FixedSupplyToken contract:\n', '//   symbol         symbol\n', '//   name           name\n', '//   decimals       number of decimal places for the token contract\n', '//   totalSupply    the fixed token total supply\n', '//\n', '// For example, deploying a FixedSupplyToken contract with a `totalSupply`\n', '// of 1,000.000000000000000000 tokens:\n', '//   symbol         "ME"\n', '//   name           "My Token"\n', '//   decimals       18\n', '//   initialSupply  10000000000000000000000 = 1,000.000000000000000000 tokens\n', '//\n', '// The TokenDeployed() event is logged with the following parameters:\n', '//   owner          the account that execute this transaction\n', '//   token          the newly deployed FixedSupplyToken address\n', '//   symbol         symbol\n', '//   name           name\n', '//   decimals       number of decimal places for the token contract\n', '//   totalSupply    the fixed token total supply\n', '// ----------------------------------------------------------------------------\n', 'contract BokkyPooBahsFixedSupplyTokenFactory is Owned {\n', '    using SafeMath for uint;\n', '\n', '    address public newAddress;\n', '    uint public minimumFee = 0.1 ether;\n', '    mapping(address => bool) public isChild;\n', '    address[] public children;\n', '\n', '    event FactoryDeprecated(address _newAddress);\n', '    event MinimumFeeUpdated(uint oldFee, uint newFee);\n', '    event TokenDeployed(address indexed owner, address indexed token, string symbol, string name, uint8 decimals, uint totalSupply);\n', '\n', '    constructor () public {\n', '        _initOwned(msg.sender);\n', '    }\n', '    function numberOfChildren() public view returns (uint) {\n', '        return children.length;\n', '    }\n', '    function deprecateFactory(address _newAddress) public {\n', '        require(isOwner());\n', '        require(newAddress == address(0));\n', '        emit FactoryDeprecated(_newAddress);\n', '        newAddress = _newAddress;\n', '    }\n', '    function setMinimumFee(uint _minimumFee) public {\n', '        require(isOwner());\n', '        emit MinimumFeeUpdated(minimumFee, _minimumFee);\n', '        minimumFee = _minimumFee;\n', '    }\n', '    function deployTokenContract(string memory symbol, string memory name, uint8 decimals, uint totalSupply) public payable returns (FixedSupplyToken token) {\n', '        require(msg.value >= minimumFee);\n', '        require(decimals <= 27);\n', '        require(totalSupply > 0);\n', '        token = new FixedSupplyToken();\n', '        token.init(msg.sender, symbol, name, decimals, totalSupply);\n', '        isChild[address(token)] = true;\n', '        children.push(address(token));\n', '        emit TokenDeployed(owner(), address(token), symbol, name, decimals, totalSupply);\n', '        if (msg.value > 0) {\n', '            payable(owner()).transfer(msg.value);\n', '        }\n', '    }\n', '    receive () external payable {\n', '        revert();\n', '    }\n', '}']