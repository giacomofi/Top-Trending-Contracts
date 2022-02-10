['pragma solidity ^0.4.24;\n', '\n', 'contract GaiBanngToken {\n', '\n', '    string public name = &#39;丐帮令牌&#39;;      //  token name\n', '    string constant public symbol = "GAI";           //  token symbol\n', '    uint256 constant public decimals = 8;            //  token digit\n', '\n', '    uint256 public constant INITIAL_SUPPLY = 20170808 * (10 ** uint256(decimals));\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    uint256 public totalSupply = 0;\n', '    address public owner = 0x0;\n', '\n', '    modifier isOwner {\n', '        assert(owner == msg.sender);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) public isOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        totalSupply = INITIAL_SUPPLY;\n', '        balanceOf[owner] = totalSupply;\n', '        emit Transfer(0x0, owner, totalSupply);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value)  public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        balanceOf[_to] += _value;\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit  Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function setName(string _name) public isOwner {\n', '        name = _name;\n', '    }\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract GaiBanngToken {\n', '\n', "    string public name = '丐帮令牌';      //  token name\n", '    string constant public symbol = "GAI";           //  token symbol\n', '    uint256 constant public decimals = 8;            //  token digit\n', '\n', '    uint256 public constant INITIAL_SUPPLY = 20170808 * (10 ** uint256(decimals));\n', '    \n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    uint256 public totalSupply = 0;\n', '    address public owner = 0x0;\n', '\n', '    modifier isOwner {\n', '        assert(owner == msg.sender);\n', '        _;\n', '    }\n', '    function transferOwnership(address newOwner) public isOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        totalSupply = INITIAL_SUPPLY;\n', '        balanceOf[owner] = totalSupply;\n', '        emit Transfer(0x0, owner, totalSupply);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value)  public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        balanceOf[msg.sender] -= _value;\n', '        balanceOf[_to] += _value;\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '        require(allowance[_from][msg.sender] >= _value);\n', '        balanceOf[_to] += _value;\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        emit  Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function setName(string _name) public isOwner {\n', '        name = _name;\n', '    }\n', '    \n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '}']