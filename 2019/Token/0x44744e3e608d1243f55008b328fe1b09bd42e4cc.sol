['pragma solidity ^0.5.7;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '\taddress public owner;\n', '\taddress public newOwner;\n', '\n', '\tevent OwnershipTransferred(address indexed oldOwner, address indexed newOwner);\n', '\n', '\tconstructor() public {\n', '\t\towner = msg.sender;\n', '\t\tnewOwner = address(0);\n', '\t}\n', '\n', '\tmodifier onlyOwner() {\n', '\t\trequire(msg.sender == owner, "msg.sender == owner");\n', '\t\t_;\n', '\t}\n', '\n', '\tfunction transferOwnership(address _newOwner) public onlyOwner {\n', '\t\trequire(address(0) != _newOwner, "address(0) != _newOwner");\n', '\t\tnewOwner = _newOwner;\n', '\t}\n', '\n', '\tfunction acceptOwnership() public {\n', '\t\trequire(msg.sender == newOwner, "msg.sender == newOwner");\n', '\t\temit OwnershipTransferred(owner, msg.sender);\n', '\t\towner = msg.sender;\n', '\t\tnewOwner = address(0);\n', '\t}\n', '}\n', '\n', 'contract Authorizable is Ownable {\n', '    mapping(address => bool) public authorized;\n', '  \n', '    event AuthorizationSet(address indexed addressAuthorized, bool indexed authorization);\n', '\n', '    constructor() public {\n', '        authorized[msg.sender] = true;\n', '    }\n', '\n', '    modifier onlyAuthorized() {\n', '        require(authorized[msg.sender], "authorized[msg.sender]");\n', '        _;\n', '    }\n', '\n', '    function setAuthorized(address addressAuthorized, bool authorization) onlyOwner public {\n', '        emit AuthorizationSet(addressAuthorized, authorization);\n', '        authorized[addressAuthorized] = authorization;\n', '    }\n', '  \n', '}\n', '\n', 'contract ERC20Basic {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath for uint256;\n', '\n', '    mapping(address => uint256) balances;\n', '\n', '    function transferFunction(address _sender, address _to, uint256 _value) internal returns (bool) {\n', '        require(_to != address(0), "_to != address(0)");\n', '        require(_to != address(this), "_to != address(this)");\n', '        require(_value <= balances[_sender], "_value <= balances[_sender]");\n', '\n', '        balances[_sender] = balances[_sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(_sender, _to, _value);\n', '        return true;\n', '    }\n', '  \n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '\t    return transferFunction(msg.sender, _to, _value);\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', 'contract ERC223TokenCompatible is BasicToken {\n', '  using SafeMath for uint256;\n', '  \n', '  event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);\n', '\n', '\tfunction transfer(address _to, uint256 _value, bytes memory _data, string memory _custom_fallback) public returns (bool success) {\n', '\t\trequire(_to != address(0), "_to != address(0)");\n', '        require(_to != address(this), "_to != address(this)");\n', '\t\trequire(_value <= balances[msg.sender], "_value <= balances[msg.sender]");\n', '\t\t\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\t\tif( isContract(_to) ) {\n', '\t\t    (bool txOk, ) = _to.call.value(0)( abi.encodePacked(bytes4( keccak256( abi.encodePacked( _custom_fallback ) ) ), msg.sender, _value, _data) );\n', '\t\t\trequire( txOk, "_to.call.value(0)( abi.encodePacked(bytes4( keccak256( abi.encodePacked( _custom_fallback ) ) ), msg.sender, _value, _data) )" );\n', '\n', '\t\t} \n', '\t\temit Transfer(msg.sender, _to, _value, _data);\n', '\t\treturn true;\n', '\t}\n', '\n', '\tfunction transfer(address _to, uint256 _value, bytes memory _data) public returns (bool success) {\n', '\t\treturn transfer( _to, _value, _data, "tokenFallback(address,uint256,bytes)");\n', '\t}\n', '\n', '\t//assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '\tfunction isContract(address _addr) private view returns (bool is_contract) {\n', '\t\tuint256 length;\n', '\t\tassembly {\n', '            //retrieve the size of the code on target address, this needs assembly\n', '            length := extcodesize(_addr)\n', '\t\t}\n', '\t\treturn (length>0);\n', '    }\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0), "_to != address(0)");\n', '        require(_to != address(this), "_to != address(this)");\n', '        require(_value <= balances[_from], "_value <= balances[_from]");\n', '        require(_value <= allowed[_from][msg.sender], "_value <= allowed[_from][msg.sender]");\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '        allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '    }\n', '\n', '}\n', '\n', 'contract HumanStandardToken is StandardToken {\n', '    /* Approves and then calls the receiving contract */\n', '    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {\n', '        approve(_spender, _value);\n', '        (bool txOk, ) = _spender.call(abi.encodePacked(bytes4(keccak256("receiveApproval(address,uint256,bytes)")), msg.sender, _value, _extraData));\n', '        require(txOk, \'_spender.call(abi.encodePacked(bytes4(keccak256("receiveApproval(address,uint256,bytes)")), msg.sender, _value, _extraData))\');\n', '        return true;\n', '    }\n', '    function approveAndCustomCall(address _spender, uint256 _value, bytes memory _extraData, bytes4 _customFunction) public returns (bool success) {\n', '        approve(_spender, _value);\n', '        (bool txOk, ) = _spender.call(abi.encodePacked(_customFunction, msg.sender, _value, _extraData));\n', '        require(txOk, "_spender.call(abi.encodePacked(_customFunction, msg.sender, _value, _extraData))");\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Startable is Ownable, Authorizable {\n', '    event Start();\n', '\n', '    bool public started = false;\n', '\n', '    modifier whenStarted() {\n', '\t    require( started || authorized[msg.sender], "started || authorized[msg.sender]" );\n', '        _;\n', '    }\n', '\n', '    function start() onlyOwner public {\n', '        started = true;\n', '        emit Start();\n', '    }\n', '}\n', '\n', 'contract StartToken is Startable, ERC223TokenCompatible, StandardToken {\n', '\n', '    function transfer(address _to, uint256 _value) public whenStarted returns (bool) {\n', '        return super.transfer(_to, _value);\n', '    }\n', '    function transfer(address _to, uint256 _value, bytes memory _data) public whenStarted returns (bool) {\n', '        return super.transfer(_to, _value, _data);\n', '    }\n', '    function transfer(address _to, uint256 _value, bytes memory _data, string memory _custom_fallback) public whenStarted returns (bool) {\n', '        return super.transfer(_to, _value, _data, _custom_fallback);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public whenStarted returns (bool) {\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public whenStarted returns (bool) {\n', '        return super.approve(_spender, _value);\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public whenStarted returns (bool success) {\n', '        return super.increaseApproval(_spender, _addedValue);\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public whenStarted returns (bool success) {\n', '        return super.decreaseApproval(_spender, _subtractedValue);\n', '    }\n', '}\n', '\n', '\n', 'contract BurnToken is StandardToken {\n', '    uint256 public initialSupply;\n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '    \n', '    constructor(uint256 _totalSupply) internal {\n', '        initialSupply = _totalSupply;\n', '    }\n', '    \n', '    function burnFunction(address _burner, uint256 _value) internal returns (bool) {\n', '        require(_value > 0, "_value > 0");\n', '\t\trequire(_value <= balances[_burner], "_value <= balances[_burner]");\n', '\n', '        balances[_burner] = balances[_burner].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Burn(_burner, _value);\n', '\t\temit Transfer(_burner, address(0), _value);\n', '\t\treturn true;\n', '    }\n', '    \n', '\tfunction burn(uint256 _value) public returns(bool) {\n', '        return burnFunction(msg.sender, _value);\n', '    }\n', '\t\n', '\tfunction burnFrom(address _from, uint256 _value) public returns (bool) {\n', '\t\trequire(_value <= allowed[_from][msg.sender], "_value <= allowed[_from][msg.sender]"); // check if it has the budget allowed\n', '\t\tburnFunction(_from, _value);\n', '\t\tallowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\t\treturn true;\n', '\t}\n', '}\n', '\n', 'contract Changable is Ownable, ERC20Basic {\n', '    function changeName(string memory _newName) public onlyOwner {\n', '        name = _newName;\n', '    }\n', '    function changeSymbol(string memory _newSymbol) public onlyOwner {\n', '        symbol = _newSymbol;\n', '    }\n', '}\n', '\n', 'contract Token is ERC20Basic, ERC223TokenCompatible, StandardToken, HumanStandardToken, StartToken, BurnToken, Changable {\n', '    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) public BurnToken(_totalSupply) {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        totalSupply = _totalSupply;\n', '        \n', '        balances[msg.sender] = totalSupply;\n', '\t\temit Transfer(address(0), msg.sender, totalSupply);\n', '    }\n', '}']