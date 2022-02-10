['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-16\n', '*/\n', '\n', 'pragma solidity ^0.5.16;\n', '\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  \n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  \n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', ' \n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  \n', '  constructor (address _owner) public {\n', '    owner = _owner;\n', '  }\n', '\n', '  \n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  \n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '    \n', '    mapping(address => uint256) balances;\n', '    \n', '    uint256 _totalSupply;\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '     \n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */ \n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        \n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '    \n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        \n', '        return balances[_owner];\n', '    \n', '    }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_from != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    \n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  \n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    \n', '    require(_spender != address(0));\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    require(_spender != address(0));\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    require(_spender != address(0));\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract DAFIToken is StandardToken, Ownable\n', '{\n', '    \n', '    string constant _name = "DAFI Token";\n', '    string constant _symbol = "DAFI";\n', '    uint256 constant _decimals = 18;\n', '\n', '    uint256 public maxSupply;\n', '    \n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    \n', '    constructor() public Ownable(msg.sender){ \n', '        \n', '       maxSupply = 2250000000 * 10 ** _decimals;\n', '\n', '    }\n', '    \n', '    function mint(uint256 _value, address _beneficiary)  external onlyOwner{\n', '\n', '        require(_beneficiary != address(0));\n', '        require(_value > 0);\n', '        require(_value.add(_totalSupply) <= maxSupply,"Minting amount exceeding max limit");\n', '        balances[_beneficiary] = balances[_beneficiary].add(_value);\n', '        _totalSupply = _totalSupply.add(_value);\n', '        \n', '        emit Transfer(address(0), _beneficiary, _value);\n', '        \n', '    }\n', '    \n', '    function burn(uint256 _value, address _beneficiary)  external onlyOwner {\n', '\n', '        require(_beneficiary != address(0));\n', '        require(balanceOf(_beneficiary) >= _value,"User does not have sufficient tokens to burn");\n', '        _totalSupply = _totalSupply.sub(_value);\n', '        balances[_beneficiary] = balances[_beneficiary].sub(_value);\n', '        \n', '        emit Transfer(_beneficiary, address(0), _value);\n', '    }\n', '    \n', '    function name() public pure returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the symbol of the token, usually a shorter version of the\n', '     * name.\n', '     */\n', '    function symbol() public pure returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of decimals used to get its user representation.\n', '     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n', '     * be displayed to a user as `5,05` (`505 / 10 ** 2`).\n', '     *\n', '     * Tokens usually opt for a value of 18, imitating the relationship between\n', '     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is\n', '     * called.\n', '     *\n', '     * NOTE: This information is only used for _display_ purposes: it in\n', '     * no way affects any of the arithmetic of the contract, including\n', '     * {IERC20-balanceOf} and {IERC20-transfer}.\n', '     */\n', '    function decimals() public pure returns (uint256) {\n', '        return _decimals;\n', '    }\n', '}']