['pragma solidity ^0.4.19;\n', '\n', 'contract BaseToken {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != address(0));\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '    //     require(_value <= allowance[_from][msg.sender]);\n', '    //     allowance[_from][msg.sender] -= _value;\n', '    //     _transfer(_from, _to, _value);\n', '    //     return true;\n', '    // }\n', '\n', '    // function approve(address _spender, uint256 _value) public returns (bool success) {\n', '    //     allowance[msg.sender][_spender] = _value;\n', '    //     emit Approval(msg.sender, _spender, _value);\n', '    //     return true;\n', '    // }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract AirdropToken is BaseToken, Ownable {\n', '    // uint256 public airAmount;\n', '    address public airSender;\n', '    // uint32 public airLimitCount;\n', '    // bool public airState;\n', '\n', '    // mapping (address => uint32) public airCountOf;\n', '\n', '    // event Airdrop(address indexed from, uint32 indexed count, uint256 tokenValue);\n', '\n', '    // function setAirState(bool _state) public onlyOwner {\n', '    //     airState = _state;\n', '    // }\n', '\n', '    // function setAirAmount(uint256 _amount) public onlyOwner {\n', '    //     airAmount = _amount;\n', '    // }\n', '\n', '    // function setAirLimitCount(uint32 _count) public onlyOwner {\n', '    //     airLimitCount = _count;\n', '    // }\n', '\n', '    // function setAirSender(address _sender) public onlyOwner {\n', '    //     airSender = _sender;\n', '    // }\n', '\n', '    // function airdrop() public payable {\n', '    //     require(airState == true);\n', '    //     require(msg.value == 0);\n', '    //     if (airLimitCount > 0 && airCountOf[msg.sender] >= airLimitCount) {\n', '    //         revert();\n', '    //     }\n', '    //     _transfer(airSender, msg.sender, airAmount);\n', '    //     airCountOf[msg.sender] += 1;\n', '    //     emit Airdrop(msg.sender, airCountOf[msg.sender], airAmount);\n', '    // }\n', '\n', '    function airdropToAdresses(address[] _tos, uint _amount) public onlyOwner {\n', '        uint total = _amount * _tos.length;\n', '        require(total >= _amount && balanceOf[airSender] >= total);\n', '        balanceOf[airSender] -= total;\n', '        for (uint i = 0; i < _tos.length; i++) {\n', '            balanceOf[_tos[i]] += _amount;\n', '            emit Transfer(airSender, _tos[i], _amount);\n', '        }\n', '    }\n', '}\n', '\n', 'contract CustomToken is BaseToken, AirdropToken {\n', '    constructor() public {\n', '        totalSupply = 10000000000000000000000000000;\n', '        name = &#39;T0703&#39;;\n', '        symbol = &#39;T0703&#39;;\n', '        decimals = 18;\n', '        balanceOf[msg.sender] = totalSupply;\n', '        emit Transfer(address(0), address(msg.sender), totalSupply);\n', '\n', '        // airAmount = 500000000000000000000;\n', '        // airState = false;\n', '        airSender = msg.sender;\n', '        // airLimitCount = 2;\n', '    }\n', '\n', '    function() public payable {\n', '        // airdrop();\n', '    }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'contract BaseToken {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != address(0));\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '        emit Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    // function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '    //     require(_value <= allowance[_from][msg.sender]);\n', '    //     allowance[_from][msg.sender] -= _value;\n', '    //     _transfer(_from, _to, _value);\n', '    //     return true;\n', '    // }\n', '\n', '    // function approve(address _spender, uint256 _value) public returns (bool success) {\n', '    //     allowance[msg.sender][_spender] = _value;\n', '    //     emit Approval(msg.sender, _spender, _value);\n', '    //     return true;\n', '    // }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract AirdropToken is BaseToken, Ownable {\n', '    // uint256 public airAmount;\n', '    address public airSender;\n', '    // uint32 public airLimitCount;\n', '    // bool public airState;\n', '\n', '    // mapping (address => uint32) public airCountOf;\n', '\n', '    // event Airdrop(address indexed from, uint32 indexed count, uint256 tokenValue);\n', '\n', '    // function setAirState(bool _state) public onlyOwner {\n', '    //     airState = _state;\n', '    // }\n', '\n', '    // function setAirAmount(uint256 _amount) public onlyOwner {\n', '    //     airAmount = _amount;\n', '    // }\n', '\n', '    // function setAirLimitCount(uint32 _count) public onlyOwner {\n', '    //     airLimitCount = _count;\n', '    // }\n', '\n', '    // function setAirSender(address _sender) public onlyOwner {\n', '    //     airSender = _sender;\n', '    // }\n', '\n', '    // function airdrop() public payable {\n', '    //     require(airState == true);\n', '    //     require(msg.value == 0);\n', '    //     if (airLimitCount > 0 && airCountOf[msg.sender] >= airLimitCount) {\n', '    //         revert();\n', '    //     }\n', '    //     _transfer(airSender, msg.sender, airAmount);\n', '    //     airCountOf[msg.sender] += 1;\n', '    //     emit Airdrop(msg.sender, airCountOf[msg.sender], airAmount);\n', '    // }\n', '\n', '    function airdropToAdresses(address[] _tos, uint _amount) public onlyOwner {\n', '        uint total = _amount * _tos.length;\n', '        require(total >= _amount && balanceOf[airSender] >= total);\n', '        balanceOf[airSender] -= total;\n', '        for (uint i = 0; i < _tos.length; i++) {\n', '            balanceOf[_tos[i]] += _amount;\n', '            emit Transfer(airSender, _tos[i], _amount);\n', '        }\n', '    }\n', '}\n', '\n', 'contract CustomToken is BaseToken, AirdropToken {\n', '    constructor() public {\n', '        totalSupply = 10000000000000000000000000000;\n', "        name = 'T0703';\n", "        symbol = 'T0703';\n", '        decimals = 18;\n', '        balanceOf[msg.sender] = totalSupply;\n', '        emit Transfer(address(0), address(msg.sender), totalSupply);\n', '\n', '        // airAmount = 500000000000000000000;\n', '        // airState = false;\n', '        airSender = msg.sender;\n', '        // airLimitCount = 2;\n', '    }\n', '\n', '    function() public payable {\n', '        // airdrop();\n', '    }\n', '}']