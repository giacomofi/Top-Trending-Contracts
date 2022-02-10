['/**\n', ' *Submitted for verification at Etherscan.io on 2020-08-12\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2020-08-12\n', '*/\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', 'library SafeMath {\n', '    \n', '/**\n', ' * @dev Multiplies two unsigned integers, reverts on overflow.\n', ' */\n', ' \n', 'function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '\n', 'if (_a == 0) {\n', 'return 0;\n', '}\n', '\n', 'uint256 c = _a * _b;\n', 'require(c / _a == _b);\n', 'return c;\n', '}\n', '\n', '/**\n', ' * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', ' */\n', ' \n', 'function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '// Solidity only automatically asserts when dividing by 0\n', 'require(_b > 0);\n', 'uint256 c = _a / _b;\n', " // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", 'return c;\n', '\n', '}\n', '\n', '/**\n', ' * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', ' */\n', '     \n', 'function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '\n', 'require(_b <= _a);\n', 'return _a - _b;\n', '}\n', '\n', '/**\n', ' * @dev Adds two unsigned integers, reverts on overflow.\n', ' */\n', ' \n', 'function add(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '\n', 'uint256 c = _a + _b;\n', 'require(c >= _a);\n', 'return c;\n', '\n', '}\n', '\n', '/**\n', '  * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '  * reverts when dividing by zero.\n', '   */\n', 'function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '}\n', '}\n', '\n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', '*/\n', '\n', 'contract Ownable {\n', 'address public owner;\n', 'address public newOwner;\n', 'event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', 'constructor() public {\n', 'owner = msg.sender;\n', 'newOwner = address(0);\n', '}\n', '\n', '// allows execution by the owner only\n', '\n', 'modifier onlyOwner() {\n', 'require(msg.sender == owner);\n', '_;\n', '}\n', '\n', 'modifier onlyNewOwner() {\n', 'require(msg.sender != address(0));\n', 'require(msg.sender == newOwner);\n', '_;\n', '}\n', '\n', '/**\n', '    @dev allows transferring the contract ownership\n', '    the new owner still needs to accept the transfer\n', '    can only be called by the contract owner\n', '    @param _newOwner    new contract owner\n', '*/\n', '\n', 'function transferOwnership(address _newOwner) public onlyOwner {\n', 'require(_newOwner != address(0));\n', 'newOwner = _newOwner;\n', '}\n', '\n', '/**\n', '    @dev used by a new owner to accept an ownership transfer\n', '*/\n', '\n', 'function acceptOwnership() public onlyNewOwner {\n', 'emit OwnershipTransferred(owner, newOwner);\n', 'owner = newOwner;\n', '}\n', '}\n', '\n', '/*\n', '    ERC20 Token interface\n', '*/\n', '\n', 'contract ERC20 {\n', '\n', 'function totalSupply() public view returns (uint256);\n', 'function balanceOf(address who) public view returns (uint256);\n', 'function allowance(address owner, address spender) public view returns (uint256);\n', 'function transfer(address to, uint256 value) public returns (bool);\n', 'function transferFrom(address from, address to, uint256 value) public returns (bool);\n', 'function approve(address spender, uint256 value) public returns (bool);\n', 'function sendwithgas(address _from, address _to, uint256 _value, uint256 _fee) public returns (bool);\n', 'event Approval(address indexed owner, address indexed spender, uint256 value);\n', 'event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'interface TokenRecipient {\n', 'function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;\n', '}\n', '\n', 'contract RaOnCoin is ERC20, Ownable {\n', 'using SafeMath for uint256;\n', '\n', 'string public name;\n', 'string public symbol;\n', 'uint8 public decimals;\n', 'uint256 internal initialSupply;\n', 'uint256 internal totalSupply_;\n', 'mapping(address => uint256) internal balances;\n', 'mapping(address => bool) public frozen;\n', 'mapping(address => mapping(address => uint256)) internal allowed;\n', '\n', 'event Burn(address indexed owner, uint256 value);\n', 'event Mint(uint256 value);\n', 'event Freeze(address indexed holder);\n', 'event Unfreeze(address indexed holder);\n', '\n', 'modifier notFrozen(address _holder) {\n', 'require(!frozen[_holder]);\n', '_;\n', '}\n', '\n', 'constructor() public {\n', 'name = "RaOnCoin";\n', 'symbol = "RAO";\n', 'decimals = 0;\n', 'initialSupply = 300000000;\n', 'totalSupply_ = 300000000;\n', 'balances[owner] = totalSupply_;\n', 'emit Transfer(address(0), owner, totalSupply_);\n', '}\n', '\n', 'function () public payable {\n', 'revert();\n', '}\n', '\n', '/**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '   \n', 'function totalSupply() public view returns (uint256) {\n', 'return totalSupply_;\n', '}\n', '\n', '/**\n', ' * @dev Transfer token for a specified addresses\n', ' * @param _from The address to transfer from.\n', ' * @param _to The address to transfer to.\n', ' * @param _value The amount to be transferred.\n', ' */ \n', '\n', 'function _transfer(address _from, address _to, uint _value) internal {\n', '\n', 'require(_to != address(0));\n', 'require(_value <= balances[_from]);\n', 'require(_value <= allowed[_from][msg.sender]);\n', 'balances[_from] = balances[_from].sub(_value);\n', 'balances[_to] = balances[_to].add(_value);\n', 'allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', 'emit Transfer(_from, _to, _value);\n', '}\n', '\n', '/**\n', ' * @dev Transfer token for a specified address\n', ' * @param _to The address to transfer to.\n', ' * @param _value The amount to be transferred.\n', ' */\n', '     \n', ' \n', 'function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {\n', '\n', 'require(_to != address(0));\n', 'require(_value <= balances[msg.sender]);\n', 'balances[msg.sender] = balances[msg.sender].sub(_value);\n', 'balances[_to] = balances[_to].add(_value);\n', 'emit Transfer(msg.sender, _to, _value);\n', 'return true;\n', '}\n', '\n', '/**\n', ' * @dev Gets the balance of the specified address.\n', ' * @param _holder The address to query the balance of.\n', ' * @return An uint256 representing the amount owned by the passed address.\n', ' */\n', ' \n', 'function balanceOf(address _holder) public view returns (uint256 balance) {\n', 'return balances[_holder];\n', '}\n', '\n', '/**\n', ' * ERC20 Token Transfer\n', ' */\n', '\n', 'function sendwithgas(address _from, address _to, uint256 _value, uint256 _fee) public onlyOwner notFrozen(_from) returns (bool) {\n', '\n', 'uint256 _total;\n', '_total = _value.add(_fee);\n', 'require(!frozen[_from]);\n', 'require(_to != address(0));\n', 'require(_total <= balances[_from]);\n', 'balances[msg.sender] = balances[msg.sender].add(_fee);\n', 'balances[_from] = balances[_from].sub(_total);\n', 'balances[_to] = balances[_to].add(_value);\n', '\n', 'emit Transfer(_from, _to, _value);\n', 'emit Transfer(_from, msg.sender, _fee);\n', '\n', 'return true;\n', '\n', '}\n', '\n', '/**\n', ' * @dev Transfer tokens from one address to another.\n', ' * Note that while this function emits an Approval event, this is not required as per the specification,\n', ' * and other compliant implementations may not emit the event.\n', ' * @param _from address The address which you want to send tokens from\n', ' * @param _to address The address which you want to transfer to\n', ' * @param _value uint256 the amount of tokens to be transferred\n', ' */\n', '     \n', 'function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {\n', '\n', 'require(_to != address(0));\n', 'require(_value <= balances[_from]);\n', 'require(_value <= allowed[_from][msg.sender]);\n', '_transfer(_from, _to, _value);\n', 'return true;\n', '}\n', '\n', '/**\n', ' * @dev Approve the passed address to _spender the specified amount of tokens on behalf of msg.sender.\n', ' * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', ' * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', " * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", ' * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', ' * @param _spender The address which will spend the funds.\n', ' * @param _value The amount of tokens to be spent.\n', ' */ \n', '\n', 'function approve(address _spender, uint256 _value) public returns (bool) {\n', 'allowed[msg.sender][_spender] = _value;\n', 'emit Approval(msg.sender, _spender, _value);\n', 'return true;\n', '}\n', '\n', '/**\n', ' * @dev Function to check the amount of tokens that an _holder allowed to a spender.\n', ' * @param _holder address The address which owns the funds.\n', ' * @param _spender address The address which will spend the funds.\n', ' * @return A uint256 specifying the amount of tokens still available for the spender.\n', '*/\n', '     \n', 'function allowance(address _holder, address _spender) public view returns (uint256) {\n', 'return allowed[_holder][_spender];\n', '\n', '}\n', '\n', '/**\n', '  * Freeze Account.\n', ' */\n', '\n', 'function freezeAccount(address _holder) public onlyOwner returns (bool) {\n', '\n', 'require(!frozen[_holder]);\n', 'frozen[_holder] = true;\n', 'emit Freeze(_holder);\n', 'return true;\n', '}\n', '\n', '/**\n', '  * Unfreeze Account.\n', ' */\n', ' \n', 'function unfreezeAccount(address _holder) public onlyOwner returns (bool) {\n', '\n', 'require(frozen[_holder]);\n', 'frozen[_holder] = false;\n', 'emit Unfreeze(_holder);\n', 'return true;\n', '}\n', '\n', '/**\n', '  * Token Burn.\n', ' */\n', '\n', 'function burn(uint256 _value) public onlyOwner returns (bool) {\n', '    \n', 'require(_value <= balances[msg.sender]);\n', 'address burner = msg.sender;\n', 'balances[burner] = balances[burner].sub(_value);\n', 'totalSupply_ = totalSupply_.sub(_value);\n', 'emit Burn(burner, _value);\n', '\n', 'return true;\n', '}\n', '\n', 'function burn_address(address _target) public onlyOwner returns (bool){\n', '    \n', 'require(_target != address(0));\n', 'uint256 _targetValue = balances[_target];\n', 'balances[_target] = 0;\n', 'totalSupply_ = totalSupply_.sub(_targetValue);\n', 'address burner = msg.sender;\n', 'emit Burn(burner, _targetValue);\n', 'return true;\n', '}\n', '\n', '/**\n', '  * Token Mint.\n', ' */\n', '\n', 'function mint(uint256 _amount) public onlyOwner returns (bool) {\n', '    \n', 'totalSupply_ = totalSupply_.add(_amount);\n', 'balances[owner] = balances[owner].add(_amount);\n', 'emit Transfer(address(0), owner, _amount);\n', 'return true;\n', '}\n', '\n', '/** \n', ' * @dev Internal function to determine if an address is a contract\n', ' * @param addr The address being queried\n', ' * @return True if `_addr` is a contract\n', '*/\n', ' \n', 'function isContract(address addr) internal view returns (bool) {\n', '    \n', 'uint size;\n', 'assembly{size := extcodesize(addr)}\n', 'return size > 0;\n', '}\n', '}']