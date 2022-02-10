['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract ACAToken is ERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    address public owner;\n', '    address public admin;\n', '    address public saleAddress;\n', '\n', '    string public name = "ACA Network Token";\n', '    string public symbol = "ACA";\n', '    uint8 public decimals = 18;\n', '\n', '    uint256 totalSupply_;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    mapping (address => uint256) balances;\n', '\n', '    bool transferable = false;\n', '    mapping (address => bool) internal transferLocked;\n', '\n', '    event Genesis(address owner, uint256 value);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);\n', '    event Burn(address indexed burner, uint256 value);\n', '    event LogAddress(address indexed addr);\n', '    event LogUint256(uint256 value);\n', '    event TransferLock(address indexed target, bool value);\n', '\n', '    // modifiers\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyAdmin() {\n', '        require(msg.sender == owner || msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '    modifier canTransfer(address _from, address _to) {\n', '        require(_to != address(0x0));\n', '        require(_to != address(this));\n', '\n', '        if ( _from != owner && _from != admin ) {\n', '            require(transferable);\n', '            require (!transferLocked[_from]);\n', '        }\n', '        _;\n', '    }\n', '\n', '    // constructor\n', '    function ACAToken(uint256 _totalSupply, address _saleAddress, address _admin) public {\n', '        require(_totalSupply > 0);\n', '        owner = msg.sender;\n', '        require(_saleAddress != address(0x0));\n', '        require(_saleAddress != address(this));\n', '        require(_saleAddress != owner);\n', '\n', '        require(_admin != address(0x0));\n', '        require(_admin != address(this));\n', '        require(_admin != owner);\n', '\n', '        require(_admin != _saleAddress);\n', '\n', '        admin = _admin;\n', '        saleAddress = _saleAddress;\n', '\n', '        totalSupply_ = _totalSupply;\n', '\n', '        balances[owner] = totalSupply_;\n', '        approve(saleAddress, totalSupply_);\n', '\n', '        emit Genesis(owner, totalSupply_);\n', '    }\n', '\n', '    // permission related\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        require(newOwner != address(this));\n', '        require(newOwner != admin);\n', '\n', '        owner = newOwner;\n', '        emit OwnershipTransferred(owner, newOwner);\n', '    }\n', '\n', '    function transferAdmin(address _newAdmin) public onlyOwner {\n', '        require(_newAdmin != address(0));\n', '        require(_newAdmin != address(this));\n', '        require(_newAdmin != owner);\n', '\n', '        admin = _newAdmin;\n', '        emit AdminTransferred(admin, _newAdmin);\n', '    }\n', '\n', '    function setTransferable(bool _transferable) public onlyAdmin {\n', '        transferable = _transferable;\n', '    }\n', '\n', '    function isTransferable() public view returns (bool) {\n', '        return transferable;\n', '    }\n', '\n', '    function transferLock() public returns (bool) {\n', '        transferLocked[msg.sender] = true;\n', '        emit TransferLock(msg.sender, true);\n', '        return true;\n', '    }\n', '\n', '    function manageTransferLock(address _target, bool _value) public onlyAdmin returns (bool) {\n', '        transferLocked[_target] = _value;\n', '        emit TransferLock(_target, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferAllowed(address _target) public view returns (bool) {\n', '        return (transferable && transferLocked[_target] == false);\n', '    }\n', '\n', '    // token related\n', '    function totalSupply() public view returns (uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) canTransfer(msg.sender, _to) public returns (bool) {\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function balanceOfOwner() public view returns (uint256 balance) {\n', '        return balances[owner];\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from, _to) returns (bool) {\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public canTransfer(msg.sender, _spender) returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public canTransfer(msg.sender, _spender) returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public canTransfer(msg.sender, _spender) returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function burn(uint256 _value) public {\n', '        require(_value <= balances[msg.sender]);\n', '        // no need to require value <= totalSupply, since that would imply the\n', '        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure\n', '\n', '        address burner = msg.sender;\n', '        balances[burner] = balances[burner].sub(_value);\n', '        totalSupply_ = totalSupply_.sub(_value);\n', '        emit Burn(burner, _value);\n', '    }\n', '\n', '    function emergencyERC20Drain(ERC20 _token, uint256 _amount) public onlyOwner {\n', '        _token.transfer(owner, _amount);\n', '    }\n', '}']