['/* solium-disable-next-line linebreak-style */\n', 'pragma solidity 0.4.24;\n', '\n', '// ----------------------------------------------------------------------------\n', '// Math - Implement Math Library\n', '// ----------------------------------------------------------------------------\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 r = a + b;\n', '\n', "        require(r >= a, 'Require r >= a');\n", '\n', '        return r;\n', '    }\n', '\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        require(a >= b, 'Require a >= b');\n", '\n', '        return a - b;\n', '    }\n', '\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 r = a * b;\n', '\n', "        require(r / a == b, 'Require r / a == b');\n", '\n', '        return r;\n', '    }\n', '\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20Interface - Standard ERC20 Interface Definition\n', '// Based on the final ERC20 specification at:\n', '// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Interface {\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// ERC20Token - Standard ERC20 Implementation\n', '// ----------------------------------------------------------------------------\n', 'contract ERC20Token is ERC20Interface {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    string public  name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    mapping(address => uint256) internal balances;\n', '    mapping(address => mapping (address => uint256)) allowed;\n', '\n', '\n', '    constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply, address _initialTokenHolder) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        totalSupply = _totalSupply;\n', '\n', '        // The initial balance of tokens is assigned to the given token holder address.\n', '        balances[_initialTokenHolder] = _totalSupply;\n', '        allowed[_initialTokenHolder][_initialTokenHolder] = balances[_initialTokenHolder];\n', '\n', '        // Per EIP20, the constructor should fire a Transfer event if tokens are assigned to an account.\n', '        emit Transfer(0x0, _initialTokenHolder, _totalSupply);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value)  public returns (bool success) {\n', "        require(balances[msg.sender] >= _value, 'Sender`s balance is not enough');\n", "        require(balances[_to] + _value > balances[_to], 'Value is invalid');\n", "        require(_to != address(0), '_to address is invalid');\n", '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', "        require(balances[_from] >= _value, 'Owner`s balance is not enough');\n", "        require(allowed[_from][msg.sender] >= _value, 'Sender`s allowance is not enough');\n", "        require(balances[_to] + _value > balances[_to], 'Token amount value is invalid');\n", "        require(_to != address(0), '_to address is invalid');\n", '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '\n', '        emit Approval(msg.sender, _spender, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     */\n', '    function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {\n', '        uint256 oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '// Implements a simple ownership model with 2-phase transfer.\n', 'contract Owned {\n', '\n', '    address public owner;\n', '    address public proposedOwner;\n', '\n', '    constructor() public\n', '    {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    modifier onlyOwner() {\n', "        require(isOwner(msg.sender) == true, 'Require owner to execute transaction');\n", '        _;\n', '    }\n', '\n', '\n', '    function isOwner(address _address) public view returns (bool result) {\n', '        return (_address == owner);\n', '    }\n', '\n', '\n', '    function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool success) {\n', "        require(_proposedOwner != address(0), 'Require proposedOwner != address(0)');\n", "        require(_proposedOwner != address(this), 'Require proposedOwner != address(this)');\n", "        require(_proposedOwner != owner, 'Require proposedOwner != owner');\n", '\n', '        proposedOwner = _proposedOwner;\n', '        return true;\n', '    }\n', '\n', '\n', '    function completeOwnershipTransfer() public returns (bool success) {\n', "        require(msg.sender == proposedOwner, 'Require msg.sender == proposedOwner');\n", '\n', '        owner = msg.sender;\n', '        proposedOwner = address(0);\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// OpsManaged - Implements an Owner and Ops Permission Model\n', '// ----------------------------------------------------------------------------\n', 'contract OpsManaged is Owned {\n', '\n', '    address public opsAddress;\n', '\n', '\n', '    constructor() public\n', '        Owned()\n', '    {\n', '    }\n', '\n', '\n', '    modifier onlyOwnerOrOps() {\n', "        require(isOwnerOrOps(msg.sender), 'Require only owner or ops');\n", '        _;\n', '    }\n', '\n', '\n', '    function isOps(address _address) public view returns (bool result) {\n', '        return (opsAddress != address(0) && _address == opsAddress);\n', '    }\n', '\n', '\n', '    function isOwnerOrOps(address _address) public view returns (bool result) {\n', '        return (isOwner(_address) || isOps(_address));\n', '    }\n', '\n', '\n', '    function setOpsAddress(address _newOpsAddress) public onlyOwner returns (bool success) {\n', "        require(_newOpsAddress != owner, 'Require newOpsAddress != owner');\n", "        require(_newOpsAddress != address(this), 'Require newOpsAddress != address(this)');\n", '\n', '        opsAddress = _newOpsAddress;\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// Finalizable - Implement Finalizable (Crowdsale) model\n', '// ----------------------------------------------------------------------------\n', 'contract Finalizable is OpsManaged {\n', '\n', '    FinalizeState public finalized;\n', '\n', '    enum FinalizeState {\n', '        None,\n', '        Finalized\n', '    }\n', '\n', '    event Finalized();\n', '\n', '\n', '    constructor() public OpsManaged()\n', '    {\n', '        finalized = FinalizeState.None;\n', '    }\n', '\n', '\n', '    function finalize() public onlyOwner returns (bool success) {\n', "        require(finalized == FinalizeState.None, 'Require !finalized');\n", '\n', '        finalized = FinalizeState.Finalized;\n', '\n', '        emit Finalized();\n', '\n', '        return true;\n', '    }\n', '}\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// FinalizableToken - Extension to ERC20Token with ops and finalization\n', '// ----------------------------------------------------------------------------\n', '//\n', '// ERC20 token with the following additions:\n', '//    1. Owner/Ops Ownership\n', '//    2. Finalization\n', '//\n', 'contract FinalizableToken is ERC20Token, Finalizable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '\n', '    // The constructor will assign the initial token supply to the owner (msg.sender).\n', '    constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public\n', '        ERC20Token(_name, _symbol, _decimals, _totalSupply, msg.sender)\n', '        Finalizable()\n', '    {\n', '    }\n', '\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        validateTransfer(msg.sender, _to);\n', '\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        validateTransfer(msg.sender, _to);\n', '\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '\n', '    function validateTransfer(address _sender, address _to) internal view {\n', '        // Once the token is finalized, everybody can transfer tokens.\n', '        if (finalized == FinalizeState.Finalized) {\n', '            return;\n', '        }\n', '\n', '        if (isOwner(_to)) {\n', '            return;\n', '        }\n', '\n', "        require(_to != opsAddress, 'Ops cannot recieve token');\n", '\n', '        // Before the token is finalized, only owner and ops are allowed to initiate transfers.\n', '        // This allows them to move tokens while the sale is still in private sale.\n', "        require(isOwnerOrOps(_sender), 'Require is owner or ops allowed to initiate transfer');\n", '    }\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Token Contract Configuration\n', '// ----------------------------------------------------------------------------\n', 'contract TokenConfig {\n', '\n', "    string  internal constant TOKEN_SYMBOL      = 'SLS';\n", "    string  internal constant TOKEN_NAME        = 'SKILLSH';\n", '    uint8   internal constant TOKEN_DECIMALS    = 8;\n', '\n', '    uint256 internal constant DECIMALS_FACTOR    = 10 ** uint256(TOKEN_DECIMALS);\n', '    uint256 internal constant TOKEN_TOTAL_SUPPLY = 500000000 * DECIMALS_FACTOR;\n', '}\n', '\n', '\n', '\n', '// ----------------------------------------------------------------------------\n', '// Token Contract\n', '// ----------------------------------------------------------------------------\n', 'contract SLSToken is FinalizableToken, TokenConfig {\n', '\n', '    enum HaltState {\n', '        Unhalted,\n', '        Halted\n', '    }\n', '\n', '    HaltState public halts;\n', '\n', '    constructor() public\n', '        FinalizableToken(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, TOKEN_TOTAL_SUPPLY)\n', '    {\n', '        halts = HaltState.Unhalted;\n', '        finalized = FinalizeState.None;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', "        require(halts == HaltState.Unhalted, 'Require smart contract is not in halted state');\n", '\n', '        if(isOps(msg.sender)) {\n', '            return super.transferFrom(owner, _to, _value);\n', '        }\n', '\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', "        require(halts == HaltState.Unhalted, 'Require smart contract is not in halted state');\n", '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    // Allows a token holder to burn tokens. Once burned, tokens are permanently\n', '    // removed from the total supply.\n', '    function burn(uint256 _amount) public returns (bool success) {\n', "        require(_amount > 0, 'Token amount to burn must be larger than 0');\n", '\n', '        address account = msg.sender;\n', "        require(_amount <= balanceOf(account), 'You cannot burn token you dont have');\n", '\n', '        balances[account] = balances[account].sub(_amount);\n', '        totalSupply = totalSupply.sub(_amount);\n', '        return true;\n', '    }\n', '\n', '    /* Halts or unhalts direct trades without the sell/buy functions below */\n', '    function haltsTrades() public onlyOwnerOrOps returns (bool success) {\n', '        halts = HaltState.Halted;\n', '        return true;\n', '    }\n', '\n', '    function unhaltsTrades() public onlyOwnerOrOps returns (bool success) {\n', '        halts = HaltState.Unhalted;\n', '        return true;\n', '    }\n', '\n', '}']