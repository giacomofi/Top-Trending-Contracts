['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-08\n', '*/\n', '\n', 'pragma solidity ^0.5.11;\n', '\n', 'contract ERC20 {\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  function transfer(address to, uint value) public returns(bool);\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '  event Burn(address indexed from, uint256 value);\n', '}\n', '\n', 'library SafeMath{\n', '      function mul(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '        if (a == 0) {\n', '        return 0;}\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) \n', '    {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', 'contract BKC is ERC20 {\n', '    \n', '        using SafeMath for uint256;\n', '\n', '    string internal _name;\n', '    string internal _symbol;\n', '    uint8 internal _decimals;\n', '    uint256 internal _totalSupply;\n', '    \n', '    address internal  _admin;\n', '    \n', '\n', '    mapping (address => uint256) internal balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '  \n', '\n', '    constructor() public {\n', '        _admin = msg.sender;\n', '        _symbol = "BKC";  \n', '        _name = "Burger King Finance"; \n', '        _decimals = 18; \n', '        _totalSupply = 1000000* 10**uint(_decimals);\n', '        balances[msg.sender]=_totalSupply;\n', '       \n', '    }\n', '    \n', '    modifier ownership()  {\n', '    require(msg.sender == _admin);\n', '        _;\n', '    }\n', '    \n', '  \n', '    function name() public view returns (string memory) \n', '    {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) \n', '    {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) \n', '    {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256) \n', '    {\n', '        return _totalSupply;\n', '    }\n', '\n', '   function transfer(address _to, uint256 _value) public returns (bool) {\n', '     require(_to != address(0));\n', '     require(_value <= balances[msg.sender]);\n', '     balances[msg.sender] = balances[msg.sender].sub(_value);\n', '     balances[_to] = (balances[_to]).add( _value);\n', '     emit ERC20.Transfer(msg.sender, _to, _value);\n', '     return true;\n', '   }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '   }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '     require(_to != address(0));\n', '     require(_value <= balances[_from]);\n', '     require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = (balances[_from]).sub( _value);\n', '    balances[_to] = (balances[_to]).add(_value);\n', '    allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_value);\n', '    emit ERC20.Transfer(_from, _to, _value);\n', '     return true;\n', '   }\n', '\n', '   function approve(address _spender, uint256 _value) public returns (bool) {\n', '     allowed[msg.sender][_spender] = _value;\n', '    emit ERC20.Approval(msg.sender, _spender, _value);\n', '     return true;\n', '   }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '     return allowed[_owner][_spender];\n', '   }\n', '\n', '  function mint(uint256 _amount) public ownership returns (bool) {\n', '    _totalSupply = (_totalSupply).add(_amount);\n', '    balances[_admin] +=_amount;\n', '    return true;\n', '  }\n', '    \n', ' function burn(uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);   // Check if the sender has enough\n', '        balances[msg.sender] -= _value;            // Subtract from the sender\n', '        _totalSupply -= _value;                      // Updates totalSupply\n', '        emit Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * Destroy tokens from other account\n', '     */\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balances[_from] >= _value);                // Check if the targeted balance is enough\n', '        require(_value <= allowed[_from][msg.sender]);    // Check allowance\n', '        balances[_from] -= _value;                         // Subtract from the targeted balance\n', "        allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance\n", '        _totalSupply -= _value;                              // Update totalSupply\n', '        emit Burn(_from, _value);\n', '        return true;\n', '    }\n', '     \n', '  \n', '  \n', ' \n', '  \n', '  //Admin can transfer his ownership to new address\n', '  function transferownership(address _newaddress) public returns(bool){\n', '      require(msg.sender==_admin);\n', '      _admin=_newaddress;\n', '      return true;\n', '  }\n', '    \n', '}']